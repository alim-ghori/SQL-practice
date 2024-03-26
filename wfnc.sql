SELECT *
FROM EMPLOYEE;


SELECT DEPT_NAME,
	MAX(SALARY) AS MAX_SALARY
FROM EMPLOYEES
GROUP BY DEPT_NAME;

--  USING WINDOW FUNCTION

SELECT E.*,
	MAX(SALARY) OVER(PARTITION BY DEPT_NAME) AS MAX_SALARY
FROM EMPLOYEE E;

-- ROW_NUMBER, RANK, DENSE_RANK, LEAD, and LAG
SELECT E.*,
	ROW_NUMBER() OVER(PARTITION BY DEPT_NAME) AS RN
FROM EMPLOYEE E;


-- fetch the first 2 employees from each department to join the company
select * from(
	select e.*,
	row_number() over(partition by dept_name order by emp_id) as rn
	from employee e) x
where x.rn < 3


-- FETCH THE TOP 3 EMPLOYEES in EACH DEPARTMENT EARNING THE MAX SALARY

select * from(
	select e.*,
	rank() over(partition by dept_name order by salary desc ) as rnk
	from employee e) x
where x.rnk < 4

-- DENSE_RANK (IT WILL NOT SKIP A VALUE UNLIKE RANK FUNCTION)

select e.*,
	rank() over(partition by dept_name order by salary desc ) as rnk,
	dense_rank() over(partition by dept_name order by salary desc ) as dns_rnk
	from employee e;


-- LEAD and LAG function 

select e.*,
lag(salary) over (partition by  dept_name order by emp_id) as prev_emp_salary,
lead(salary) over (partition by dept_name order by emp_id) as next_emp_salary
from employee e;


--fetch a query to display if the salary of an employee is higher, lower or equal to previous employee.


select e.*,
lag(salary) over (partition by dept_name order by emp_id) as prev_emp_salary,
case when e.salary > lag(salary) over (partition by dept_name order by emp_id) then 'Higher than previous employee'
	when e.salary < lag(salary) over (partition by dept_name order by emp_id) then 'Lower than previous employee'
	when e.salary = lag(salary) over (partition by dept_name order by emp_id)then 'Same as prevoius employee'
	end sal_range

from employee e;









