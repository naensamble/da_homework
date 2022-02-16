--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

-- Задание 1: Вывести name, class по кораблям, выпущенным после 1920
--

SELECT * 
FROM ships s
WHERE launched >= 1920

-- Задание 2: Вывести name, class по кораблям, выпущенным после 1920, но не позднее 1942
--

SELECT * 
FROM ships s
WHERE launched BETWEEN 1920 AND 1942


-- Задание 3: Какое количество кораблей в каждом классе. Вывести количество и class
--

SELECT "class"
	, count(*)
FROM ships s
GROUP BY "class"

-- Задание 4: Для классов кораблей, калибр орудий которых не менее 16, укажите класс и страну. (таблица classes)
--

SELECT s."class"
	, name
	, country
	, bore
FROM ships
JOIN classes s
	ON ships."class" = s."class"
WHERE bore >= 16

-- Задание 5: Укажите корабли, потопленные в сражениях в Северной Атлантике (таблица Outcomes, North Atlantic). Вывод: ship.
--

SELECT ship
FROM outcomes
WHERE battle = 'North Atlantic' AND "result" = 'sunk'

-- Задание 6: Вывести название (ship) последнего потопленного корабля
--

SELECT ship
	, date
FROM outcomes o
JOIN battles b
	ON o.battle = b."name"
WHERE date = ( 
	SELECT max(date)
	FROM outcomes o
	JOIN battles b
		ON o.battle = b."name"
	WHERE "result" = 'sunk'
	)
	AND "result" = 'sunk'



-- Задание 7: Вывести название корабля (ship) и класс (class) последнего потопленного корабля
--
SELECT ship
	, COALESCE("class", 'Unknown') AS "class"
FROM
(
	SELECT ship
		, date
	FROM outcomes o
	JOIN battles b
		ON o.battle = b."name"
	WHERE date = ( 
		SELECT max(date)
			FROM outcomes o
			JOIN battles b
				ON o.battle = b."name"
			WHERE "result" = 'sunk'
		)
		AND "result" = 'sunk'
	) AS sub
LEFT JOIN ships ON ships."name" = sub.ship
	

-- Задание 8: Вывести все потопленные корабли, у которых калибр орудий не менее 16, и которые потоплены. Вывод: ship, class
--

SELECT s."name"
	, s."class" 
FROM ships s 
JOIN classes c ON c."class" = s."class"
JOIN outcomes o ON o.ship = s."name"
WHERE bore >= 16 AND "result" = 'sunk'

-- Задание 9: Вывести все классы кораблей, выпущенные США (таблица classes, country = 'USA'). Вывод: class
--

SELECT
	DISTINCT c."class"
FROM ships s 
JOIN classes c ON c."class" = s."class"
WHERE country = 'USA'

-- Задание 10: Вывести все корабли, выпущенные США (таблица classes & ships, country = 'USA'). Вывод: name, class


SELECT
	DISTINCT c."class"
	, "name"
FROM ships s 
JOIN classes c ON c."class" = s."class"
WHERE country = 'USA'
