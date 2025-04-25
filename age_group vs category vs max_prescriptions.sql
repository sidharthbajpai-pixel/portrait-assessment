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

test_2 as
(
select patient_id, medication_name, count(distinct medication_name) as cnt  from prescriptions p

group by 1,2
),

categories as
(select f.age_group, t.medication_name, sum(t.cnt) as total_medication_usage
from final_analysis f inner join test_2 t 
on f.patient_id = t.patient_id
group by 1,2)

select age_group, category, total_medication_usage as max_prescription
from (
select *, dense_rank() over (partition by age_group order by total_medication_usage desc) as rnk
from
(select age_group, case when medication_name in ('Ibuprofen', 'Aspirin') then 'pain relief'  
when medication_name in ('Atorvastatin', 'Lisinopril') then 'Heart'
when medication_name in ('Metformin') then 'Diabetes'
when medication_name in ('Amoxicillin') then 'Antibiotics' end as category,
sum(total_medication_usage) as total_medication_usage
from categories
group by 1,2) a
)b
where rnk = 1


--result
--age_group	category		max_prescription
--71+		pain relief		12
--71+		Heart			12
--51-70		pain relief		9
--31-50		Heart			11
--19-30		pain relief		4
--0-18		Diabetes		1
--0-18		Antibiotics		1
--0-18		Heart			1

--we can see that  for each age group and for which category maximum prescriptions are  there