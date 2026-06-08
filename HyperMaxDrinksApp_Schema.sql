-- ============================================================
--  HyperMaxDrinksApp  –  SQL Server (SSMS) Setup Script
--  Run this ONCE in SSMS to create the database and all tables.
-- ============================================================

-- 1. Create the database (skip if it already exists)

    CREATE DATABASE HyperMaxDrinksDB;
END
GO

USE HyperMaxDrinksDB;
GO

-- ── Suppliers ────────────────────────────────────────────────
CREATE TABLE Suppliers (
    SupplierID   INT           IDENTITY(1,1) PRIMARY KEY,
    Name         NVARCHAR(100) NOT NULL,
    Phone        NVARCHAR(20)  NOT NULL,
    Address      NVARCHAR(200) NOT NULL,
    Email        NVARCHAR(100) NOT NULL
);

-- ── Drinks ───────────────────────────────────────────────────
CREATE TABLE Drinks (
    DrinkID     INT            IDENTITY(1,1) PRIMARY KEY,
    Name        NVARCHAR(100)  NOT NULL,
    ExpiryDate  DATETIME       NOT NULL,
    SupplierID  INT            NOT NULL REFERENCES Suppliers(SupplierID),
    Price       DECIMAL(10,2)  NOT NULL,
    Category    NVARCHAR(50)   NOT NULL,   -- Fizzy | Juice | Water | Energy
    Size        NVARCHAR(20)   NOT NULL    -- 250ml | 500ml | 1L | 2L
);

-- ── Inventory ────────────────────────────────────────────────
CREATE TABLE Inventory (
    DrinkID       INT      PRIMARY KEY REFERENCES Drinks(DrinkID),
    StockQuantity INT      NOT NULL DEFAULT 0,
    LastUpdate    DATETIME NOT NULL DEFAULT GETDATE()
);

-- ── Orders ───────────────────────────────────────────────────
CREATE TABLE Orders (
    OrderID    INT           IDENTITY(1,1) PRIMARY KEY,
    OrderDate  DATETIME      NOT NULL DEFAULT GETDATE(),
    SupplierID INT           NOT NULL REFERENCES Suppliers(SupplierID),
    TotalPrice DECIMAL(10,2) NOT NULL DEFAULT 0,
    Status     NVARCHAR(20)  NOT NULL DEFAULT 'Pending'  -- Pending | Delivered | Cancelled
);

-- ── OrderDetails ─────────────────────────────────────────────
CREATE TABLE OrderDetails (
    OrderID  INT           NOT NULL REFERENCES Orders(OrderID)  ON DELETE CASCADE,
    DrinkID  INT           NOT NULL REFERENCES Drinks(DrinkID),
    Quantity INT           NOT NULL,
    Price    DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (OrderID, DrinkID)
);

-- ── Users ────────────────────────────────────────────────────
CREATE TABLE Users (
    UserID   INT           IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50)  NOT NULL UNIQUE,
    Password NVARCHAR(100) NOT NULL,
    Role     NVARCHAR(20)  NOT NULL   -- Admin | Manager | Staff
);

-- ── Seed Data ─────────────────────────────────────────────────

INSERT INTO Users   (Username, Password, Role) VALUES
    ('admin',   'admin123',   'Admin'),
    ('manager', 'manager123', 'Manager'),
    ('staff',   'staff123',   'Staff');

INSERT INTO Suppliers (Name, Phone, Address, Email) VALUES
    ('Coca-Cola Distributors', '0791234567', '123 Amman Street',  'orders@cocacola.jo'),
    ('PepsiCo Jordan',         '0797654321', '456 Irbid Road',    'supply@pepsi.jo'),
    ('Fresh Juice Co.',        '0799876543', '789 Zarqa Avenue',  'info@freshjuice.jo');

INSERT INTO Drinks (Name, ExpiryDate, SupplierID, Price, Category, Size) VALUES
    ('Coca-Cola Classic', DATEADD(MONTH,  6, GETDATE()), 1, 1.50, 'Fizzy',  '500ml'),
    ('Pepsi Max',         DATEADD(MONTH,  8, GETDATE()), 2, 1.50, 'Fizzy',  '500ml'),
    ('Orange Fresh',      DATEADD(MONTH,  3, GETDATE()), 3, 2.00, 'Juice',  '1L'),
    ('Red Bull Energy',   DATEADD(MONTH, 12, GETDATE()), 1, 3.50, 'Energy', '250ml'),
    ('Aqua Pure',         DATEADD(YEAR,   1, GETDATE()), 2, 0.75, 'Water',  '500ml');

INSERT INTO Inventory (DrinkID, StockQuantity, LastUpdate) VALUES
    (1,  50, GETDATE()),
    (2,  35, GETDATE()),
    (3,   8, GETDATE()),
    (4,   5, GETDATE()),
    (5, 100, GETDATE());

INSERT INTO Orders (OrderDate, SupplierID, TotalPrice, Status) VALUES
    (DATEADD(DAY, -5, GETDATE()), 1, 45.00, 'Delivered'),
    (DATEADD(DAY, -2, GETDATE()), 2, 30.00, 'Pending'),
    (DATEADD(DAY, -1, GETDATE()), 3, 16.00, 'Pending');

INSERT INTO OrderDetails (OrderID, DrinkID, Quantity, Price) VALUES
    (1, 1, 20, 1.50),
    (1, 4, 10, 1.50),
    (2, 2, 20, 1.50),
    (3, 3,  8, 2.00);
GO
PRINT 'HyperMaxDrinksDB created and seeded successfully.';
select * from Drinks;

select * from Inventory;
 
 select * from OrderDetails;

 select * from Orders ;

 SELECT * from Suppliers ;

 select * from Users ;

 --crud 
 --SELECT — Retrieve all drinks with supplier info:
SELECT d.DrinkID, d.Name, d.Category, d.Size,
       d.Price, d.ExpiryDate, s.Name AS SupplierName
FROM   Drinks d
JOIN   Suppliers s ON d.SupplierID = s.SupplierID
ORDER  BY d.Category, d.Name;


--INSERT — Add a new drink:
INSERT INTO Drinks (Name, ExpiryDate, SupplierID, Price, Category, Size)
VALUES ('Sprite Zero', DATEADD(MONTH, 9, GETDATE()), 1, 1.25, 'Fizzy', '500ml');


--UPDATE — Adjust stock quantity:
UPDATE Inventory
SET    StockQuantity = StockQuantity - 1,
       LastUpdate    = GETDATE()
WHERE  DrinkID = 1;  -- After a sale of Coca-Cola Classic


--DELETE — Remove a drink (with integrity check):

-- FK constraint prevents deletion if drink exists in OrderDetails
DELETE FROM Drinks WHERE DrinkID = 3;

-- Error raised if referenced: FK constraint violation


-- Create logins
CREATE LOGIN Staff   WITH PASSWORD = 'Staff';
CREATE LOGIN Manager WITH PASSWORD = 'Mgr!';

-- Create users in HyperMaxDrinksDB
USE HyperMaxDrinksDB;
CREATE USER Staff  FOR LOGIN Staff;
CREATE USER Manager FOR LOGIN Manager;

-- Staff role: can read/write drinks, inventory and orders only
CREATE ROLE StaffRole;
GRANT SELECT, INSERT, UPDATE ON Drinks       TO StaffRole;
GRANT SELECT, INSERT, UPDATE ON Inventory    TO StaffRole;
GRANT SELECT, INSERT, UPDATE ON Orders       TO StaffRole;
GRANT SELECT, INSERT, UPDATE ON OrderDetails TO StaffRole;
GRANT SELECT                 ON Suppliers    TO StaffRole;
GRANT SELECT                 ON Users        TO StaffRole;
ALTER ROLE StaffRole ADD MEMBER Staff;

-- Manager role: full access including DELETE on all tables
CREATE ROLE ManagerRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Drinks       TO ManagerRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Inventory    TO ManagerRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Orders       TO ManagerRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON OrderDetails TO ManagerRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Suppliers    TO ManagerRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Users        TO ManagerRole;
ALTER ROLE ManagerRole ADD MEMBER Manager;


-- 1. Verify the logins were created
SELECT name FROM sys.server_principals WHERE name IN ('Staff', 'Manager');

-- 2. Verify the database users were created
USE HyperMaxDrinksDB;
SELECT name FROM sys.database_principals WHERE name IN ('Staff', 'Manager');

-- 3. Verify the roles and their members
SELECT 
    r.name AS RoleName,
    m.name AS MemberName
FROM sys.database_role_members rm
JOIN sys.database_principals r ON rm.role_principal_id = r.principal_id
JOIN sys.database_principals m ON rm.member_principal_id = m.principal_id
WHERE r.name IN ('StaffRole', 'ManagerRole');

-- 4. Verify the permissions granted
SELECT 
    dp.name AS Grantee,
    o.name AS ObjectName,
    p.permission_name AS Permission
FROM sys.database_permissions p
JOIN sys.database_principals dp ON p.grantee_principal_id = dp.principal_id
JOIN sys.objects o ON p.major_id = o.object_id
WHERE dp.name IN ('StaffRole', 'ManagerRole');