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