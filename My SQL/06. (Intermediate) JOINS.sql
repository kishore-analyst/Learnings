-- JOIN
# INNER JOIN - An INNER JOIN returns only the matching records between two tables based on a common column. If there is no match, the row is not included in the result.
# LEFT JOIN - All rows from the left table + matching rows from the right table
# RIGHT JOIN - All rows from the right table + matching rows from the left table
# self join concept - A SELF JOIN is when a table is joined with itself. It is useful when you need to compare rows within the same table.

-- INNER JOIN
# by default JOIN represent INNER JOIN


SELECT *
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id; 
    

-- OUTER JOIN 


SELECT *
FROM employee_demographics AS dem
LEFT JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id;
    
SELECT *
FROM employee_demographics AS dem
RIGHT JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id;   
    

-- Self join concept


SELECT 
	dem1.employee_id friend_id,
    dem1.first_name friend_name,
    dem2.employee_id,
    dem2.first_name
FROM employee_demographics AS dem1
RIGHT JOIN employee_demographics AS dem2
	ON dem1.employee_id + 1= dem2.employee_id; 
    
    
-- Joining multiple table
    
    
SELECT *
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
INNER JOIN parks_departments AS pd
	ON sal.dept_id = pd.department_id;  
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    