-- Subqueries


SELECT employee_id, age
FROM employee_demographics
WHERE employee_id IN 
				(SELECT employee_id
					FROM employee_salary
                    WHERE dept_id = 1)
;

SELECT employee_id, occupation, salary,
	(SELECT avg(salary) 
    FROM employee_salary) AS avg_salary
FROM employee_salary;

SELECT gender, 
	avg(age) avg_age, 
    max(age) max_age, 
    min(age) min_age, 
    count(age) count
FROM employee_demographics
GROUP BY gender
;

SELECT avg(max_age) avg_max_age
FROM 
	(SELECT gender, 
		avg(age) avg_age, 
		max(age) max_age, 
		min(age) min_age, 
		count(age) count
	FROM employee_demographics
	GROUP BY gender) age_table;





























