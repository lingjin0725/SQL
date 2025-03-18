-- SQL Script for Payroll & Salary Management System
DROP TABLE IF EXISTS Employees CASCADE;
DROP TABLE IF EXISTS Payroll CASCADE;

-- Creating Employee Table
CREATE TABLE Employees (
    EmployeeID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    Position VARCHAR(50),
    Salary DECIMAL(10,2),
    TaxRate DECIMAL(5,2),
    Benefits DECIMAL(10,2),
    HireDate DATE
);

-- Creating Payroll Table
CREATE TABLE Payroll (
    PayrollID SERIAL PRIMARY KEY,
    EmployeeID INT REFERENCES Employees(EmployeeID),
    PayPeriod DATE,
    BaseSalary DECIMAL(10,2),
    TaxDeduction DECIMAL(10,2),
    BenefitsDeduction DECIMAL(10,2),
    NetSalary DECIMAL(10,2)
);

-- Insert Sample Employees
INSERT INTO Employees (FirstName, LastName, Department, Position, Salary, TaxRate, Benefits, HireDate) VALUES
('John', 'Doe', 'Finance', 'Accountant', 70000, 0.22, 5000, '2020-05-15'),
('Jane', 'Smith', 'IT', 'Developer', 85000, 0.25, 6000, '2019-08-22'),
('Alice', 'Brown', 'HR', 'HR Manager', 65000, 0.20, 4500, '2021-04-10'),
('Bob', 'Johnson', 'Marketing', 'Marketing Lead', 72000, 0.18, 4800, '2018-11-05'),
('Charlie', 'Davis', 'Sales', 'Sales Manager', 75000, 0.21, 5100, '2017-09-23'),
('David', 'Wilson', 'Operations', 'Operations Manager', 78000, 0.23, 5200, '2016-06-12'),
('Ella', 'Miller', 'Finance', 'Financial Analyst', 69000, 0.22, 4900, '2022-01-15'),
('Frank', 'Taylor', 'IT', 'System Administrator', 83000, 0.24, 5800, '2019-07-18'),
('Grace', 'Anderson', 'HR', 'Recruiter', 62000, 0.19, 4400, '2020-10-30'),
('Hank', 'Martinez', 'Marketing', 'Brand Manager', 77000, 0.22, 5300, '2015-08-25');

-- Calculate Payroll for Employees
INSERT INTO Payroll (EmployeeID, PayPeriod, BaseSalary, TaxDeduction, BenefitsDeduction, NetSalary)
SELECT EmployeeID, '2024-01-01', Salary / 12, (Salary * TaxRate) / 12, Benefits / 12, 
       (Salary / 12) - ((Salary * TaxRate) / 12) - (Benefits / 12)
FROM Employees;

-- Query to Retrieve Payroll Report
SELECT e.FirstName, e.LastName, p.PayPeriod, p.BaseSalary, p.TaxDeduction, p.BenefitsDeduction, p.NetSalary
FROM Payroll p
JOIN Employees e ON p.EmployeeID = e.EmployeeID
ORDER BY p.PayPeriod DESC;
