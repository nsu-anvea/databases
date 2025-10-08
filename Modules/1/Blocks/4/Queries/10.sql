--====[ 1.4.10 ]====--
--[ 16 ]
with avg_american_salary as (
  	select avg(salary) as avg_salary
  	from employees
  	join departments using(department_id)
  	join locations using(location_id)
  	join countries using(country_id)
  	join regions using(region_id)
  	where region_name = 'Americas'
),
departments_min_salary as (
  	select department_name, min(salary) as min_salary
  	from departments
  	join employees using(department_id)
  	group by department_id
)

select department_name
from departments_min_salary
where min_salary > (
  	select avg_salary
  	from avg_american_salary
)
order by department_name;