
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

WITH t1 AS
    (
    SELECT cd.client_id
        , bank
        , actual_from_date
        , MAX(salary) AS max_salary
    FROM clnt_aggr ca
    JOIN clnt_data cd
        ON ca.client_id = cd.client_id
    GROUP BY client_id, bank, actual_from_date
    ), t2 AS
    (
    SELECT cd.client_id
        , bank
        , actual_from_date
        , max_salary
        , age
    FROM t1
    JOIN clnt_data cd
        ON cd.client_id = t1.client_id
    )
SELECT client_id
    , bank
    , actual_from_date
    , max_salary
    , age
FROM t2
JOIN (
    SELECT client_id
        , MAX(actual_from_date) AS actual_from_date
    FROM clnt_data cd
    GROUP BY client_id
    ) s
ON s.client_id = t2.client_id
    AND s.actual_from_date = t2.actual_from_date



-- Задание 3

SELECT client_id
FROM
(
    SELECT DISTINCT cd.client_id
        , actual_from_date
    FROM clnt_aggr ca
    JOIN clnt_data cd
        ON cd.client_id = ca.client_id
    WHERE pos_amt > (SELECT AVG(pos_amt) FROM clnt_aggr)
) s 
JOIN (
    SELECT client_id
        , MAX(actual_from_date) AS actual_from_date
    FROM clnt_data cd
    GROUP BY client_id
    ) s2
ON s.client_id = s2.client_id
    AND s.actual_from_date = s2.actual_from_date
