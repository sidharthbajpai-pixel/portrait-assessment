with appointment_data as
(select patient_id, count(appointment_date) as times_of_appointment
from appointments a
group by 1),

prescription_data as
(select patient_id, count(prescription_date) as times_of_prescription
from prescriptions p
group by 1),

patients_data as
(select distinct patient_id, name from patients p),

final_data as
(select a.patient_id,
pd.name,
a.times_of_appointment,
p.times_of_prescription
from appointment_data a 
inner join prescription_data p 
on a.patient_id = p.patient_id
inner join patients_data pd on a.patient_id = pd.patient_id
order by a.patient_id)


SELECT CORR(times_of_appointment, times_of_prescription)
FROM final_data




-- result
---0.08598128167724464
--
--we can conclude Very weak negative correlation between appointment frequency and prescription frequency. The number is close to 0, so there’s almost no linear relationship.
--
--The slight negative value suggests that as appointments increase, prescriptions very slightly decrease, but this effect is extremely weak and likely not meaningful.
--


