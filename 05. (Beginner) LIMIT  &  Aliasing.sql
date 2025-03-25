-- LIMIT


SELECT *
FROM employee_demographics
ORDER  BY age DESC
LIMIT 5;

-- Explanation
#The number (5) means return the top 5 rows.
#It does not skip any rows.
#This query returns the top 5 rows based on age DESC.

SELECT *
FROM employee_demographics
ORDER  BY age DESC
LIMIT 5, 1;
-- explanation
#The first number (5) is the offset → It skips the first 5 rows.
#The second number (1) is the row count → It selects only 1 row after skipping.
#This query returns the 6th row in the sorted result.


-- ALiasing
#Aliasing in SQL allows us to rename a column or table temporarily for readability, convenience
# Can use AS as the keyword or nothing just a space and enter the column name

SELECT gender, AVG(age) AS avg_age
FROM employee_demographics
GROUP BY gender
HAVING avg_age >40;