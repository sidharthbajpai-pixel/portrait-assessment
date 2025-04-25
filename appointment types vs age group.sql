with main as
(
select patient_id, name, 
coalesce(age, (select avg(age) from patients)) as age -- as some ages are null of patients so taking the avg age for analysis
, gender,
cast(registration_date as date) as registration_date
from patients
),

sample_data as
(select *,
case when age >=0 and age <= 18  then '0-18'
when age >=19 and age <=30  then '19-30'
when age >=31 and age <=50  then '31-50'
when age >=51 and age <=70  then '51-70'
when age >= 71 then '71+' end as age_group, -- making buckets based on age
(EXTRACT(YEAR FROM AGE(current_date, registration_date)) * 12 +
        EXTRACT(MONTH FROM AGE(current_date, registration_date))) AS total_months -- calculating total months from current_date
from main p 
--order by registration_date desc
),

final_analysis as
(select patient_id, name, age, age_group, registration_date,
totaL_months,
case when totaL_months <= 6 then 'New'
when totaL_months > 6 and totaL_months <= 24 then 'Regular'
when totaL_months > 24 then 'Long-term' end as patient_type -- making buckets based on difference of months b/w currennt date and registration date
from sample_data),


table2 as
(select  patient_id, appointment_type, count(*) as cnt_of_appointment_type
from appointments 
group by 1,2),

final_data as
(select f.age_group, t.appointment_type, sum(t.cnt_of_appointment_type) as total_appointments
from 
final_analysis f inner join table2 t
on f.patient_id = t.patient_id
group by 1,2
order by f.age_group, t.appointment_type)

select age_group, appointment_type, total_appointments from
(select age_group, appointment_type, total_appointments, 
dense_rank() over  (partition by age_group order by total_appointments desc) as rn
from final_data) a
where rn = 1


--age_group	appointment_type	total_appointments
--0-18		Consultation		2
--19-30		Emergency			8
--31-50		Consultation		10
--51-70		Checkup				16
--71+		Checkup				13
--
--we can see that 51-70 age group has taken maximum consultation appointment type
