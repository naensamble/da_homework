--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1 (lesson5)
-- Компьютерная фирма: Сделать view (pages_all_products), в которой будет постраничная разбивка всех продуктов (не более двух продуктов на одной странице). 
--Вывод: все данные из laptop, номер страницы, список всех страниц


--sample:
--1 1
--2 1
--1 2
--2 2
--1 3
--2 3

--task2 (lesson5)
-- Компьютерная фирма: Сделать view (distribution_by_type), в рамках которого будет процентное соотношение всех товаров по типу устройства. Вывод: производитель, тип, процент (%)

CREATE OR REPLACE VIEW distribution_by_type AS (
	
	WITH t1 AS (
		SELECT maker
			, "type"
			, count(*) AS devices_cnt
		FROM product
		GROUP BY maker, "type"
	), t2 AS (
			
		SELECT maker
			, count(*) AS total_devices_cnt
		FROM product p 
		GROUP BY maker

	)
SELECT t1.maker
	, "type"
	, CAST(devices_cnt AS float) / CAST(total_devices_cnt AS float) * 100 AS percentage
FROM t1
JOIN t2
	ON t1.maker = t2.maker

)


SELECT * FROM distribution_by_type

--task3 (lesson5)
-- Компьютерная фирма: Сделать на базе предыдущенр view график - круговую диаграмму. Пример https://plotly.com/python/histograms/



--task4 (lesson5)
-- Корабли: Сделать копию таблицы ships (ships_two_words), но название корабля должно состоять из двух слов

CREATE TABLE ships_two_words AS (
	SELECT *
	FROM ships s 
	WHERE "name" LIKE '% %'
	)

SELECT * FROM ships_two_words

--task5 (lesson5)
-- Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL) и название начинается с буквы "S"

SELECT ship
FROM ships s
FULL OUTER JOIN outcomes o 
	ON s."name" = o.ship 
WHERE "class" IS NULL 
	AND COALESCE("name", ship, '') LIKE 'S%'

--task6 (lesson5)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'C' 
-- и три самых дорогих (через оконные функции). Вывести model

	
-- у производителя C нет принтеров(
--SELECT *
--FROM product p 
--FULL OUTER JOIN printer p2 
--	ON p.model = p2.model 


	
	