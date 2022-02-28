--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing

--task1
--Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей.

WITH t1 AS (
	SELECT s."class"
		, count(*) AS cnt
	FROM ships s 
	JOIN outcomes o 
		ON o.ship = s."name"
	JOIN classes c 
		ON c."class" = s."class" 
	WHERE "result" = 'sunk'
	GROUP BY s."class" 
	)
SELECT c."class"
	, COALESCE(cnt, 0) AS cnt
FROM t1
FULL OUTER JOIN classes c
	ON c."class" = t1."class"
	
--task2
--Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.

SELECT c."class" 
	, min(launched) AS launched  
FROM ships s 
JOIN classes c 
	ON c."class" = s."class" 
GROUP BY c."class"
ORDER BY min(launched)

--task3
--Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, вывести имя класса и число потопленных кораблей.

WITH t1 AS (
	SELECT c."class"
		, count(*) AS ships_num_in_db
	FROM ships s 
	JOIN classes c 
		ON c."class" = s."class"
	GROUP BY c."class" 
	HAVING count(*) >= 3
	), t2 AS (
	SELECT s."class" 
		, count(*) AS sunk_ships_num
	FROM outcomes o
	JOIN ships s 
		ON s."name" = o.ship 
	GROUP BY s."class" 
	)
SELECT t1."class"
	, sunk_ships_num
	, ships_num_in_db
FROM t2
JOIN t1 
	ON t2."class" = t1."class"


--task4
--Корабли: Найдите названия кораблей, имеющих наибольшее число орудий среди всех кораблей такого же водоизмещения (учесть корабли из таблицы Outcomes).

SELECT DENSE_RANK() OVER (PARTITION BY displacement ORDER BY displacement DESC, numguns DESC) AS rank_
	, "name"
	, numguns
	, displacement 
FROM
	(
	SELECT *
	FROM ships s 
	JOIN classes c 
		ON c."class" = s."class" 
	LEFT JOIN outcomes o
		ON o.ship = s."name" 
	) sub

--task5
--Компьютерная фирма: Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker



WITH t1 AS (
	SELECT DISTINCT maker
	FROM product p
	WHERE "type" = 'Printer'
	), t2 AS (
	SELECT DISTINCT p.maker, model AS model_
	FROM product p
	JOIN t1
		ON p.maker = t1.maker
	WHERE "type" = 'Laptop'
	), t3 AS (
	SELECT *
	FROM t2
	JOIN laptop l 
		ON t2.model_ = l.model
	)
SELECT maker
	, model_
	, speed
	, ram
	, price
FROM t3
ORDER BY ram, speed DESC
