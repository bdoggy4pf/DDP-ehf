-- human_resource.sql

-- 3.1 Búa til gagnagrunn
CREATE DATABASE IF NOT EXISTS human_resource;
USE human_resource;

-- 3.2 Tafla: Staðsetningar
CREATE TABLE IF NOT EXISTS Locations (
  location_id INT PRIMARY KEY,
  city VARCHAR(100) NOT NULL,
  address VARCHAR(200) NOT NULL,
  zip_code VARCHAR(20) NOT NULL
);

-- 3.3 Tafla: Deildir
CREATE TABLE IF NOT EXISTS Departments (
  department_id INT PRIMARY KEY,
  department_name VARCHAR(100) NOT NULL,
  location_id INT NOT NULL,
  manager_id INT NOT NULL,
  FOREIGN KEY (location_id) REFERENCES Locations(location_id),
  FOREIGN KEY (manager_id) REFERENCES Employees(employee_id)
);

-- 3.4 Tafla: Störf
CREATE TABLE IF NOT EXISTS Jobs (
  job_id INT PRIMARY KEY,
  job_title VARCHAR(100) NOT NULL,
  min_salary DECIMAL(10,2) NOT NULL,
  max_salary DECIMAL(10,2) NOT NULL
);

-- 3.5 Tafla: Starfsmenn
CREATE TABLE IF NOT EXISTS Employees (
  employee_id INT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  username VARCHAR(50) NOT NULL UNIQUE,
  email VARCHAR(100) NOT NULL UNIQUE,
  phone VARCHAR(20),
  hire_date DATE NOT NULL,
  salary DECIMAL(10,2) NOT NULL,
  department_id INT NOT NULL,
  job_id INT NOT NULL,
  FOREIGN KEY (department_id) REFERENCES Departments(department_id),
  FOREIGN KEY (job_id) REFERENCES Jobs(job_id)
);
