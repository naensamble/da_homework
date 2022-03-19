
-- Задание 1

SELECT "date" 
    , bank
    , gender
    , age_category 
    , COUNT(DISTINCT client_id) AS clients_count
    , AVG(salary) AS avg_salary
FROM
(
    SELECT cd.client_id
        , "date"
        , bank
        , gender
        , CASE
            WHEN age <= 18 THEN 'Under 18'
            WHEN age > 18 AND age <= 35 THEN '18-35'
            WHEN age > 35 AND age <= 60 THEN '36-60'
            WHEN age > 60 THEN 'Over 60'
            END AS age_category
        , salary
    FROM clnt_aggr ca
    JOIN clnt_data cd
        on ca.client_id = cd.client_id
    WHERE "date" BETWEEN TO_DATE('2018-01-01', 'YYYY-mm-dd')
        AND TO_DATE('2018-12-31', 'YYYY-mm-dd')
) s
GROUP BY "date", bank, gender, age_category


-- Задание 2