-- GROUP BY 

SELECT *
FROM  employee_demographics;

SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM  employee_demographics
GROUP BY  gender;

SELECT occupation, salary, dept_id
FROM  employee_salary
GROUP BY  occupation, salary, dept_id; 


-- ORDER BY 

SELECT *
FROM  employee_demographics
ORDER BY gender, age DESC;
-- or --   the column number can be used to refer the column instead of writing the columnn name. Recommended is to write column name to readability and to avoid error
SELECT *
FROM  employee_demographics
ORDER BY 5, 4 DESC;

SELECT *
FROM  employee_demographics
ORDER BY age, gender;  -- it is important to choose the column which should first and the next - here the age is the first criteria and gender next which has no purpose as age is ordered


















