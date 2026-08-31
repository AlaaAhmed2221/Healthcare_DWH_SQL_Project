/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Silver Layer';
        PRINT '================================================';


set @start_time=GETDATE()
print'>>Truncating Table: silver.appointments'
truncate table silver.appointments
print'>> inserting data into: silver.appointments'
insert into silver.appointments (
    appointment_id,
    patient_id,
    doctor_id,
    appointment_date,
    appointment_time,
    reason_for_visit,
    status
)
select
    TRIM( appointment_id)  ,
	TRIM( patient_id  )    ,
    TRIM( doctor_id  )     ,
	appointment_date ,
	CAST(appointment_time AS TIME(0)) as appointment_time ,
	TRIM( reason_for_visit ),
    TRIM( status  )
from bronze.appointments
SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';


set @start_time=GETDATE()
print'>>Truncating Table: silver.billing'
truncate table silver.billing
print'>> inserting data into: silver.billing'
insert into silver.billing(
    bill_id        ,
	patient_id     ,
	treatment_id   ,
	bill_date      ,
    amount         ,
    payment_method ,
	payment_status 
)
select 
    TRIM( bill_id  )      ,
	TRIM (patient_id )    ,
	TRIM( treatment_id )  ,
	 bill_date     ,
    amount         ,
    TRIM( payment_method) ,
	TRIM( payment_status) 
from bronze.billing
SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';


set @start_time=GETDATE()
print'>>Truncating Table: silver.doctors'
truncate table silver.doctors
print'>> inserting data into: silver.doctors'
insert into silver.doctors(
    doctor_id        ,
	first_name       ,
	last_name        ,
	specialization   ,
	phone_number     ,
	years_experience ,
    hospital_branch  ,
	email 
)

select
    trim(doctor_id )       ,
	TRIM( first_name )      ,
	TRIM( last_name )       ,
	TRIM( specialization )  ,
	TRIM( phone_number )    ,
	years_experience ,
    TRIM( hospital_branch ) ,
	LOWER( TRIM(email) )           
from bronze.doctors
SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';


set @start_time=GETDATE()
print'>>Truncating Table: silver.patients'
truncate table silver.patients
print'>> inserting data into: silver.patients'
insert into silver.patients(
    patient_id        ,
	first_name        ,
	last_name         ,
	gender            ,
	date_of_birth     ,
	contact_number    ,
	address           ,
	registration_date ,
	insurance_provider ,
	insurance_number  ,
	email 
)
select
    TRIM( patient_id )      ,
	TRIM( first_name )       ,
	TRIM( last_name  )       ,
	case when UPPER(trim( gender)) = 'F' then 'Female'
         when UPPER(trim( gender)) = 'M' then 'Male'
		 else 'n/a'
       end gender            ,
	date_of_birth     ,
	TRIM( contact_number )   ,
	TRIM( address   )        ,
	registration_date ,
	TRIM( insurance_provider ),
	TRIM( insurance_number ) ,
	lower(TRIM( email ))
from bronze.patients
SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';


set @start_time=GETDATE()
print'>>Truncating Table: silver.treatments'
truncate table silver.treatments
print'>> inserting data into: silver.treatments'
insert into silver.treatments(
    treatment_id    ,
	appointment_id  ,
	treatment_type  ,
	description     ,
	cost            ,
	treatment_date
)
select
    trim (treatment_id )   ,
	TRIM( appointment_id)  ,
	TRIM( treatment_type ) ,
	TRIM( description )    ,
	cost            ,
	treatment_date
from bronze.treatments
set @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';




     SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Silver Layer is Completed';
        PRINT ' Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
		
	end try
	begin catch
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	end catch
end
