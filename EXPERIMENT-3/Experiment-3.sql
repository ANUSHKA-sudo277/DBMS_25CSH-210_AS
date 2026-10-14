-- =====================================================
-- DBMS EXPERIMENT 3
-- EMPLOYEE - DEPARTMENT - PROJECT DATABASE
-- =====================================================

CREATE DATABASE IF NOT EXISTS DBMS_Lab;
USE DBMS_Lab;

-- 1. RESET TABLES IN THE CORRECT FOREIGN KEY ORDER

DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Project;
DROP TABLE IF EXISTS Department;

-- 2. CREATE DEPARTMENT TABLE

CREATE TABLE Department (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL,
    Location VARCHAR(50)
);

-- 3. CREATE PROJECT TABLE

CREATE TABLE Project (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100) NOT NULL,
    Budget DECIMAL(12,2) NOT NULL,
    DeptID INT NOT NULL,
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);

-- 4. CREATE EMPLOYEE TABLE

CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(100) NOT NULL,
    JobTitle VARCHAR(60),
    Salary DECIMAL(10,2) NOT NULL,
    HireDate DATE,
    DeptID INT NOT NULL,
    ProjectID INT,
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID),
    FOREIGN KEY (ProjectID) REFERENCES Project(ProjectID)
);

-- 5. INSERT DEPARTMENTS (5 RECORDS)

INSERT INTO Department VALUES
(1, 'IT', 'Delhi'),
(2, 'HR', 'Noida'),
(3, 'Finance', 'Gurugram'),
(4, 'Marketing', 'Mumbai'),
(5, 'Research', 'Bengaluru');

-- 6. INSERT PROJECTS (8 RECORDS)

INSERT INTO Project VALUES
(101, 'Website Development', 500000, 1),
(102, 'Cloud Migration', 800000, 1),
(103, 'Recruitment Portal', 250000, 2),
(104, 'Payroll Automation', 350000, 2),
(105, 'Financial Analytics', 600000, 3),
(106, 'Digital Campaign', 400000, 4),
(107, 'AI Research', 900000, 5),
(108, 'Data Analytics', 700000, 5);

-- 7. INSERT EMPLOYEES (30 RECORDS)

INSERT INTO Employee VALUES
(1, 'Aarav Sharma', 'Manager', 85000, '2022-01-10', 1, 101),
(2, 'Ananya Verma', 'Developer', 72000, '2022-03-15', 1, 101),
(3, 'Rohan Gupta', 'Developer', 68000, '2023-02-12', 1, 102),
(4, 'Priya Singh', 'Analyst', 75000, '2021-11-05', 1, 102),
(5, 'Karan Mehta', 'Tester', 55000, '2023-06-20', 1, 101),
(6, 'Isha Kapoor', 'Developer', 78000, '2022-08-17', 1, 102),
(7, 'Aditya Rao', 'Team Lead', 95000, '2020-04-10', 1, 101),
(8, 'Sneha Jain', 'HR Manager', 82000, '2021-07-12', 2, 103),
(9, 'Rahul Das', 'Recruiter', 48000, '2023-01-22', 2, 103),
(10, 'Meera Joshi', 'Recruiter', 52000, '2022-09-14', 2, 104),
(11, 'Vikram Yadav', 'HR Executive', 45000, '2023-04-18', 2, 104),
(12, 'Neha Mishra', 'HR Analyst', 60000, '2021-12-01', 2, 103),
(13, 'Arjun Malhotra', 'Accountant', 65000, '2022-05-11', 3, 105),
(14, 'Kavya Nair', 'Finance Manager', 92000, '2020-02-19', 3, 105),
(15, 'Dev Patel', 'Financial Analyst', 78000, '2021-06-25', 3, 105),
(16, 'Riya Saxena', 'Accountant', 58000, '2023-07-08', 3, 105),
(17, 'Manish Kumar', 'Auditor', 70000, '2022-10-16', 3, 105),
(18, 'Pooja Reddy', 'Marketing Manager', 88000, '2020-09-03', 4, 106),
(19, 'Aman Khanna', 'SEO Specialist', 62000, '2022-02-14', 4, 106),
(20, 'Simran Kaur', 'Content Writer', 50000, '2023-03-09', 4, 106),
(21, 'Yash Agarwal', 'Designer', 58000, '2022-11-21', 4, 106),
(22, 'Tanya Bose', 'Marketing Analyst', 67000, '2021-05-30', 4, 106),
(23, 'Siddharth Roy', 'Research Lead', 105000, '2019-08-15', 5, 107),
(24, 'Nisha Bhat', 'Data Scientist', 98000, '2020-10-07', 5, 107),
(25, 'Varun Sethi', 'ML Engineer', 92000, '2021-03-17', 5, 108),
(26, 'Aditi Chawla', 'Researcher', 76000, '2022-12-12', 5, 107),
(27, 'Mohit Arora', 'Data Analyst', 72000, '2023-05-19', 5, 108),
(28, 'Diya Menon', 'ML Engineer', 88000, '2021-09-28', 5, 108),
(29, 'Kabir Anand', 'Researcher', 69000, '2023-08-01', 5, 107),
(30, 'Sana Ali', 'Data Scientist', 95000, '2020-06-22', 5, 108);

-- =====================================================
-- 8. SELECTION
-- Display employees earning more than 70000
-- =====================================================

SELECT *
FROM Employee
WHERE Salary > 70000;

-- =====================================================
-- 9. PROJECTION
-- Display employee names and salaries
-- =====================================================

SELECT EmpName, Salary
FROM Employee;

-- =====================================================
-- 10. AGGREGATE FUNCTIONS
-- =====================================================

SELECT
    COUNT(*) AS TotalEmployees,
    SUM(Salary) AS TotalSalary,
    AVG(Salary) AS AverageSalary,
    MAX(Salary) AS HighestSalary,
    MIN(Salary) AS LowestSalary
FROM Employee;

-- =====================================================
-- 11. GROUP BY
-- Count employees in each department
-- =====================================================

SELECT
    D.DeptName,
    COUNT(E.EmpID) AS EmployeeCount
FROM Department D
LEFT JOIN Employee E ON D.DeptID = E.DeptID
GROUP BY D.DeptID, D.DeptName;

-- =====================================================
-- 12. DEPARTMENT-WISE AVERAGE SALARY
-- =====================================================

SELECT
    D.DeptName,
    AVG(E.Salary) AS AverageSalary
FROM Department D
JOIN Employee E ON D.DeptID = E.DeptID
GROUP BY D.DeptID, D.DeptName;

-- =====================================================
-- 13. HAVING
-- Departments with more than 5 employees
-- =====================================================

SELECT
    D.DeptName,
    COUNT(E.EmpID) AS EmployeeCount
FROM Department D
JOIN Employee E ON D.DeptID = E.DeptID
GROUP BY D.DeptID, D.DeptName
HAVING COUNT(E.EmpID) > 5;

-- =====================================================
-- 14. CASE EXPRESSION
-- Classify employees by salary
-- =====================================================

SELECT
    EmpName,
    Salary,
    CASE
        WHEN Salary >= 90000 THEN 'High Salary'
        WHEN Salary >= 60000 THEN 'Medium Salary'
        ELSE 'Low Salary'
    END AS SalaryCategory
FROM Employee;

-- =====================================================
-- 15. ORDER BY
-- Employees ranked by salary
-- =====================================================

SELECT EmpName, Salary
FROM Employee
ORDER BY Salary DESC;

-- =====================================================
-- 16. ORDER BY DEPARTMENT AND SALARY
-- =====================================================

SELECT
    D.DeptName,
    E.EmpName,
    E.Salary
FROM Employee E
JOIN Department D ON E.DeptID = D.DeptID
ORDER BY D.DeptName ASC, E.Salary DESC;

-- =====================================================
-- 17. INNER JOIN
-- Employees and their departments
-- =====================================================

SELECT
    E.EmpName,
    D.DeptName
FROM Employee E
INNER JOIN Department D ON E.DeptID = D.DeptID;

-- =====================================================
-- 18. THREE-TABLE JOIN
-- Employees, departments and projects
-- =====================================================

SELECT
    E.EmpName,
    D.DeptName,
    P.ProjectName
FROM Employee E
JOIN Department D ON E.DeptID = D.DeptID
LEFT JOIN Project P ON E.ProjectID = P.ProjectID;

-- =====================================================
-- 19. DEPARTMENT-WISE TOTAL SALARY
-- =====================================================

SELECT
    D.DeptName,
    SUM(E.Salary) AS TotalDepartmentSalary
FROM Department D
JOIN Employee E ON D.DeptID = E.DeptID
GROUP BY D.DeptID, D.DeptName;

-- =====================================================
-- 20. HAVING WITH AVERAGE SALARY
-- Departments with average salary above 65000
-- =====================================================

SELECT
    D.DeptName,
    AVG(E.Salary) AS AverageSalary
FROM Department D
JOIN Employee E ON D.DeptID = E.DeptID
GROUP BY D.DeptID, D.DeptName
HAVING AVG(E.Salary) > 65000;

-- =====================================================
-- 21. PROJECT-WISE EMPLOYEE COUNT
-- Include projects with zero employees
-- =====================================================

SELECT
    P.ProjectName,
    COUNT(E.EmpID) AS EmployeeCount
FROM Project P
LEFT JOIN Employee E ON P.ProjectID = E.ProjectID
GROUP BY P.ProjectID, P.ProjectName
ORDER BY EmployeeCount DESC;

-- =====================================================
-- 22. VERIFY RECORD COUNTS
-- =====================================================

SELECT 'Department' AS TableName, COUNT(*) AS TotalRecords
FROM Department
UNION ALL
SELECT 'Project', COUNT(*) FROM Project
UNION ALL
SELECT 'Employee', COUNT(*) FROM Employee;