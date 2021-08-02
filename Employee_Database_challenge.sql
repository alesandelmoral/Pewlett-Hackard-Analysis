--Deliverable 1
SELECT e.emp_no,
	   e.first_name,
	   e.last_name,
	   s.tittle,
	   s.from_date,
	   s.to_date
INTO retirement_titles
FROM employees AS e
INNER JOIN titles AS s
ON (e.emp_no = s.emp_no)
WHERE birth_date BETWEEN '1952-01-01'AND '1955-12-31'
ORDER BY emp_no ASC;

SELECT * FROM  retirement_titles;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (r.emp_no)
					r.emp_no,
					r.first_name,
					r.last_name,
					r.tittle
INTO unique_titles
FROM retirement_titles AS r
ORDER BY emp_no ASC, to_date DESC;

SELECT * FROM unique_titles;

SELECT COUNT(u.emp_no),
			u.tittle
INTO retiring_titles
FROM unique_titles AS u
GROUP BY u.tittle
ORDER BY COUNT(u.emp_no) DESC;

SELECT * FROM retiring_titles;

--Deliverable 2

SELECT DISTINCT ON (e.emp_no)
	   e.emp_no,
	   e.first_name,
	   e.last_name,
	   e.birth_date,
	   d.from_date,
	   d.to_date,
	   t.tittle
INTO mentorship_eligibilty
FROM employees AS e
	INNER JOIN dept_emp as d
		ON (e.emp_no = d.emp_no)
	INNER JOIN titles as t
		ON (e.emp_no = t.emp_no)
WHERE (birth_date BETWEEN '1965-01-01' AND '1965-12-31') AND (d.to_date = '9999-01-01')
ORDER BY e.emp_no ASC;

select * from mentorship_eligibilty;


--Deliverable 3
--Queries that may provide more insight

--Mentors per title
SELECT COUNT(me.emp_no),
			me.tittle
FROM mentorship_eligibilty AS me
GROUP BY me.tittle
ORDER BY COUNT(me.emp_no) DESC;

--Gender retirements
SELECT e.emp_no,
	   e.first_name,
	   e.last_name,
	   e.gender,
	   s.tittle,
	   s.from_date,
	   s.to_date
INTO retirement_genders
FROM employees AS e
INNER JOIN titles AS s
ON (e.emp_no = s.emp_no)
WHERE birth_date BETWEEN '1952-01-01'AND '1955-12-31'
ORDER BY emp_no ASC;

SELECT COUNT(rg.emp_no),
			 rg.gender
FROM retirement_genders AS rg
GROUP BY rg.gender;


