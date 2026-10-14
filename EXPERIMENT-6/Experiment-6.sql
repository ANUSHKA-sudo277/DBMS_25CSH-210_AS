-- ============================================
-- EXPERIMENT 6: STORED PROCEDURE AND TRIGGERS
-- ============================================

USE dbms_lab;

-- 1. REMOVE PREVIOUS OBJECTS

DROP TRIGGER IF EXISTS validate_salary_insert;
DROP TRIGGER IF EXISTS validate_salary_update;
DROP TRIGGER IF EXISTS salary_audit_trigger;

DROP PROCEDURE IF EXISTS transfer_employee;

DROP TABLE IF EXISTS SalaryAudit;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Project;
DROP TABLE IF EXISTS Department;


-- 2. CREATE DEPARTMENT TABLE

CREATE TABLE Department (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL,
    Location VARCHAR(50)
);


-- 3. CREATE EMPLOYEE TABLE

CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50) NOT NULL,
    JobTitle VARCHAR(50),
    Salary DECIMAL(10,2),
    HireDate DATE,
    DeptID INT,
    ManagerID INT NULL,

    FOREIGN KEY (DeptID)
        REFERENCES Department(DeptID),

    FOREIGN KEY (ManagerID)
        REFERENCES Employee(EmpID)
);


-- 4. INSERT DEPARTMENTS

INSERT INTO Department VALUES
(1, 'IT', 'Delhi'),
(2, 'HR', 'Mumbai'),
(3, 'Finance', 'Bangalore'),
(4, 'Marketing', 'Pune'),
(5, 'Operations', 'Hyderabad');


-- 5. INSERT EMPLOYEES
-- Managers are inserted before their subordinates.

INSERT INTO Employee VALUES
(1, 'Aarav Sharma', 'CEO', 100000, '2018-01-10', 1, NULL);

INSERT INTO Employee VALUES
(3, 'Rohan Verma', 'IT Manager', 85000, '2020-07-10', 1, 1),
(7, 'Rahul Joshi', 'HR Manager', 70000, '2018-05-10', 2, 1),
(15, 'Nikhil Bansal', 'Finance Manager', 90000, '2018-09-10', 3, 1),
(19, 'Sakshi Mishra', 'Marketing Manager', 82000, '2018-02-12', 4, 1),
(25, 'Amit Yadav', 'Operations Manager', 80000, '2018-06-20', 5, 1);

INSERT INTO Employee VALUES
(2, 'Ananya Singh', 'Data Analyst', 68000, '2022-03-20', 1, 3),
(4, 'Priya Gupta', 'AI Engineer', 92000, '2019-11-05', 1, 3),
(5, 'Karan Mehta', 'Software Engineer', 78000, '2021-09-12', 1, 3),
(6, 'Neha Kapoor', 'System Analyst', 72000, '2022-01-18', 1, 3);

INSERT INTO Employee VALUES
(8, 'Sneha Agarwal', 'HR Executive', 52000, '2021-06-15', 2, 7),
(9, 'Vikas Malhotra', 'Recruiter', 48000, '2022-08-20', 2, 7),
(10, 'Ishita Jain', 'HR Executive', 55000, '2020-12-01', 2, 7),
(11, 'Aditya Rao', 'Training Manager', 65000, '2019-04-25', 2, 7),
(12, 'Simran Kaur', 'HR Executive', 51000, '2023-02-10', 2, 7);

INSERT INTO Employee VALUES
(13, 'Arjun Patel', 'Financial Analyst', 72000, '2020-01-15', 3, 15),
(14, 'Meera Shah', 'Accountant', 58000, '2021-03-18', 3, 15),
(16, 'Pooja Nair', 'Accountant', 60000, '2022-05-22', 3, 15),
(17, 'Varun Sethi', 'Financial Analyst', 68000, '2021-11-11', 3, 15),
(18, 'Riya Das', 'Auditor', 75000, '2019-07-07', 3, 15);

INSERT INTO Employee VALUES
(20, 'Yash Thakur', 'Marketing Executive', 55000, '2021-04-17', 4, 19),
(21, 'Tanya Roy', 'Content Strategist', 62000, '2022-06-19', 4, 19),
(22, 'Mohit Arora', 'SEO Specialist', 58000, '2021-10-09', 4, 19),
(23, 'Kriti Sinha', 'Marketing Executive', 53000, '2023-01-05', 4, 19),
(24, 'Dev Khanna', 'Brand Manager', 76000, '2019-08-15', 4, 19);

INSERT INTO Employee VALUES
(26, 'Nisha Verma', 'Operations Analyst', 60000, '2021-02-14', 5, 25),
(27, 'Harsh Vardhan', 'Process Engineer', 70000, '2020-10-18', 5, 25),
(28, 'Divya Menon', 'Operations Analyst', 62000, '2022-04-12', 5, 25),
(29, 'Manish Kumar', 'Supply Chain Manager', 85000, '2019-05-25', 5, 25),
(30, 'Aditi Bose', 'Process Analyst', 59000, '2023-03-08', 5, 25);


-- 6. CREATE SALARY AUDIT TABLE

CREATE TABLE SalaryAudit (
    AuditID INT AUTO_INCREMENT PRIMARY KEY,
    EmpID INT NOT NULL,
    OldSalary DECIMAL(10,2),
    NewSalary DECIMAL(10,2),
    ActionType VARCHAR(30),
    ChangedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- 7. SALARY VALIDATION TRIGGER FOR INSERT

DELIMITER //

CREATE TRIGGER validate_salary_insert
BEFORE INSERT ON Employee
FOR EACH ROW
BEGIN
    IF NEW.Salary IS NULL OR NEW.Salary <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Salary must be greater than zero';
    END IF;
END//

DELIMITER ;


-- 8. SALARY VALIDATION TRIGGER FOR UPDATE

DELIMITER //

CREATE TRIGGER validate_salary_update
BEFORE UPDATE ON Employee
FOR EACH ROW
BEGIN
    IF NEW.Salary IS NULL OR NEW.Salary <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Salary must be greater than zero';
    END IF;
END//

DELIMITER ;


-- 9. SALARY AUDIT TRIGGER

DELIMITER //

CREATE TRIGGER salary_audit_trigger
AFTER UPDATE ON Employee
FOR EACH ROW
BEGIN
    IF NOT (OLD.Salary <=> NEW.Salary) THEN
        INSERT INTO SalaryAudit (
            EmpID,
            OldSalary,
            NewSalary,
            ActionType
        )
        VALUES (
            NEW.EmpID,
            OLD.Salary,
            NEW.Salary,
            'SALARY UPDATE'
        );
    END IF;
END//

DELIMITER ;


-- 10. STORED PROCEDURE: TRANSFER EMPLOYEE

DELIMITER //

CREATE PROCEDURE transfer_employee(
    IN p_emp_id INT,
    IN p_new_dept_id INT
)
BEGIN
    DECLARE v_current_dept INT;
    DECLARE v_employee_exists INT DEFAULT 0;
    DECLARE v_department_exists INT DEFAULT 0;

    -- Error handler

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- Validate employee ID

    IF p_emp_id IS NULL OR p_emp_id <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid employee ID';
    END IF;

    -- Validate department ID

    IF p_new_dept_id IS NULL OR p_new_dept_id <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid department ID';
    END IF;

    -- Check employee existence

    SELECT COUNT(*)
    INTO v_employee_exists
    FROM Employee
    WHERE EmpID = p_emp_id;

    IF v_employee_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Employee does not exist';
    END IF;

    -- Check department existence

    SELECT COUNT(*)
    INTO v_department_exists
    FROM Department
    WHERE DeptID = p_new_dept_id;

    IF v_department_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Department does not exist';
    END IF;

    -- Get employee's current department

    SELECT DeptID
    INTO v_current_dept
    FROM Employee
    WHERE EmpID = p_emp_id;

    -- Check whether employee is already in that department

    IF v_current_dept = p_new_dept_id THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Employee is already in this department';
    END IF;

    -- Start transaction

    START TRANSACTION;

    -- Transfer employee

    UPDATE Employee
    SET DeptID = p_new_dept_id
    WHERE EmpID = p_emp_id;

    -- Commit transaction

    COMMIT;
END//

DELIMITER ;


-- 11. DISPLAY EMPLOYEE BEFORE TRANSFER

SELECT
    EmpID,
    EmpName,
    DeptID
FROM Employee
WHERE EmpID = 2;


-- 12. VALID TRANSFER TEST
-- Employee 2: IT to HR

CALL transfer_employee(2, 2);


-- 13. VERIFY TRANSFER

SELECT
    EmpID,
    EmpName,
    DeptID
FROM Employee
WHERE EmpID = 2;


-- 14. TEST SALARY AUDIT

UPDATE Employee
SET Salary = 70000
WHERE EmpID = 2;

SELECT
    AuditID,
    EmpID,
    OldSalary,
    NewSalary,
    ActionType,
    ChangedAt
FROM SalaryAudit
ORDER BY AuditID;


-- RESTORE ORIGINAL SALARY

UPDATE Employee
SET Salary = 68000
WHERE EmpID = 2;


-- 15. TEST VALID SALARY INSERT

INSERT INTO Employee (
    EmpID,
    EmpName,
    JobTitle,
    Salary,
    HireDate,
    DeptID,
    ManagerID
)
VALUES (
    31,
    'Test Employee',
    'Tester',
    50000,
    '2026-01-01',
    2,
    7
);

SELECT *
FROM Employee
WHERE EmpID = 31;

-- Remove test employee

DELETE FROM Employee
WHERE EmpID = 31;


-- 16. FINAL EMPLOYEE DATA

SELECT
    EmpID,
    EmpName,
    JobTitle,
    Salary,
    DeptID
FROM Employee
ORDER BY EmpID;


-- 17. FINAL AUDIT LOG

SELECT
    AuditID,
    EmpID,
    OldSalary,
    NewSalary,
    ActionType,
    ChangedAt
FROM SalaryAudit
ORDER BY AuditID;


-- 18. EDGE-CASE TESTS
-- Uncomment and execute ONE AT A TIME.

-- Invalid employee:
-- CALL transfer_employee(999, 2);

-- Invalid department:
-- CALL transfer_employee(2, 999);

-- Employee already in the same department:
-- CALL transfer_employee(2, 2);

-- NULL employee ID:
-- CALL transfer_employee(NULL, 2);

-- NULL department ID:
-- CALL transfer_employee(2, NULL);

-- Negative salary:
-- UPDATE Employee
-- SET Salary = -5000
-- WHERE EmpID = 2;

-- Zero salary:
-- UPDATE Employee
-- SET Salary = 0
-- WHERE EmpID = 2;

-- NULL salary:
-- UPDATE Employee
-- SET Salary = NULL
-- WHERE EmpID = 2;