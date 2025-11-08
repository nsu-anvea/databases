--====[ 1.4.8 ]====--
--[ 14 ]
select e1.last_name, e1.first_name
from employees e1
join employees e2 on e1.manager_id = e2.employee_id
where abs(e1.salary - e2.salary) < 5000
order by e1.hire_date asc
limit 1;