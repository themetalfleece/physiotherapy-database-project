from mysql.connector import MySQLConnection, Error
from python_mysql_dbconfig import read_db_config

try:
    dbconfig = read_db_config()
    conn = MySQLConnection(**dbconfig)
    cursor = conn.cursor()
 
except Error as e1:
    print(e1)

def a():
    query = """
SELECT FirstName, LastName, medicine.Name FROM patients
JOIN medication ON
medication.patientID = patients.patientID
JOIN medicine ON
medication.medicineID = medicine.medicineID
WHERE patients.FirstName = 'Adam' AND patients.LastName = 'Black'
"""
    cursor.execute(query)
    rows = cursor.fetchall()
    print("Total Row(s):", cursor.rowcount)
    for fname, lname, mname in rows:
        print fname, lname, mname

def b():
    query = """
Select patients.FirstName, patients.LastName, medicine.Name AS 'Medicine Name', medication.StartDate
FROM patients
JOIN medication ON
patients.patientID = medication.patientID
JOIN medicine ON
medicine.medicineID = medication.medicineID
WHERE medication.EndDate IS Null AND YEAR(medication.StartDate) = 2011 AND MONTH(medication.StartDate)>6
"""
    cursor.execute(query)
    rows = cursor.fetchall()
    print("Total Row(s):", cursor.rowcount)
    for fname, lname, mname, date in rows:
        print fname, lname, mname, date

def c():
    query = """
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
"""
    cursor.execute(query)
    rows = cursor.fetchall()
    print("Total Row(s):", cursor.rowcount)
    for fname, lname, first, difference in rows:
        print fname, lname, first, difference
        
def d():
    query = """
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
        """
    cursor.execute(query)
    rows = cursor.fetchall()
    print("Total Row(s):", cursor.rowcount)
    for month, s14, s15, difference in rows:
        print month, s14, s15, difference

def e():
    query = """
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
"""
    cursor.execute(query)
    rows = cursor.fetchall()
    print("Total Row(s):", cursor.rowcount)
    for pname, tname, date, desc in rows:
        print pname, tname, date, desc

def f():
    query = """
SELECT patients.FirstName, patients.LastName
FROM patients
JOIN patientneedsassistance ON
patients.patientID = patientneedsassistance.patientID
WHERE
patientneedsassistance.assistanceID = (SELECT assistance.assistanceID FROM assistance WHERE assistance.Type = 'Foot Orthotics')
AND !EXISTS
(SELECT * FROM patientachievesmilestones WHERE patientachievesmilestones.milestoneID = (SELECT milestones.milestoneID FROM milestones WHERE milestones.Name = 'Running') AND patientachievesmilestones.patientID = patients.patientID)

"""
    cursor.execute(query)
    rows = cursor.fetchall()
    print("Total Row(s):", cursor.rowcount)
    for fname, lname in rows:
        print fname, lname
        
def g():
    query = """
SELECT COUNT(*) / (SELECT COUNT(*) FROM testsinassessment WHERE testsinassessment.testID = (SELECT tests.testID FROM tests WHERE tests.Name LIKE "%GMFM%")) * 100 AS 'Percentage'
FROM testsinassessment
JOIN diagnosis ON
testsinassessment.patientID = diagnosis.patientID
WHERE testsinassessment.testID = (SELECT tests.testID FROM tests WHERE tests.Name LIKE "%GMFM%")
AND diagnosis.mainconditionID IN (SELECT mainconditions.conditionID FROM mainconditions WHERE mainconditions.Name LIKE "CP%")
"""
    cursor.execute(query)
    rows = cursor.fetchall()
    print("Total Row(s):", cursor.rowcount)
    for percent in rows:
        print percent 

def h():
    query = """
SELECT CONCAT_WS (' ',doctors.FirstName, doctors.LastName) AS 'Doctor Name', CONCAT_WS (' ',patients.FirstName, patients.LastName) as 'Patient Name'
FROM patientsupervisors
JOIN operations ON
patientsupervisors.consultantID = operations.surgeonID
JOIN doctors ON
operations.surgeonID = doctors.doctorID
JOIN patients ON
operations.patientID = patients.patientID
WHERE patientsupervisors.patientID = operations.patientID
"""
    cursor.execute(query)
    rows = cursor.fetchall()
    print("Total Row(s):", cursor.rowcount)
    for dname, pname in rows:
        print dname,pname

def i():
    query = """
SELECT patients.FirstName, patients.LastName, TIMESTAMPDIFF(YEAR, patients.DateOfBirth, CURDATE()) AS 'Age'
FROM patients
JOIN medication
ON patients.patientID = medication.patientID
JOIN medicine
ON medication.medicineID = medicine.medicineID
WHERE patients.DateOfBirth > DATE_SUB(CURDATE(), INTERVAL 10 YEAR)
AND medicine.TypeID = (SELECT medicinetype.medicineTypeID FROM medicinetype WHERE medicinetype.Type = 'Antiepileptic')
"""
    cursor.execute(query)
    rows = cursor.fetchall()
    print("Total Row(s):", cursor.rowcount)
    for fname, lname, age in rows:
        print fname, lname, age      
 
def choose():
    
    while (1): 
        choice = input("Enter your choice (1-9): ")

        options = {
                1 : a,
                2 : b,
                3 : c,
                4 : d,
                5 : e,
                6 : f,
                7 : g,
                8 : h,
                9 : i
                  }
        try:
            options[choice]()
        except KeyError as e1:
            print "Wrong code"

def finish():
    cursor.close()
    conn.close()

if __name__ == '__main__':
    choose()
    finish()
    
