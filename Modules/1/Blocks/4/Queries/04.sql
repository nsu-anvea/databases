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