SELECT *
FROM Parks_and_Recreation.employee_demographics;

SELECT *
FROM Parks_and_Recreation.employee_salary;

SELECT *
FROM Parks_and_Recreation.parks_departments;


-- ---------------------------------------------------------- JOINS ---------------------------------------------------------------------

-- 1. INNER JOINS ---> returns value that same in both the columns












-- ------------------------------------------------------------- UNIONS ------------------------------------------------------------------

-- 1. UNION DISTINCT : it removes all the duplicate value and only give the distinct values

SELECT first_name, last_name
FROM employee_demographics
UNION DISTINCT 
SELECT first_name, last_name
FROM employee_demographics;


-- 2. UNION ALL : it gives all the values, also the duplicate values

SELECT first_name, last_name
FROM employee_demographics
UNION ALL 
SELECT first_name, last_name
FROM employee_demographics;



SELECT first_name, last_name, 'old' AS label
FROM employee_demographics
WHERE age > 50
;




SELECT first_name, last_name, 'old' AS label
FROM employee_demographics
WHERE age >50
UNION
SELECT first_name, last_name, 'Higly Paid Employee' AS label
FROM employee_salary
WHERE salary > 70000
;




SELECT first_name, last_name, 'Old Lady' AS label
FROM employee_demographics
WHERE age >40 AND gender = 'Male'
UNION
SELECT first_name, last_name, 'Old Man' AS label
FROM employee_demographics
WHERE age >40 AND gender = 'Female'
UNION
SELECT first_name, last_name, 'Higly Paid Employee' AS label
FROM employee_salary
WHERE salary > 70000
ORDER BY first_name,last_name
;












-- ---------------------------------------------------------- STRING FUNCTIONS ---------------------------------------------------------------


-- 1. LENGTH()

select length('skyfall');

select first_name, length(first_name) as words_length
FROM employee_demographics;

select first_name, length(first_name) as words_length
FROM employee_demographics
order by 2;




-- 2. UPPER() and LOWER()

SELECT upper('skyfall');
SELECT lower('skyfall');

SELECT first_name, upper(first_name)
FROM employee_demographics;



-- 3. TRIM() : remove the space from right and left of the word

SELECT ('      skyfall      ');
SELECT TRIM('    skyfall      '); 




-- 4.  LTRIM() and RTRIM() : ltrim remove space from left and rtrim from the right side
SELECT ('      skyfall      ');
SELECT LTRIM('    skyfall      ');
SELECT RTRIM('    skyfall      ');




-- 5. LEFT() and RIGHT() : select character from the left or right a/c to set values

SELECT first_name, LEFT(first_name,4)
FROM employee_demographics;

SELECT first_name, RIGHT(first_name,4)
FROM employee_demographics;





-- 6. SUBSTRING() : select the start point and end point of the words , better than left() and right()

SELECT first_name, 
	LEFT(first_name,4),
	RIGHT(first_name,4),
    SUBSTRING(first_name,3,2)
FROM employee_demographics;



SELECT first_name, 
	LEFT(first_name,4),
	RIGHT(first_name,4),
    SUBSTRING(first_name,3,2),
    birth_date,
    SUBSTRING(birth_date,6,2) AS birth_months -- got months
FROM employee_demographics;




-- 7. REPLACE() :  replace the vaules

SELECT first_name, 
	REPLACE(first_name, 'e', 'a') AS Replaced_name
FROM employee_demographics;



-- 8. LOCATE() :  find the given value position

SELECT LOCATE('n', 'Alexander');


SELECT first_name, 
	LOCATE('e', first_name) AS word_position
FROM employee_demographics;


SELECT first_name, 
	LOCATE('ann', first_name) AS word_position
FROM employee_demographics;


SELECT first_name, 
	last_name,
	CONCAT(first_name,' ',last_name) AS full_name
FROM employee_demographics;


# More function:
 -- 8. INITCAP(string): Converts the first letter of each word to uppercase. ----> Postqrl
 -- 9. REVERSE(string): Reverses a string
 -- 10. REPEAT(string, number): Repeats a string a given number of times.
 -- 11. SPACE(number): Returns a string consisting of a specified number of spaces.
 -- 12. CHAR_LENGTH(string): Returns the number of characters in a string.
 -- 13. INSTR(string, substring): Returns the position of a substring (MySQL)
 -- 14. LIKE and ILIKE: Used for pattern matching (ILIKE is case-insensitive)
 -- 15. FORMAT(value, format): Formats a value with a specific format (e.g., decimal places)
 -- 16. LPAD(string, length, pad_string): Left-pads a string with a specified character.
 -- 17. RPAD(string, length, pad_string): Right-pads a string with a specified character.
 -- 18. ASCII(string): Returns the ASCII value of the first character
 -- 18. CHAR(code): Converts an ASCII code to a character.
 -- 19. TO_BASE64(string): Converts a string to Base64 encoding.
 -- 20. FROM_BASE64(string): Decodes a Base64-encoded string.
 -- 21. REGEXP_LIKE(string, pattern): Checks if a string matches a regex pattern.
 -- 22. REGEXP_REPLACE(string, pattern, replacement): Replaces substring based on regex.
 -- 23. REGEXP_SUBSTR(string, pattern): Extracts substring using regex.
 











-- ---------------------------------------------------------- CASE STATEMENTs ---------------------------------------------------------------
-- A Case Statement allows you to add logic to your Select Statement, sort of like an if else statement in other programming languages or even things like Excel


SELECT first_name, 
	   last_name,
       age,
       CASE
		WHEN age <= 29 THEN 'Young'
        WHEN age BETWEEN 30 AND 50 THEN 'Old'
        WHEN age > 50 THEN 'Death Door'
       END AS Age_Bracket
FROM employee_demographics;





-- Pawnee Council sent out a memo of their bonus and pay increase structure so we need to follow it
-- Basically if they make less than 45k then they get a 5% raise - very generous
-- if they make more than 45k they get a 7% raise
-- they get a bonus of 10% if they work for the Finance Department

SELECT first_name, 
	   last_name,
       salary,
       CASE
		   WHEN salary < 50000 THEN (salary + (salary* 0.05))
           WHEN salary > 50000 THEN (salary + (salary* 0.07))
       END AS New_Salary,
       CASE
		   WHEN dept_id = 6 THEN salary + (salary* 0.1)
       END AS Bonus
FROM  employee_salary;












-- ---------------------------------------------------------- Subqueries ---------------------------------------------------------------

SELECT *
FROM employee_demographics
WHERE employee_id IN (
					SELECT employee_id
                    FROM employee_salary
                    WHERE dept_id = 1
);




SELECT  first_name,
		salary,
        (SELECT AVG(salary) FROM employee_salary)
FROM employee_salary;




SELECT gender, MAX(age), MIN(age), AVG(age), COUNT(age)
FROM employee_demographics
GROUP BY gender;




SELECT AVG(max_age)
FROM (SELECT gender, 
	MAX(age) as max_age, 
    MIN(age) as min_age, 
    AVG(age) as avg_age, 
    COUNT(age) as count_of_No
FROM employee_demographics
GROUP BY gender) AS agg_table;














-- ---------------------------------------------------------- Window Functions ---------------------------------------------------------------

# windows functions are really powerful and are somewhat like a group by - except they don't roll everything up into 1 row when grouping. 
# windows functions allow us to look at a partition or a group, but they each keep their own unique rows in the output
# we will also look at things like Row Numbers, rank, and dense rank


SELECT 
	dem.first_name,
    dem.last_name,
    gender, 
    AVG(salary) OVER(PARTITION BY gender) AS avg_salary
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;


    
-- now if we wanted to see what the salaries were for genders we could do that by using sum, but also we could use order by to get a rol
SELECT 
	dem.employee_id,
	dem.first_name,
    dem.last_name,
    gender,
    salary,
    SUM(salary) OVER(PARTITION BY gender ORDER BY dem.employee_id) AS Rolling_Total
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;




-- Let's look at row_number rank and dense rank now
-- let's  try ordering by salary so we can see the order of highest paid employees by gender

SELECT 
	dem.employee_id,
	dem.first_name,
    dem.last_name,
    gender,
    salary,
    ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS row_num
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;



-- let's compare this to RANK()
SELECT 
	dem.employee_id,
	dem.first_name,
    dem.last_name,
    gender,
    salary,
    RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS rank_num
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;


-- let's compare this to DENSE()
SELECT 
	dem.employee_id,
	dem.first_name,
    dem.last_name,
    gender,
    salary,
    DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS dense_num
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
    
    
    
    
# let's compare all these ROW_NUMBER(), RANK(), DENSE_RANK()
# notice rank repeats on tom ad jerry at 5, but then skips 6 to go to 7 -- this goes based off positional rank
# this is numerically ordered instead of positional like rank. on tom aNd jerry at 5, but then skips 6 insted of 7

SELECT 
	dem.employee_id,
	dem.first_name,
    dem.last_name,
    gender,
    salary,
    ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS row_num,
    RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS rank_num,
    DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS dense_num
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    














-- ---------------------------------------------------------- CTEs ---------------------------------------------------------------

# Using Common Table Expressions (CTE)
# A CTE allows you to define a subquery block that can be referenced within the main query. 
# It is particularly useful for recursive queries or queries that require referencing a higher level
# First, CTEs start using a "With" Keyword. Now we get to name this CTE anything we want
# Then we say as and within the parenthesis we build our subquery/table we want


SELECT gender, MAX(salary), MIN(salary), AVG(salary), COUNT(salary)
FROM employee_demographics dem
JOIN employee_salary sal 
	ON dem.employee_id = sal.employee_id
GROUP BY gender; 



# it is just like a subquery
WITH CTE_Example AS
(
SELECT gender, MAX(salary) AS max_sal, MIN(salary) AS min_sal, AVG(salary) AS avg_sal, COUNT(salary) AS count
FROM employee_demographics dem
JOIN employee_salary sal 
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT *
FROM  CTE_Example;





WITH CTE_Example AS
(
SELECT gender, MAX(salary) AS max_sal, MIN(salary) AS min_sal, AVG(salary) AS avg_sal, COUNT(salary) AS count
FROM employee_demographics dem
JOIN employee_salary sal 
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT AVG(avg_sal) -- This will give the avg of both male n females avg.
FROM  CTE_Example; 




-- Now if I come down here, it won't work because it's not using the same syntax, so it should be used directly after using it we can query the CTEs
SELECT *
FROM CTE_Example;




# Using two CTEs and conneting them for Example
WITH CTE_Example_1 AS
(
SELECT employee_id,gender,birth_date
FROM employee_demographics
WHERE birth_date > '1985-01-01'
),
CTE_Example_2 AS
(
SELECT employee_id,salary
FROM employee_salary
WHERE salary > 50000
)
SELECT *              -- Now if we change this a bit, we can join these two CTEs together
FROM CTE_Example_1
JOIN CTE_Example_2 
	ON CTE_Example_1.employee_id = CTE_Example_2.employee_id;
    
    
    
    
    
# We can rename the columns in the CTE
WITH CTE_Example (gender, sum_salary, min_salary, max_salary, count_salary) AS 
(
SELECT gender, SUM(salary), MIN(salary), MAX(salary), COUNT(salary)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
-- notice here I have to use back ticks to specify the table names  - without them it doesn't work
SELECT gender, ROUND(AVG(sum_salary/count_salary),2)
FROM CTE_Example
GROUP BY gender;













-- ------------------------------------------------------- Temporary Tabels ---------------------------------------------------------------

-- Temporary tables are tables that are only visible to the session that created them. 
-- They can be used to store intermediate results for complex queries or to manipulate data before inserting it into a permanent table.

-- There's 2 ways to create temp tables:
-- 1. This is the less commonly used way - which is to build it exactly like a real table and insert data into it

CREATE TEMPORARY TABLE temp_table
(
first_name varchar(50),
last_name varchar(50),
movie_name varchar(100)
);

SELECT * FROM temp_table;

INSERT INTO temp_table
VALUES(
'Hirdesh', 'Pal', 'Chhavva'
);

SELECT * FROM temp_table;





-- the second way is much faster and my preferred method
-- 2. Build it by inserting data into it - easier and faster

CREATE TEMPORARY TABLE Salary_over_50k
SELECT *
FROM employee_salary
WHERE salary >= 50000;

SELECT * FROM Salary_over_50k;

# this "TEMPORARY TABLE" can be used in any window but if we close the system then it won't work











-- ------------------------------------------------------- Stored Procedures ---------------------------------------------------------------


SELECT *
FROM employee_salary
WHERE salary >= 50000;



# it will create the procedure,we can check it in left under Stored Procedures (under main table)
CREATE PROCEDURE large_salaries()  
SELECT *
FROM employee_salary
WHERE salary >= 50000;

CALL large_salaries();


-- if we tried to add another query to this stored procedure it wouldn't work. It's a separate query:
CREATE PROCEDURE large_salaries2()
SELECT *
FROM employee_salary
WHERE salary >= 60000;
SELECT *
FROM employee_salary
WHERE salary >= 50000;




-- Best practice is to use a delimiter and a Begin and End to really control what's in the stored procedure
-- let's see how we can do this.
-- the delimiter is what separates the queries by default, we can change this to something like two $$
-- in my career this is what I've seen a lot of people who work in SQL use so I've picked it up as well

-- When we change this delimiter it now reads in everything as one whole unit or query instead of stopping
-- after that, we should cahnge it to again first semi colon(;)

DELIMITER $$
CREATE PROCEDURE large_salaries_2()
BEGIN
	SELECT *
	FROM employee_salary
	WHERE salary >= 50000;
	SELECT *
	FROM employee_salary
	WHERE salary >= 10000;
END $$
DELIMITER ;  -- now we change the delimiter back after we use it to make it default again


CALL large_salaries_2();  -- as you can see we have 2 outputs which are the 2 queries we had in our stored procedure



-- We can also add parameters

DELIMITER $$
CREATE PROCEDURE large_salaries_4(employee_id INT)  -- use can use any name  in parameter 'employee_id'
BEGIN
	SELECT salary
	FROM employee_salary
    WHERE employee_id = employee_id;
END $$
DELIMITER ;

CALL large_salaries_4(1);












-- ----------------------------------------------------- Triggers and Events --------------------------------------------------------------


SELECT *
FROM Parks_and_Recreation.employee_demographics;

SELECT *
FROM Parks_and_Recreation.employee_salary;




DELIMITER $$
CREATE TRIGGER employee_insert_1
	AFTER INSERT ON employee_salary
    FOR EACH ROW
BEGIN
	INSERT INTO employee_demographics(employee_id,first_name,last_name)
    VALUES(NEW.employee_id,NEW.first_name,NEW.last_name);
END $$
DELIMITER ;



INSERT INTO employee_salary(employee_id,first_name,last_name,occupation,salary,dept_id)
VALUES(13,'Hirdesh','Pal','CEO',100000,NULL);


-- now it was updated in the payments table and the trigger was triggered and update the corresponding values in the invoice table

DELETE FROM employee_salary
WHERE employee_id = 13;











-- ----------------------------------------------------- Events --------------------------------------------------------------


-- Now I usually call these "Jobs" because I called them that for years in MSSQL, but in MySQL they're called Events

-- Events are task or block of code that gets executed according to a schedule. These are fantastic for so many reasons. Importing data on a schedule. 
-- Scheduling reports to be exported to files and so many other things
-- you can schedule all of this to happen every day, every monday, every first of the month at 10am. Really whenever you want

-- This really helps with automation in MySQL

-- let's say Parks and Rec has a policy that anyone over the age of 60 is immediately retired with lifetime pay
-- All we have to do is delete them from the demographics table

SELECT *
FROM Parks_and_Recreation.employee_demographics;



DELIMITER $$
CREATE EVENT delete_retirees
ON SCHEDULE EVERY 30 SECOND
DO
BEGIN
	DELETE
	FROM employee_demographics
    WHERE age >= 60;
END
DELIMITER ;



SHOW VARIABLES LIKE 'event%';























