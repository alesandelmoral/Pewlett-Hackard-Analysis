--Creating tables for PH-EmployeeBD
CREATE TABLE deparments (
	dept_no VARCHAR(4) NOT NULL,
	dept_name VARCHAR(40) NOT NULL,
	PRIMARY KEY (dept_no),
	UNIQUE (dept_name)
);
DROP TABLE employees CASCADE;
DROP TABLE deparments CASCADE;
DROP TABLE dept_manager CASCADE;
DROP TABLE salaries CASCADE;
DROP TABLE dept_emp CASCADE;
DROP TABLE titles CASCADE;


CREATE TABLE employees(
	emp_no INT NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	gender VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES deparments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE dept_emp(
	emp_no INT NULL,
	dept_no VARCHAR NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES deparments (dept_no),
	FOREIGN KEY (emp_no) REFERENCES salaries (emp_no),
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE titles(
	emp_no INT NOT NULL,
	tittle VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (emp_no) REFERENCES salaries (emp_no)
);

SELECT first_name, last_name FROM employees
WHERE birth_date BETWEEN '1952-01-01'AND '1955-12-31';

SELECT first_name, last_name FROM employees
WHERE birth_date BETWEEN '1952-01-02' AND '1952-12-31';

-- Retirement eligibility
SELECT first_name, last_name FROM employees
WHERE (birth_date BETWEEN '1952-01-01'AND '1955-12-31') AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');	

-- Number of employees retiring
SELECT COUNT(first_name) FROM employees
WHERE (birth_date BETWEEN '1952-01-01'AND '1955-12-31') AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');	

--Saving the resulting data into a file
SELECT first_name, last_name 
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')AND 
(hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Select the resulting table retirementinfo
SELECT * FROM retirement_info;

SELECT COUNT(first_name) FROM retirement_info;

--- Adding the employee number--------
DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

--Joining deparments and dept_manager tables 
SELECT d.dept_name,
	dm.emp_no,
	dm.from_date,
	dm.to_date
FROM deparments AS d
INNER JOIN dept_manager AS dm
ON d.dept_no = dm.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
	retirement_info.first_name,
	retirement_info.last_name,
	dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

-- Joining retirement_info and dept_emp tables
SELECT ri.emp_no,
	   ri.first_name,
	   ri.last_name,
	   de.to_date
FROM retirement_info AS ri
LEFT JOIN dept_emp AS de
ON ri.emp_no = de.emp_no;

-- Joining retirement_info and dept_emp tables and save the table into current_emp
SELECT ri.emp_no,
	   ri.first_name,
	   ri.last_name,
	   de.to_date
INTO current_emp
FROM retirement_info AS ri
LEFT JOIN dept_emp AS de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number (how many employees per deparment were leaving)
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp AS ce
LEFT JOIN dept_emp as de 
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no;

-- Employee count by department number (how many employees per deparment were leaving) WITH ORDER BY
SELECT COUNT(ce.emp_no), de.dept_no
INTO count_perdeparments
FROM current_emp AS ce
LEFT JOIN dept_emp as de 
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

--_________________________Employee information___________________
SELECT e.emp_no, 
	   e.first_name, 
	   e.last_name,
	   e.gender,
	   s.salary,
	   s.to_date,
	   de.dept_no
INTO emp_info
FROM employees AS e
	INNER JOIN salaries as s
		ON (e.emp_no = s.emp_no)
	INNER JOIN dept_emp as de
		ON (e.emp_no = de.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') AND (de.to_date = '9999-01-01');

SELECT * FROM emp_info;

DROP TABLE emp_info;

--________________________________Management Table_______________________
-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN deparments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);

--_________________________________Department Retirees__________________________
SELECT ce.emp_no,
	   ce.first_name,
	   ce.last_name,
	   d.dept_name
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN deparments AS d
ON (de.dept_no = d.dept_no);

SELECT * FROM dept_info;