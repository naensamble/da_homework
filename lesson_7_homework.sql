--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson7)
-- sqlite3: Сделать тестовый проект с БД (sqlite3, project name: task1_7). В таблицу table1 записать 1000 строк с случайными значениями (3 колонки, тип int) от 0 до 1000.
-- Далее построить гистаграмму распределения этих трех колонко

Сделал в документе в тетрадке: lesson_7_homework_task1_7.ipynb

--task2  (lesson7)
-- oracle: https://leetcode.com/problems/duplicate-emails/


SELECT 'Email' 
FROM 'Person'
GROUP BY 'Email'
HAVING COUNT(*) > 1

--task3  (lesson7)
-- oracle: https://leetcode.com/problems/employees-earning-more-than-their-managers/

SELECT t1.name AS 'Employee'
FROM Employee AS t1
JOIN Employee AS t2
	ON t1.managerId = t2.Id AND t1.salary > t2.salary

--task4  (lesson7)
-- oracle: https://leetcode.com/problems/rank-scores/

SELECT Score, dense_rank() over(ORDER BY Score DESC) AS 'Rank'
FROM Scores



--task5  (lesson7)
-- oracle: https://leetcode.com/problems/combine-two-tables/

SELECT FirstName
	, LastName
	, City
	, State 
FROM Person 
LEFT JOIN Address
	ON Person.personId=Address.personId



