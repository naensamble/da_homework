--task1  (lesson8)
-- oracle: https://leetcode.com/problems/department-top-three-salaries/

SELECT
    d.Name AS 'Department'
    , e1.Name AS 'Employee'
    , e1.Salary
FROM
    Employee e1
        JOIN
    Department d ON e1.DepartmentId = d.Id
WHERE 3 > (
    SELECT COUNT(DISTINCT e2.Salary)
    FROM Employee e2
    WHERE e2.Salary > e1.Salary
        AND e1.DepartmentId = e2.DepartmentId
    )

--task2  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/17

SELECT member_name
    , status
    , SUM(amount*unit_price) AS costs
FROM FamilyMembers
JOIN Payments 
    ON FamilyMembers.member_id = Payments.family_member
WHERE YEAR(date) = 2005
GROUP BY member_name, status


--task3  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/13

SELECT name
FROM Passenger
GROUP BY name
HAVING COUNT(name) > 1

--task4  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

SELECT COUNT(first_name) AS count
FROM Student
WHERE first_name = 'Anna'

--task5  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/35

SELECT COUNT(classroom) AS count
FROM Schedule
WHERE date='2019-09-02'

--task6  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

SELECT COUNT(first_name) AS count
FROM Student
WHERE first_name = 'Anna'

--task7  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/32

SELECT FLOOR(AVG(YEAR(CURRENT_DATE)
	- YEAR(birthday))) AS age
FROM FamilyMembers

--task8  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/27

SELECT good_type_name
	, SUM(amount * unit_price) AS costs
FROM GoodTypes
JOIN Goods
	ON good_type_id = type
JOIN Payments
	ON good_id = good
WHERE YEAR(date) = 2005
GROUP BY good_type_name


--task9  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/37

SELECT MIN(TIMESTAMPDIFF(YEAR, birthday, CURRENT_DATE)) AS year
FROM Student

--task10  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/44

SELECT MAX(TIMESTAMPDIFF(YEAR, birthday, CURRENT_DATE)) AS max_year
FROM Student
JOIN Student_in_class
	ON Student.id = Student_in_class.student
JOIN Class
	ON Student_in_class.class = Class.id
WHERE Class.name LIKE '10%'

--task11 (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/20

SELECT fms.status
	, fms.member_name
	, SUM(p.amount * p.unit_price) AS costs
FROM FamilyMembers fms
JOIN Payments p
	ON fms.member_id = p.family_member
JOIN Goods g
	ON p.good = g.good_id
JOIN GoodTypes gt
	ON g.type = gt.good_type_id
WHERE good_type_name = 'entertainment'
GROUP BY fms.status
	, fms.member_name

--task12  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/55

DELETE FROM Company
WHERE Company.id IN (
	SELECT company
	FROM Trip
	GROUP BY company
	HAVING COUNT(id) = (
		SELECT MIN(count)
		FROM (
			SELECT COUNT(id) AS count
			FROM Trip
			GROUP BY company
			) AS min_count
		)
	)


--task13  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/45

SELECT classroom
FROM Schedule
GROUP BY classroom
HAVING COUNT(classroom) = (
	SELECT COUNT (classroom)
	FROM Schedule
	GROUP BY classroom
	ORDER BY COUNT(classroom) DESC
	LIMIT 1
	) 

--task14  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/43

SELECT last_name
FROM Teacher
JOIN Schedule
	ON Teacher.id=Schedule.teacher
JOIN Subject
	ON Schedule.subject=Subject.id
	WHERE Subject.name = 'Physical Culture'
	ORDER BY Teacher.last_name 


--task15  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/63

SELECT CONCAT(
	last_name
	, '.'
	, LEFT(first_name, 1)
	, '.'
	, LEFT(middle_name, 1)
	, '.'
	) AS name
FROM Student
ORDER BY last_name, first_name


