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