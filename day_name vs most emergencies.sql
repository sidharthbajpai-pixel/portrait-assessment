with main as
(select appointment_id, 
patient_id, 
cast(appointment_date as date) as appointment_date,
appointment_type, provider_id,
trim(TO_CHAR(cast(appointment_date as date), 'Day')) AS day_name
 from appointments a 
order by patient_id, a.appointment_date desc)

select day_name, count(appointment_type) as count_of_emergencies
from main 
where appointment_type = 'Emergency'
group by 1
order by count_of_emergencies desc


-- result
--day_name	count_of_emergencies
--Friday		9
--Saturday		6
--Monday		6
--Thursday		4
--Tuesday		3
--Sunday		3
--Wednesday		2
--
--Friday has most emergencies
