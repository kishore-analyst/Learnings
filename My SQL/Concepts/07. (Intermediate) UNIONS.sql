-- UNIONS	
#UNION is used to combine the results of two or more SELECT statements into a single result set.


SELECT first_name, last_name, 'Old Lady' label
FROM employee_demographics
WHERE age > 40 AND gender = 'Female'
UNION
SELECT first_name, last_name, 'Old Man' label
FROM employee_demographics
WHERE age > 40 AND gender = 'Male'
UNION
SELECT first_name, last_name, 'high paid' label
FROM employee_salary
WHERE salary > 50000
ORDER BY first_name;