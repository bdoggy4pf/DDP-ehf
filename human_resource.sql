-- human_resource.sql

-- 2.1 Búa til gagnagrunn
CREATE DATABASE IF NOT EXISTS human_resource;
USE human_resource;

-- 2.2 Tafla: Staðsetningar
CREATE TABLE IF NOT EXISTS Locations (
  location_id INT PRIMARY KEY,
  city VARCHAR(100),
  address VARCHAR(200),
  zip_code VARCHAR(20)
);

-- 2.3 Tafla: Deildir
CREATE TABLE IF NOT EXISTS Departments (
  department_id INT PRIMARY KEY,
  department_name VARCHAR(100),
  location_id INT NOT NULL,
  manager_kennitala CHAR(10),
  FOREIGN KEY (location_id) REFERENCES Locations(location_id)
);

-- 2.4 Tafla: Störf
CREATE TABLE IF NOT EXISTS Jobs (
  job_id INT PRIMARY KEY,
  job_title VARCHAR(100),
  min_salary DECIMAL(10,2),
  max_salary DECIMAL(10,2)
);

-- 2.5 Tafla: Starfsmenn
CREATE TABLE IF NOT EXISTS Employees (
  kennitala CHAR(10) PRIMARY KEY,
  firstname VARCHAR(50),
  lastname VARCHAR(50),
  email VARCHAR(100),
  phone VARCHAR(20),
  hire_date DATE,
  salary DECIMAL(10,2),
  department_id INT NOT NULL,
  job_id INT NOT NULL,
  FOREIGN KEY (department_id) REFERENCES Departments(department_id),
  FOREIGN KEY (job_id) REFERENCES Jobs(job_id)
);
