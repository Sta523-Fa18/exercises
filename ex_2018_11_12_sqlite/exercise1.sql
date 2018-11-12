SELECT dept, AVG(salary) AS avg_salary FROM employees GROUP BY dept;

SELECT * FROM employees NATURAL LEFT JOIN (SELECT dept, AVG(salary) AS avg_salary FROM employees GROUP BY dept);

SELECT name, email, salary, dept, ROUND(salary - avg_salary,2) AS above_avg FROM employees NATURAL LEFT JOIN (SELECT dept, AVG(salary) as avg_salary FROM employees GROUP BY dept);