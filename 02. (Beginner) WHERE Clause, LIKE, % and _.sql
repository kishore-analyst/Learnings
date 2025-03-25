-- 0r # (both can be used to write a comment)
-- <> or != (both means same which is not equal to where !> commonly used in other coding languages and <> is specific for SQL)
-- '' (this can be used to strings and for numbers no need of quotes and for simple column name, eg. Salary, no quotes required 
-- but for special column name, eg. emp_salary, quotes required)


-- WHERE CLAUSE 


SELECT *
FROM employee_demographics
WHERE gender != 'Female';

SELECT *
FROM employee_demographics
WHERE birth_date > '1987-03-01';


-- AND OR NOT -- Logical Operators


SELECT *
FROM employee_demographics
WHERE birth_date > '1987-03-01'
AND gender = 'Male';

SELECT *
FROM employee_demographics
WHERE birth_date > '1987-03-01'
OR NOT gender = 'Male'; -- here OR NOT states that gender = female

SELECT *
FROM employee_demographics
WHERE (first_name = 'Leslie' AND age = 44) OR age > 55;


-- LIKE Statement
-- % and _


SELECT *
FROM employee_demographics
WHERE first_name LIKE 'jer%';

SELECT *
FROM employee_demographics
WHERE first_name LIKE '%ar%';

SELECT *
FROM employee_demographics
WHERE first_name LIKE 'a___';

SELECT *
FROM employee_demographics
WHERE first_name LIKE 'a___%';

SELECT *
FROM employee_demographics
WHERE birth_date LIKE '1983%';



