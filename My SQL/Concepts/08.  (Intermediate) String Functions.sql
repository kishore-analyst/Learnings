-- String Functions
# LENGTH - Find the Number of Characters in a String
# UPPER & LOWER - Convert Case
# TRIM - Remove Unwanted Spaces
# LEFT, RIGHT AND SUBSTRING - Extract Part of a String
# REPLACE - Replace Text
# LOCATE - Find Position of a Substring	
# CONCAT - Merge Two or More Strings


-- LENGTH


SELECT first_name, LENGTH(first_name)	
FROM employee_demographics
ORDER BY LENGTH(first_name);


-- UPPER, LOWER


SELECT UPPER(first_name)
FROM employee_demographics;

SELECT LOWER(first_name)
FROM employee_demographics;


-- TRIM
# TRIM - removes spaces from L and R
# LTRIM - left trim
# RTRIM - right trim


SELECT TRIM('         TONY          ');
SELECT LTRIM('         TONY          ');
SELECT RTRIM('         TONY          ');


-- LEFT, RIGHT and SUBSTING


SELECT LEFT(first_name, 3) First_3,
	RIGHT (first_name, 3) Last_3
FROM employee_demographics;

SELECT SUBSTRING(first_name,3,2),
	SUBSTRING(birth_date, 6,2)
FROM employee_demographics;

SELECT birth_date, 
	substring(birth_date, LOCATE( 0 , birth_date) +1)
FROM employee_demographics;


-- REPLACE


SELECT first_name, REPLACE(first_name, 'Tom' , 'Tomas') AS  updated_name
FROM employee_demographics;


-- LOCATE


SELECT first_name, LOCATE('ar', first_name)
FROM employee_demographics;


-- CONCAT


SELECT first_name, last_name,
	CONCAT(first_name,' ', last_name) full_name
FROM employee_demographics;







