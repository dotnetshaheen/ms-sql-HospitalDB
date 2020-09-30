/* 
-------------------------------
Hospital Management Database
-------------------------------
Name -  Md. Shaheen Hossain
Student ID- 1251661
Batch ID- ESAD-CS/GNSL-M/41/01

*/
--
--use master
--Drop database shifaHospital
if db_Id('shifaHospital') is not null
		drop database shifahospital

CREATE DATABASE shifaHospital
--on	(
--		name = shifaHospital_data,
--		filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\shifaHospital.mdf',
--		size = 15 mb,
--		maxsize = 100 mb,
--		filegrowth = 10%
--	)
--Log on	(
--			name = shifaHospital_log,
--			filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\shifaHospital_log.ldf',
--			size = 10 mb,
--			maxsize = 50 mb,
--			filegrowth = 5%
--		)
go
use shifaHospital;
go
-- Department Table
CREATE TABLE Department
(
	Dept_ID int identity primary key,
	Dept_Name varchar(50)
)
-- Medicine Table
CREATE TABLE DrugsList
(
	Drug_ID	int	identity primary key,
	Drug_Name varchar(30),
	Brand_Name	varchar(40),
	[Description] varchar(max),
	Drug_Price	Money default 0
)
-- Hospital Bed List
CREATE TABLE BedNo
(
	Bed_ID	int identity primary key,
	Ward_Name varchar(50),
	Floor_Num	int,
	Bed_rent money
)
-- Medical Test List
CREATE TABLE MedTest
(
	M_Test_ID	int identity primary key,
	M_Test_Name	varchar(50),
	Test_Cost	Money default 0
)
-- Doctor List
CREATE TABLE Doctor
(
	Doctor_Id	int identity primary key,
	Doc_Name	varchar(50),
	Gender		varchar(6),
	Dept_ID		int references Department(Dept_ID)
)
-- Patient List
CREATE TABLE Patient
(
	Patient_ID	int identity primary key,
	Patient_Name	varchar(50) not null,
	patient_PhoneNo	varchar(11),
	patient_address	varchar(50)
)
-- Patient Appointment List
CREATE TABLE AppoitmentInfo
(
	ID	int identity primary key,
	Patient_Id int references patient(patient_Id),
	Doctor_id int references doctor(doctor_id),
	Serial_Num	int,
	Appointment_time	time,
	Appoint_Date date
)
-- Addmitted Patient List
create table admitPatient
(
	ID	int identity primary key,
	PatientID	int references patient(Patient_ID),
	AdmitDate	date,
	DispatchDate	date

)
-- Prescription List
CREATE TABLE prescription
(
	Id int identity primary key,
	Doctor_Id int references doctor(doctor_id),
	patient_id int references patient(patient_id),
	Medicine_id int references DrugsList(Drug_ID),
	Medical_test int references Medtest(M_Test_ID),
	Doc_Advice	varchar(150)
)
-- Invoice List
Create TABLE	Invoice
(
	Invoice_Id	int identity primary key,
	Patient_Id	int references patient(patient_id),
	Consultation_Fee	money default 500,
	Medicine_ID	int references DrugsList(Drug_ID),
	Medicine_Price money,
	MedicalTest_Id	int references MedTest(M_Test_ID),
	Test_Cost	money,
	Bed_Id int references BedNo(Bed_ID),
	Bed_rent money,
	SubTotal money,
	Invoice_date	date
)

go

------------------------------------------------------------------------------
--- Create STORE PROCEDURE---
------------------------------------------------------------------------------
-- Department Table

create proc sp_department
	@DeptName varchar(50)
as
	begin
		insert into dbo.Department(Dept_Name)
		values(@DeptName)
	end

go

-- Drug List
create proc sp_DrugList
	@drugName varchar(50),
	@brandName	varchar(50),
	@description	varchar(max),
	@price money
as
	begin
			insert into DrugsList(Drug_Name,Brand_Name,[Description],Drug_Price)
			values(@drugName,@brandName,@description,@price)
	end


go

-- Bed List
create proc sp_bedList
	@WardName varchar(50),
	@FloorNumber int,
	@bedRent money
as
	begin
			insert into BedNo(Ward_Name,Floor_Num,Bed_rent)
			values(@WardName,@FloorNumber,@bedRent)
	end

go

-- Medical Test list
create proc sp_MedTest
	@medicalTestName	varchar(50),
	@testCost	money
as
	begin
			insert into MedTest(M_Test_Name,Test_Cost)
			values(@medicalTestName,@testCost)
	end

go

-- Doctor List
create proc sp_doctor
	@docName	varchar(50),
	@gender		varchar(6),
	@deptID	int
as	
	begin
		insert into Doctor(Doc_Name, Gender, Dept_ID)
		values(@docName, @gender, @deptID)
	end

go

-- patient list
create proc sp_patient
	@patientName varchar(50),
	@phoneNum	varchar(11),
	@address varchar(50)
as
	begin
			insert into Patient(Patient_Name,patient_PhoneNo,patient_address)
			values(@patientName,@phoneNum,@address)
	end
go

-- Appointment List

create proc sp_appointment
	@patientID	int,
	@doctorId	int,
	@serialNo	int,
	@ApppintTime	time,
	@Date	date
as
	begin
		insert into AppoitmentInfo(Patient_Id,Doctor_id,Serial_Num,Appointment_time,Appoint_Date)
		values(@patientID,@doctorId,@serialNo,@ApppintTime,@Date)
	end

go

-- Admit/dispatch Patient List
create proc sp_admitDispatch
	@patienID	int,
	@admitdate	date,
	@dispatch date
as	
	begin
		insert into admitPatient(PatientID,AdmitDate,DispatchDate)
		values(@patienID,@admitdate,@dispatch)
	end

go

-- Prescription
create proc sp_prescription
	@doctor int,
	@patient int,
	@medicine int,
	@test int,
	@advice varchar(150)
as
	begin
		insert into prescription(Doctor_Id,Patient_id,Medicine_id,Medical_test,Doc_Advice)
		values(@doctor,@patient,@medicine,@test,@advice)
	end

go

-- Invoice list
create proc sp_invoice
	@Patient_Id	int,
	@Consultation_Fee	money,
	@Medicine_ID	int,
	@Medicine_Price money,
	@MedicalTest_Id	int,  
	@Test_Cost	money,
	@Bed_Id int,
	@Bed_rent money,
	@SubTotal money,
	@Invoice_date	date
as
	begin
			set @Medicine_Price = (select Drug_Price from DrugsList where Drug_ID=@Medicine_ID)
			set @Test_Cost = (select Test_Cost from MedTest where M_Test_ID=@MedicalTest_Id)
			set @Bed_rent=(select Bed_rent from BedNo where Bed_ID=@Bed_Id)
			set @SubTotal=@Medicine_Price+@Test_Cost+@Bed_rent
				
				Insert into Invoice(
									Patient_Id,
									Consultation_Fee,
									Medicine_ID,
									Medicine_Price,
									MedicalTest_Id,
									Test_Cost,
									Bed_Id,
									Bed_rent,
									SubTotal,								
									Invoice_date
									)
							values(
									@Patient_Id,
									@Consultation_Fee,
									@Medicine_ID,
									@Medicine_Price,
									@MedicalTest_Id,
									@Test_Cost,
									@Bed_Id,
									@Bed_rent,
									@SubTotal,									
									@Invoice_date
									)
	end

go





go	


-------------------------------------------------
-----------Insert Data
-------------------------------------------------

----- Insert data Using STORE PROCEDURE
---- Department

exec sp_department 'Medicine'
exec sp_department 'Neurology'
exec sp_department 'Orthopaedic Surgery'
exec sp_department 'Pathology'
exec sp_department 'Physiology & Biophysics'

go
---- Drug List

exec sp_DrugList 'Ace Plus','Square','Fever, headache, migraine, muscle ache, backache, toothache & menstrual pain.','20'
exec sp_DrugList 'Anadol','Square','Postoperative pain, Colic and spastic pain, Cancer pain, Joint pain,','80'
exec sp_DrugList 'Asynta','Square','Treatment of symptoms of gastro-oesophageal reflux such as acid regurgitation, heartburn and indigestion ','120'
exec sp_DrugList 'Ebaril','Incepta','Therapeutic Group: Anti Histamine','60'
exec sp_DrugList 'Idatix','Incepta','Therapeutic Group: Cardiovascular','70'
exec sp_DrugList 'Actidex','Incepta','Therapeutic Group: Analgesic, Anti Inflammatory','90'
exec sp_DrugList 'Calcin Tablet','Renata','Calcium Carbonate','30'
exec sp_DrugList 'Calcin-D Tablet','Renata','Calcium Carbonate And Vitamin-D','70'
exec sp_DrugList 'Calcin-M Tablet','Renata','Calcium Carbonate, Vitamin-D, Zinc, Copper, Magnesium, Manganese And Boron','155'
exec sp_DrugList 'Doripen','Eskayef','Meropenem','85'

go

---- bed list

exec sp_bedList 'General','4','400'
exec sp_bedList 'Cabin','4','800'
exec sp_bedList 'Maternity Wards','3','600'
exec sp_bedList 'Cabin','3','1200'
exec sp_bedList 'VIP Ward','2','2000'

go
---- Medical Test

exec sp_MedTest 'ECG','300'
exec sp_MedTest 'ECHO','500'
exec sp_MedTest 'RADIOLOGY','800'
exec sp_MedTest 'Pathology','1200'
exec sp_MedTest 'Ultrasound','1800'

go
---- DOCTOR LIST

exec sp_doctor 'Mahbub Alam','Male','1'
exec sp_doctor 'Kaniz Fatema','Female','1'
exec sp_doctor 'Ibrahim Khalil','Male','2'
exec sp_doctor 'Faisal Khan','Male','2'
exec sp_doctor 'Sumaiya Akter','Female','3'
exec sp_doctor 'Md Haider','Male','3'
exec sp_doctor 'Ali Hossain','Male','3'
exec sp_doctor 'Sagor Ahmed','Male','4'
exec sp_doctor 'Rafiqul Islam','Male','5'
exec sp_doctor 'Shopon Chowdhury','Male','2'

go
---- Patient List

exec sp_patient 'Md Salim Hossain','01719131614','Mirpur-12'
exec sp_patient 'J A Mamun','01791295547','Dhanmondi'
exec sp_patient 'Md Sumon','01791534547','Dhanmondi'
exec sp_patient 'Md Rahim','01797274547','Nikunja-2'
exec sp_patient 'Abdur Razzak','01771274547','Mohammadpur'
exec sp_patient 'Bimol Chandra das','01591274547','Niketon'
exec sp_patient 'Meghnath Decosta','01391274547','Bananai'
exec sp_patient 'Provat Snal','01491274547','Mirpur DOHS'
exec sp_patient 'Sheikh Abdullah','01691274547','Uttara'
exec sp_patient 'Anowar Ansari','01891274547','Basabo'
exec sp_patient 'Tania Ahmed','01701274557','Jatrabari'
exec sp_patient 'Provat Snal','01491279747','Mirpur DOHS'
exec sp_patient 'Sheikh Sumon','01511274547','Uttara'
exec sp_patient 'Anowar Ansari','01893374547','Adabor'
exec sp_patient 'Tania Ahmed','01701299557','Jatrabari'
exec sp_patient 'Provat Snal','01491200547','Mirpur DOHS'
exec sp_patient 'Sheikh Abdullah','01361274547','Khilkhet'
exec sp_patient 'Anowar Ansari','01441274547','Basabo'
exec sp_patient 'Sadia Ahmed','01799274557','Jatrabari'

go

---- Appoint List

exec sp_appointment '15','1','1','08:00:00','07-15-2019'
exec sp_appointment '16','1','2','08:20:00','07-15-2019'
exec sp_appointment '17','2','3','07:40:00','07-15-2019'
exec sp_appointment '18','3','4','07:20:00','07-15-2019'
exec sp_appointment '11','4','5','07:00:00','07-15-2019'
exec sp_appointment '8','5','6','07:30:00','07-15-2019'
exec sp_appointment '16','1','7','07:30:00','07-16-2019'
exec sp_appointment '2','2','8','06:30:00','07-16-2019'
exec sp_appointment '5','3','9','05:30:00','07-16-2019'
--exec sp_appointment '9','4','10','04:30:00','07-16-2019'

-- Test Trigger By execute this statement ( Trigger Name : tr_Appoitment_Patient  )
--exec sp_appointment '25','5','11','07:30:00','07-16-2019'

go

---- admit patient list-

exec sp_admitDispatch '1','07-13-2019',''
exec sp_admitDispatch '3','07-13-2019',''
exec sp_admitDispatch '4','07-12-2019','07-14-2019'
exec sp_admitDispatch '13','07-12-2019','07-13-2019'

go

---- Prescription List
exec sp_prescription '1',1,10,1,'Drink More Water'
exec sp_prescription '2',2,9,2,'Drink More Water'
exec sp_prescription '3',3,8,1,'Drink More Water'
exec sp_prescription '4',4,7,3,'Drink More Water'
exec sp_prescription '5',5,6,1,'Drink More Water'
exec sp_prescription '5',6,5,4,'Drink More Water'
exec sp_prescription '6',7,4,1,'Drink More Water'
exec sp_prescription '7',8,3,5,'Drink More Water'
exec sp_prescription '1',9,2,5,'Drink More Water'
exec sp_prescription '9',10,1,3,'Drink More Water'
exec sp_prescription '8',11,10,2,'Drink More Water'
exec sp_prescription '10',12,9,1,'Drink More Water'

go

---- Invoice List

exec sp_invoice	2,500,5,'',5,'',5,'','','2019-06-13'
exec sp_invoice	3,500,4,'',4,'',4,'','','2019-06-13'
exec sp_invoice	4,500,3,'',3,'',3,'','','2019-06-14'
exec sp_invoice	5,500,2,'',2,'',2,'','','2019-06-14'
exec sp_invoice	6,500,1,'',1,'',1,'','','2019-06-14'
exec sp_invoice	7,500,2,'',2,'',2,'','','2019-06-15'
exec sp_invoice	8,500,3,'',3,'',3,'','','2019-06-15'
exec sp_invoice	9,500,4,'',4,'',4,'','','2019-06-15'
exec sp_invoice	10,500,5,'',5,'',5,'','','2019-06-15'

go
------------------------------------------------------
---------------create Nonclustered Index---------
-----------------------------------------------
create index in_medicine
on [dbo].[DrugsList]([Drug_Name]);

go
---------------------------------------
--- create trigger
---------------------------------------
--- If patient id not exists in patient table then trigger will fire in appointment table and raise error

Create trigger tr_Appoitment_Patient
on	[dbo].[AppoitmentInfo]
instead of insert
as
begin
		declare @patient	int
		select	@patient=[Patient_Id] from inserted
		if @patient in (select Patient_ID from Patient)
		begin
			begin tran
			insert into AppoitmentInfo([Patient_Id],[Doctor_id],[Serial_Num],[Appointment_time],[Appoint_Date])
			select [Patient_Id],[Doctor_id],[Serial_Num],[Appointment_time],[Appoint_Date] from inserted
			commit tran
		end
		else
			print 'Patient is Not Listed in Patient Table'
			rollback
end

go

--------------------------------------------------
---- Create view
--------------------------------------------------

-- Create View for Prescription data
create view vw_Prescription
as
Select			Id as	Prescription_ID,
				pres.[Doctor_Id], 
				[Doc_Name],
				pres.[patient_id],
				[Patient_Name],
				[Drug_Name],
				Doc_Advice

from prescription pres
	join	Doctor doc
	on	pres.Doctor_Id=doc.Doctor_Id
	join	Patient pat
	on	pres.patient_id=pat.Patient_ID
	join DrugsList dru
	on pres.Medicine_id=dru.Drug_ID

go

-- create view for appointment data
Create view vw_appointment
as
Select		ID as [Appointmnet ID],
			[Doc_Name],
			[Patient_Name],
			[Serial_Num],
			[Appointment_time],
			[Appoint_Date]

from		AppoitmentInfo appinfo
join	Doctor doc
on		appinfo.Doctor_id=doc.Doctor_Id
join	Patient pat
on		appinfo.Patient_Id=pat.Patient_ID

go

-- View of Appointment list for Dr. Mahbub Alam
Create view vw_appointment_Of_Mahbub_Alam
as
Select		ID as [Appointmnet ID],
			[Doc_Name],
			[Patient_Name],
			[Serial_Num],
			[Appointment_time],
			[Appoint_Date]

from		AppoitmentInfo appinfo
join	Doctor doc
on		appinfo.Doctor_id=doc.Doctor_Id
join	Patient pat
on		appinfo.Patient_Id=pat.Patient_ID
where  appinfo.Doctor_id=1

go

---------------------------------------------
--- create function 
---------------------------------------------
-- Scalar Function for Calculate Daily Sales

create function fn_incomeOfToday(@date date)
returns money
begin
	return( select sum(SubTotal)
			from	Invoice
			where Invoice_date=@date)
end

go

--Table Valued Function
-- Retrive all prescription of specific doctor by id

Create function fn_prescriptionByDoctorID(@doctorID int)
returns table
as
return	(	select 	id Prescription_ID,
					[Doc_Name],
					[Patient_Name],
					[Drug_Name],
					[M_Test_Name],
					Doc_Advice
			from prescription pres
			join	[dbo].[Doctor] doc
			on pres.[Doctor_Id]=doc.[Doctor_Id]
			join  [dbo].[Patient] pat
			on	pres.[patient_id]=pat.[Patient_ID]
			join [dbo].[DrugsList] drug
			on pres.[Medicine_id]=drug.[Drug_ID]
			join [dbo].[MedTest] medt
			on pres.[Medical_test]=medt.[M_Test_ID]
			where pres.Doctor_Id=@doctorID
		)
