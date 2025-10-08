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