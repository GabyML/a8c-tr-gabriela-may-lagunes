select * from trial.billing_combined order by dateym limit 10
select * from trial.billing_combined order by dateym desc limit 10

-- ha! the table actually has data from 1970 (???) to 2022. Start with the years 2015-2018
-- as stated in the instructions and then ask if they want to see a different time period

-- Start looking into January 2015:

select count(*)
from trial.billing_combined
where dateym = 201501

-- there were 434,437 rows (receipt items) in that month

-- how many unique customers? - 215,998
select count(distinct user_id) as count_unique_users
from trial.billing_combined
where dateym = 201501

-- had a look at a single customer to see an example of activity
select *
from trial.billing_combined
where dateym = 201501
limit 10

-- take user 59489060 as example

select *
from trial.billing_combined
where dateym = 201501
and user_id = 59489060

-- all 4 transactions in jan 2015 are type recurring, so I assume that this
-- is what a happy, recurring customer looks like.

-- now look for examples of cancellations this month
-- Note: I can see for this user that they finished their ownerships on jan 2016 (a year later)
-- How many models are implemented to predict which customers are more likely to churn?

select *
from trial.billing_combined
where dateym = 201501
and trial.billing_combined.type = "cancellation"

-- I'm trying to see examples of cancellations but I get an
-- error {'message': "line 4:35: Column 'cancellation' cannot be resolved",[...]

-- Try a group by to see if there are actually cancellations

select type, count(*)
from trial.billing_combined
where dateym = 201501
group by type

-- with the query above we can see that the 4th most common type of receipt item were cancellations,
-- so this is a good heads up that cancellations are not trivial.
-- For a total of 434437 entries of the table for Jan 2015, 50877 have a cancellation type (11.7% of all receipt items)

-- Why am I having troubles filtering for cancellations? ITS A VARCHAR, NOT A STRING

select *
from trial.billing_combined
where dateym = 201501
and type like '%cancellation%'
limit 10

-- Ok! So... look at the customers. What is the distribution of counts per receipt_item_id per customer for jan 2015?

select item_count, count(user_id) as user_count
from (
  select user_id, count(receipt_item_id) as item_count
  from trial.billing_combined
  where dateym = 201501
  group by user_id
  order by item_count desc
  ) as foo
group by item_count
order by user_count

-- This table is actually useful! It is showing that the majority of the users have one, two or three items
-- in the receipt. Is this enough to assume that if one of the item types is cancellation, then we lost the customer?
-- The graph shows that: 114375/215998 (53%) of customers just had one item in that month, 73% had 2 or less, 91% had 3 or less.

-- If you have one cancellation, are all your transactions cancellations?

  select user_id, count(receipt_item_id) as item_count
  from trial.billing_combined
  where dateym = 201501
  and type like '%cancellation%'
  group by user_id
  limit 100

-- see some examples

select *
from trial.billing_combined
where dateym = 201501
and user_id = 14650585

-- The user above looks like a good example to start asking questions!
-- First, note this is a very special customer, because they have 16 receipt_item_ids
-- From those 16, 5 are cancellations
-- We see 8 different product_ownership_id values, and all of them have now a cancellation date value,
-- but only 5 of the 8 product_ownership_id have a cancellation date value within Jan 2015 (the rest happen after)
-- so now I am thinking that, in order to consider that we "lost" a customer, then all cancellation date values
-- for that customer have to be no later than the month we are looking at. I could assume that cancellation dates in the future
-- mean that the customer may have drop 1 or more products, but they are still active customers.

-- But oh oh! The documentation literally says:
-- "cancellation_date – cancellation date associated with product_ownership_id. Also note this field may be unreliable especially for particular services (like “woo”) see the discussion here. See below."
-- Looking into that discussion now...

-- From the discussion, I can see that cancellation date is not reliable for all services (specially woo)
-- "Because of the inconsistencies in data, we've moved toward identifying subscription events via the revenue recognition system, which looks at what periods any given receipt_item_id is intended to pay for (this data, which is reasonably reliable, can be found in billing_receipt_item_period )."
-- Since I don't have access to that table or to the internal articles about churn, then I am going to keep working
-- as if cancellation_date was a reliable field.
-- Therefore, in order to consider a customer churned, then all the receipt items of that month have to have a cancellation date falling in that same month
-- Note that for now I haven't considered refunds or expirations, I think I need a bit of help understanding better what do those mean.

------------------------------------------------------------------ May 25th, 2022 ----------------------------------------------------------

-- Below there is a first attempt at filtering using cancellation date to filter. The query will get receipt items with a cancellation date lower than 1st february 2015
select *
from trial.billing_combined
where dateym = 201501
and (cast(SUBSTRING(cancellation_date, 1, 10) AS date) < date '2015-02-01')
limit 10

-- Now, I need to create a window function that looks into all items for a period x and:
-- If all items have not null cancellation date AND the last cancellation date happened within a period x, then customer churned
-- Otherwise, customer not churned

-- Each partition is going to be over the same user and ordered by cancellation_date
select (cancellation_date is null) as is_it_null
from trial.billing_combined
where dateym = 201501
and user_id = 59489060--14650585
order by cancellation_date desc -- This order will put the newest cancellation date at the top

-- check if any receipt item has cancelled date as null. If 1, then no churned
select
  user_id,
  max(case when cancellation_date is null then 1 else 0 end) over (partition by user_id) as at_least_one_null
from trial.billing_combined
where dateym = 201501
limit 10
/*
1 58510	1
2	58510	1
3	58510	1
4	58510	1
5	73500	0
6	139308	0
7	327540	1
8	433829	0
9	555667	1
10	605167	0
*/

-- checkout examples to see if it actually works

select *
from trial.billing_combined
where dateym = 201501
and user_id = 34265337

-- NOTE: I just realised I am assuming that all active customers have at least one receipt item a month... but I guess active customers could have just one a year.

-- see how many customers had items during 2015 -- 1,516,057

select count(distinct user_id)
from trial.billing_combined
where year = 2015

-- I DONT KNOW HOW TO KNOW HOW MANY CUSTOMERS YOU HAVE AT THE BEGINNING OF A PERIOD!!!!! AAAAAHHHHHHH!!!!!!!!!!!

-- Put a pin on that: keep going with calculating how many customers churn within a period

-- if at_least_one_null is 1, then these customers aren't churn. From all the others, get the ones that have cancellation date within that period

-- this query gets you customers that have had all their items cancelled but you can still have cancellations happening after the period you are looking at.
-- see user_id = 34265337 as example below
select *
from (
  select
    user_id,
    max(case when cancellation_date is null then 1 else 0 end) over (partition by user_id) as at_least_one_null,
    cast(SUBSTRING(cancellation_date, 1, 10) AS date) as c_date
  from trial.billing_combined
  where dateym = 201501
) as foo
where at_least_one_null = 0
and c_date < date '2015-02-01'

select *
from trial.billing_combined
where dateym = 201501
and user_id = 34265337

------------------------------------------------------------------ May 26th, 2022 ----------------------------------------------------------

-- Idea: If a you want to see how many customers churned on, for example, Jan 2015, you first you have to look at all the transactions of all customers before that time
-- and get the at_least_one_null 0 to know how many are active. Then see how many have the last cancellation within the period you are looking into.

-- note: I think they are using '1970-01-01' as a date dummy value for null dates. The question is, why would a date be null, and should I take it in count?
-- The query below shows that the earlierst date after 1970-01-01 is 2006-08-04.

select *
from trial.billing_combined
where cast(SUBSTRING(date_only, 1, 10) AS date) > date '1970-01-01'
order by trial.billing_combined.date limit 10

-- check if there are any active customers with transactions from 1970-01-01

select *
from (
  select
    user_id,
    date_only,
    max(case when cancellation_date is null then 1 else 0 end) over (partition by user_id) as at_least_one_null,
    cast(SUBSTRING(cancellation_date, 1, 10) AS date) as c_date
  from trial.billing_combined
) as foo
where at_least_one_null = 1
and cast(SUBSTRING(date_only, 1, 10) AS date) = date '1970-01-01'

-- check out one of the results

select *
from trial.billing_combined
where user_id = 3641212

--- Ok, let's try get the rate for jan 2015!
--- First thing, try to write something that 1) gets all users that have no nulls from the beginning to jan 2015,
--- 2) orders the receipt items of the users by cancellation date and 3) the newest cancellation date is no later than jan 2015

-- count all users with receipt item ids from the start until jan 2015
select count(distinct user_id)
from (
  select
    *,
    max(case when cancellation_date is null then 1 else 0 end) over (partition by user_id) as at_least_one_null,
    cast(SUBSTRING(cancellation_date, 1, 10) AS date) as c_date
  from trial.billing_combined
  where cast(SUBSTRING(date_only, 1, 10) AS date) < date '2015-02-01'
) as foo
-- 2,013,362

-- from those 2 million, count how many have at least one null in cancellation date
select count(distinct user_id)
from (
  select
    *,
    max(case when cancellation_date is null then 1 else 0 end) over (partition by user_id) as at_least_one_null,
    cast(SUBSTRING(cancellation_date, 1, 10) AS date) as c_date
  from trial.billing_combined
  where cast(SUBSTRING(date_only, 1, 10) AS date) < date '2015-02-01'
) as foo
where at_least_one_null = 1
-- 705,404 are for sure still active by jan 2015.

select count(distinct user_id)
from (
  select
    *,
    max(case when cancellation_date is null then 1 else 0 end) over (partition by user_id) as at_least_one_null,
    cast(SUBSTRING(cancellation_date, 1, 10) AS date) as c_date
  from trial.billing_combined
  where cast(SUBSTRING(date_only, 1, 10) AS date) < date '2015-02-01'
) as foo
where at_least_one_null = 0
-- from the rest 1,307,958 I have to look into each of them, order their transactions and see if the newest cancellation is within jan 2015

-- first check out an example to see if things look right
select *
from (
  select
    *,
    max(case when cancellation_date is null then 1 else 0 end) over (partition by user_id) as at_least_one_null,
    cast(SUBSTRING(cancellation_date, 1, 10) AS date) as c_date
  from trial.billing_combined
  where cast(SUBSTRING(date_only, 1, 10) AS date) < date '2015-02-01'
) as foo
where at_least_one_null = 0
limit 10

select *
from trial.billing_combined
where user_id = 14084
and cast(SUBSTRING(date_only, 1, 10) AS date) < date '2015-02-01'

-- If newest cancellation is after the period, then customer is active and the quantity has to be added to active customers.
-- If it’s before the period then customer churned before and this has to be substrated to active customers.
-- If within period, then those churned at that time

-- get some examples
select user_id, at_least_one_null, max_c_date
from (
  select
    *,
    max(case when cancellation_date is null then 1 else 0 end) over (partition by user_id) as at_least_one_null,
    max(case when cancellation_date is null then date '1970-01-01' else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
  from trial.billing_combined
  where cast(SUBSTRING(date_only, 1, 10) AS date) < date '2015-02-01'
) as foo
limit 30
-- results:
/*
 	user_id	at_least_one_null	max_c_date
1	2278	0	2010-10-22
2	2278	0	2010-10-22
3	2580	1	1970-01-01
4	2580	1	1970-01-01
5	2580	1	1970-01-01
6	3748	0	2013-08-15
7	3748	0	2013-08-15
8	3748	0	2013-08-15
9	3748	0	2013-08-15
10	24433	0	2015-01-08
*/

-- let-s check out customer 24433, who according to our logic, would count as if they churned in jan 2015

select *
from trial.billing_combined
where user_id = 24433
and cast(SUBSTRING(date_only, 1, 10) AS date) < date '2015-02-01'

-- this customer has one product_ownership_id, 1 new purchase and 3 recurring items, then cancelled in Jan 8th, 2015. Boom! This customer would count as churned

select *
from trial.billing_combined
where user_id = 2580
and cast(SUBSTRING(date_only, 1, 10) AS date) < date '2015-02-01'
-- this customer has not cancelled any of its products, at_least_one_null = 1, then it's counted as active

select *
from trial.billing_combined
where user_id = 2278
and cast(SUBSTRING(date_only, 1, 10) AS date) < date '2015-02-01'
-- this customer would count as non active because they cancelled their products before jan 2015

select *
from trial.billing_combined
where user_id = 2022
and cast(SUBSTRING(date_only, 1, 10) AS date) < date '2015-02-01'
-- This customer cancelled his products in march 2015, so in jan 2015 they were still active!


-- OK! NOW LETS GET CHURN RATE FOR JAN 2015!!!

-- 1) Get active customers count at the beginning of jan 2015:
--    customers with (at_least_one_null = 1) + (at_least_one_null = 0 AND max_c_date >= date '2015-02-01')
-- 2) Get churned customers by the end of jan 2015
--    customers with (at_least_one_null = 0 AND date '2015-01-01' <= max_c_date < date '2015-02-01')
-- those two quantities plus (at_least_one_null = 0 AND max_c_date < date '2015-01-01') should be same as total users

select count(distinct user_id)
from (
  select
    *,
    max(case when cancellation_date is null then 1 else 0 end) over (partition by user_id) as at_least_one_null,
    max(case when cancellation_date is null then date '1970-01-01' else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
  from trial.billing_combined
  where cast(SUBSTRING(date_only, 1, 10) AS date) < date '2015-02-01'
) as foo
-- where at_least_one_null = 1
where at_least_one_null = 0
and max_c_date >= date '2015-01-01'
and max_c_date < date '2015-02-01'

-- total users = 2,013,362
-- active users, at least 1 null cancellation = 705,404
-- active users, no nulls, but max c grater than jan 15 = 662,809
-- non active users, no nulls and max c lower tahn jan 15 = 627,757
-- churned in jan 2015, no nulls, and date '2015-01-01' <= max_c_date < date '2015-02-01' = 17392

-- total checks out!!!
-- so Jan 2015 customer churn rate is 17392 / (705,404 + 662,809 + 17392) = 17392 / 1,385,605 = 1.26%

-- can you get that number in a single query?
-- flag customers as active, non active and churned


select churn_category,
      count(distinct user_id)
from (
    select user_id,
       (case when at_least_one_null = 1 then 'active'
             when at_least_one_null = 0 and (max_c_date >= date '2015-02-01') then 'active'
             when at_least_one_null = 0 and max_c_date < date '2015-01-01' then 'inactive'
             else 'churned' end) as churn_category
    from (
          select
            user_id,
            max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
            max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
          from trial.billing_combined
          where cast(SUBSTRING(date_only, 1, 10) AS date) < date '2015-02-01'
         ) as foo
    ) as temp
group by churn_category

------------------------------------------------------------------ May 27th, 2022 ----------------------------------------------------------

-- Considering Eric's comment, I'm having a quick look at product_variation_slug

select product_variation_slug, count(*)
from trial.billing_combined
where year = 2015
group by product_variation_slug

-- 614 different product_variation_slug values
-- items


------------------------------------------------------------------ May 30th, 2022 ----------------------------------------------------------

-- Remember where you left:

select churn_category,
      count(distinct user_id) as user_count
from (
    select user_id,
       (case when at_least_one_null = 1 then 'active'
             when at_least_one_null = 0 and (max_c_date >= date '2015-02-01') then 'active'
             when at_least_one_null = 0 and max_c_date < date '2015-01-01' then 'inactive'
             else 'churned' end) as churn_category
    from (
          select
            user_id,
            max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
            max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
          from trial.billing_combined
          where cast(SUBSTRING(date_only, 1, 10) AS date) < date '2015-02-01'
         ) as foo
    ) as temp
group by churn_category

-- We created a query that looks into Jan 2015, categorises all customers in either active, inactive or churned (churn_category)
-- and counts them.

-- Great! Now let us create a query that creates a table with user_id, churn_category and dateym as columns
-- We will use this table to calculate customer churn rate for each month and quarter and year from 2015-2018 and see if we find
-- any interesting patterns. After doing this we can look at ccr with other divisions (product, service, location or currency)
-- If we manage to do this in the next day or two, we could do something similar for other metrics.
-- N.B: I am just now realising that I have been writing about me and what I plan to do using we instead, as if I was in a
-- Golum/Smeagol kind of situation... should probably stop doing that.

--select churn_category,
--      count(distinct user_id) as user_count
--from (
    select user_id,
           (case when at_least_one_null = 1 then 'active'
             when at_least_one_null = 0 and (max_c_date >= date '2015-02-01') then 'active'
             when at_least_one_null = 0 and max_c_date < date '2015-01-01' then 'inactive'
             else 'churned' end) as churn_category,
           (date '2015-01-01' + interval '1' month) as churn_category_month
    from (
          select
            user_id,
            max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
            max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
          from trial.billing_combined
          where cast(SUBSTRING(date_only, 1, 10) AS date) < date '2015-02-01'
         ) as foo
--    ) as temp
--group by churn_category

--- I can agreate months to a date using + interval
select *
from trial.billing_combined
where cast(date_only AS date) = (date '2015-01-01' + interval '1' month)
limit 3

-- apparently, I can't set a variable using set in presto... dk why but that's what someone said in stackoverflow https://stackoverflow.com/questions/34301577/does-presto-have-the-equivalent-of-hives-set-command
DECLARE @Counter INT
SET @Counter = 1

-- go back to see how does it need to work using the intervals for dates

select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2015-02-01' + interval '0' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2015-01-01' + interval '0' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2015-01-01' + interval '0' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2015-02-01' + interval '0' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
limit 10

-- found the following alternative in this post: https://github.com/prestodb/presto/issues/5918
/*
PREPARE my_select FROM
SELECT *
FROM users
WHERE email_address = ?;
EXECUTE my_select USING 'foo@bar.com';
EXECUTE my_select USING 'foo2@bar.com';
DEALLOCATE PREPARE my_select; */

-- so for me it'd be something like:

prepare start_date from
select *
from trial.billing_combined
where cast(date_only AS date) = ?
limit 3;
EXECUTE start_date USING date '2015-01-01';
DEALLOCATE PREPARE start_date;

-- not working either...

-- I really don't want to write the same query 48 times...

select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2015-02-01' + interval '0' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2015-01-01' + interval '0' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2015-01-01' + interval '0' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2015-02-01' + interval '0' month)
      ) as foo
) as temp
group by churn_category, churn_category_month

union

select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2015-02-01' + interval '1' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2015-01-01' + interval '1' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2015-01-01' + interval '1' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2015-02-01' + interval '1' month)
      ) as foo
) as temp
group by churn_category, churn_category_month


-- Ok, it seems like I'm going to have to... so... I will create a materialized view with the user_id, churn_category, churn_category_month format
-- and from there I can make counts and get rates.
-- I will probably have to make a different monthly and yearly category column

-- base query:

select user_id, churn_category, churn_category_month from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2015-02-01' + interval '0' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2015-01-01' + interval '0' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2015-01-01' + interval '0' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2015-02-01' + interval '0' month)
      ) as foo
) as temp
group by user_id, churn_category, churn_category_month


--- Create a materialized view...

CREATE OR REPLACE MATERIALIZED VIEW customer_churn_category_monthly_2015_2018
AS

select user_id, churn_category, churn_category_month from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2015-02-01' + interval '0' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2015-01-01' + interval '0' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2015-01-01' + interval '0' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2015-02-01' + interval '0' month)
      ) as foo
) as temp
group by user_id, churn_category, churn_category_month

union

select user_id, churn_category, churn_category_month from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2015-02-01' + interval '1' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2015-01-01' + interval '1' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2015-01-01' + interval '1' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2015-02-01' + interval '1' month)
      ) as foo
) as temp
group by user_id, churn_category, churn_category_month

--- I do not have permissions to create a materialized view!!!

-- Ok, for now run the query that gives you already the churn rate per month. I think it would be really great to have the
-- disagregated table as a view, but for now let's do this

select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2015-02-01' + interval '0' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2015-01-01' + interval '0' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2015-01-01' + interval '0' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2015-02-01' + interval '0' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month




--questions coming up:
--What is the distribution of product_ownership_id per user?
--How does churn changes according to time but also product, service, country and currency?
--How can I differentiate customers that pay monthly to those that pay yearly?
--Should I used cancellation date or end date?
-- I'm using cancelled and not end because I am assuming that a customer can reactivate a product after it expires (edited)
