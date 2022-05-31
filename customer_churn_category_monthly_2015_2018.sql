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
