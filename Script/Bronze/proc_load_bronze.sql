/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
	
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '================================================';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.appointments';
		TRUNCATE TABLE bronze.appointments;
		PRINT '>> Inserting Data Into: bronze.appointments';
		BULK INSERT bronze.appointments
		FROM "C:\Users\allal\Downloads\healthcare dataset\healthcare dataset\appointments.csv"
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			TABLOCK
		);
set @end_time=GETDATE()
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

-- 2. Insert Billing

SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.billing';
		TRUNCATE TABLE bronze.billing;
		PRINT '>> Inserting Data Into: bronze.billing';

        BULK INSERT bronze.billing
		FROM 'C:\Users\allal\Downloads\healthcare dataset\healthcare dataset\billing.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			TABLOCK
);

SET @end_time= GETDATE()
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

-- 3. Doctors
SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.doctors';
		TRUNCATE TABLE bronze.doctors;
		PRINT '>> Inserting Data Into: bronze.doctors';


		BULK INSERT bronze.doctors
		FROM 'C:\Users\allal\Downloads\healthcare dataset\healthcare dataset\doctors.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			TABLOCK
		);
set @end_time=GETDATE()
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
-- 4. Patients
SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.patients';
		TRUNCATE TABLE bronze.patients;
		PRINT '>> Inserting Data Into: bronze.patients';

	    BULK INSERT bronze.patients
		FROM 'C:\Users\allal\Downloads\healthcare dataset\healthcare dataset\patients.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			TABLOCK
		);
set @end_time=GETDATE()
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
-- 5. Treatments
SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.treatments';
		TRUNCATE TABLE bronze.treatments;
		PRINT '>> Inserting Data Into: bronze.treatments';

		BULK INSERT bronze.treatments
		FROM 'C:\Users\allal\Downloads\healthcare dataset\healthcare dataset\treatments.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			TABLOCK
		);
set @end_time=GETDATE()
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';


SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Bronze Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
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
END
