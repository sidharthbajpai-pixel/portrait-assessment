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
from sample_data)

select age_group, count(distinct patient_id) as cnt_of_patients
from final_analysis
group by 1
order by cnt_of_patients desc



--- results 
--age_group	patients_count
--51-70		17
--71+		15
--31-50		14
--19-30		8
--0-18		1

--we can conclude that maximum patients are falling under age_group of 51-70 followed by 71+
