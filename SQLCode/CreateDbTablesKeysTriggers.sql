/*
CREATE DATABASE physdb
 DEFAULT CHARACTER SET utf8
 DEFAULT COLLATE utf8_general_ci;

 USE physdb;
*/
 
-- CREATE THE TABLES
CREATE TABLE IF NOT EXISTS `Patients` (
	`patientID` INT(5) NOT NULL AUTO_INCREMENT,
	`FirstName` varchar(30) NOT NULL,
	`LastName` varchar(20) NOT NULL,
	`Sex` VARCHAR(1) DEFAULT NULL,
	`DateSeen` DATE DEFAULT NULL,
	`FatherName` varchar(30) DEFAULT NULL,
	`MotherName` varchar(30) DEFAULT NULL,
	`DateOfBirth` DATE DEFAULT NULL,
	`Phone` varchar(60) DEFAULT NULL,
	`e_mail` varchar(60) DEFAULT NULL,
	PRIMARY KEY (`patientID`)
);

CREATE TABLE IF NOT EXISTS `PatientLifeInfo` (
	`patientID` INT(5) NOT NULL ,
	`OtherTreatments` TEXT(300) DEFAULT NULL,
	`PersonalFactors` TEXT(500) DEFAULT NULL,
	`EnvironmentalFactors` TEXT(500) DEFAULT NULL,
	PRIMARY KEY (`patientID`)
);

CREATE TABLE IF NOT EXISTS `Diagnosis` (
	`patientID` INT(5) NOT NULL ,
	`mainconditionID` INT(7) NOT NULL,
	`maintypeID` INT(2) NOT NULL,
	`sidetypeID` INT(2) DEFAULT NULL,
	`OtherImpairments` TEXT(1000) DEFAULT NULL,
	PRIMARY KEY (`patientID`)
);

CREATE TABLE IF NOT EXISTS `DiagnosisType` (
	`diagnosisTypeID` INT(2) NOT NULL AUTO_INCREMENT,
	`Type` varchar(30) NOT NULL UNIQUE,
	`Description` TEXT(100) DEFAULT NULL,
	PRIMARY KEY (`diagnosisTypeID`)
);

CREATE TABLE IF NOT EXISTS `Operations` (
	`surgeonID` INT(5) NOT NULL ,
	`patientID` INT(5) NOT NULL ,
	`Date` DATE NOT NULL ,
	`Type` varchar(150) NOT NULL,
	`Notes` TEXT(500) DEFAULT NULL,
	PRIMARY KEY (`surgeonID`,`patientID`,`Date`)
);

CREATE TABLE IF NOT EXISTS `Doctors` (
	`doctorID` INT(5) NOT NULL AUTO_INCREMENT,
	`Specialty` varchar(30) NOT NULL,
	`FirstName` varchar(30) NOT NULL,
	`LastName` varchar(30) NOT NULL,
	`Phone` varchar(60) DEFAULT NULL,
	`e_mail` varchar(60) DEFAULT NULL,
	PRIMARY KEY (`doctorID`)
);

CREATE TABLE IF NOT EXISTS `PatientSupervisors` (
	`consultantID` INT(5) DEFAULT NULL,
	`patientID` INT(5) NOT NULL ,
	`therapistID` INT(5) NOT NULL ,
	PRIMARY KEY (`patientID`,`therapistID`)
);

CREATE TABLE IF NOT EXISTS `Therapists` (
	`therapistID` INT(5) NOT NULL AUTO_INCREMENT,
	`FirstName` varchar(30) NOT NULL,
	`LastName` varchar(20) NOT NULL,
	`Phone` varchar(60) DEFAULT NULL,
	`e_mail` varchar(60) DEFAULT NULL,
	PRIMARY KEY (`therapistID`)
);

CREATE TABLE IF NOT EXISTS `Sessions` (
	`therapistID` INT(5) NOT NULL,
	`patientID` INT(5) NOT NULL ,
	`Date` DATE NOT NULL ,
	`Notes` TEXT(1000) DEFAULT NULL,
	PRIMARY KEY (`patientID`,`Date`)
);

CREATE TABLE IF NOT EXISTS `Assessments` (
	`therapistID` INT(5) NOT NULL,
	`patientID` INT(5) NOT NULL ,
	`Date` DATE NOT NULL ,
	`Notes` TEXT(1000) NOT NULL,
	`FunctionalSkills` TEXT(1000) DEFAULT NULL,
	PRIMARY KEY (`patientID`,`Date`)
);

CREATE TABLE IF NOT EXISTS `TherapyPlansAndGoals` (
	`patientID` INT(5) NOT NULL ,
	`Date` DATE NOT NULL ,
	`Counter` INT(3) NOT NULL ,
	`Description` TEXT(1000) NOT NULL,
	`Status` varchar(1) NOT NULL DEFAULT 'P',
	PRIMARY KEY (`patientID`,`Date`,`Counter`)
);

CREATE TABLE IF NOT EXISTS `Tests` (
	`testID` INT(5) NOT NULL AUTO_INCREMENT,
	`Name` varchar(60) NOT NULL,
	`Description` TEXT(500) DEFAULT NULL,
	PRIMARY KEY (`testID`)
);

CREATE TABLE IF NOT EXISTS `TestsInAssessment` (
	`patientID` INT(5) NOT NULL ,
	`Date` DATE NOT NULL ,
	`testID` INT(5) NOT NULL ,
	`Score` TEXT(200) NOT NULL,
	PRIMARY KEY (`patientID`,`Date`,`testID`)
);

CREATE TABLE IF NOT EXISTS `DiagnosticImagingFinding` (
	`patientID` INT(5) NOT NULL,
	`findingID` INT(5) NOT NULL AUTO_INCREMENT,
	`Notes` TEXT(1000) NOT NULL,
	`Date` DATE DEFAULT NULL,
	PRIMARY KEY (`findingID`)
);

CREATE TABLE IF NOT EXISTS `Assistance` (
	`assistanceID` INT(5) NOT NULL AUTO_INCREMENT,
	`Type` varchar(60) NOT NULL,
	`Info` TEXT(200) DEFAULT NULL,
	PRIMARY KEY (`assistanceID`)
);

CREATE TABLE IF NOT EXISTS `Milestones` (
	`milestoneID` INT(5) NOT NULL AUTO_INCREMENT,
	`Name` varchar(60) NOT NULL,
	`Info` TEXT(200) DEFAULT NULL,
	PRIMARY KEY (`milestoneID`)
);

CREATE TABLE IF NOT EXISTS `PatientNeedsAssistance` (
	`patientID` INT(5) NOT NULL ,
	`assistanceID` INT(5) NOT NULL ,
	`Description` TEXT(300) NOT NULL,
	PRIMARY KEY (`patientID`,`assistanceID`)
);

CREATE TABLE IF NOT EXISTS `PatientAchievesMilestones` (
	`patientID` INT(5) NOT NULL ,
	`milestoneID` INT(5) NOT NULL ,
	`Notes` TEXT(300) DEFAULT NULL,
	`Date` DATE DEFAULT NULL,
	PRIMARY KEY (`patientID`,`milestoneID`)
);

CREATE TABLE IF NOT EXISTS `MainConditions` (
	`conditionID` INT(7) NOT NULL AUTO_INCREMENT,
	`Name` varchar(200) NOT NULL,
	`Description` TEXT(750) DEFAULT NULL,
	PRIMARY KEY (`conditionID`)
);

CREATE TABLE IF NOT EXISTS `Medicine` (
	`medicineID` INT(7) NOT NULL AUTO_INCREMENT,
	`Name` varchar(60) NOT NULL,
	`TypeID` INT(7) DEFAULT NULL,
	`Description` TEXT(200) DEFAULT NULL,
	PRIMARY KEY (`medicineID`)
);

CREATE TABLE IF NOT EXISTS `Medication` (
	`patientID` INT(5) NOT NULL ,
	`medicineID` INT(7) NOT NULL ,
	`StartDate` DATE NOT NULL ,
	`EndDate` DATE DEFAULT NULL,
	`Result` varchar(250) DEFAULT NULL,
	`Dosage` varchar(150) DEFAULT NULL,
	PRIMARY KEY (`patientID`,`medicineID`,`StartDate`)
);

CREATE TABLE IF NOT EXISTS `MedicineType` (
	`medicineTypeID` INT(7) NOT NULL AUTO_INCREMENT,
	`Type` varchar(60) NOT NULL,
	`Description` TEXT(200) DEFAULT NULL,
	PRIMARY KEY (`medicineTypeID`)
);


-- ADD FOREIGN KEY CONSTRAINTS

ALTER TABLE `PatientLifeInfo` ADD CONSTRAINT `PatientLifeInfo_fk0` FOREIGN KEY (`patientID`) REFERENCES `Patients`(`patientID`) ON DELETE CASCADE;

ALTER TABLE `Diagnosis` ADD CONSTRAINT `Diagnosis_fk0` FOREIGN KEY (`patientID`) REFERENCES `Patients`(`patientID`) ON DELETE CASCADE;

ALTER TABLE `Diagnosis` ADD CONSTRAINT `Diagnosis_fk1` FOREIGN KEY (`mainconditionID`) REFERENCES `MainConditions`(`conditionID`) ON DELETE CASCADE;

ALTER TABLE `Diagnosis` ADD CONSTRAINT `Diagnosis_fk2` FOREIGN KEY (`maintypeID`) REFERENCES `DiagnosisType`(`diagnosisTypeID`) ON DELETE CASCADE;

ALTER TABLE `Diagnosis` ADD CONSTRAINT `Diagnosis_fk3` FOREIGN KEY (`sidetypeID`) REFERENCES `DiagnosisType`(`diagnosisTypeID`) ON DELETE CASCADE;

ALTER TABLE `Operations` ADD CONSTRAINT `Operations_fk0` FOREIGN KEY (`surgeonID`) REFERENCES `Doctors`(`doctorID`) ON DELETE RESTRICT;

ALTER TABLE `Operations` ADD CONSTRAINT `Operations_fk1` FOREIGN KEY (`patientID`) REFERENCES `Patients`(`patientID`) ON DELETE CASCADE;

ALTER TABLE `PatientSupervisors` ADD CONSTRAINT `PatientSupervisors_fk0` FOREIGN KEY (`consultantID`) REFERENCES `Doctors`(`doctorID`) ON DELETE SET NULL;

ALTER TABLE `PatientSupervisors` ADD CONSTRAINT `PatientSupervisors_fk1` FOREIGN KEY (`patientID`) REFERENCES `Patients`(`patientID`) ON DELETE CASCADE;

ALTER TABLE `PatientSupervisors` ADD CONSTRAINT `PatientSupervisors_fk2` FOREIGN KEY (`therapistID`) REFERENCES `Therapists`(`therapistID`) ON DELETE RESTRICT;

ALTER TABLE `Sessions` ADD CONSTRAINT `Sessions_fk0` FOREIGN KEY (`therapistID`) REFERENCES `Therapists`(`therapistID`) ON DELETE RESTRICT;

ALTER TABLE `Sessions` ADD CONSTRAINT `Sessions_fk1` FOREIGN KEY (`patientID`) REFERENCES `Patients`(`patientID`) ON DELETE CASCADE;

ALTER TABLE `Assessments` ADD CONSTRAINT `Assessments_fk0` FOREIGN KEY (`therapistID`) REFERENCES `Therapists`(`therapistID`) ON DELETE RESTRICT;

ALTER TABLE `Assessments` ADD CONSTRAINT `Assessments_fk1` FOREIGN KEY (`patientID`) REFERENCES `Patients`(`patientID`) ON DELETE CASCADE;

ALTER TABLE `TherapyPlansAndGoals` ADD CONSTRAINT `TherapyPlansAndGoals_fk0` FOREIGN KEY (`patientID`) REFERENCES `Assessments`(`patientID`) ON DELETE CASCADE;

ALTER TABLE `TestsInAssessment` ADD CONSTRAINT `TestsInAssessment_fk0` FOREIGN KEY (`patientID`) REFERENCES `Assessments`(`patientID`) ON DELETE CASCADE;

ALTER TABLE `TestsInAssessment` ADD CONSTRAINT `TestsInAssessment_fk1` FOREIGN KEY (`testID`) REFERENCES `Tests`(`testID`) ON DELETE CASCADE;

ALTER TABLE `DiagnosticImagingFinding` ADD CONSTRAINT `DiagnosticImagingFinding_fk0` FOREIGN KEY (`patientID`) REFERENCES `Patients`(`patientID`) ON DELETE CASCADE;

ALTER TABLE `PatientNeedsAssistance` ADD CONSTRAINT `PatientNeedsAssistance_fk0` FOREIGN KEY (`patientID`) REFERENCES `Patients`(`patientID`) ON DELETE CASCADE;

ALTER TABLE `PatientNeedsAssistance` ADD CONSTRAINT `PatientNeedsAssistance_fk1` FOREIGN KEY (`assistanceID`) REFERENCES `Assistance`(`assistanceID`) ON DELETE CASCADE;

ALTER TABLE `PatientAchievesMilestones` ADD CONSTRAINT `PatientAchievesMilestones_fk0` FOREIGN KEY (`patientID`) REFERENCES `Patients`(`patientID`) ON DELETE CASCADE;

ALTER TABLE `PatientAchievesMilestones` ADD CONSTRAINT `PatientAchievesMilestones_fk1` FOREIGN KEY (`milestoneID`) REFERENCES `Milestones`(`milestoneID`) ON DELETE CASCADE;

ALTER TABLE `Medicine` ADD CONSTRAINT `Medicine_fk0` FOREIGN KEY (`TypeID`) REFERENCES `MedicineType`(`medicineTypeID`) ON DELETE SET NULL;

ALTER TABLE `Medication` ADD CONSTRAINT `Medication_fk0` FOREIGN KEY (`patientID`) REFERENCES `Patients`(`patientID`) ON DELETE CASCADE;

ALTER TABLE `Medication` ADD CONSTRAINT `Medication_fk1` FOREIGN KEY (`medicineID`) REFERENCES `Medicine`(`medicineID`) ON DELETE CASCADE;


-- ADD DECLERATION CONSTRAINTS

--
-- BEFORE INSERT
--

delimiter //
CREATE TRIGGER patients_trigg BEFORE INSERT ON Patients
FOR EACH ROW 
BEGIN
DECLARE msg VARCHAR(100);
IF NEW.Sex NOT IN ('M','F') THEN 
set msg = "Sex must be either 'M' or 'F'";
signal sqlstate '45000' set message_text = msg;
END IF;
IF NEW.DateOfBirth > CURDATE() OR NEW.DateSeen > CURDATE() THEN 
set msg = "Date of birth and Date seen cannot be after today";
signal sqlstate '45000' set message_text = msg;
END IF; 
IF NEW.e_mail NOT LIKE '%@%.%' THEN
set msg = "Invalid e-mail format";
signal sqlstate '45000' set message_text = msg;
END IF; 
END //

delimiter //
CREATE TRIGGER patientachievesmilestones_trigg BEFORE INSERT ON PatientAchievesMilestones
FOR EACH ROW 
BEGIN
DECLARE msg VARCHAR(100);
IF NEW.Date > CURDATE() THEN 
set msg = "Date cannot be after today";
signal sqlstate '45000' set message_text = msg;
END IF; 
END //

delimiter //
CREATE TRIGGER medication_check BEFORE INSERT ON Medication
FOR EACH ROW 
BEGIN
DECLARE msg VARCHAR(100);
IF NEW.StartDate > CURDATE() THEN 
set msg = "Date cannot be after today";
signal sqlstate '45000' set message_text = msg;
END IF; 
END //

delimiter //
CREATE TRIGGER operation_trigg BEFORE INSERT ON Operations
FOR EACH ROW 
BEGIN
DECLARE msg VARCHAR(100);
IF NEW.Date > CURDATE() THEN 
set msg = "Date cannot be after today";
signal sqlstate '45000' set message_text = msg;
END IF; 
END //

delimiter //
CREATE TRIGGER doctors_trigg BEFORE INSERT ON Doctors
FOR EACH ROW 
BEGIN
DECLARE msg VARCHAR(100);
IF NEW.e_mail NOT LIKE '%@%.%' THEN
set msg = "Invalid e-mail format";
signal sqlstate '45000' set message_text = msg;
END IF; 
END //

delimiter //
CREATE TRIGGER therapists_trigg BEFORE INSERT ON Therapists
FOR EACH ROW 
BEGIN
DECLARE msg VARCHAR(100);
IF NEW.e_mail NOT LIKE '%@%.%' THEN
set msg = "Invalid e-mail format";
signal sqlstate '45000' set message_text = msg;
END IF; 
END //

delimiter //
CREATE TRIGGER sessions_trigg BEFORE INSERT ON Sessions
FOR EACH ROW 
BEGIN
DECLARE msg VARCHAR(100);
IF NEW.Date > CURDATE() THEN 
set msg = "Date cannot be after today";
signal sqlstate '45000' set message_text = msg;
END IF; 
END //

delimiter //
CREATE TRIGGER diagnosticimagingfinding_trigg BEFORE INSERT ON DiagnosticImagingFinding
FOR EACH ROW 
BEGIN
DECLARE msg VARCHAR(100);
IF NEW.Date > CURDATE() THEN 
set msg = "Date cannot be after today";
signal sqlstate '45000' set message_text = msg;
END IF; 
END //

delimiter //
CREATE TRIGGER assessments_trigg BEFORE INSERT ON Assessments
FOR EACH ROW 
BEGIN
DECLARE msg VARCHAR(100);
IF NEW.Date > CURDATE() THEN 
set msg = "Date cannot be after today";
signal sqlstate '45000' set message_text = msg;
END IF; 
END //

delimiter //
CREATE TRIGGER therapyplansandgoals_trigg BEFORE INSERT ON TherapyPlansAndGoals
FOR EACH ROW 
BEGIN
DECLARE msg VARCHAR(100);
IF NEW.Status NOT IN ('P','C', 'A') THEN 
set msg = "Status must be one of the following: P (Pending), C (Completed) or A (Aborted)";
signal sqlstate '45000' set message_text = msg;
END IF;
IF NEW.Counter < 0 THEN 
set msg = "Counter cannot be negative";
signal sqlstate '45000' set message_text = msg;
END IF; 
END //