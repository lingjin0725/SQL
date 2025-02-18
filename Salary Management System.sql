-- Salary Management System (PostgreSQL)

-- Drop existing tables if they exist (for fresh setup)
DROP TABLE IF EXISTS deductions, bonuses, salaries, employees, departments CASCADE;

-- Department Table
CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL UNIQUE
);

-- Employee Table
CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    emp_email VARCHAR(150) UNIQUE NOT NULL,
    hire_date DATE NOT NULL DEFAULT CURRENT_DATE,
    dept_id INT NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE CASCADE
);

-- Salary Table
CREATE TABLE salaries (
    salary_id SERIAL PRIMARY KEY,
    emp_id INT NOT NULL,
    base_salary DECIMAL(10,2) NOT NULL CHECK (base_salary >= 0),
    pay_date DATE NOT NULL DEFAULT CURRENT_DATE,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id) ON DELETE CASCADE
);

-- Bonuses Table
CREATE TABLE bonuses (
    bonus_id SERIAL PRIMARY KEY,
    emp_id INT NOT NULL,
    bonus_amount DECIMAL(10,2) NOT NULL CHECK (bonus_amount >= 0),
    bonus_date DATE NOT NULL DEFAULT CURRENT_DATE,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id) ON DELETE CASCADE
);

-- Deductions Table
CREATE TABLE deductions (
    deduction_id SERIAL PRIMARY KEY,
    emp_id INT NOT NULL,
    deduction_amount DECIMAL(10,2) NOT NULL CHECK (deduction_amount >= 0),
    deduction_date DATE NOT NULL DEFAULT CURRENT_DATE,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id) ON DELETE CASCADE
);

-- Insert Sample Data
INSERT INTO departments (dept_name) VALUES ('HR'), ('IT'), ('Finance');

INSERT INTO employees (emp_name, emp_email, hire_date, dept_id) VALUES
('Alice Johnson', 'alice@example.com', '2022-01-15', 1),
('Bob Smith', 'bob@example.com', '2021-06-20', 2),
('Charlie Brown', 'charlie@example.com', '2023-03-10', 3);

INSERT INTO salaries (emp_id, base_salary, pay_date) VALUES
(1, 5000.00, '2024-02-01'),
(2, 7000.00, '2024-02-01'),
(3, 6000.00, '2024-02-01');

INSERT INTO bonuses (emp_id, bonus_amount, bonus_date) VALUES
(1, 500.00, '2024-02-05'),
(2, 1000.00, '2024-02-05');

INSERT INTO deductions (emp_id, deduction_amount, deduction_date) VALUES
(1, 200.00, '2024-02-10'),
(3, 300.00, '2024-02-10');

-- Query to Calculate Net Salary for Each Employee
SELECT e.emp_name, s.base_salary, COALESCE(SUM(b.bonus_amount), 0) AS total_bonus,
       COALESCE(SUM(d.deduction_amount), 0) AS total_deductions,
       (s.base_salary + COALESCE(SUM(b.bonus_amount), 0) - COALESCE(SUM(d.deduction_amount), 0)) AS net_salary
FROM employees e
JOIN salaries s ON e.emp_id = s.emp_id
LEFT JOIN bonuses b ON e.emp_id = b.emp_id
LEFT JOIN deductions d ON e.emp_id = d.emp_id
GROUP BY e.emp_name, s.base_salary;
