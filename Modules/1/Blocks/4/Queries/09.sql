--====[ 1.4.9 ]====--
--[ 15 ]
with countries_of_employees_with_max_experience as (
  	select country_id
  	from (
	  	select *
  		from employees
	  	where hire_date = (
      		select min(hire_date)
      		from employees
    	)
    ) e
  	join departments d on coalesce(e.department_id, 0) = coalesce(d.department_id, 0)
  	join locations using(location_id)
),
subordinates_salary_of_managers as (
  	select
  		e1.employee_id as manager_id,
  		country_id,
  		(
          	select
          		case
          			when count(e2.employee_id) > 0 then sum(e2.salary)
          			else 0
          		end
          	from employees e2
          	where e2.manager_id = e1.employee_id
        ) as subordinates_salary
  	from employees e1
  	join departments using(department_id)
  	join locations using(location_id)
)

select 
	(
      	select ssm.manager_id
      	from subordinates_salary_of_managers ssm
	   	where ssm.country_id = ceme.country_id
    	order by ssm.subordinates_salary desc
      	limit 1
    ) as employee_id
from countries_of_employees_with_max_experience ceme
order by employee_id;