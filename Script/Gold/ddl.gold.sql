/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

===============================================================================
*/

IF OBJECT_ID('gold.dim_patients', 'v') IS NOT NULL
DROP VIEW gold.dim_patients;
GO

create view gold.dim_patients AS
select
    ROW_NUMBER() OVER (ORDER BY patient_id) AS patient_key, -- Surrogate Key
    patient_id,
    first_name,
    last_name,
    first_name + ' ' + last_name            AS full_name,
    gender,
    date_of_birth,
    contact_number,
    address,
    registration_date,
    insurance_provider,
    insurance_number,
    email
from silver.patients;
GO


IF OBJECT_ID('gold.dim_doctors', 'v') IS NOT NULL DROP VIEW gold.dim_doctors;

Go
create view gold.dim_doctors as
select
    ROW_NUMBER() OVER (ORDER BY doctor_id) AS doctor_key, -- Surrogate Key
    doctor_id,
    first_name,
    last_name,
    first_name + ' ' + last_name AS full_name,
    specialization,
    phone_number,
    years_experience,
    hospital_branch,
    email
from silver.doctors;
GO


IF OBJECT_ID('gold.fact_appointment', 'V') IS NOT NULL
DROP VIEW gold.fact_appointment;
GO
CREATE VIEW gold.fact_appointment AS

SELECT
ROW_NUMBER() OVER (ORDER BY ap.appointment_id) appointment_key,
ap.appointment_id,
do.doctor_key,
pa.patient_key,
tr.treatment_id,
ap.reason_for_visit,
tr.treatment_type,
tr.description treatment_description,
ap.status ,
tr.cost treatment_cost,
ap.appointment_date,
ap.appointment_time,
tr.treatment_date
FROM silver.appointments ap
left join silver.treatments tr
on ap.appointment_id=tr.appointment_id
left join gold.dim_patients pa
on pa.patient_id=ap.patient_id
left join gold.dim_doctors do
on do.doctor_id=ap.doctor_id
GO



IF OBJECT_ID('gold.fact_billing', 'v') IS NOT NULL
DROP VIEW gold.fact_billing;
GO

CREATE VIEW gold.fact_billing as

SELECT
ROW_NUMBER() OVER (ORDER BY bill_id) bill_key,
bi.bill_id,
pa.patient_key,
bi.treatment_id,
bi.payment_method,
bi.payment_status,
bi.amount,
bi.bill_date
FROM silver.billing bi
left join gold.dim_patients pa
on pa.patient_id=bi.patient_id
GO
