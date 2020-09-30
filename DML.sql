use shifaHospital;

select * from	[dbo].[Department]
select * from	[dbo].[DrugsList]
select * from	[dbo].[BedNo]
select * from	[dbo].[Doctor]
select * from	[dbo].[Patient]
select * from	[dbo].[MedTest]

select * from	[dbo].[AppoitmentInfo]
select * from	[dbo].[admitPatient]
select * from	[dbo].[prescription]
select * from	[dbo].[Invoice]

-- View
select * from vw_Prescription /* All Prescription List*/
select * from vw_appointment /* All Appointment List*/
select * from vw_appointment_Of_Mahbub_Alam /* Appointment List of Mahbub Alam */

-- Function
select dbo.fn_incomeOfToday('2019-06-13') as [Total Income of the Day]					/*Scalar Valued Function*/
select  * from dbo.fn_prescriptionByDoctorID(1)											 /*Table Valued Function */

-- Check Trigger  Tr-Name = tr_Appoitment_Patient
-- If patient id not exists in patient table then trigger will fire in appointment table and raise error
-- First Parametere is Patient Id
exec sp_appointment '50','3','9','05:30:00','07-16-2019'