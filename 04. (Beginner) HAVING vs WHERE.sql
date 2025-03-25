-- HAVING vs WHERE

-- WHERE use case
# Used to filter rows before any aggregation.
# Works on individual records (row-by-row filtering).
# Cannot be used with aggregate functions (SUM(), COUNT(), AVG(), etc.).

-- HAVING use case
# Used to filter grouped records after aggregation.
# Works on aggregated values (like SUM(), COUNT(), etc.).	
# Must be used with GROUP BY.


SELECT occupation, AVG(salary)
FROM employee_salary
WHERE occupation LIKE '%manager%'
GROUP BY occupation
HAVING AVG(salary) > 75000













