DELIMITER $$
CREATE PROCEDURE `Large_Salaries`()
BEGIN
	 SELECT*
	 FROM employee_salary
	 WHERE salary >=55000;
	 SELECT*
	 FROM employee_salary
	 WHERE salary >=10000;
END$$
DELIMITER ;