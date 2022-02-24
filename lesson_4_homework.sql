--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task13 (lesson3)
--Компьютерная фирма: Вывести список всех продуктов и производителя с указанием типа продукта (pc, printer, laptop). Вывести: model, maker, type

SELECT maker
	, sub.model
	, type_
FROM (
	SELECT model
		, 'pc' AS type_
	FROM pc p
	UNION ALL
	SELECT model
		, 'laptop' AS type_
	FROM laptop l 
	UNION ALL
	SELECT model
		, 'printer' AS type_
	FROM printer p2 
	) sub
	JOIN product
		ON sub.model = product.model


--task14 (lesson3)
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"

SELECT *
	, CASE
		WHEN price > (SELECT avg(price) FROM pc) THEN 1 ELSE 0 END price_is_more_than_pc_avg
FROM printer p 
	

--task15 (lesson3)
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)

SELECT "name"
	, s."class"
FROM ships s 
JOIN classes c 
	ON c."class" = s."class" 
WHERE s."class" IS NULL


--task16 (lesson3)
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.

SELECT "name"
FROM battles b 
WHERE EXTRACT('year' FROM "date") NOT IN 
	(SELECT launched FROM ships s)

--task17 (lesson3)
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.

SELECT *
FROM ships s 
JOIN outcomes o 
	ON o.ship = s."name" 
WHERE "class" IN 
	(SELECT "class" FROM ships WHERE "class" = 'Kongo')
	
--task1  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше > 300. Во view три колонки: model, price, flag


	
CREATE VIEW all_products_flag_300 AS
	SELECT model, price, 'pc' AS flag FROM pc WHERE price > 300
	UNION ALL
	SELECT model, price, 'laptop' AS flag FROM laptop WHERE price > 300 
	UNION ALL
	SELECT model, price, 'printer' AS flag FROM printer WHERE price > 300
	

--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше cредней . Во view три колонки: model, price, flag

CREATE OR REPLACE VIEW all_products_flag_300 AS
	SELECT model, price, 'pc' AS flag FROM pc WHERE price > (SELECT avg(price) FROM pc)
	UNION ALL
	SELECT model, price, 'laptop' AS flag FROM laptop WHERE price > (SELECT avg(price) FROM laptop)
	UNION ALL
	SELECT model, price, 'printer' AS flag FROM printer WHERE price > (SELECT avg(price) FROM printer)

	--task3  (lesson4)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

SELECT *
FROM printer p3
JOIN product p4 
	ON p4.model = p3.model
WHERE price > (
	SELECT avg(price) AS avg_price
	FROM printer p 
	JOIN product p2 
		ON p2.model = p.model
	WHERE maker = 'D' OR maker = 'C'
	)
	AND maker = 'A'




--task4 (lesson4)
-- Компьютерная фирма: Вывести все товары производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

WITH t1 AS (
	SELECT model, price FROM pc
	UNION ALL
	SELECT model, price FROM laptop
	UNION ALL
	SELECT model, price FROM printer
	), t2 AS (
	SELECT avg(price)
	FROM product p 
	JOIN t1
		ON t1.model = p.model 
	WHERE maker = 'D' OR maker = 'C'
	), t3 AS (
	SELECT *
	FROM t1
	WHERE price > (SELECT * FROM t2)
	)
SELECT DISTINCT t3.model, "type"
FROM t3
JOIN product p
	ON p.model = t3.model 
WHERE maker = 'A'


--task5 (lesson4)
-- Компьютерная фирма: Какая средняя цена среди уникальных продуктов производителя = 'A' (printer & laptop & pc)

SELECT avg(price)
FROM 
(
	SELECT DISTINCT model, price FROM pc
	UNION ALL
	SELECT DISTINCT model, price FROM laptop
	UNION ALL
	SELECT DISTINCT model, price FROM printer p
) s
JOIN product p2 
	ON s.model = p2.model
WHERE maker = 'A'


--task6 (lesson4)
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) по каждому производителю. Во view: maker, count

CREATE VIEW count_products_by_makers AS 
	SELECT maker
		, count(*)
	FROM (
		SELECT model FROM pc
		UNION ALL
		SELECT model FROM laptop
		UNION ALL
		SELECT model FROM printer p
	) s 
	JOIN product p2 
		ON s.model = p2.model
	GROUP BY maker


--task7 (lesson4)
-- По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count)

--task8 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры производителя 'D'
	
--task9 (lesson4)
-- Компьютерная фирма: Сделать на базе таблицы (printer_updated) view с дополнительной колонкой производителя (название printer_updated_with_makers)

CREATE TABLE printer_updated AS
	SELECT code
		, p.model
		, color
		, p."type"
		, price
		, maker
	FROM printer p
	JOIN product p2
		ON p.model = p2.model
		
		
DELETE FROM printer_updated
	WHERE maker = 'D'


SELECT * FROM printer_updated p 


--task10 (lesson4)
-- Корабли: Сделать view c количеством потопленных кораблей и классом корабля (название sunk_ships_by_classes). Во view: count, class (если значения класса нет/IS NULL, то заменить на 0)

CREATE VIEW sunk_ships_by_classes AS 
	SELECT COALESCE(c."class", '0') AS "class"
		, count(*)
	FROM ships s
	JOIN classes c
		ON c."class" = s."class" 
	FULL OUTER JOIN outcomes o
		ON o.ship = s."name" 
	WHERE "result" = 'sunk'
	GROUP BY c."class"
	
		
SELECT * FROM sunk_ships_by_classes

--task11 (lesson4)
-- Корабли: По предыдущему view (sunk_ships_by_classes) сделать график в colab (X: class, Y: count)

--task12 (lesson4)
-- Корабли: Сделать копию таблицы classes (название classes_with_flag) и добавить в нее flag: если количество орудий больше или равно 9 - то 1, иначе 0

CREATE TABLE classes_with_flag AS 
	SELECT *
		, CASE
			WHEN numguns >= 9
			THEN 1
			ELSE 0
			END flag
	FROM classes 


SELECT * FROM classes_with_flag c 


--task13 (lesson4)
-- Корабли: Сделать график в colab по таблице classes с количеством классов по странам (X: country, Y: count)

--task14 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M".

SELECT count(*)
FROM ships s 
WHERE "name" LIKE 'M%' OR "name" LIKE 'O%'

--task15 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название состоит из двух слов.

SELECT count(*)
FROM ships s 
WHERE "name" LIKE '% %'

--task16 (lesson4)
-- Корабли: Построить график с количеством запущенных на воду кораблей и годом запуска (X: year, Y: count)

SELECT launched 
	, count(*) 
FROM ships s 
GROUP BY launched 
ORDER BY launched 
	
