-- Window Functions
# ROW_NUMBER() OVER()
# AVG() OVER()
# RANK() OVER()
#DENSE_RANK() OVER()

SELECT occupation, avg(salary)
FROM employee_salary
GROUP BY occupation
ORDER BY occupation
;
SELECT employee_id, occupation, avg(salary) over (partition by occupation)
FROM employee_salary
ORDER BY employee_id
;


SELECT 
	dem.employee_id, 
    concat(dem.first_name, ' ', dem.last_name) full_name,
	gender, 
    salary,
	ROW_NUMBER() OVER(partition by gender ORDER BY salary DESC) row_gender,
    RANK() OVER(partition by gender ORDER BY salary DESC) rank_sal_gender,
		DENSE_RANK() OVER(partition by gender ORDER BY salary DESC) rank_sal_gender
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id

















