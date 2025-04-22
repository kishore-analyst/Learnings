-- CASE Statements


SELECT concat(first_name, ' ', last_name) AS 'full_name',
CASE 
	WHEN age < 30 THEN 'Young'
	WHEN age BETWEEN 30 and 50 THEN 'Old'
    WHEN age > 50 THEN "On Death's Door"
END  AS 'age_bracket'
FROM employee_demographics;


-- Pay increase and bonus
# < 50000 = 5%
# > 50000 = 7%
# Finance = 10% Bonus


SELECT concat(first_name, ' ', last_name) AS 'full_name', occupation, salary,
CASE 
	WHEN salary <= 50000 THEN salary*1.05
    WHEN salary > 50000 THEN salary*1.07
END 'new_salary',
CASE
	WHEN dept_id = 6 THEN salary*.1
END 'bonus'
FROM employee_salary;















