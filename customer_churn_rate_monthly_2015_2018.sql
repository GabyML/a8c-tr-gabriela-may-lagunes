-- 2015-01
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

union

-- 2015-02
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
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
) as temp1
group by churn_category_month

union

-- 2015-03
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2015-02-01' + interval '2' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2015-01-01' + interval '2' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2015-01-01' + interval '2' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2015-02-01' + interval '2' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2015-04
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2015-02-01' + interval '3' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2015-01-01' + interval '3' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2015-01-01' + interval '3' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2015-02-01' + interval '3' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2015-05
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2015-02-01' + interval '4' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2015-01-01' + interval '4' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2015-01-01' + interval '4' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2015-02-01' + interval '4' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2015-06
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2015-02-01' + interval '5' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2015-01-01' + interval '5' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2015-01-01' + interval '5' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2015-02-01' + interval '5' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2015-07
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2015-02-01' + interval '6' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2015-01-01' + interval '6' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2015-01-01' + interval '6' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2015-02-01' + interval '6' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2015-08
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2015-02-01' + interval '7' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2015-01-01' + interval '7' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2015-01-01' + interval '7' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2015-02-01' + interval '7' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2015-09
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2015-02-01' + interval '8' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2015-01-01' + interval '8' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2015-01-01' + interval '8' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2015-02-01' + interval '8' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2015-10
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2015-02-01' + interval '9' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2015-01-01' + interval '9' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2015-01-01' + interval '9' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2015-02-01' + interval '9' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2015-11
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2015-02-01' + interval '10' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2015-01-01' + interval '10' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2015-01-01' + interval '10' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2015-02-01' + interval '10' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2015-12
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2015-02-01' + interval '11' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2015-01-01' + interval '11' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2015-01-01' + interval '11' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2015-02-01' + interval '11' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2016-01
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2016-02-01' + interval '0' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2016-01-01' + interval '0' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2016-01-01' + interval '0' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2016-02-01' + interval '0' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2016-02
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2016-02-01' + interval '1' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2016-01-01' + interval '1' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2016-01-01' + interval '1' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2016-02-01' + interval '1' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2016-03
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2016-02-01' + interval '2' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2016-01-01' + interval '2' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2016-01-01' + interval '2' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2016-02-01' + interval '2' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2016-04
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2016-02-01' + interval '3' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2016-01-01' + interval '3' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2016-01-01' + interval '3' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2016-02-01' + interval '3' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2016-05
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2016-02-01' + interval '4' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2016-01-01' + interval '4' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2016-01-01' + interval '4' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2016-02-01' + interval '4' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2016-06
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2016-02-01' + interval '5' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2016-01-01' + interval '5' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2016-01-01' + interval '5' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2016-02-01' + interval '5' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2016-07
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2016-02-01' + interval '6' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2016-01-01' + interval '6' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2016-01-01' + interval '6' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2016-02-01' + interval '6' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2016-08
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2016-02-01' + interval '7' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2016-01-01' + interval '7' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2016-01-01' + interval '7' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2016-02-01' + interval '7' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2016-09
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2016-02-01' + interval '8' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2016-01-01' + interval '8' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2016-01-01' + interval '8' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2016-02-01' + interval '8' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2016-10
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2016-02-01' + interval '9' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2016-01-01' + interval '9' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2016-01-01' + interval '9' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2016-02-01' + interval '9' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2016-11
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2016-02-01' + interval '10' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2016-01-01' + interval '10' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2016-01-01' + interval '10' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2016-02-01' + interval '10' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2016-12
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2016-02-01' + interval '11' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2016-01-01' + interval '11' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2016-01-01' + interval '11' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2016-02-01' + interval '11' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2017-01
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2017-02-01' + interval '0' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2017-01-01' + interval '0' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2017-01-01' + interval '0' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2017-02-01' + interval '0' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2017-02
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2017-02-01' + interval '1' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2017-01-01' + interval '1' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2017-01-01' + interval '1' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2017-02-01' + interval '1' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2017-03
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2017-02-01' + interval '2' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2017-01-01' + interval '2' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2017-01-01' + interval '2' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2017-02-01' + interval '2' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2017-04
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2017-02-01' + interval '3' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2017-01-01' + interval '3' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2017-01-01' + interval '3' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2017-02-01' + interval '3' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2017-05
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2017-02-01' + interval '4' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2017-01-01' + interval '4' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2017-01-01' + interval '4' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2017-02-01' + interval '4' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2017-06
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2017-02-01' + interval '5' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2017-01-01' + interval '5' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2017-01-01' + interval '5' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2017-02-01' + interval '5' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2017-07
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2017-02-01' + interval '6' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2017-01-01' + interval '6' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2017-01-01' + interval '6' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2017-02-01' + interval '6' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2017-08
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2017-02-01' + interval '7' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2017-01-01' + interval '7' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2017-01-01' + interval '7' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2017-02-01' + interval '7' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2017-09
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2017-02-01' + interval '8' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2017-01-01' + interval '8' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2017-01-01' + interval '8' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2017-02-01' + interval '8' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2017-10
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2017-02-01' + interval '9' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2017-01-01' + interval '9' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2017-01-01' + interval '9' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2017-02-01' + interval '9' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2017-11
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2017-02-01' + interval '10' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2017-01-01' + interval '10' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2017-01-01' + interval '10' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2017-02-01' + interval '10' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2017-12
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2017-02-01' + interval '11' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2017-01-01' + interval '11' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2017-01-01' + interval '11' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2017-02-01' + interval '11' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2018-01
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2018-02-01' + interval '0' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2018-01-01' + interval '0' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2018-01-01' + interval '0' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2018-02-01' + interval '0' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2018-02
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2018-02-01' + interval '1' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2018-01-01' + interval '1' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2018-01-01' + interval '1' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2018-02-01' + interval '1' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2018-03
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2018-02-01' + interval '2' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2018-01-01' + interval '2' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2018-01-01' + interval '2' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2018-02-01' + interval '2' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2018-04
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2018-02-01' + interval '3' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2018-01-01' + interval '3' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2018-01-01' + interval '3' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2018-02-01' + interval '3' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2018-05
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2018-02-01' + interval '4' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2018-01-01' + interval '4' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2018-01-01' + interval '4' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2018-02-01' + interval '4' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2018-06
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2018-02-01' + interval '5' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2018-01-01' + interval '5' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2018-01-01' + interval '5' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2018-02-01' + interval '5' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2018-07
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2018-02-01' + interval '6' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2018-01-01' + interval '6' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2018-01-01' + interval '6' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2018-02-01' + interval '6' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2018-08
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2018-02-01' + interval '7' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2018-01-01' + interval '7' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2018-01-01' + interval '7' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2018-02-01' + interval '7' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2018-09
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2018-02-01' + interval '8' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2018-01-01' + interval '8' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2018-01-01' + interval '8' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2018-02-01' + interval '8' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2018-10
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2018-02-01' + interval '9' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2018-01-01' + interval '9' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2018-01-01' + interval '9' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2018-02-01' + interval '9' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2018-11
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2018-02-01' + interval '10' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2018-01-01' + interval '10' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2018-01-01' + interval '10' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2018-02-01' + interval '10' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month

union

-- 2018-12
select churn_category_month,
       SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as total_active,
       MAX(case when churn_category = 'churned' then user_count else 0 end) as total_churned,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double) as ccr_monthly,
       cast(MAX(case when churn_category = 'churned' then user_count else 0 end) as double)/cast(SUM(case when churn_category = 'inactive' THEN 0 ELSE user_count END) as double)*100 as ccr_monthly_percentage
from (
select churn_category, churn_category_month, count(distinct user_id) as user_count from (
select user_id,
        (case when at_least_one_null = 1 then 'active'
          when at_least_one_null = 0 and (max_c_date >= date '2018-02-01' + interval '11' month) then 'active'
          when at_least_one_null = 0 and (max_c_date < date '2018-01-01' + interval '11' month) then 'inactive'
          else 'churned' end) as churn_category,
        (date '2018-01-01' + interval '11' month) as churn_category_month
from (
      select user_id,
             max(case when cancellation_date is null then 1
                     else 0 end) over (partition by user_id) as at_least_one_null,
             max(case when cancellation_date is null then date '1970-01-01'
                     else cast(SUBSTRING(cancellation_date, 1, 10) AS date) end) over (partition by user_id) as max_c_date -- get the newest cancellation date
      from trial.billing_combined
      where cast(SUBSTRING(date_only, 1, 10) AS date) < (date '2018-02-01' + interval '11' month)
      ) as foo
) as temp
group by churn_category, churn_category_month
) as temp1
group by churn_category_month
