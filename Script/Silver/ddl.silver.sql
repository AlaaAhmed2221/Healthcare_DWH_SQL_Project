/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

IF OBJECT_ID('silver.appointments', 'U') IS NOT NULL
    DROP TABLE silver.appointments;

	create table silver.appointments(
	appointment_id   varchar(50),
	patient_id       varchar(50),
    doctor_id        varchar(50),
	appointment_date date,
	appointment_time time(0),
	reason_for_visit varchar(50),
    status varchar(50),
	 dwh_create_date    DATETIME2 DEFAULT GETDATE()
	)
Go

IF OBJECT_ID('silver.billing', 'U') IS NOT NULL
    DROP TABLE silver.billing;

	create table silver.billing(
	bill_id        varchar(50),
	patient_id     varchar(50),
	treatment_id   varchar(50),
	bill_date      date,
    amount         float,
    payment_method varchar(50),
	payment_status varchar(50),
	 dwh_create_date    DATETIME2 DEFAULT GETDATE()
		)
Go

IF OBJECT_ID('silver.doctors', 'U') IS NOT NULL
    DROP TABLE silver.doctors;

	create table silver.doctors(
	doctor_id        varchar(50),
	first_name       varchar(50),
	last_name        varchar(50),
	specialization   varchar(50),
	phone_number     varchar(50),
	years_experience int,
    hospital_branch  varchar(50),
	email            varchar(50),
	 dwh_create_date    DATETIME2 DEFAULT GETDATE()
		)
Go

IF OBJECT_ID('silver.patients', 'U') IS NOT NULL
    DROP TABLE silver.patients;

	create table silver.patients(
	patient_id        varchar(50),
	first_name        varchar(50),
	last_name         varchar(50),
	gender            varchar(50),
	date_of_birth     date,
	contact_number    varchar(50),
	address           varchar(100),
	registration_date date,
	insurance_provider varchar(50),
	insurance_number  varchar(50),
	email             varchar(50),
	 dwh_create_date    DATETIME2 DEFAULT GETDATE()
		)
Go

IF OBJECT_ID('silver.treatments', 'U') IS NOT NULL
    DROP TABLE silver.treatments;

	create table silver.treatments(
	treatment_id    varchar(50),
	appointment_id  varchar(50),
	treatment_type  varchar(50),
	description     varchar(50),
	cost            float,
	treatment_date  date,
	 dwh_create_date    DATETIME2 DEFAULT GETDATE()
		)
