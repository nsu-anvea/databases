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