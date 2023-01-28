CREATE DATABASE employee;

USE employee;

SELECT DATABASE();

CREATE TABLE Proj_table (
	PROJECT_ID CHAR(4),
    PROJ_Name VARCHAR(50),
    DOMAIN VARCHAR(20),
    START_DATE DATE,
    CLOSURE_DATE DATE,
    DEV_QTR CHAR(2),
    STATUS VARCHAR(10)
    );
    
DESC Proj_table;

SELECT * FROM Proj_table;

CREATE TABLE Data_science_team (
	EMP_ID CHAR(4),
    FIRST_NAME VARCHAR(50),
    LAST_NAME VARCHAR(50),
    GENDER CHAR(1),
    ROLE VARCHAR(50),
    DEPT VARCHAR(20),
    EXP INT,
    COUNTRY VARCHAR(20),
    CONTINENT VARCHAR(25)
    );
    
DROP TABLE Data_science_team;

CREATE TABLE Data_science_team (
	EMP_ID CHAR(4),
    FIRST_NAME VARCHAR(50),
    LAST_NAME VARCHAR(50),
    GENDER CHAR(1),
    ROLE VARCHAR(50),
    DEPT VARCHAR(20),
    EXP INT,
    COUNTRY VARCHAR(20),
    CONTINENT VARCHAR(25)
    );
    
SELECT * FROM Data_science_team;

CREATE TABLE emp_record_table (
	EMP_ID CHAR(4),
    FIRST_NAME VARCHAR(50),
    LAST_NAME VARCHAR(50),
    GENDER CHAR(1),
    ROLE VARCHAR(50),
    DEPT VARCHAR(20),
    EXP INT,
    COUNTRY VARCHAR(20),
    CONTINENT VARCHAR(25),
    SALARY INT,
    EMP_RATING TINYINT,
    MANAGER_ID CHAR(4),
    PROJ_ID CHAR(4)
    );
    
SELECT * FROM emp_record_table;

-- (3) Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table, and make a list of employees and details of their department.

SELECT EMP_ID,FIRST_NAME,LAST_NAME,GENDER,DEPT 
FROM emp_record_table; 

-- (4) Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: 

-- less than two

SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
FROM emp_record_table WHERE EMP_RATING < 2;

-- greater than four 

SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
FROM emp_record_table WHERE EMP_RATING > 4;

-- between two and four

SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
FROM emp_record_table WHERE EMP_RATING BETWEEN 2 AND 4 ;

-- (5) Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department from the employee table and then give the resultant column alias as NAME.

SELECT
CONCAT(FIRST_NAME,' ',LAST_NAME) AS NAME FROM emp_record_table
WHERE DEPT='FINANCE';

-- (6) Write a query to list only those employees who have someone reporting to them. Also, show the number of reporters (including the President).

SELECT m.EMP_ID,m.FIRST_NAME,m.LAST_NAME,m.ROLE,
m.EXP,COUNT(e.EMP_ID) as "EMP_COUNT"
FROM emp_record_table m
INNER JOIN emp_record_table e
ON m.EMP_ID = e.MANAGER_ID
GROUP BY m.EMP_ID
ORDER BY m.EMP_ID;

-- (7) Write a query to list down all the employees from the healthcare and finance departments using union. Take data from the employee record table.

SELECT EMP_ID,FIRST_NAME,LAST_NAME,DEPT FROM emp_record_table
WHERE DEPT = "HEALTHCARE"
UNION
SELECT EMP_ID,FIRST_NAME,LAST_NAME,DEPT FROM emp_record_table
WHERE DEPT = "FINANCE"
ORDER BY DEPT,EMP_ID;

-- (8) Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept. Also include the respective employee rating along with the max emp rating for the department.

SELECT  m.EMP_ID,m.FIRST_NAME,m.LAST_NAME,m.ROLE,m.DEPT,m.EMP_RATING,max(m.EMP_RATING)
OVER(PARTITION BY m.DEPT)
AS "MAX_DEPT_RATING"
FROM emp_record_table m
ORDER BY DEPT;

-- (9) Write a query to calculate the minimum and the maximum salary of the employees in each role. Take data from the employee record table.

SELECT ROLE, MIN(SALARY) AS MIN_SALARY, MAX(SALARY) AS MAX_SALARY
FROM emp_record_table GROUP BY ROLE;

-- (10) Write a query to assign ranks to each employee based on their experience. Take data from the employee record table.

SELECT EMP_ID,FIRST_NAME,LAST_NAME,EXP,
RANK() OVER(ORDER BY EXP) EXP_RANK
FROM emp_record_table;

-- (11) Write a query to create a view that displays employees in various countries whose salary is more than six thousand. Take data from the employee record table.

CREATE VIEW employees_in_various_countries AS
SELECT EMP_ID,FIRST_NAME,LAST_NAME,COUNTRY,SALARY
FROM emp_record_table
WHERE SALARY>6000;

SELECT *FROM employees_in_various_countries;

-- (12) Write a nested query to find employees with experience of more than ten years. Take data from the employee record table.

SELECT EMP_ID,FIRST_NAME,LAST_NAME,EXP FROM emp_record_table
WHERE EMP_ID IN(SELECT manager_id FROM emp_record_table);

-- (13) Write a query to create a stored procedure to retrieve the details of the employees whose experience is more than three years. Take data from the employee record table.

DELIMITER &&
CREATE PROCEDURE get_experience_details()
BEGIN
SELECT EMP_ID,FIRST_NAME,LAST_NAME,EXP FROM emp_record_table WHERE EXP>3;
END &&
CALL get_experience_details();

-- (14) Write a query using stored functions in the project table to check whether the job profile assigned to each employee in the data science team matches the organization’s set standard.
-- The standard being:
-- For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',
-- For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',
-- For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',
-- For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',
-- For an employee with the experience of 12 to 16 years assign 'MANAGER'.

DELIMITER &&
CREATE FUNCTION Employee_ROLE(EXP int)
RETURNS VARCHAR(40)
DETERMINISTIC
BEGIN DECLARE Employee_ROLE VARCHAR(40);
IF EXP>12 AND 16 THEN SET Employee_ROLE="MANAGER";
ELSEIF EXP>10 AND 12 THEN SET Employee_ROLE ="LEAD DATA SCIENTIST";
ELSEIF EXP>5 AND 10 THEN SET Employee_ROLE ="SENIOR DATA SCIENTIST";
ELSEIF EXP>2 AND 5 THEN SET Employee_ROLE ="ASSOCIATE DATA SCIENTIST";
ELSEIF EXP<=2 THEN SET Employee_ROLE ="JUNIOR DATA SCIENTIST";
END IF;
RETURN (Employee_ROLE);
END &&

SELECT EXP,Employee_ROLE(EXP)
FROM data_science_team;

-- (15) Create an index to improve the cost and performance of the query to find the employee whose FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan.

CREATE INDEX idx_first_name
ON emp_record_table(FIRST_NAME(20));
SELECT * FROM emp_record_table
WHERE FIRST_NAME='Eric';

-- (16) Write a query to calculate the bonus for all the employees, based on their ratings and salaries (Use the formula: 5% of salary * employee rating).

UPDATE emp_record_table set salary=(select salary +(select salary*.05*EMP_RATING))
SELECT *FROM emp_record_table;

-- (17) Write a query to calculate the average salary distribution based on the continent and country. Take data from the employee record table.

SELECT EMP_ID,FIRST_NAME,LAST_NAME,SALARY,COUNTRY,CONTINENT,
AVG(salary)OVER(PARTITION BY COUNTRY)AVG_salary_IN_COUNTRY,
AVG(salary)OVER(PARTITION BY CONTINENT)AVG_salary_IN_CONTINENT, 
COUNT(*)OVER(PARTITION BY COUNTRY)COUNT_IN_COUNTRY,
COUNT(*)OVER(PARTITION BY CONTINENT)COUNT_IN_CONTINENT
     FROM emp_record_table;




