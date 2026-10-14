-- ============================================
-- EXPERIMENT 5: SQL VIEWS AND RECURSIVE CTE
-- ============================================

USE dbms_lab;

-- 1. REMOVE OLD VIEWS

DROP VIEW IF EXISTS DepartmentSalarySummary;
DROP VIEW IF EXISTS EmployeeHierarchy;
DROP VIEW IF EXISTS EmployeeSalaryView;

-- 2. REMOVE OLD TABLES IN CORRECT ORDER

DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Project;
DROP TABLE IF EXISTS Department;

-- 3. CREATE DEPARTMENT TABLE

CREATE TABLE Department (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50),
    Location VARCHAR(50)
);

-- 4. CREATE EMPLOYEE TABLE

CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    JobTitle VARCHAR(50),
    Salary DECIMAL(10,2),
    HireDate DATE,
    DeptID INT,
    ManagerID INT,
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID),
    FOREIGN KEY (ManagerID) REFERENCES Employee(EmpID)
);

-- 5. INSERT DEPARTMENT DATA

INSERT INTO Department VALUES
(1, 'IT', 'Delhi'),
(2, 'HR', 'Mumbai'),
(3, 'Finance', 'Bangalore'),
(4, 'Marketing', 'Pune'),
(5, 'Operations', 'Hyderabad');

-- 6. INSERT TOP-LEVEL EMPLOYEE

INSERT INTO Employee VALUES
(1, 'Aarav Sharma', 'CEO', 100000, '2018-01-10', 1, NULL);

-- 7. INSERT MANAGERS

INSERT INTO Employee VALUES
(3, 'Rohan Verma', 'IT Manager', 85000, '2020-07-10', 1, 1),
(7, 'Rahul Joshi', 'HR Manager', 70000, '2018-05-10', 2, 1),
(15, 'Nikhil Bansal', 'Finance Manager', 90000, '2018-09-10', 3, 1),
(19, 'Sakshi Mishra', 'Marketing Manager', 82000, '2018-02-12', 4, 1),
(25, 'Amit Yadav', 'Operations Manager', 80000, '2018-06-20', 5, 1);

-- 8. INSERT IT EMPLOYEES

INSERT INTO Employee VALUES
(2, 'Ananya Singh', 'Data Analyst', 68000, '2022-03-20', 1, 3),
(4, 'Priya Gupta', 'AI Engineer', 92000, '2019-11-05', 1, 3),
(5, 'Karan Mehta', 'Software Engineer', 78000, '2021-09-12', 1, 3),
(6, 'Neha Kapoor', 'System Analyst', 72000, '2022-01-18', 1, 3);

-- 9. INSERT HR EMPLOYEES

INSERT INTO Employee VALUES
(8, 'Sneha Agarwal', 'HR Executive', 52000, '2021-06-15', 2, 7),
(9, 'Vikas Malhotra', 'Recruiter', 48000, '2022-08-20', 2, 7),
(10, 'Ishita Jain', 'HR Executive', 55000, '2020-12-01', 2, 7),
(11, 'Aditya Rao', 'Training Manager', 65000, '2019-04-25', 2, 7),
(12, 'Simran Kaur', 'HR Executive', 51000, '2023-02-10', 2, 7);

-- 10. INSERT FINANCE EMPLOYEES

INSERT INTO Employee VALUES
(13, 'Arjun Patel', 'Financial Analyst', 72000, '2020-01-15', 3, 15),
(14, 'Meera Shah', 'Accountant', 58000, '2021-03-18', 3, 15),
(16, 'Pooja Nair', 'Accountant', 60000, '2022-05-22', 3, 15),
(17, 'Varun Sethi', 'Financial Analyst', 68000, '2021-11-11', 3, 15),
(18, 'Riya Das', 'Auditor', 75000, '2019-07-07', 3, 15);

-- 11. INSERT MARKETING EMPLOYEES

INSERT INTO Employee VALUES
(20, 'Yash Thakur', 'Marketing Executive', 55000, '2021-04-17', 4, 19),
(21, 'Tanya Roy', 'Content Strategist', 62000, '2022-06-19', 4, 19),
(22, 'Mohit Arora', 'SEO Specialist', 58000, '2021-10-09', 4, 19),
(23, 'Kriti Sinha', 'Marketing Executive', 53000, '2023-01-05', 4, 19),
(24, 'Dev Khanna', 'Brand Manager', 76000, '2019-08-15', 4, 19);

-- 12. INSERT OPERATIONS EMPLOYEES

INSERT INTO Employee VALUES
(26, 'Nisha Verma', 'Operations Analyst', 60000, '2021-02-14', 5, 25),
(27, 'Harsh Vardhan', 'Process Engineer', 70000, '2020-10-18', 5, 25),
(28, 'Divya Menon', 'Operations Analyst', 62000, '2022-04-12', 5, 25),
(29, 'Manish Kumar', 'Supply Chain Manager', 85000, '2019-05-25', 5, 25),
(30, 'Aditi Bose', 'Process Analyst', 59000, '2023-03-08', 5, 25);

-- 13. VERIFY EMPLOYEE DATA

SELECT *
FROM Employee
ORDER BY EmpID;

-- 14. DEPARTMENT SALARY SUMMARY VIEW

CREATE VIEW DepartmentSalarySummary AS
SELECT
    D.DeptID,
    D.DeptName,
    COUNT(E.EmpID) AS EmployeeCount,
    SUM(E.Salary) AS TotalSalary,
    AVG(E.Salary) AS AverageSalary,
    MAX(E.Salary) AS MaximumSalary,
    MIN(E.Salary) AS MinimumSalary
FROM Department D
INNER JOIN Employee E
    ON D.DeptID = E.DeptID
GROUP BY D.DeptID, D.DeptName;

SELECT *
FROM DepartmentSalarySummary;

-- 15. EMPLOYEE HIERARCHY VIEW

CREATE VIEW EmployeeHierarchy AS
SELECT
    E.EmpID,
    E.EmpName AS EmployeeName,
    E.JobTitle,
    E.Salary,
    E.ManagerID,
    M.EmpName AS ManagerName,
    E.DeptID
FROM Employee E
LEFT JOIN Employee M
    ON E.ManagerID = M.EmpID;

SELECT *
FROM EmployeeHierarchy;

-- 16. CREATE SIMPLE UPDATABLE VIEW

CREATE VIEW EmployeeSalaryView AS
SELECT
    EmpID,
    EmpName,
    Salary
FROM Employee;

SELECT *
FROM EmployeeSalaryView;

-- 17. TEST VIEW UPDATABILITY

UPDATE EmployeeSalaryView
SET Salary = 76000
WHERE EmpID = 2;

SELECT *
FROM EmployeeSalaryView
WHERE EmpID = 2;

-- RESTORE ORIGINAL SALARY

UPDATE EmployeeSalaryView
SET Salary = 68000
WHERE EmpID = 2;

SELECT *
FROM EmployeeSalaryView
WHERE EmpID = 2;

-- 18. CHECK VIEW UPDATABILITY

SELECT
    TABLE_NAME,
    IS_UPDATABLE
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME IN (
        'DepartmentSalarySummary',
        'EmployeeHierarchy',
        'EmployeeSalaryView'
    );

-- 19. RECURSIVE CTE: REPORTING CHAIN

WITH RECURSIVE ReportingChain AS (
    SELECT
        E.EmpID,
        E.EmpName,
        E.ManagerID,
        E.DeptID,
        0 AS Level,
        CAST(E.EmpName AS CHAR(2000)) AS ReportingChain
    FROM Employee E
    WHERE E.ManagerID IS NULL

    UNION ALL

    SELECT
        E.EmpID,
        E.EmpName,
        E.ManagerID,
        E.DeptID,
        RC.Level + 1,
        CONCAT(RC.ReportingChain, ' -> ', E.EmpName)
    FROM Employee E
    INNER JOIN ReportingChain RC
        ON E.ManagerID = RC.EmpID
)
SELECT
    EmpID,
    EmpName,
    ManagerID,
    DeptID,
    Level,
    ReportingChain
FROM ReportingChain
ORDER BY ReportingChain;

-- 20. RECURSIVE CTE WITH MANAGER NAME

WITH RECURSIVE ReportingHierarchy AS (
    SELECT
        E.EmpID,
        E.EmpName,
        E.ManagerID,
        0 AS Level
    FROM Employee E
    WHERE E.ManagerID IS NULL

    UNION ALL

    SELECT
        E.EmpID,
        E.EmpName,
        E.ManagerID,
        RH.Level + 1
    FROM Employee E
    INNER JOIN ReportingHierarchy RH
        ON E.ManagerID = RH.EmpID
)
SELECT
    E.EmpID,
    E.EmpName,
    M.EmpName AS ManagerName,
    RH.Level
FROM ReportingHierarchy RH
INNER JOIN Employee E
    ON RH.EmpID = E.EmpID
LEFT JOIN Employee M
    ON E.ManagerID = M.EmpID
ORDER BY RH.Level, E.EmpID;