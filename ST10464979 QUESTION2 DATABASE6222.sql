
-- ==========================================
-- QUESTION 2: EQUIPMENT DATABASE
-- ==========================================

-- CREATE DATABASE
IF DB_ID('ST10464979_DATA6222_ExamQ2') IS NULL
BEGIN
    CREATE DATABASE ST10464979_DATA6222_ExamQ2;
END;
GO

USE ST10464979_DATA6222_ExamQ2;
GO


-- ==========================================
-- RESET TABLES
-- ==========================================

-- Remove existing tables before recreating them
IF OBJECT_ID('AVAILABILITY', 'U') IS NOT NULL
    DROP TABLE AVAILABILITY;

IF OBJECT_ID('EQUIPMENT', 'U') IS NOT NULL
    DROP TABLE EQUIPMENT;

IF OBJECT_ID('WAREHOUSE', 'U') IS NOT NULL
    DROP TABLE WAREHOUSE;
GO


-- ==========================================
-- Q.2.1 CREATE EQUIPMENT TABLE
-- ==========================================

CREATE TABLE EQUIPMENT (
    EquipmentID VARCHAR(5) NOT NULL,
    EquipmentName VARCHAR(40) NOT NULL,

    CONSTRAINT PK_EQUIPMENT
        PRIMARY KEY (EquipmentID)
);
GO


-- ==========================================
-- Q.2.1 CREATE WAREHOUSE TABLE
-- ==========================================

CREATE TABLE WAREHOUSE (
    WarehouseID VARCHAR(5) NOT NULL,
    WarehouseName VARCHAR(20) NOT NULL,
    Address VARCHAR(40) NOT NULL,

    CONSTRAINT PK_WAREHOUSE
        PRIMARY KEY (WarehouseID)
);
GO


-- ==========================================
-- Q.2.1 CREATE AVAILABILITY TABLE
-- ==========================================

CREATE TABLE AVAILABILITY (
    EquipmentID VARCHAR(5) NOT NULL,
    WarehouseID VARCHAR(5) NOT NULL,
    Quantity SMALLINT NOT NULL,

    CONSTRAINT PK_AVAILABILITY
        PRIMARY KEY (EquipmentID, WarehouseID),

    CONSTRAINT FK_AVAILABILITY_EQUIPMENT
        FOREIGN KEY (EquipmentID)
        REFERENCES EQUIPMENT(EquipmentID),

    CONSTRAINT FK_AVAILABILITY_WAREHOUSE
        FOREIGN KEY (WarehouseID)
        REFERENCES WAREHOUSE(WarehouseID)
);
GO


-- ==========================================
-- Q.2.2 INSERT EQUIPMENT DATA
-- ==========================================

INSERT INTO EQUIPMENT
(EquipmentID, EquipmentName)
VALUES
('E001', 'Football nets'),
('E002', 'Training cones'),
('E003', 'Cricket bats'),
('E004', 'Tennis rackets'),
('E005', 'Gym mats');
GO


-- ==========================================
-- Q.2.2 INSERT WAREHOUSE DATA
-- ==========================================

INSERT INTO WAREHOUSE
(WarehouseID, WarehouseName, Address)
VALUES
('W001', 'Central Sports Depot', '15 Loop Street, Cape Town'),
('W002', 'Northern Supplies', '88 Church Street, Polokwane'),
('W003', 'Coastal Storage', '44 Marine Road, Durban'),
('W004', 'Inland Hub', '9 Park Avenue, Bloemfontein'),
('W005', 'Eastern Depot', '61 Oxford Street, East London');
GO


-- ==========================================
-- Q.2.2 INSERT AVAILABILITY DATA
-- ==========================================

INSERT INTO AVAILABILITY
(EquipmentID, WarehouseID, Quantity)
VALUES
('E001', 'W001', 20),
('E002', 'W002', 12),
('E003', 'W003', 7),
('E004', 'W003', 9),
('E005', 'W005', 14);
GO


-- ==========================================
-- Q.2.3 ALTER AVAILABILITY TABLE
-- ADD STOCK_ORDERED
-- ==========================================

ALTER TABLE AVAILABILITY
ADD STOCK_ORDERED SMALLINT;
GO


-- ==========================================
-- Q.2.4 UPDATE STOCK_ORDERED
-- ==========================================

UPDATE AVAILABILITY
SET STOCK_ORDERED = 3
WHERE EquipmentID = 'E004'
AND WarehouseID = 'W003';
GO

-- Verify update
SELECT * FROM AVAILABILITY;
GO


-- ==========================================
-- Q.2.5 EQUIPMENT NOT AVAILABLE
-- IN ANY WAREHOUSE
-- ==========================================

SELECT
    EquipmentName
FROM EQUIPMENT
WHERE NOT EXISTS (
    SELECT 1
    FROM AVAILABILITY
    WHERE AVAILABILITY.EquipmentID =
          EQUIPMENT.EquipmentID
);
GO


-- ==========================================
-- Q.2.6 TOTAL AVAILABLE STOCK
-- ==========================================

SELECT
    EQUIPMENT.EquipmentName,
    ISNULL(SUM(AVAILABILITY.Quantity), 0)
        AS TotalAvailableStock
FROM EQUIPMENT
LEFT JOIN AVAILABILITY
    ON EQUIPMENT.EquipmentID =
       AVAILABILITY.EquipmentID
GROUP BY
    EQUIPMENT.EquipmentID,
    EQUIPMENT.EquipmentName
ORDER BY
    EQUIPMENT.EquipmentName ASC;
GO


-- ==========================================
-- Q.2.7 WAREHOUSE WITH MOST E002 STOCK
-- ==========================================

SELECT TOP 1
    WAREHOUSE.WarehouseName,
    WAREHOUSE.Address,
    EQUIPMENT.EquipmentName,
    AVAILABILITY.Quantity
FROM AVAILABILITY
INNER JOIN WAREHOUSE
    ON AVAILABILITY.WarehouseID =
       WAREHOUSE.WarehouseID
INNER JOIN EQUIPMENT
    ON AVAILABILITY.EquipmentID =
       EQUIPMENT.EquipmentID
WHERE AVAILABILITY.EquipmentID = 'E002'
ORDER BY
    AVAILABILITY.Quantity DESC;
GO


-- ==========================================
-- FINAL VERIFICATION
-- ==========================================

SELECT * FROM EQUIPMENT;

SELECT * FROM WAREHOUSE;

SELECT * FROM AVAILABILITY;
GO
