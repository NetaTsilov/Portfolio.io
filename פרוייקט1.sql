--this class diagram represents a complex model for a Psychology Center
--that allows for relationships between appointments, patients, and invoices to be tracked and managed.

--Payment Table
CREATE TABLE Payment
(
	specialty VARCHAR(20)
		CONSTRAINT Payment_specialty_pk PRIMARY KEY,
	paymentPerH MONEY
)

--Patient Table
CREATE TABLE  Patient 
(
	patientId INT 
		CONSTRAINT Patient_patientId_pk PRIMARY KEY,
	name VARCHAR(50),
	birthDate DATE,
	gender VARCHAR(6),
	phone VARCHAR(20)
		CONSTRAINT Patient_phone_nn NOT NULL
		CONSTRAINT Patient_phone_uk UNIQUE (phone),
	email VARCHAR(30)
		CONSTRAINT Patient_email_nn NOT NULL
		CONSTRAINT Patient_email_uk UNIQUE (email),
	address VARCHAR(50),
	emergencyContactName VARCHAR(50)
		CONSTRAINT Patient_emergencyContactN_nn NOT NULL,
	emergencyContactPhone VARCHAR(20)
		CONSTRAINT Patient_emergencyContactP_nn NOT NULL
		
)

--Therapist Table
CREATE TABLE  Therapist
(
	therapistId INT 
		CONSTRAINT Therapist_therapistId_pk PRIMARY KEY,
	name VARCHAR(50)
		CONSTRAINT Therapist_name_nn NOT NULL,
	birthDate DATE,
	gender VARCHAR(6),
	phone VARCHAR(20)
		CONSTRAINT Therapist_phone_nn NOT NULL
		CONSTRAINT Therapist_phone_uk UNIQUE (phone),
	email VARCHAR(30)
		CONSTRAINT Therapist_email_nn NOT NULL
		CONSTRAINT Therapist_email_uk UNIQUE (email),
	address VARCHAR(50),
	specialty VARCHAR(20)
		CONSTRAINT Therapist_specialty_fk FOREIGN KEY REFERENCES Payment(specialty),
	hiredate DATE DEFAULT GETDATE()
	
		
)
--Appointments Table
CREATE TABLE Appointments
(
	appointmentId INT 
		CONSTRAINT Appointments_appointmentId_pk PRIMARY KEY,
	date DATE DEFAULT GETDATE(),
	time time,
	therapistId INT
		CONSTRAINT Appointments_therapistId_fk FOREIGN KEY REFERENCES Therapist(therapistId),
	patientId INT
		CONSTRAINT Appointments_patientId_fk FOREIGN KEY REFERENCES Patient(patientId)
)

--Invoice table
CREATE TABLE Invoice
(
	InvoiceId INT
		CONSTRAINT Invoice_InvoiceId_pk PRIMARY KEY,
	date DATE ,
	amount MONEY,
	patientId INT
		CONSTRAINT Invoice_patientId_fk FOREIGN KEY REFERENCES Patient(patientId)
)

--Appointments Details Table
 CREATE TABLE AppointmentsDetails
(
	appointmentId INT
		CONSTRAINT AppointmentsDetails_appointmentId_pk PRIMARY KEY
		CONSTRAINT AppointmentsDetails_appointmentId_fk FOREIGN KEY REFERENCES Appointments(appointmentId),
	description VARCHAR(255),
	diagnosis VARCHAR(60)
)


--Insert data into Payment table 
INSERT INTO Payment VALUES
	('Psychology',200),
	('Psychiatry',250),
	('Counseling',150),
	('Psychotherapy',300)


--Insert data into therapist
INSERT INTO Therapist VALUES
	(1, 'John Smith', '1985-06-21', 'Male', '555-1234', 'john.s@psychcenter.com', '123 Main St, New York, NY', 'Psychology', '2010-05-01'),
	(2, 'Sarah Johnson', '1978-12-15', 'Female', '555-5678', 'sarah.j@psychcenter.com', '456 Broadway, New York, NY', 'Psychiatry', '2008-03-01'),
	(3, 'Michael Williams', '1982-04-09', 'Male', '555-9012', 'michael.w@psychcenter.com', '789 5th Ave, New York, NY', 'Counseling', '2015-09-01'),
	(4, 'Jessica Brown', '1976-09-02', 'Female', '555-3456', 'jessica.b@psychcenter.com', '321 Elm St, New York, NY', 'Psychotherapy', '2012-01-01'),
	(5, 'James Lee', '1990-11-19', 'Male', '555-6789', 'james.l@psychcenter.com', '456 Main St, San Francisco, CA', 'Psychology','2022-11-01'),
	(6, 'Emily Davis', '1987-02-28', 'Female', '555-2345', 'emily.d@psychcenter.com', '789 Broadway, San Francisco, CA', 'Counseling', '2017-07-01'),
	(7, 'William Johnson', '1995-08-12', 'Male', '555-7890', 'william.j@psychcenter.com', '123 4th St, San Francisco, CA', 'Psychiatry', '2021-02-01'),
	(8, 'Samantha Jones', '1980-05-06', 'Female', '555-4567', 'samantha.j@psychcenter.com', '567 Market St, San Francisco, CA', 'Psychotherapy', '2018-06-01'),
	(9, 'Robert Hernandez', '1973-10-24', 'Male', '555-1233', 'robert.h@psychcenter.com', '789 Oak St, Los Angeles, CA', 'Psychology', '2014-09-01'),
	(10, 'Ashley Smith', '1989-03-17', 'Female', '555-5677', 'ashley.s@psychcenter.com', '456 Main St, Los Angeles, CA', 'Counseling', '2019-04-01')


--Insert data into Patient
INSERT INTO Patient VALUES
  (1, 'Jessica Allen', '1990-05-23', 'Female', '555-1234', 'jessica.allen@gmail.com', '123 Main St, Los Angeles, CA', 'Brian Allen', '555-5733'),
  (2, 'Melanie Brown', '1985-12-11', 'Female', '555-5777', 'melanie.brown@gmail.com', '456 Broadway, New York, NY', 'David Brown', '555-9012'),
  (3, 'Nicholas Carter', '1981-07-01', 'Male', '555-9012', 'nicholas.carter@yahoo.com', '789 5th Ave, New York, NY', 'Rachel Carter', '555-2345'),
  (4, 'Katherine Davis', '1993-02-19', 'Female', '555-2345', 'katherine.davis@yahoo.com', '456 Elm St, San Francisco, CA', 'Michael Davis', '555-6789'),
  (5, 'William Edwards', '1978-11-30', 'Male', '555-6789', 'william.edwards@gmail.com', '321 Oak St, Boston, MA', 'Hannah Edwards', '555-3456'),
  (6, 'Sophia Franklin', '1990-04-18', 'Female', '555-3456', 'sophia.franklin@yahoo.com', '567 Pine St, Seattle, WA', 'John Franklin', '555-7890'),
  (7, 'Daniel Garcia', '1982-09-09', 'Male', '555-7890', 'daniel.garcia@gmail.com', '890 Maple Ave, Chicago, IL', 'Ava Garcia', '555-4567'),
  (8, 'Olivia Hernandez', '1998-12-25', 'Female', '555-4567', 'olivia.hernandez@yahoo.com', '432 Cedar St, Miami, FL', 'Matthew Hernandez', '555-8901'),
  (9, 'Ethan Johnson', '1975-02-13', 'Male', '555-8901', 'ethan.johnson@yahoo.com', '654 Elm St, Dallas, TX', 'Isabella Johnson', '555-2345'),
  (10, 'Abigail Martin', '1989-08-20', 'Female', '555-5111', 'abigail.martin@gmail.com', '987 Oak St, Philadelphia, PA', 'Jacob Martin', '555-9012')

 --Insert data into Appointments
INSERT INTO Appointments  VALUES
	(1, '2023-04-05', '10:00:00', 1, 1),
	(2, '2023-04-06', '11:00:00', 2, 2),
	(3, '2023-04-07', '12:00:00', 3, 3),
	(4, '2023-04-08', '13:00:00', 4, 4),
	(5, '2023-04-09', '14:00:00', 5, 5),
	(6, '2023-04-10', '15:00:00', 6, 6),
	(7, '2023-04-11', '16:00:00', 7, 7),
	(8, '2023-04-12', '17:00:00', 8, 8),
	(9, '2023-04-13', '18:00:00', 1, 9),
	(10, '2023-04-14', '19:00:00', 3, 10),
	(11, '2023-04-15', '10:30:00', 1, 1),
	(12, '2023-04-16', '11:30:00', 2, 2),
	(13, '2023-04-17', '12:30:00', 3, 3),
	(14, '2023-04-18', '13:30:00', 5, 5),
	(15, '2023-04-19', '14:30:00', 4, 4),
	(16, '2023-04-20', '15:30:00', 3,10),
	(17, '2023-04-21', '16:30:00', 1,9),
	(18, '2023-04-22', '17:30:00', 8, 8),
	(19, '2023-04-23', '18:30:00', 2, 2),
	(20, '2023-04-24', '19:30:00', 3, 3)

--Insert data into AppointmentsDetails
INSERT INTO AppointmentsDetails (appointmentId, description, diagnosis)
VALUES
    (1, 'Initial consultation for anxiety disorder', 'Generalized anxiety disorder'),
    (2, 'Follow-up appointment for depression', 'Major depressive disorder'),
    (3, 'Couple therapy session for communication issues', NULL),
    (4, 'Individual therapy session for trauma', 'Post-traumatic stress disorder'),
    (5, 'Cognitive behavioral therapy session for phobia', 'Specific phobia'),
    (6, 'Grief counseling session for recent loss', NULL),
    (7, 'Psychiatric evaluation for medication management', NULL),
    (8, 'Psychoanalytic therapy session for personality disorder', 'Borderline personality disorder'),
    (9, 'Counseling session for work-related stress', NULL),
    (10, 'Family therapy session for parent-child conflict', NULL),
    (11, 'Follow-up appointment for anxiety', 'Generalized anxiety disorder'),
    (12, 'Follow-up appointment for depression', 'Major depressive disorder'),
    (13, 'Couple therapy session for conflict resolution', NULL),
    (14, 'Exposure therapy session for phobia', 'Specific phobia'),
    (15, 'Individual therapy session for relationship issues', NULL),
    (16, 'Counseling session for grief and loss', NULL),
    (17, 'Follow-up appointment for work-related stress', NULL),
    (18, 'Psychoanalytic therapy session for personality disorder', 'Borderline personality disorder'),
    (19, 'Counseling session for anxiety and depression', 'Generalized anxiety disorder, Major depressive disorder'),
    (20, 'Counseling session for family conflict', NULL);

--Insert data into Invoice
INSERT INTO Invoice (InvoiceId, date, amount, patientId)
SELECT A.appointmentId, A.Date, P.paymentPerH, A.PatientId
FROM Appointments A
JOIN Therapist T ON A.TherapistId = T.TherapistId
JOIN Payment P ON T.specialty = P.specialty;


