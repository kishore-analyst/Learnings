-- Tempoary Table

CREATE TEMPORARY TABLE temp_table
(first_name varchar(50),
last_name  varchar(50),
favorite_food varchar(100)
);

INSERT INTO temp_table
VALUES ('Kishore', 'Kumar', 'Fried Rice');

SELECT*
FROM temp_table;

CREATE TEMPORARY TABLE salary_over_50k
SELECT *
FROM employee_salary
WHERE salary >= 50000;

SELECT *
FROM salary_over_50k;

































































