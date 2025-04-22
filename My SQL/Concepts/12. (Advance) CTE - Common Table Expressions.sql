-- CTE (Common Table Expression)
# CTEs improve readability and make queries more structured.
# Using CTE for Aggregation & Filtering



WITH avg_salary AS 
(
    SELECT AVG(salary) AS avg_sal FROM employee_salary
)
SELECT first_name, salary
FROM employee_salary, avg_salary
WHERE salary > avg_salary.avg_sal;


WITH high_paid AS 
(
    SELECT employee_id, first_name, salary FROM employee_salary WHERE salary > 50000
)
SELECT * FROM high_paid;


WITH CTE_Trial (Row_num, Occupation, Avg_Salary)AS 
(
    SELECT ROW_NUMBER() OVER (ORDER BY occupation),occupation, FORMAT(AVG(salary),3)
    FROM employee_salary
    GROUP BY occupation
)
SELECT *
FROM CTE_Trial;

































