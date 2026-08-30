/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

use H_DWH
Go

IF OBJECT_ID('bronze.appointments', 'U') IS NOT NULL
    DROP TABLE bronze.appointments;

	create table bronze.appointments(
	appointment_id varchar(50),
	patient_id varchar(50),
    doctor_id varchar(50),
	appointment_date date,
	appointment_time time,
	reason_for_visit varchar(50),
    status varchar(50)
	)
Go

IF OBJECT_ID('bronze.billing', 'U') IS NOT NULL
    DROP TABLE bronze.billing;

	create table bronze.billing(
	bill_id varchar(50),
	patient_id varchar(50),
	treatment_id varchar(50),
	bill_date date,
    amount float,
    payment_method varchar(50),
	payment_status varchar(50)
		)
Go

IF OBJECT_ID('bronze.doctors', 'U') IS NOT NULL
    DROP TABLE bronze.doctors;

	create table bronze.doctors(
	doctor_id varchar(50),
	first_name varchar(50),
	last_name varchar(50),
	specialization varchar(50),
	phone_number varchar(50),
	years_experience int,
    hospital_branch varchar(50),
	email varchar(50)
		)
Go

IF OBJECT_ID('bronze.patients', 'U') IS NOT NULL
    DROP TABLE bronze.patients;

	create table bronze.patients(
	patient_id varchar(50),
	first_name varchar(50),
	last_name varchar(50),
	gender varchar(50),
	date_of_birth date,
	contact_number varchar(50),
	address varchar(100),
	registration_date date,
	insurance_provider varchar(50),
	insurance_number varchar(50),
	email varchar(50)
		)
Go

IF OBJECT_ID('bronze.treatments', 'U') IS NOT NULL
    DROP TABLE bronze.treatments;

	create table bronze.treatments(
	treatment_id varchar(50),
	appointment_id varchar(50),
	treatment_type varchar(50),
	description varchar(50),
	cost float,
	treatment_date date
		)

