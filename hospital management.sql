create database hospital_management;
use hospital_management;
# patients
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    name VARCHAR(50),
    age INT,
    gender VARCHAR(10),
    phone VARCHAR(15),
    city VARCHAR(50)
);

INSERT INTO Patients VALUES
(1, 'Rahul', 22, 'Male', '9876543210', 'Bangalore'),
(2, 'Anita', 25, 'Female', '9123456780', 'Bangalore'),
(3, 'Kiran', 30, 'Male', '9012345678', 'Mysore'),
(4, 'Sneha', 28, 'Female', '9988776655', 'Bangalore'),
(5, 'Arjun', 35, 'Male', '8899001122', 'Tumkur');

select* from Patients;

#doctors
CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY,
    name VARCHAR(50),
    specialization VARCHAR(50),
    experience INT,
    availability VARCHAR(50)
);

INSERT INTO Doctors VALUES
(101, 'Dr. Sharma', 'Cardiologist', 10, 'Morning'),
(102, 'Dr. Rao', 'Dermatologist', 8, 'Evening'),
(103, 'Dr. Mehta', 'General Physician', 12, 'Morning'),
(104, 'Dr. Khan', 'Orthopedic', 9, 'Evening');
select * from Doctors;

# appointments
CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE,
    time_slot VARCHAR(20),
    status VARCHAR(20),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);
INSERT INTO Appointments VALUES
(1, 1, 101, '2026-03-01', '10AM', 'Completed'),
(2, 2, 102, '2026-03-01', '11AM', 'Completed'),
(3, 1, 103, '2026-03-02', '9AM', 'Completed'),
(4, 3, 101, '2026-03-02', '10AM', 'Completed'),
(5, 4, 104, '2026-03-03', '12PM', 'Cancelled'),
(6, 1, 101, '2026-03-03', '11AM', 'Completed'),
(7, 2, 103, '2026-03-04', '10AM', 'Completed'),
(8, 5, 104, '2026-03-04', '2PM', 'Completed'),
(9, 1, 101, '2026-03-05', '9AM', 'Completed'),
(10, 3, 102, '2026-03-05', '3PM', 'Cancelled'),
(11, 2, 101, '2026-03-06', '11AM', 'Completed'),
(12, 4, 103, '2026-03-06', '10AM', 'Completed'),
(13, 1, 101, '2026-03-07', '12PM', 'Completed'),
(14, 5, 103, '2026-03-07', '9AM', 'Completed'),
(15, 2, 101, '2026-03-08', '10AM', 'Completed');

select * from Appointments;


# TOKEN / QUEUE SYSTEM
CREATE TABLE Tokens (
    token_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    token_number INT,
    status VARCHAR(20),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);
select*from Tokens;


#BILLING
CREATE TABLE Billing (
    bill_id INT PRIMARY KEY,
    patient_id INT,
    appointment_id INT,
    amount DECIMAL(10,2),
    payment_status VARCHAR(20),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);

INSERT INTO Billing VALUES
(1, 1, 1, 500, 'Paid'),
(2, 2, 2, 300, 'Paid'),
(3, 1, 3, 400, 'Paid'),
(4, 3, 4, 600, 'Paid'),
(5, 4, 5, 200, 'Pending'),
(6, 1, 6, 500, 'Paid'),
(7, 2, 7, 350, 'Paid'),
(8, 5, 8, 700, 'Paid'),
(9, 1, 9, 500, 'Paid'),
(10, 3, 10, 300, 'Pending'),
(11, 2, 11, 450, 'Paid'),
(12, 4, 12, 400, 'Paid'),
(13, 1, 13, 500, 'Paid'),
(14, 5, 14, 600, 'Paid'),
(15, 2, 15, 550, 'Paid');
select * from Billing;

#PRESCRIPTIONS
CREATE TABLE Prescriptions (
    prescription_id INT PRIMARY KEY,
    appointment_id INT,
    medicine VARCHAR(100),
    dosage VARCHAR(50),
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);
select * from Prescriptions;

# most demanded doctor
SELECT d.name, COUNT(*) AS total_visits
FROM Doctors d
JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.name
ORDER BY total_visits DESC;

#most regular patients
SELECT p.name, COUNT(*) AS visits
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
GROUP BY p.name
ORDER BY visits DESC;

#Total Revenue
SELECT SUM(amount) AS total_revenue
FROM Billing
WHERE payment_status = 'Paid';

# canceled appointments
SELECT COUNT(*) AS cancelled
FROM Appointments
WHERE status = 'Cancelled';

# pending payments
SELECT COUNT(*) AS pending_bills
FROM Billing
WHERE payment_status = 'Pending';

#daily patient load
SELECT appointment_date, COUNT(*) AS total_patients
FROM Appointments
GROUP BY appointment_date;

#Department-wise Load
SELECT d.specialization, COUNT(*) AS total_cases
FROM Doctors d
JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.specialization;

#OVERLOADED DOCTORS
SELECT d.name, COUNT(*) AS total_appointments
FROM Doctors d
JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.name
HAVING COUNT(*) > 4;

#EFFICIENCY SCORE
SELECT d.name,
COUNT(CASE WHEN a.status = 'Completed' THEN 1 END) * 100.0 / COUNT(*) AS efficiency
FROM Doctors d
JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.name;

#APPOINTMENT TIME SLOT ANALYSIS
SELECT time_slot, COUNT(*) AS total
FROM Appointments
GROUP BY time_slot
ORDER BY total DESC;

#PEAK APPOINTMENT DAY
SELECT appointment_date, COUNT(*) AS total
FROM Appointments
GROUP BY appointment_date
ORDER BY total DESC;

#Doctor Work Summary
CREATE VIEW Doctor_Summary AS
SELECT d.name, COUNT(a.appointment_id) AS total_patients
FROM Doctors d
JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.name;
SELECT * FROM Doctor_Summary;

#Daily Hospital Report
CREATE VIEW Daily_Report AS
SELECT appointment_date, COUNT(*) AS total_patients
FROM Appointments
GROUP BY appointment_date;
select * from Daily_Report;

