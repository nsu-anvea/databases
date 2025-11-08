--====[ 1.4.1 ]====--
--[ 1 ]
with jobs_with_max_diff_salary as (
    select job_id from jobs
    where (max_salary - min_salary) = (
        select max(max_salary - min_salary) from jobs
    )
)
select job_id, avg(salary) as average_salary
from employees
where job_id in (
  	select job_id from jobs_with_max_diff_salary
)
group by job_id
order by job_id;


--[ 2 ]
with jobs_with_max_diff_salary as (
    select job_id from jobs
    where (max_salary - min_salary) = (
        select max(max_salary - min_salary) from jobs
    )
)
select job_id, round(avg(salary), 2) as average_salary
from employees
join jobs_with_max_diff_salary using(job_id)
group by job_id
order by job_id;



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



--====[ 1.4.3 ]====--
--[ 5 ]
select
	case
    	when salary <= 5000  then 1
        when salary <= 10000 then 2
        when salary <= 15000 then 3
        else 4
	end as salary_group_id,
    count(employee_id)     as employees_count,
    round(sum(salary), 2)  as sum_salary,
    round(avg(salary), 2)  as avg_salary,
    count(distinct job_id) as unique_jobs_count
from employees

group by salary_group_id
order by salary_group_id;


--[ 6 ]
--[ можно использовать between, но в данной задаче надо учитывать, что salary нецелое число; between эквивалентен __ <= {значение} <= __ ]
select
	case
    	when salary between 0     and 5000    then 1
        when salary between 5000  and 10000   then 2
        when salary between 10000 and 15000   then 3
        when salary between 15000 and 1000000 then 4
	end as salary_group_id,
    count(employee_id)     as employees_count,
    round(sum(salary), 2)  as sum_salary,
    round(avg(salary), 2)  as avg_salary,
    count(distinct job_id) as unique_jobs_count
from employees

group by salary_group_id
order by salary_group_id;



--====[ 1.4.4 ]====--
--[ 7 ]
with jobs_with_min_diff_salary as (
  	select job_id, max_salary - min_salary as min_diff_salary
  	from jobs
  	where (max_salary - min_salary) = (
      	select min(max_salary - min_salary) from jobs
    )
)
select job_id, round(avg(salary), 2) as avg_salary
from employees
join jobs_with_min_diff_salary using(job_id)
group by job_id
order by job_id;


--[ 8 ]
with jobs_with_min_diff_salary as (
  	select job_id, max_salary - min_salary as min_diff_salary
  	from jobs
  	where (max_salary - min_salary) = (
      	select min(max_salary - min_salary) from jobs
    )
)
select job_id, round(avg(salary), 2) as avg_salary
from employees
where job_id in (select job_id from jobs_with_min_diff_salary)
group by job_id
order by job_id;



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



--====[ 1.4.6 ]====--
--[ 11 ]
with top_3_employees as (
  	select *
  	from employees
  	
 	order by salary desc
  	limit 3
),
subordinates_of_managers as (
  	select
  		employee_id as manager_id,
  		(
        	select count(employee_id)
			from employees e2
          	where e2.manager_id = e1.employee_id
        ) as subordinates_count
  	from employees e1
)
select manager_id as employee_id
from subordinates_of_managers

where manager_id in (
  	select employee_id
  	from top_3_employees
)
order by subordinates_count desc
limit 1;


--[ 12 ]
with subordinates_of_managers as (
  	select employee_id, coalesce(subordinates_count, 0) as subordinates_count
	from (
      	select employee_id
  		from employees
  		group by employee_id
    )
	left join (
      	select manager_id, count(employee_id) as subordinates_count
  		from employees
  		group by manager_id
    ) on employee_id = manager_id
  	order by employee_id
)
select employee_id
from subordinates_of_managers
join (
  	select *
  	from employees
  	order by salary desc
  	limit 3
) using(employee_id)
order by subordinates_count desc
limit 1;



--====[ 1.4.7 ]====--
--[ 13 ]
select employee_id
from (
  	select
  		employee_id,
  		hire_date,
  		(
          	select count(employee_id)
          	from employees e2
          	where e2.employee_id = e1.employee_id
        ) as subordinates_count
  	from employees e1
  	order by subordinates_count desc
  	limit 3
)
order by hire_date desc
limit 1;



--====[ 1.4.8 ]====--
--[ 14 ]
select e1.last_name, e1.first_name
from employees e1
join employees e2 on e1.manager_id = e2.employee_id
where abs(e1.salary - e2.salary) < 5000
order by e1.hire_date asc
limit 1;



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