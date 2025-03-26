#PEMDAS - Parentheses, exponents, multiplication, division, addition, subtraction

-- The order should follow in writing the queries

# SELECT – What columns do you need?
# CASE 
# FROM – Which table(s) are you selecting from?
# JOIN – Are you joining another table?
# WHERE – Filter records before aggregation.
# GROUP BY – Group records based on a column.
# HAVING – Filter aggregated data.
# ORDER BY – Sort the results.
# LIMIT – Restrict the number of rows.



SELECT *
FROM parks_and_recreation.employee_demographics;

SELECT *
FROM employee_demographics;

SELECT DISTINCT first_name
FROM employee_demographics;

SELECT first_name, age, (age+10)*2+1
FROM employee_demographics;