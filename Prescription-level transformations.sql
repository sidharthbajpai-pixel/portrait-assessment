with main as
(select *, case when medication_name in ('Ibuprofen', 'Aspirin') then 'pain relief'  
when medication_name in ('Atorvastatin', 'Lisinopril') then 'Heart'
when medication_name in ('Metformin') then 'Diabetes'
when medication_name in ('Amoxicillin') then 'Antibiotics' end as category,
row_number() over (partition by patient_id, medication_name order by prescription_date asc) as rn
from prescriptions p 
)

select *, case when rn = 1 then 'first-time' else 'repeat' end as prescription_frequency
from main
order by patient_id, medication_name

