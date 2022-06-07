-- 2015-01
SELECT product_slug, churn_category_month,
       SUM(CASE WHEN churn_category = 'inactive' THEN 0 ELSE user_count END) AS total_active_users,
       MAX(CASE WHEN churn_category = 'churned' THEN user_count ELSE 0 END) AS total_churned_users,
       cASt(MAX(CASE WHEN churn_category = 'churned'
         THEN user_count ELSE 0 END) AS double)/cASt(SUM(CASE WHEN churn_category = 'inactive'
           THEN 0 ELSE user_count END) AS double)*100 AS user_ccr_monthly_percentage,
       SUM(CASE WHEN churn_category = 'inactive' THEN 0 ELSE product_count END) AS total_active_products,
       MAX(CASE WHEN churn_category = 'churned' THEN product_count ELSE 0 END) AS total_churned_products,
       cASt(MAX(CASE WHEN churn_category = 'churned'
         THEN product_count ELSE 0 END) AS double)/cASt(SUM(CASE WHEN churn_category = 'inactive'
           THEN 0 ELSE product_count END) AS double)*100 AS product_ccr_monthly_percentage
FROM (
      SELECT product_slug,
           churn_category,
           churn_category_month,
           count(distinct user_id) AS user_count,
           count(distinct product_ownership_id) AS product_count
           FROM (
                 SELECT user_id,
                        product_ownership_id,
                        product_slug,
                        (CASE WHEN max_c_date = DATE '1970-01-01' THEN 'active'
                              WHEN max_c_date >= DATE '2015-02-01' THEN 'active'
                              WHEN max_c_date < DATE '2015-01-01' THEN 'inactive'
                              ELSE 'churned' END) AS churn_category,
                              (DATE '2015-01-01') AS churn_category_month
                 FROM (
                      SELECT user_id,
                             product_ownership_id,
                             product_slug,
                             max(CASE WHEN cancellation_date IS NULL THEN DATE '1970-01-01'
                                 ELSE CAST(SUBSTRING(cancellation_date, 1, 10) AS DATE) END)
                                 over (PARTITION BY product_ownership_id) AS max_c_date
                      FROM trial.billing_combined
                      WHERE CAST(SUBSTRING(date_only, 1, 10) AS DATE) < (DATE '2015-02-01')
                      AND product_slug != ''
                      ) AS foo
                ) AS temp
                GROUP BY product_slug, churn_category, churn_category_month
    ) AS temp1
GROUP BY product_slug, churn_category_month

UNION

-- 2015-02
SELECT product_slug, churn_category_month,
       SUM(CASE WHEN churn_category = 'inactive' THEN 0 ELSE user_count END) AS total_active_users,
       MAX(CASE WHEN churn_category = 'churned' THEN user_count ELSE 0 END) AS total_churned_users,
       cASt(MAX(CASE WHEN churn_category = 'churned'
         THEN user_count ELSE 0 END) AS double)/cASt(SUM(CASE WHEN churn_category = 'inactive'
           THEN 0 ELSE user_count END) AS double)*100 AS user_ccr_monthly_percentage,
       SUM(CASE WHEN churn_category = 'inactive' THEN 0 ELSE product_count END) AS total_active_products,
       MAX(CASE WHEN churn_category = 'churned' THEN product_count ELSE 0 END) AS total_churned_products,
       cASt(MAX(CASE WHEN churn_category = 'churned'
         THEN product_count ELSE 0 END) AS double)/cASt(SUM(CASE WHEN churn_category = 'inactive'
           THEN 0 ELSE product_count END) AS double)*100 AS product_ccr_monthly_percentage
FROM (
      SELECT product_slug,
           churn_category,
           churn_category_month,
           count(distinct user_id) AS user_count,
           count(distinct product_ownership_id) AS product_count
           FROM (
                 SELECT user_id,
                        product_ownership_id,
                        product_slug,
                        (CASE WHEN max_c_date = DATE '1970-01-01' THEN 'active'
                              WHEN max_c_date >= DATE '2015-02-01' + INTERVAL '1' MONTH THEN 'active'
                              WHEN max_c_date < DATE '2015-01-01' + INTERVAL '1' MONTH THEN 'inactive'
                              ELSE 'churned' END) AS churn_category,
                              (DATE '2015-01-01' + INTERVAL '1' MONTH) AS churn_category_month
                 FROM (
                      SELECT user_id,
                             product_ownership_id,
                             product_slug,
                             max(CASE WHEN cancellation_date IS NULL THEN DATE '1970-01-01'
                                 ELSE CAST(SUBSTRING(cancellation_date, 1, 10) AS DATE) END)
                                 over (PARTITION BY product_ownership_id) AS max_c_date
                      FROM trial.billing_combined
                      WHERE CAST(SUBSTRING(date_only, 1, 10) AS DATE) < (DATE '2015-02-01' + INTERVAL '1' MONTH)
                      AND product_slug != ''
                      ) AS foo
                ) AS temp
                GROUP BY product_slug, churn_category, churn_category_month
    ) AS temp1
GROUP BY product_slug, churn_category_month

UNION

-- 2015-03
SELECT product_slug, churn_category_month,
       SUM(CASE WHEN churn_category = 'inactive' THEN 0 ELSE user_count END) AS total_active_users,
       MAX(CASE WHEN churn_category = 'churned' THEN user_count ELSE 0 END) AS total_churned_users,
       cASt(MAX(CASE WHEN churn_category = 'churned'
         THEN user_count ELSE 0 END) AS double)/cASt(SUM(CASE WHEN churn_category = 'inactive'
           THEN 0 ELSE user_count END) AS double)*100 AS user_ccr_monthly_percentage,
       SUM(CASE WHEN churn_category = 'inactive' THEN 0 ELSE product_count END) AS total_active_products,
       MAX(CASE WHEN churn_category = 'churned' THEN product_count ELSE 0 END) AS total_churned_products,
       cASt(MAX(CASE WHEN churn_category = 'churned'
         THEN product_count ELSE 0 END) AS double)/cASt(SUM(CASE WHEN churn_category = 'inactive'
           THEN 0 ELSE product_count END) AS double)*100 AS product_ccr_monthly_percentage
FROM (
      SELECT product_slug,
           churn_category,
           churn_category_month,
           count(distinct user_id) AS user_count,
           count(distinct product_ownership_id) AS product_count
           FROM (
                 SELECT user_id,
                        product_ownership_id,
                        product_slug,
                        (CASE WHEN max_c_date = DATE '1970-01-01' THEN 'active'
                              WHEN max_c_date >= DATE '2015-02-01' + INTERVAL '2' MONTH THEN 'active'
                              WHEN max_c_date < DATE '2015-01-01' + INTERVAL '2' MONTH THEN 'inactive'
                              ELSE 'churned' END) AS churn_category,
                              (DATE '2015-01-01' + INTERVAL '2' MONTH) AS churn_category_month
                 FROM (
                      SELECT user_id,
                             product_ownership_id,
                             product_slug,
                             max(CASE WHEN cancellation_date IS NULL THEN DATE '1970-01-01'
                                 ELSE CAST(SUBSTRING(cancellation_date, 1, 10) AS DATE) END)
                                 over (PARTITION BY product_ownership_id) AS max_c_date
                      FROM trial.billing_combined
                      WHERE CAST(SUBSTRING(date_only, 1, 10) AS DATE) < (DATE '2015-02-01' + INTERVAL '2' MONTH)
                      AND product_slug != ''
                      ) AS foo
                ) AS temp
                GROUP BY product_slug, churn_category, churn_category_month
    ) AS temp1
GROUP BY product_slug, churn_category_month

UNION

-- 2015-04
SELECT product_slug, churn_category_month,
       SUM(CASE WHEN churn_category = 'inactive' THEN 0 ELSE user_count END) AS total_active_users,
       MAX(CASE WHEN churn_category = 'churned' THEN user_count ELSE 0 END) AS total_churned_users,
       cASt(MAX(CASE WHEN churn_category = 'churned'
         THEN user_count ELSE 0 END) AS double)/cASt(SUM(CASE WHEN churn_category = 'inactive'
           THEN 0 ELSE user_count END) AS double)*100 AS user_ccr_monthly_percentage,
       SUM(CASE WHEN churn_category = 'inactive' THEN 0 ELSE product_count END) AS total_active_products,
       MAX(CASE WHEN churn_category = 'churned' THEN product_count ELSE 0 END) AS total_churned_products,
       cASt(MAX(CASE WHEN churn_category = 'churned'
         THEN product_count ELSE 0 END) AS double)/cASt(SUM(CASE WHEN churn_category = 'inactive'
           THEN 0 ELSE product_count END) AS double)*100 AS product_ccr_monthly_percentage
FROM (
      SELECT product_slug,
           churn_category,
           churn_category_month,
           count(distinct user_id) AS user_count,
           count(distinct product_ownership_id) AS product_count
           FROM (
                 SELECT user_id,
                        product_ownership_id,
                        product_slug,
                        (CASE WHEN max_c_date = DATE '1970-01-01' THEN 'active'
                              WHEN max_c_date >= DATE '2015-02-01' + INTERVAL '3' MONTH THEN 'active'
                              WHEN max_c_date < DATE '2015-01-01' + INTERVAL '3' MONTH THEN 'inactive'
                              ELSE 'churned' END) AS churn_category,
                              (DATE '2015-01-01' + INTERVAL '3' MONTH) AS churn_category_month
                 FROM (
                      SELECT user_id,
                             product_ownership_id,
                             product_slug,
                             max(CASE WHEN cancellation_date IS NULL THEN DATE '1970-01-01'
                                 ELSE CAST(SUBSTRING(cancellation_date, 1, 10) AS DATE) END)
                                 over (PARTITION BY product_ownership_id) AS max_c_date
                      FROM trial.billing_combined
                      WHERE CAST(SUBSTRING(date_only, 1, 10) AS DATE) < (DATE '2015-02-01' + INTERVAL '3' MONTH)
                      AND product_slug != ''
                      ) AS foo
                ) AS temp
                GROUP BY product_slug, churn_category, churn_category_month
    ) AS temp1
GROUP BY product_slug, churn_category_month

UNION

-- 2015-05
SELECT product_slug, churn_category_month,
       SUM(CASE WHEN churn_category = 'inactive' THEN 0 ELSE user_count END) AS total_active_users,
       MAX(CASE WHEN churn_category = 'churned' THEN user_count ELSE 0 END) AS total_churned_users,
       cASt(MAX(CASE WHEN churn_category = 'churned'
         THEN user_count ELSE 0 END) AS double)/cASt(SUM(CASE WHEN churn_category = 'inactive'
           THEN 0 ELSE user_count END) AS double)*100 AS user_ccr_monthly_percentage,
       SUM(CASE WHEN churn_category = 'inactive' THEN 0 ELSE product_count END) AS total_active_products,
       MAX(CASE WHEN churn_category = 'churned' THEN product_count ELSE 0 END) AS total_churned_products,
       cASt(MAX(CASE WHEN churn_category = 'churned'
         THEN product_count ELSE 0 END) AS double)/cASt(SUM(CASE WHEN churn_category = 'inactive'
           THEN 0 ELSE product_count END) AS double)*100 AS product_ccr_monthly_percentage
FROM (
      SELECT product_slug,
           churn_category,
           churn_category_month,
           count(distinct user_id) AS user_count,
           count(distinct product_ownership_id) AS product_count
           FROM (
                 SELECT user_id,
                        product_ownership_id,
                        product_slug,
                        (CASE WHEN max_c_date = DATE '1970-01-01' THEN 'active'
                              WHEN max_c_date >= DATE '2015-02-01' + INTERVAL '4' MONTH THEN 'active'
                              WHEN max_c_date < DATE '2015-01-01' + INTERVAL '4' MONTH THEN 'inactive'
                              ELSE 'churned' END) AS churn_category,
                              (DATE '2015-01-01' + INTERVAL '4' MONTH) AS churn_category_month
                 FROM (
                      SELECT user_id,
                             product_ownership_id,
                             product_slug,
                             max(CASE WHEN cancellation_date IS NULL THEN DATE '1970-01-01'
                                 ELSE CAST(SUBSTRING(cancellation_date, 1, 10) AS DATE) END)
                                 over (PARTITION BY product_ownership_id) AS max_c_date
                      FROM trial.billing_combined
                      WHERE CAST(SUBSTRING(date_only, 1, 10) AS DATE) < (DATE '2015-02-01' + INTERVAL '4' MONTH)
                      AND product_slug != ''
                      ) AS foo
                ) AS temp
                GROUP BY product_slug, churn_category, churn_category_month
    ) AS temp1
GROUP BY product_slug, churn_category_month

UNION

-- 2015-06
SELECT product_slug, churn_category_month,
       SUM(CASE WHEN churn_category = 'inactive' THEN 0 ELSE user_count END) AS total_active_users,
       MAX(CASE WHEN churn_category = 'churned' THEN user_count ELSE 0 END) AS total_churned_users,
       cASt(MAX(CASE WHEN churn_category = 'churned'
         THEN user_count ELSE 0 END) AS double)/cASt(SUM(CASE WHEN churn_category = 'inactive'
           THEN 0 ELSE user_count END) AS double)*100 AS user_ccr_monthly_percentage,
       SUM(CASE WHEN churn_category = 'inactive' THEN 0 ELSE product_count END) AS total_active_products,
       MAX(CASE WHEN churn_category = 'churned' THEN product_count ELSE 0 END) AS total_churned_products,
       cASt(MAX(CASE WHEN churn_category = 'churned'
         THEN product_count ELSE 0 END) AS double)/cASt(SUM(CASE WHEN churn_category = 'inactive'
           THEN 0 ELSE product_count END) AS double)*100 AS product_ccr_monthly_percentage
FROM (
      SELECT product_slug,
           churn_category,
           churn_category_month,
           count(distinct user_id) AS user_count,
           count(distinct product_ownership_id) AS product_count
           FROM (
                 SELECT user_id,
                        product_ownership_id,
                        product_slug,
                        (CASE WHEN max_c_date = DATE '1970-01-01' THEN 'active'
                              WHEN max_c_date >= DATE '2015-02-01' + INTERVAL '5' MONTH THEN 'active'
                              WHEN max_c_date < DATE '2015-01-01' + INTERVAL '5' MONTH THEN 'inactive'
                              ELSE 'churned' END) AS churn_category,
                              (DATE '2015-01-01' + INTERVAL '5' MONTH) AS churn_category_month
                 FROM (
                      SELECT user_id,
                             product_ownership_id,
                             product_slug,
                             max(CASE WHEN cancellation_date IS NULL THEN DATE '1970-01-01'
                                 ELSE CAST(SUBSTRING(cancellation_date, 1, 10) AS DATE) END)
                                 over (PARTITION BY product_ownership_id) AS max_c_date
                      FROM trial.billing_combined
                      WHERE CAST(SUBSTRING(date_only, 1, 10) AS DATE) < (DATE '2015-02-01' + INTERVAL '5' MONTH)
                      AND product_slug != ''
                      ) AS foo
                ) AS temp
                GROUP BY product_slug, churn_category, churn_category_month
    ) AS temp1
GROUP BY product_slug, churn_category_month

UNION

-- 2015-07
SELECT product_slug, churn_category_month,
       SUM(CASE WHEN churn_category = 'inactive' THEN 0 ELSE user_count END) AS total_active_users,
       MAX(CASE WHEN churn_category = 'churned' THEN user_count ELSE 0 END) AS total_churned_users,
       cASt(MAX(CASE WHEN churn_category = 'churned'
         THEN user_count ELSE 0 END) AS double)/cASt(SUM(CASE WHEN churn_category = 'inactive'
           THEN 0 ELSE user_count END) AS double)*100 AS user_ccr_monthly_percentage,
       SUM(CASE WHEN churn_category = 'inactive' THEN 0 ELSE product_count END) AS total_active_products,
       MAX(CASE WHEN churn_category = 'churned' THEN product_count ELSE 0 END) AS total_churned_products,
       cASt(MAX(CASE WHEN churn_category = 'churned'
         THEN product_count ELSE 0 END) AS double)/cASt(SUM(CASE WHEN churn_category = 'inactive'
           THEN 0 ELSE product_count END) AS double)*100 AS product_ccr_monthly_percentage
FROM (
      SELECT product_slug,
           churn_category,
           churn_category_month,
           count(distinct user_id) AS user_count,
           count(distinct product_ownership_id) AS product_count
           FROM (
                 SELECT user_id,
                        product_ownership_id,
                        product_slug,
                        (CASE WHEN max_c_date = DATE '1970-01-01' THEN 'active'
                              WHEN max_c_date >= DATE '2015-02-01' + INTERVAL '6' MONTH THEN 'active'
                              WHEN max_c_date < DATE '2015-01-01' + INTERVAL '6' MONTH THEN 'inactive'
                              ELSE 'churned' END) AS churn_category,
                              (DATE '2015-01-01' + INTERVAL '6' MONTH) AS churn_category_month
                 FROM (
                      SELECT user_id,
                             product_ownership_id,
                             product_slug,
                             max(CASE WHEN cancellation_date IS NULL THEN DATE '1970-01-01'
                                 ELSE CAST(SUBSTRING(cancellation_date, 1, 10) AS DATE) END)
                                 over (PARTITION BY product_ownership_id) AS max_c_date
                      FROM trial.billing_combined
                      WHERE CAST(SUBSTRING(date_only, 1, 10) AS DATE) < (DATE '2015-02-01' + INTERVAL '6' MONTH)
                      AND product_slug != ''
                      ) AS foo
                ) AS temp
                GROUP BY product_slug, churn_category, churn_category_month
    ) AS temp1
GROUP BY product_slug, churn_category_month

UNION

-- 2015-08
SELECT product_slug, churn_category_month,
       SUM(CASE WHEN churn_category = 'inactive' THEN 0 ELSE user_count END) AS total_active_users,
       MAX(CASE WHEN churn_category = 'churned' THEN user_count ELSE 0 END) AS total_churned_users,
       cASt(MAX(CASE WHEN churn_category = 'churned'
         THEN user_count ELSE 0 END) AS double)/cASt(SUM(CASE WHEN churn_category = 'inactive'
           THEN 0 ELSE user_count END) AS double)*100 AS user_ccr_monthly_percentage,
       SUM(CASE WHEN churn_category = 'inactive' THEN 0 ELSE product_count END) AS total_active_products,
       MAX(CASE WHEN churn_category = 'churned' THEN product_count ELSE 0 END) AS total_churned_products,
       cASt(MAX(CASE WHEN churn_category = 'churned'
         THEN product_count ELSE 0 END) AS double)/cASt(SUM(CASE WHEN churn_category = 'inactive'
           THEN 0 ELSE product_count END) AS double)*100 AS product_ccr_monthly_percentage
FROM (
      SELECT product_slug,
           churn_category,
           churn_category_month,
           count(distinct user_id) AS user_count,
           count(distinct product_ownership_id) AS product_count
           FROM (
                 SELECT user_id,
                        product_ownership_id,
                        product_slug,
                        (CASE WHEN max_c_date = DATE '1970-01-01' THEN 'active'
                              WHEN max_c_date >= DATE '2015-02-01' + INTERVAL '7' MONTH THEN 'active'
                              WHEN max_c_date < DATE '2015-01-01' + INTERVAL '7' MONTH THEN 'inactive'
                              ELSE 'churned' END) AS churn_category,
                              (DATE '2015-01-01' + INTERVAL '7' MONTH) AS churn_category_month
                 FROM (
                      SELECT user_id,
                             product_ownership_id,
                             product_slug,
                             max(CASE WHEN cancellation_date IS NULL THEN DATE '1970-01-01'
                                 ELSE CAST(SUBSTRING(cancellation_date, 1, 10) AS DATE) END)
                                 over (PARTITION BY product_ownership_id) AS max_c_date
                      FROM trial.billing_combined
                      WHERE CAST(SUBSTRING(date_only, 1, 10) AS DATE) < (DATE '2015-02-01' + INTERVAL '7' MONTH)
                      AND product_slug != ''
                      ) AS foo
                ) AS temp
                GROUP BY product_slug, churn_category, churn_category_month
    ) AS temp1
GROUP BY product_slug, churn_category_month

UNION

-- 2015-09
SELECT product_slug, churn_category_month,
       SUM(CASE WHEN churn_category = 'inactive' THEN 0 ELSE user_count END) AS total_active_users,
       MAX(CASE WHEN churn_category = 'churned' THEN user_count ELSE 0 END) AS total_churned_users,
       cASt(MAX(CASE WHEN churn_category = 'churned'
         THEN user_count ELSE 0 END) AS double)/cASt(SUM(CASE WHEN churn_category = 'inactive'
           THEN 0 ELSE user_count END) AS double)*100 AS user_ccr_monthly_percentage,
       SUM(CASE WHEN churn_category = 'inactive' THEN 0 ELSE product_count END) AS total_active_products,
       MAX(CASE WHEN churn_category = 'churned' THEN product_count ELSE 0 END) AS total_churned_products,
       cASt(MAX(CASE WHEN churn_category = 'churned'
         THEN product_count ELSE 0 END) AS double)/cASt(SUM(CASE WHEN churn_category = 'inactive'
           THEN 0 ELSE product_count END) AS double)*100 AS product_ccr_monthly_percentage
FROM (
      SELECT product_slug,
           churn_category,
           churn_category_month,
           count(distinct user_id) AS user_count,
           count(distinct product_ownership_id) AS product_count
           FROM (
                 SELECT user_id,
                        product_ownership_id,
                        product_slug,
                        (CASE WHEN max_c_date = DATE '1970-01-01' THEN 'active'
                              WHEN max_c_date >= DATE '2015-02-01' + INTERVAL '8' MONTH THEN 'active'
                              WHEN max_c_date < DATE '2015-01-01' + INTERVAL '8' MONTH THEN 'inactive'
                              ELSE 'churned' END) AS churn_category,
                              (DATE '2015-01-01' + INTERVAL '8' MONTH) AS churn_category_month
                 FROM (
                      SELECT user_id,
                             product_ownership_id,
                             product_slug,
                             max(CASE WHEN cancellation_date IS NULL THEN DATE '1970-01-01'
                                 ELSE CAST(SUBSTRING(cancellation_date, 1, 10) AS DATE) END)
                                 over (PARTITION BY product_ownership_id) AS max_c_date
                      FROM trial.billing_combined
                      WHERE CAST(SUBSTRING(date_only, 1, 10) AS DATE) < (DATE '2015-02-01' + INTERVAL '8' MONTH)
                      AND product_slug != ''
                      ) AS foo
                ) AS temp
                GROUP BY product_slug, churn_category, churn_category_month
    ) AS temp1
GROUP BY product_slug, churn_category_month

UNION

-- 2015-10
SELECT product_slug, churn_category_month,
       SUM(CASE WHEN churn_category = 'inactive' THEN 0 ELSE user_count END) AS total_active_users,
       MAX(CASE WHEN churn_category = 'churned' THEN user_count ELSE 0 END) AS total_churned_users,
       cASt(MAX(CASE WHEN churn_category = 'churned'
         THEN user_count ELSE 0 END) AS double)/cASt(SUM(CASE WHEN churn_category = 'inactive'
           THEN 0 ELSE user_count END) AS double)*100 AS user_ccr_monthly_percentage,
       SUM(CASE WHEN churn_category = 'inactive' THEN 0 ELSE product_count END) AS total_active_products,
       MAX(CASE WHEN churn_category = 'churned' THEN product_count ELSE 0 END) AS total_churned_products,
       cASt(MAX(CASE WHEN churn_category = 'churned'
         THEN product_count ELSE 0 END) AS double)/cASt(SUM(CASE WHEN churn_category = 'inactive'
           THEN 0 ELSE product_count END) AS double)*100 AS product_ccr_monthly_percentage
FROM (
      SELECT product_slug,
           churn_category,
           churn_category_month,
           count(distinct user_id) AS user_count,
           count(distinct product_ownership_id) AS product_count
           FROM (
                 SELECT user_id,
                        product_ownership_id,
                        product_slug,
                        (CASE WHEN max_c_date = DATE '1970-01-01' THEN 'active'
                              WHEN max_c_date >= DATE '2015-02-01' + INTERVAL '9' MONTH THEN 'active'
                              WHEN max_c_date < DATE '2015-01-01' + INTERVAL '9' MONTH THEN 'inactive'
                              ELSE 'churned' END) AS churn_category,
                              (DATE '2015-01-01' + INTERVAL '9' MONTH) AS churn_category_month
                 FROM (
                      SELECT user_id,
                             product_ownership_id,
                             product_slug,
                             max(CASE WHEN cancellation_date IS NULL THEN DATE '1970-01-01'
                                 ELSE CAST(SUBSTRING(cancellation_date, 1, 10) AS DATE) END)
                                 over (PARTITION BY product_ownership_id) AS max_c_date
                      FROM trial.billing_combined
                      WHERE CAST(SUBSTRING(date_only, 1, 10) AS DATE) < (DATE '2015-02-01' + INTERVAL '9' MONTH)
                      AND product_slug != ''
                      ) AS foo
                ) AS temp
                GROUP BY product_slug, churn_category, churn_category_month
    ) AS temp1
GROUP BY product_slug, churn_category_month

UNION

-- 2015-11
SELECT product_slug, churn_category_month,
       SUM(CASE WHEN churn_category = 'inactive' THEN 0 ELSE user_count END) AS total_active_users,
       MAX(CASE WHEN churn_category = 'churned' THEN user_count ELSE 0 END) AS total_churned_users,
       cASt(MAX(CASE WHEN churn_category = 'churned'
         THEN user_count ELSE 0 END) AS double)/cASt(SUM(CASE WHEN churn_category = 'inactive'
           THEN 0 ELSE user_count END) AS double)*100 AS user_ccr_monthly_percentage,
       SUM(CASE WHEN churn_category = 'inactive' THEN 0 ELSE product_count END) AS total_active_products,
       MAX(CASE WHEN churn_category = 'churned' THEN product_count ELSE 0 END) AS total_churned_products,
       cASt(MAX(CASE WHEN churn_category = 'churned'
         THEN product_count ELSE 0 END) AS double)/cASt(SUM(CASE WHEN churn_category = 'inactive'
           THEN 0 ELSE product_count END) AS double)*100 AS product_ccr_monthly_percentage
FROM (
      SELECT product_slug,
           churn_category,
           churn_category_month,
           count(distinct user_id) AS user_count,
           count(distinct product_ownership_id) AS product_count
           FROM (
                 SELECT user_id,
                        product_ownership_id,
                        product_slug,
                        (CASE WHEN max_c_date = DATE '1970-01-01' THEN 'active'
                              WHEN max_c_date >= DATE '2015-02-01' + INTERVAL '10' MONTH THEN 'active'
                              WHEN max_c_date < DATE '2015-01-01' + INTERVAL '10' MONTH THEN 'inactive'
                              ELSE 'churned' END) AS churn_category,
                              (DATE '2015-01-01' + INTERVAL '10' MONTH) AS churn_category_month
                 FROM (
                      SELECT user_id,
                             product_ownership_id,
                             product_slug,
                             max(CASE WHEN cancellation_date IS NULL THEN DATE '1970-01-01'
                                 ELSE CAST(SUBSTRING(cancellation_date, 1, 10) AS DATE) END)
                                 over (PARTITION BY product_ownership_id) AS max_c_date
                      FROM trial.billing_combined
                      WHERE CAST(SUBSTRING(date_only, 1, 10) AS DATE) < (DATE '2015-02-01' + INTERVAL '10' MONTH)
                      AND product_slug != ''
                      ) AS foo
                ) AS temp
                GROUP BY product_slug, churn_category, churn_category_month
    ) AS temp1
GROUP BY product_slug, churn_category_month

UNION

-- 2015-12
SELECT product_slug, churn_category_month,
       SUM(CASE WHEN churn_category = 'inactive' THEN 0 ELSE user_count END) AS total_active_users,
       MAX(CASE WHEN churn_category = 'churned' THEN user_count ELSE 0 END) AS total_churned_users,
       cASt(MAX(CASE WHEN churn_category = 'churned'
         THEN user_count ELSE 0 END) AS double)/cASt(SUM(CASE WHEN churn_category = 'inactive'
           THEN 0 ELSE user_count END) AS double)*100 AS user_ccr_monthly_percentage,
       SUM(CASE WHEN churn_category = 'inactive' THEN 0 ELSE product_count END) AS total_active_products,
       MAX(CASE WHEN churn_category = 'churned' THEN product_count ELSE 0 END) AS total_churned_products,
       cASt(MAX(CASE WHEN churn_category = 'churned'
         THEN product_count ELSE 0 END) AS double)/cASt(SUM(CASE WHEN churn_category = 'inactive'
           THEN 0 ELSE product_count END) AS double)*100 AS product_ccr_monthly_percentage
FROM (
      SELECT product_slug,
           churn_category,
           churn_category_month,
           count(distinct user_id) AS user_count,
           count(distinct product_ownership_id) AS product_count
           FROM (
                 SELECT user_id,
                        product_ownership_id,
                        product_slug,
                        (CASE WHEN max_c_date = DATE '1970-01-01' THEN 'active'
                              WHEN max_c_date >= DATE '2015-02-01' + INTERVAL '11' MONTH THEN 'active'
                              WHEN max_c_date < DATE '2015-01-01' + INTERVAL '11' MONTH THEN 'inactive'
                              ELSE 'churned' END) AS churn_category,
                              (DATE '2015-01-01' + INTERVAL '11' MONTH) AS churn_category_month
                 FROM (
                      SELECT user_id,
                             product_ownership_id,
                             product_slug,
                             max(CASE WHEN cancellation_date IS NULL THEN DATE '1970-01-01'
                                 ELSE CAST(SUBSTRING(cancellation_date, 1, 10) AS DATE) END)
                                 over (PARTITION BY product_ownership_id) AS max_c_date
                      FROM trial.billing_combined
                      WHERE CAST(SUBSTRING(date_only, 1, 10) AS DATE) < (DATE '2015-02-01' + INTERVAL '11' MONTH)
                      AND product_slug != ''
                      ) AS foo
                ) AS temp
                GROUP BY product_slug, churn_category, churn_category_month
    ) AS temp1
GROUP BY product_slug, churn_category_month

ORDER BY churn_category_month ASC, total_churned_users DESC, total_churned_products DESC
