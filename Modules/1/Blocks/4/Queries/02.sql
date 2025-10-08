--====[ 1.4.2 ]====--
--[ 3 ]
with employees_info as (
  	select *
  	from employees
  	join departments using(department_id)
  	join locations using(location_id)
  	join countries using(country_id)
),
two_countries_with_lowest_earnings as (
  	select country_id, sum(salary) as sum_salary
  	from employees_info
  	group by country_id
  	order by sum_salary
  	limit 2
)
select employee_id
from employees_info
join two_countries_with_lowest_earnings using(country_id)
order by employee_id;


--[ 4 ]
with employees_info as (
  	select *
  	from employees
  	join departments using(department_id)
  	join locations using(location_id)
  	join countries using(country_id)
),
two_countries_with_lowest_earnings as (
  	select country_id, sum(salary) as sum_salary
  	from employees_info
  	group by country_id
  	order by sum_salary asc
  	limit 2
)
select employee_id
from employees_info
where country_id in (
  	select country_id from two_countries_with_lowest_earnings
)
order by employee_id;