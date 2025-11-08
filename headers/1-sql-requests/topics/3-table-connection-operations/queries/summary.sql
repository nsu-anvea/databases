-- 1.3.8
WITH department_employee_count AS (
    SELECT 
        d.department_id,
        COUNT(e.employee_id) AS employee_count
    FROM departments d
  
    LEFT JOIN employees e ON d.department_id = e.department_id
  
    GROUP BY d.department_id
  
	HAVING COUNT(e.employee_id) > 0
)

SELECT 
    dec.department_id,
    COALESCE(SUM(e.salary), 0) AS total_salary
FROM department_employee_count dec
LEFT JOIN employees e ON dec.department_id = e.department_id
WHERE dec.employee_count = (
  	SELECT MIN(employee_count) AS min_count
    FROM department_employee_count
)
GROUP BY dec.department_id
ORDER BY dec.department_id;



-- 1.3.7
SELECT 
    e.job_id,
    COUNT(*) AS employee_count
FROM employees e

JOIN jobs j ON e.job_id = j.job_id

WHERE e.salary = j.min_salary

GROUP BY e.job_id

ORDER BY employee_count, e.job_id;



-- 1.3.6
SELECT DISTINCT j.job_title
FROM jobs j

WHERE j.job_id NOT IN (
    SELECT DISTINCT e.job_id
    FROM employees e
  
    JOIN departments d ON e.department_id = d.department_id
    JOIN locations l ON d.location_id = l.location_id
    JOIN countries c ON l.country_id = c.country_id
  
    WHERE c.country_name = 'United States of America'
)

ORDER BY j.job_title;



-- 1.3.5
SELECT 
    COALESCE(d.department_id, 0) AS department_id,
    COUNT(e.employee_id) AS employee_count
FROM departments d

LEFT JOIN employees e ON d.department_id = e.department_id

GROUP BY d.department_id


UNION ALL


SELECT 
    0 AS department_id,
    COUNT(*) AS employee_count
FROM employees

WHERE department_id IS NULL

ORDER BY employee_count, department_id;



-- 1.3.4
SELECT country_name
FROM countries

WHERE country_id NOT IN (
	SELECT DISTINCT country_id
	FROM locations

	JOIN departments USING(location_id)
	LEFT JOIN employees USING(department_id)

	WHERE employee_id IS NULL
)

ORDER BY country_name;



-- 1.3.3
SELECT DISTINCT country_name
FROM countries

JOIN locations USING(country_id)
JOIN departments USING(location_id)
LEFT JOIN employees USING(department_id)

WHERE employee_id IS NULL

ORDER BY country_name;



-- 1.3.2
SELECT job_id, COUNT(employee_id) AS num_employees
FROM jobs

LEFT JOIN employees USING(job_id)

GROUP BY job_id

ORDER BY job_id, num_employees;



-- 1.3.1
SELECT country_id, COALESCE(SUM(salary), 0) AS sum_salary
FROM employees

RIGHT JOIN departments USING(department_id)
RIGHT JOIN locations USING(location_id)

GROUP BY country_id

ORDER BY sum_salary DESC;
