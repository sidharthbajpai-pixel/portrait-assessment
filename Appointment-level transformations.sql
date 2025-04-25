with main as
(select appointment_id, 
patient_id, 
cast(appointment_date as date) as appointment_date,
appointment_type, provider_id,
trim(TO_CHAR(cast(appointment_date as date), 'Day')) AS day_name
 from appointments a 
order by patient_id, a.appointment_date desc
),

report as (
select * from
(select *,
row_number() over (partition by patient_id order by appointment_date desc) as rn
from main
) a where rn = 1)

select distinct patient_id, 
appointment_date as latest_date,
day_name,
(current_date - appointment_date) as total_days_difference
from report
