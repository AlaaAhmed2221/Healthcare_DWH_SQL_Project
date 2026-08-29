/*
=============================================================
Create Database and Schemas
=============================================================
create a new DB named 'H_DWH'
*/

create database H_DWH;

use H_DWH
Go

--Create Schemas

create schema bronze;
GO
create schema silver;
GO
create schema gold;

