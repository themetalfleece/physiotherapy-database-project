1) Τα ονόματα όλων των φαρμάκων που παίρνει ο Ασθενής 'Adam Black'

SELECT FirstName, LastName, medicine.Name FROM patients
JOIN medication ON
medication.patientID = patients.patientID
JOIN medicine ON
medication.medicineID = medicine.medicineID
WHERE patients.FirstName = 'Adam' AND patients.LastName = 'Black'

2) Τα ονόματα των ασθενών και των φαρμάκων που ξεκίνησαν να παίρνουν το 2ο Εξάμηνο του 2011 και δεν έχουν σταματήσει μέχρι σήμερα

Select patients.FirstName, patients.LastName, medicine.Name AS 'Medicine Name', medication.StartDate
FROM patients
JOIN medication ON
patients.patientID = medication.patientID
JOIN medicine ON
medicine.medicineID = medication.medicineID
WHERE medication.EndDate IS Null AND YEAR(medication.StartDate) = 2011 AND MONTH(medication.StartDate)>6

3) Το όνομα του θεραπευτή που έχει πραγματοποιήσει τα περισσότερα Sessions και το πόσα περισσότερα έχει πραγματοποιήσει από τον 2ο στη σειρά

Select therapists.FirstName, therapists.LastName, first.c AS 'Sessions', first.c-second.c AS 'Difference from Second'
FROM
(SELECT Count(sessions.therapistID) AS c, sessions.therapistID
FROM sessions
GROUP BY sessions.therapistID
ORDER BY c DESC
LIMIT 0,1) AS first
JOIN
(SELECT Count(sessions.therapistID) AS c
FROM sessions
GROUP BY sessions.therapistID
ORDER BY c DESC
LIMIT 1,1) AS second
JOIN therapists ON
therapists.therapistID = first.therapistID

4) Ο αριθμός των Sessions που έγιναν μέσα στο 2014 και στο 2015 και η διαφορά τους, ομαδοποιημένα ανά μήνα για κάθε έτος

SELECT sess15.month, sess14.total AS '2014', sess15.total AS '2015', sess15.total - sess14.total AS 'Difference 15-14'
FROM
(SELECT MONTH(Date) AS month, COUNT(*) as total
FROM sessions
WHERE YEAR(Date) = 2015
GROUP BY MONTH(Date)) as sess15
JOIN
(SELECT MONTH(Date) AS month, COUNT(*) as total
FROM sessions
WHERE YEAR(Date) = 2014
GROUP BY MONTH(Date)) as sess14
ON sess15.month = sess14.month

5) Όλα τα Plans/Goals που σημειώθηκαν πριν από 1.5 χρόνο και είναι ακόμα Pending. Να εμφανιστούν επίσης το όνομα του ασθενή και το όνομα του θεραπευτή που έθεσε αυτούς τους στόχους, ταξινομηνέμα αλφαβητικά με βάση το όνομα του Ασθενούς

SELECT CONCAT_WS (' ',  patients.FirstName, patients.LastName) AS "Patient Name", CONCAT_WS (' ',  therapists.FirstName, therapists.LastName) AS "Therapist Name", therapyplansandgoals.Date, therapyplansandgoals.Description FROM therapyplansandgoals
JOIN patients ON
patients.patientID = therapyplansandgoals.patientID
JOIN assessments ON
therapyplansandgoals.patientID = assessments.patientID AND therapyplansandgoals.Date = assessments.Date
JOIN therapists ON
therapists.therapistID = assessments.therapistID
WHERE therapyplansandgoals.Date < DATE_SUB(CURDATE(), INTERVAL 18 MONTH)
AND therapyplansandgoals.Status = 'P'  
ORDER BY `Patient Name` ASC

6) Οι ασθενείς που έχουν δεν πραγματοποιήσει το Milestone "Running" και χρειάζονται "Foot Orthotics" assistance

SELECT patients.FirstName, patients.LastName
FROM patients
JOIN patientneedsassistance ON
patients.patientID = patientneedsassistance.patientID
WHERE
patientneedsassistance.assistanceID = (SELECT assistance.assistanceID FROM assistance WHERE assistance.Type = 'Foot Orthotics')
AND !EXISTS
(SELECT * FROM patientachievesmilestones WHERE patientachievesmilestones.milestoneID = (SELECT milestones.milestoneID FROM milestones WHERE milestones.Name = 'Running') AND patientachievesmilestones.patientID = patients.patientID)

7) Πόσα τέστς του τύπου "GMFM" έχουν γίνει σε ασθενείς με Main Condition του είδους "CP" σε σχέση με το πόσα τέτοια τεστ έχουν γίνει σύνολο (επί τις 100)

SELECT COUNT(*) / (SELECT COUNT(*) FROM testsinassessment WHERE testsinassessment.testID = (SELECT tests.testID FROM tests WHERE tests.Name LIKE "%GMFM%")) * 100 AS 'Percentage'
FROM testsinassessment
JOIN diagnosis ON
testsinassessment.patientID = diagnosis.patientID
WHERE testsinassessment.testID = (SELECT tests.testID FROM tests WHERE tests.Name LIKE "%GMFM%")
AND diagnosis.mainconditionID IN (SELECT mainconditions.conditionID FROM mainconditions WHERE mainconditions.Name LIKE "CP%")

8) Τα ονόματα όλων των ιατρών που έχουν πραγματοποιήσει εγχείρηση πάνω σε έναν ασθενή τον οποίον επιβλέπουν, και το όνομα του ασθενούς αυτού

SELECT CONCAT_WS (' ',doctors.FirstName, doctors.LastName) AS 'Doctor Name', CONCAT_WS (' ',patients.FirstName, patients.LastName) as 'Patient Name'
FROM patientsupervisors
JOIN operations ON
patientsupervisors.consultantID = operations.surgeonID
JOIN doctors ON
operations.surgeonID = doctors.doctorID
JOIN patients ON
operations.patientID = patients.patientID
WHERE patientsupervisors.patientID = operations.patientID

9) Τα ονόματα και οι ηλικίες όλων των Ασθενών που είναι μικρότεροι από 10 ετών και παίρνουν φάρμακα του τύπου 'Antiepileptic'

SELECT patients.FirstName, patients.LastName, TIMESTAMPDIFF(YEAR, patients.DateOfBirth, CURDATE()) AS 'Age'
FROM patients
JOIN medication
ON patients.patientID = medication.patientID
JOIN medicine
ON medication.medicineID = medicine.medicineID
WHERE patients.DateOfBirth > DATE_SUB(CURDATE(), INTERVAL 10 YEAR)
AND medicine.TypeID = (SELECT medicinetype.medicineTypeID FROM medicinetype WHERE medicinetype.Type = 'Antiepileptic')