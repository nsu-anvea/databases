--====[ 1.4.5 ]====--
--[ 9 ]
with same_last_names as (
	select last_name
	from employees

	group by last_name
  	having count(employee_id) > 1
),
avg_salary_by_departments as (
  	select
  		coalesce(department_id, 0) as department_id,
  		avg(salary) as avg_salary
  	from employees
  	
  	group by department_id
)
select last_name, employee_id, salary
from employees

join avg_salary_by_departments asbd on coalesce(employees.department_id, 0) = coalesce(asbd.department_id, 0)
join same_last_names using(last_name)

where salary > avg_salary

order by last_name, employee_id;


--[ 10 ]
select e1.last_name, e1.employee_id, e1.salary
from employees e1
where
	exists(
      	select e2.employee_id
      	from employees e2
      	where e2.last_name = e1.last_name
      	and e2.employee_id != e1.employee_id
    )
    and e1.salary > (
    	select avg(salary)
      	from employees
      	where department_id = e1.department_id
    )
order by last_name, employee_id;