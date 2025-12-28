
CREATE DATABASE IF NOT EXISTS patient_satisfaction;
USE patient_satisfaction;

CREATE TABLE stg_doctors (
    doctor_id INT,
    doctor_name VARCHAR(100)
);

CREATE TABLE stg_patients (
    patient_id INT,
    name VARCHAR(100),
    age_group VARCHAR(50),
    medical_condition VARCHAR(255)
);

CREATE TABLE stg_hours (
    hour_id INT,
    appointment_hour TIME
);

CREATE TABLE stg_appointments (
    appointment_id INT,
    appointment_date DATE,
    appointment_day VARCHAR(20),
    appointment_time TIME,
    hour_id INT
);

CREATE TABLE stg_visits (
    appointment_id INT,
    doctor_id INT,
    patient_id INT,
    hour_id INT,
    waiting_time INT,
    appointment_duration INT,
    satisfaction_rate DECIMAL(3,2),
    complaint TINYINT(1)
);


CREATE TABLE dim_doctors (
    doctor_id INT PRIMARY KEY,
    doctor_name VARCHAR(100)
);

CREATE TABLE dim_patient (
    patient_id INT PRIMARY KEY,
    name VARCHAR(100),
    age_group VARCHAR(50),
    medical_condition VARCHAR(255)
);

CREATE TABLE dim_hour (
    hour_id INT PRIMARY KEY,
    appointment_hour TIME
);

CREATE TABLE dim_appointment (
    appointment_id INT PRIMARY KEY,
    appointment_date DATE,
    appointment_day VARCHAR(20),
    appointment_time TIME,
    hour_id INT,
    FOREIGN KEY (hour_id) REFERENCES dim_hour(hour_id)
);



CREATE TABLE fact_visit (
    visit_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT,
    doctor_id INT,
    patient_id INT,
    hour_id INT,
    waiting_time INT,
    appointment_duration INT,
    satisfaction_rate DECIMAL(3,2),
    complaint TINYINT(1),
    FOREIGN KEY (appointment_id) REFERENCES dim_appointment(appointment_id) ,
    FOREIGN KEY (doctor_id) REFERENCES dim_doctors(doctor_id),
    FOREIGN KEY (patient_id) REFERENCES dim_patient(patient_id),
    FOREIGN KEY (hour_id) REFERENCES dim_hour(hour_id)
);



INSERT INTO dim_doctors
SELECT DISTINCT doctor_id, doctor_name
FROM stg_doctors;

INSERT INTO dim_patient
SELECT DISTINCT patient_id, name, age_group, medical_condition
FROM stg_patients;

INSERT INTO dim_hour
SELECT DISTINCT hour_id, appointment_hour
FROM stg_hours;

INSERT INTO dim_appointment
SELECT DISTINCT appointment_id, appointment_date, appointment_day, appointment_time, hour_id
FROM stg_appointments;


INSERT INTO fact_visit (
    appointment_id,
    doctor_id,
    patient_id,
    hour_id,
    waiting_time,
    appointment_duration,
    satisfaction_rate,
    complaint
)
SELECT
    appointment_id,
    doctor_id,
    patient_id,
    hour_id,
    waiting_time,
    appointment_duration,
    satisfaction_rate,
    complaint
FROM stg_visits;
