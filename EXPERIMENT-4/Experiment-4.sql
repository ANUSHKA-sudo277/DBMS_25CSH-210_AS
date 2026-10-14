-- ============================================
-- EMPLOYEE - DEPARTMENT - PROJECT
-- EXPERIMENT 4: ADVANCED SQL QUERIES
-- ============================================

USE dbms_lab;

-- Remove existing tables if they exist

DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Project;
DROP TABLE IF EXISTS Department;


-- 1. CREATE DEPARTMENT TABLE

CREATE TABLE Department (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50),
    Location VARCHAR(50)
);


-- 2. CREATE PROJECT TABLE

CREATE TABLE Project (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100),
    Budget DECIMAL(12,2),
    DeptID INT,
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);


-- 3. CREATE EMPLOYEE TABLE

CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    JobTitle VARCHAR(50),
    Salary DECIMAL(10,2),
    HireDate DATE,
    DeptID INT,
    ProjectID INT,
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID),
    FOREIGN KEY (ProjectID) REFERENCES Project(ProjectID)
);


-- 4. INSERT DEPARTMENT DATA

INSERT INTO Department VALUES
(1, 'IT', 'Delhi'),
(2, 'HR', 'Mumbai'),
(3, 'Finance', 'Bangalore'),
(4, 'Marketing', 'Pune'),
(5, 'Operations', 'Hyderabad');


-- 5. INSERT PROJECT DATA

INSERT INTO Project VALUES
(101, 'Cloud Migration', 1500000, 1),
(102, 'AI Analytics', 2000000, 1),
(103, 'Employee Portal', 800000, 2),
(104, 'Financial Audit', 1200000, 3),
(105, 'Market Research', 900000, 4),
(106, 'Digital Campaign', 1100000, 4),
(107, 'Supply Chain', 1800000, 5),
(108, 'Process Automation', 1300000, 5);


-- 6. INSERT EMPLOYEE DATA

INSERT INTO Employee VALUES
(1, 'Aarav Sharma', 'Software Engineer', 75000, '2021-01-15', 1, 101),
(2, 'Ananya Singh', 'Data Analyst', 68000, '2022-03-20', 1, 102),
(3, 'Rohan Verma', 'Cloud Engineer', 85000, '2020-07-10', 1, 101),
(4, 'Priya Gupta', 'AI Engineer', 92000, '2019-11-05', 1, 102),
(5, 'Karan Mehta', 'Software Engineer', 78000, '2021-09-12', 1, 102),
(6, 'Neha Kapoor', 'System Analyst', 72000, '2022-01-18', 1, 101),
(7, 'Rahul Joshi', 'HR Manager', 70000, '2018-05-10', 2, 103),
(8, 'Sneha Agarwal', 'HR Executive', 52000, '2021-06-15', 2, 103),
(9, 'Vikas Malhotra', 'Recruiter', 48000, '2022-08-20', 2, 103),
(10, 'Ishita Jain', 'HR Executive', 55000, '2020-12-01', 2, 103),
(11, 'Aditya Rao', 'Training Manager', 65000, '2019-04-25', 2, 103),
(12, 'Simran Kaur', 'HR Executive', 51000, '2023-02-10', 2, 103),
(13, 'Arjun Patel', 'Financial Analyst', 72000, '2020-01-15', 3, 104),
(14, 'Meera Shah', 'Accountant', 58000, '2021-03-18', 3, 104),
(15, 'Nikhil Bansal', 'Finance Manager', 90000, '2018-09-10', 3, 104),
(16, 'Pooja Nair', 'Accountant', 60000, '2022-05-22', 3, 104),
(17, 'Varun Sethi', 'Financial Analyst', 68000, '2021-11-11', 3, 104),
(18, 'Riya Das', 'Auditor', 75000, '2019-07-07', 3, 104),
(19, 'Sakshi Mishra', 'Marketing Manager', 82000, '2018-02-12', 4, 105),
(20, 'Yash Thakur', 'Marketing Executive', 55000, '2021-04-17', 4, 105),
(21, 'Tanya Roy', 'Content Strategist', 62000, '2022-06-19', 4, 106),
(22, 'Mohit Arora', 'SEO Specialist', 58000, '2021-10-09', 4, 106),
(23, 'Kriti Sinha', 'Marketing Executive', 53000, '2023-01-05', 4, 106),
(24, 'Dev Khanna', 'Brand Manager', 76000, '2019-08-15', 4, 105),
(25, 'Amit Yadav', 'Operations Manager', 80000, '2018-06-20', 5, 107),
(26, 'Nisha Verma', 'Operations Analyst', 60000, '2021-02-14', 5, 107),
(27, 'Harsh Vardhan', 'Process Engineer', 70000, '2020-10-18', 5, 108),
(28, 'Divya Menon', 'Operations Analyst', 62000, '2022-04-12', 5, 108),
(29, 'Manish Kumar', 'Supply Chain Manager', 85000, '2019-05-25', 5, 107),
(30, 'Aditi Bose', 'Process Analyst', 59000, '2023-03-08', 5, 108);


-- 7. INNER JOIN

SELECT
    E.EmpID,
    E.EmpName,
    D.DeptName
FROM Employee E
INNER JOIN Department D
    ON E.DeptID = D.DeptID;


-- 8. LEFT JOIN

SELECT
    D.DeptID,
    D.DeptName,
    E.EmpName
FROM Department D
LEFT JOIN Employee E
    ON D.DeptID = E.DeptID;


-- 9. SELF JOIN
-- Employees working in the same department

SELECT
    E1.EmpName AS Employee1,
    E2.EmpName AS Employee2,
    E1.DeptID
FROM Employee E1
INNER JOIN Employee E2
    ON E1.DeptID = E2.DeptID
    AND E1.EmpID < E2.EmpID;


-- 10. THREE-WAY JOIN

SELECT
    E.EmpName,
    D.DeptName,
    P.ProjectName
FROM Employee E
INNER JOIN Department D
    ON E.DeptID = D.DeptID
INNER JOIN Project P
    ON E.ProjectID = P.ProjectID;


-- 11. CORRELATED SUBQUERY
-- Employees earning more than their department average

SELECT
    E.EmpID,
    E.EmpName,
    E.Salary,
    E.DeptID
FROM Employee E
WHERE E.Salary > (
    SELECT AVG(E2.Salary)
    FROM Employee E2
    WHERE E2.DeptID = E.DeptID
);


-- 12. EXISTS
-- Employees whose department has a project

SELECT
    E.EmpID,
    E.EmpName,
    E.DeptID
FROM Employee E
WHERE EXISTS (
    SELECT 1
    FROM Project P
    WHERE P.DeptID = E.DeptID
);


-- 13. SIMULATED INTERSECT
-- Departments having both employees and projects

SELECT DISTINCT E.DeptID
FROM Employee E
WHERE EXISTS (
    SELECT 1
    FROM Project P
    WHERE P.DeptID = E.DeptID
);


-- 14. SIMULATED EXCEPT
-- Departments having employees but no projects

SELECT DISTINCT E.DeptID
FROM Employee E
WHERE NOT EXISTS (
    SELECT 1
    FROM Project P
    WHERE P.DeptID = E.DeptID
);


-- 15. EXPLAIN: INNER JOIN

EXPLAIN
SELECT
    E.EmpName,
    D.DeptName
FROM Employee E
INNER JOIN Department D
    ON E.DeptID = D.DeptID;


-- 16. EXPLAIN: LEFT JOIN

EXPLAIN
SELECT
    D.DeptName,
    E.EmpName
FROM Department D
LEFT JOIN Employee E
    ON D.DeptID = E.DeptID;


-- 17. EXPLAIN: CORRELATED SUBQUERY

EXPLAIN
SELECT
    E.EmpName,
    E.Salary
FROM Employee E
WHERE E.Salary > (
    SELECT AVG(E2.Salary)
    FROM Employee E2
    WHERE E2.DeptID = E.DeptID
);


-- 18. EXPLAIN: EXISTS

EXPLAIN
SELECT
    E.EmpName,
    E.DeptID
FROM Employee E
WHERE EXISTS (
    SELECT 1
    FROM Project P
    WHERE P.DeptID = E.DeptID
);