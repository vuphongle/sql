use AdventureWorks2008R2

--bài 1
CREATE TABLE NHANVIEN(
	MANV NVARCHAR(50),
	TENNV NVARCHAR(30)
)

INSERT NHANVIEN VALUES ('NV001', 'PHONG')
INSERT NHANVIEN VALUES ('NV002', 'PHONG')
INSERT NHANVIEN VALUES ('NV003', 'PHONG')

SELECT * FROM NHANVIEN

CREATE TRIGGER KTMNV
ON NHANVIEN
INSTEAD OF INSERT
AS
	BEGIN
		IF EXISTS (SELECT * FROM inserted WHERE MANV IN (SELECT MANV FROM NHANVIEN))
			BEGIN
				PRINT N'MA NHAN VIEN DA TON TAI'
				ROLLBACK TRAN
			END 
		ELSE
			INSERT NHANVIEN SELECT * FROM inserted
	END

INSERT NHANVIEN VALUES ('002', 'DUNG')

SELECT *FROM NHANVIEN

--Bài 2:
CREATE TABLE NHANVIEN_TK
(
	MANV NVARCHAR(30),
	MATK NVARCHAR(30),
	SODU MONEY
)

INSERT NHANVIEN_TK VALUES('NV001', 'TK001', 100)

SELECT * FROM NHANVIEN_TK

go

CREATE TRIGGER KTMNVVMTK 
ON NHANVIEN_TK
INSTEAD OF INSERT
AS
	BEGIN
		IF EXISTS (SELECT * FROM inserted 
			WHERE (MANV IN (SELECT MANV FROM NHANVIEN_TK))
			AND (MATK IN (SELECT MATK FROM NHANVIEN_TK)))
				BEGIN
					PRINT N'MA NHAN VIEN VA MA TK DA TON TAI'
					ROLLBACK TRAN
				END
		ELSE
			INSERT NHANVIEN_TK SELECT * FROM inserted
	END

INSERT NHANVIEN_TK VALUES('NV002', 'TK001', 100)

SELECT * FROM NHANVIEN

SELECT * FROM NHANVIEN_TK

--Bài 3
CREATE TABLE TAIKHOAN 
(
	MATK NVARCHAR(30),
	TENTK NVARCHAR(30),
	PASS NVARCHAR(15)
)

INSERT TAIKHOAN VALUES ('TK001', 'TTK001', 'ABC')
INSERT TAIKHOAN VALUES ('TK004', 'TTK004', 'ABC')

ALTER TRIGGER KTKN
ON NHANVIEN_TK FOR INSERT
AS
	IF EXISTS (SELECT * FROM inserted WHERE MANV NOT IN (SELECT MANV FROM NHANVIEN))
		BEGIN
			PRINT N'MA NHAN VIEN KHONG TON TAI'
			ROLLBACK TRAN
		END
	ELSE
		BEGIN
			IF EXISTS (SELECT *FROM inserted WHERE MATK NOT IN (SELECT MATK FROM TAIKHOAN))
				BEGIN
					PRINT N'MA TAI KHOAN KHONG TON TAI'
					ROLLBACK TRAN
				END
		END
SELECT *FROM NHANVIEN
SELECT *FROM NHANVIEN_TK
SELECT *FROM TAIKHOAN

INSERT NHANVIEN_TK VALUES('NV003','TK001',200)
INSERT NHANVIEN_TK VALUES('NV001','TK004',200)

DELETE FROM NHANVIEN WHERE MANV = '002'


--Bài 4: 
CREATE TABLE LOPHOC
(
	MALOP NVARCHAR(30),
	TENLOP NVARCHAR(30),
	SISO INT
)

INSERT LOPHOC VALUES('ML001', 'DHKTPM', 0)
INSERT LOPHOC VALUES('ML002', 'DHKHMT', 0)
INSERT LOPHOC VALUES('ML003', 'DHKHDL', 0)

SELECT *FROM LOPHOC
CREATE TABLE SINHVIEN 
(
	MASV NVARCHAR(30),
	TENSV NVARCHAR(30),
	MALOP NVARCHAR(30)
)

CREATE TRIGGER CAPNHATSISO
ON SINHVIEN
FOR INSERT
AS
	BEGIN 
		UPDATE LOPHOC
		SET SISO += (SELECT COUNT(*) FROM inserted) FROM LOPHOC p JOIN inserted o
		on p.MALOP = o.MALOP 
	END

--THỰC THI
INSERT SINHVIEN VALUES('SV001', 'VU PHONG', 'ML001')
INSERT SINHVIEN VALUES('SV002', 'VU PHONG', 'ML002')
INSERT SINHVIEN VALUES('SV003', 'PHONG VU', 'ML001'),('SV004', 'PHONG VU', 'ML002')

SELECT *FROM LOPHOC
SELECT *FROM SINHVIEN

-- Bài tập về nhà

--Bài 1
-- Tạo mới 2 bảng M_Employees và M_Department theo cấu trúc sau: 
--create table M_Department
--(
--DepartmentID int not null primary key, 
--Name nvarchar(50),
--GroupName nvarchar(50)
--)
--create table M_Employees 
--(
--EmployeeID int not null primary key, 
--Firstname nvarchar(50),
--MiddleName nvarchar(50), 
--LastName nvarchar(50),
--DepartmentID int foreign key references M_Department(DepartmentID)
--)
-- Tạo một view tên EmpDepart_View bao gồm các field: EmployeeID,
--FirstName, MiddleName, LastName, DepartmentID, Name, GroupName, dựa 
--trên 2 bảng M_Employees và M_Department.
-- Tạo một trigger tên InsteadOf_Trigger thực hiện trên view
--EmpDepart_View, dùng để chèn dữ liệu vào các bảng M_Employees và 
--M_Department khi chèn một record mới thông qua view EmpDepart_View.
--Dữ liệu test:
--insert EmpDepart_view values(1, 'Nguyen','Hoang','Huy', 11,'Marketing','Sales')CREATE DATABASE tuan7USE tuan7create table M_Department
(
DepartmentID int not null primary key, 
Name nvarchar(50),
GroupName nvarchar(50)
)

create table M_Employees 
(
EmployeeID int not null primary key, 
Firstname nvarchar(50),
MiddleName nvarchar(50), 
LastName nvarchar(50),
DepartmentID int foreign key references M_Department(DepartmentID)
)

select * from [dbo].[M_Department]
select * from [dbo].[M_Employees]

-- Tạo một view tên EmpDepart_View bao gồm các field: EmployeeID,
--FirstName, MiddleName, LastName, DepartmentID, Name, GroupName, dựa 
--trên 2 bảng M_Employees và M_Department.

CREATE VIEW EmpDepart_view
as
	select p.EmployeeID, Firstname, MiddleName, LastName, o.DepartmentID, Name, GroupName from [dbo].[M_Department] o join [dbo].[M_Employees] p
	on o.DepartmentID = p.DepartmentID
go

select * from [dbo].[EmpDepart_view]

--Tạo một trigger tên InsteadOf_Trigger thực hiện trên view
--EmpDepart_View, dùng để chèn dữ liệu vào các bảng M_Employees và 
--M_Department khi chèn một record mới thông qua view EmpDepart_View.

CREATE TRIGGER insteadof_trigger
ON EmpDepart_view
INSTEAD OF INSERT
AS
	BEGIN
		INSERT [dbo].[M_Department]
		SELECT [DepartmentID], [Name], [GroupName] from inserted
		INSERT [dbo].[M_Employees]
		SELECT [EmployeeID], [Firstname], [MiddleName], [LastName], [DepartmentID] FROM inserted
	END
--Dữ liệu test:
insert EmpDepart_view values(1, 'Nguyen','Hoang','Huy', 11,'Marketing','Sales')--Kiểm tra lạiselect * from [dbo].[M_Department]
select * from [dbo].[M_Employees]
select * from [dbo].[EmpDepart_view]--Câu 2--Tạo một trigger thực hiện trên bảng MSalesOrders có chức năng thiết lập độ ưu 
--tiên của khách hàng (CustPriority) khi người dùng thực hiện các thao tác Insert, 
--Update và Delete trên bảng MSalesOrders theo điều kiện như sau:
-- Nếu tổng tiền Sum(SubTotal) của khách hàng dưới 10,000 $ thì độ ưu tiên của 
--khách hàng (CustPriority) là 3
-- Nếu tổng tiền Sum(SubTotal) của khách hàng từ 10,000 $ đến dưới 50000 $ 
--thì độ ưu tiên của khách hàng (CustPriority) là 2
-- Nếu tổng tiền Sum(SubTotal) của khách hàng từ 50000 $ trở lên thì độ ưu tiên 
--của khách hàng (CustPriority) là 1
--Các bước thực hiện:
-- Tạo bảng MCustomers và MSalesOrders theo cấu trúc 
--sau: create table MCustomer
--(
--CustomerID int not null primary key, 
--CustPriority int
--)
--create table MSalesOrders 
--(
--SalesOrderID int not null primary key, 
--OrderDate date,
--SubTotal money,
--CustomerID int foreign key references MCustomer(CustomerID) )
-- Chèn dữ liệu cho bảng MCustomers, lấy dữ liệu từ bảng Sales.Customer, 
--nhưng chỉ lấy CustomerID>30100 và CustomerID<30118, cột CustPriority cho 
--giá trị null.
-- Chèn dữ liệu cho bảng MSalesOrders, lấy dữ liệu từ bảng
--Sales.SalesOrderHeader, chỉ lấy những hóa đơn của khách hàng có trong bảng 
--khách hàng.
-- Viết trigger để lấy dữ liệu từ 2 bảng inserted và deleted.
-- Viết câu lệnh kiểm tra việc thực thi của trigger vừa tạo bằng cách chèn thêm hoặc 
--xóa hoặc update một record trên bảng MSalesOrders


--Câu 3
--. Viết một trigger thực hiện trên bảng MEmployees sao cho khi người dùng thực
--hiện chèn thêm một nhân viên mới vào bảng MEmployees thì chương trình cập 
--nhật số nhân viên trong cột NumOfEmployee của bảng MDepartment. Nếu tổng 
--số nhân viên của phòng tương ứng <=200 thì cho phép chèn thêm, ngược lại thì 
--hiển thị thông báo “Bộ phận đã đủ nhân viên” và hủy giao tác. Các bước thực hiện:
-- Tạo mới 2 bảng MEmployees và MDepartment theo cấu trúc sau:
--create table MDepartment 
--(
--DepartmentID int not null primary key, 
--Name nvarchar(50),
--NumOfEmployee int
--)
--create table MEmployees 
--(
--EmployeeID int not null, 
--FirstName nvarchar(50), 
--MiddleName nvarchar(50), 
--LastName nvarchar(50),
--DepartmentID int foreign key references MDepartment(DepartmentID), 
--constraint pk_emp_depart primary key(EmployeeID, DepartmentID)
--)

use AdventureWorks2008R2

create table MDepartment 
(
	DepartmentID int not null primary key, 
	Name nvarchar(50),
	NumOfEmployee int
)

create table MEmployees 
(
	EmployeeID int not null, 
	FirstName nvarchar(50), 
	MiddleName nvarchar(50), 
	LastName nvarchar(50),
	DepartmentID int foreign key references MDepartment(DepartmentID), 
	constraint pk_emp_depart primary key(EmployeeID, DepartmentID)
)

-- Chèn dữ liệu cho bảng MDepartment, lấy dữ liệu từ bảng Department, cột 
--NumOfEmployee gán giá trị NULL, bảng MEmployees lấy từ bảng 
--EmployeeDepartmentHistory
INSERT [dbo].[MDepartment]
SELECT [DepartmentID], [Name], NULL FROM [HumanResources].[Department]

INSERT [dbo].[MEmployees]
SELECT o.[BusinessEntityID], [FirstName], [MiddleName], [LastName], [DepartmentID]
FROM [HumanResources].[EmployeeDepartmentHistory] o join [Person].[Person] p
on o.BusinessEntityID = p.BusinessEntityID

SELECT *
FROM [dbo].[Memployees]
ORDER BY [DepartmentID]
GO

--Tạo trigger

CREATE TRIGGER KTSLNV 
ON [dbo].[MEmployees]
FOR INSERT
AS 
	DECLARE @MaPhongBan int, @SLNV int
	
	SELECT @MaPhongBan = DepartmentID FROM inserted

	--SELECT @SLNV = NumOfEmployee FROM [dbo].[MDepartment]
	--WHERE DepartmentID = @MaPhongBan
	
	SELECT @SLNV = (
		SELECT COUNT(*) 
		FROM [dbo].[Memployees]
		WHERE DepartmentID = @MaPhongBan)
	IF (@SLNV <= 200)
		BEGIN
			UPDATE MDepartment SET NumOfEmployee = @SLNV + 1 WHERE DepartmentID = @MaPhongBan
		END
	ELSE
		BEGIN
			PRINT N'Bộ phận đã đủ nhân viên'
			ROLLBACK TRANSACTION
		END
GO

--test trigger
INSERT [dbo].[Memployees]
VALUES(291, 'Le', 'Vu', 'Phong', 1),
INSERT [dbo].[Memployees]
VALUES(292, 'Vu', 'Phong', 'Le', 3)


--kiem tra ket qua
SELECT *
FROM MDepartment

DROP TRIGGER dbo.KTSLNV;
DROP TABLE dbo.MEmployees
DROP TABLE dbo.MDepartment
GO


--Câu 4: 
--Bảng [Purchasing].[Vendor], chứa thông tin của nhà cung cấp, thuộc tính
--CreditRating hiển thị thông tin đánh giá mức tín dụng, có các giá trị: 
--1 = Superior
--2 = Excellent
--3 = Above average 
--4 = Average
--5 = Below average
--Viết một trigger nhằm đảm bảo khi chèn thêm một record mới vào bảng 
--[Purchasing].[PurchaseOrderHeader], nếu Vender có CreditRating=5 thì hiển thị 
--thông báo không cho phép chèn và đồng thời hủy giao tác.
--Dữ liệu test
--INSERT INTO Purchasing.PurchaseOrderHeader (RevisionNumber, Status, 
--EmployeeID, VendorID, ShipMethodID, OrderDate, ShipDate, SubTotal, TaxAmt, 
--Freight) VALUES ( 2 ,3, 261, 1652, 4 ,GETDATE() ,GETDATE() , 44594.55,
--,3567.564, ,1114.8638 );


--Câu 5:
--Viết một trigger điều chỉnh số liệu trên bảng ProductInventory (lưu thông tin số 
--lượng sản phẩm trong kho). Khi 
--chèn thêm một đơn đặt hàng vào 
--bảng SalesOrderDetail với số 
--lượng xác định trong field
--OrderQty, nếu số lượng trong kho 
--Quantity> OrderQty thì cập nhật 
--lại số lượng trong kho 
--Quantity= Quantity- OrderQty, 
--ngược lại nếu Quantity=0 thì xuất 
--thông báo “Kho hết hàng” và đồng 
--thời hủy giao tác.

-- tạo bảng MProduct
CREATE TABLE MProduct
(
	MProductID INT NOT NULL PRIMARY KEY,
	ProductName NVARCHAR(50),
	ListPrice MONEY
)

INSERT MProduct
	(MProductID, ProductName,ListPrice)
SELECT [ProductID], [Name], [ListPrice]
FROM [Production].[Product]
WHERE [ProductID]<=710
SELECT*
FROM MProduct

-- tạo bảng MSalesOrderHeader
CREATE TABLE MSalesOrderHeader
(
	MSalesOrderID INT NOT NULL PRIMARY KEY,
	OrderDate DATETIME
)

INSERT MSalesOrderHeader
SELECT [SalesOrderID], [OrderDate]
FROM [Sales].[SalesOrderHeader]
WHERE [SalesOrderID] IN (SELECT [SalesOrderID]
FROM [Sales].[SalesOrderDetail]
WHERE [ProductID]<=710)
SELECT*
FROM MSalesOrderHeader

-- tạo bảng MSalesOrderDetail
CREATE TABLE MSalesOrderDetail
(
	SalesOrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
	ProductID INT NOT NULL FOREIGN KEY(ProductID) REFERENCES MProduct(MProductID),
	SalesOrderID INT NOT NULL FOREIGN KEY (SalesOrderID) REFERENCES MSalesOrderHeader(MSalesOrderID),
	OrderQty INT
)
INSERT MSalesOrderDetail
	(ProductID, SalesOrderID,OrderQty)
SELECT [ProductID], [SalesOrderID], [OrderQty]
FROM [Sales].[SalesOrderDetail]
WHERE [ProductID] IN(SELECT MProductID
FROM MProduct)

-- tạo bảng MProduct_inventory
CREATE TABLE MProduct_inventory
(
	productID INT NOT NULL PRIMARY KEY,
	quantity SMALLINT
)

INSERT MProduct_inventory
SELECT [ProductID], sum([Quantity]) AS sumofquatity
FROM [Production].[ProductInventory]
GROUP BY [ProductID]
GO


--Tạo trigger

CREATE TRIGGER Bai5
ON [dbo].[MSalesOrderDetail]
AFTER INSERT
AS
BEGIN
    DECLARE @ProductID INT
    DECLARE @OrderQty INT
    DECLARE @Quantity INT
    
    SELECT @ProductID = inserted.ProductID, @OrderQty = inserted.OrderQty
    FROM inserted
    
    SELECT @Quantity = Quantity
    FROM [Production].[ProductInventory]
    WHERE ProductID = @ProductID
    
    IF @Quantity > @OrderQty
    BEGIN
        UPDATE [Production].[ProductInventory]
        SET Quantity = @Quantity - @OrderQty
        WHERE ProductID = @ProductID
    END
    ELSE IF @Quantity = @OrderQty
    BEGIN
        UPDATE [Production].[ProductInventory]
        SET Quantity = 0
        WHERE ProductID = @ProductID
        
        RAISERROR('Kho hết hàng', 16, 1)
        ROLLBACK TRANSACTION
    END
END

SELECT * FROM [dbo].[MSalesOrderDetail]

--Kiểm tra trigger

DELETE FROM [MSalesOrderDetail]
INSERT [dbo].[MSalesOrderDetail]
VALUES(708, 43661, 300)

--Câu 6:
--Tạo trigger cập nhật tiền thưởng (Bonus) cho nhân viên bán hàng SalesPerson, khi 
--người dùng chèn thêm một record mới trên bảng SalesOrderHeader, theo quy định 
--như sau: Nếu tổng tiền bán được của nhân viên có hóa đơn mới nhập vào bảng 
--SalesOrderHeader có giá trị >10000000 thì tăng tiền thưởng lên 10% của mức 
--thưởng hiện tại. Cách thực hiện:
-- Tạo hai bảng mới M_SalesPerson và M_SalesOrderHeader
--create table M_SalesPerson 
--(
--SalePSID int not null primary key, 
--TerritoryID int,
--BonusPS money
--)
--create table M_SalesOrderHeader 
--(
--SalesOrdID int not null primary key, 
--OrderDate date,
--SubTotalOrd money,
--SalePSID int foreign key references M_SalesPerson(SalePSID)
--)
-- Chèn dữ liệu cho hai bảng trên lấy từ SalesPerson và SalesOrderHeader chọn 
--những field tương ứng với 2 bảng mới tạo.
-- Viết trigger cho thao tác insert trên bảng M_SalesOrderHeader, khi trigger 
--thực thi thì dữ liệu trong bảng M_SalesPerson được cập nhật

CREATE TABLE M_SalesPerson
(
	SalePSID INT NOT NULL PRIMARY KEY,
	TerritoryID INT,
	BonusPS MONEY
)

CREATE TABLE M_SalesOrderHeader
(
	SalesOrdID INT NOT NULL PRIMARY KEY,
	OrderDate DATE,
	SubTotalOrd MONEY,
	SalePSID INT FOREIGN KEY REFERENCES M_SalesPerson(SalePSID)
)

INSERT INTO M_SalesPerson
SELECT s.BusinessEntityID, s.TerritoryID, s.Bonus
FROM Sales.SalesPerson AS s

INSERT INTO M_SalesOrderHeader
SELECT s.SalesOrderID, s.OrderDate, s.SubTotal, s.SalesPersonID
FROM Sales.SalesOrderHeader AS s
GO

CREATE TRIGGER bonus_trigger
ON [dbo].[M_SalesOrderHeader]
FOR INSERT
AS
	BEGIN
	DECLARE @doanhThu FLOAT, @maNV INT
	SELECT @maNV= i.SalePSID
	FROM inserted i

	SET @doanhThu=(
		SELECT sum([SubTotalOrd])
	FROM [dbo].[M_SalesOrderHeader]
	WHERE SalePSID=@maNV
	)

	IF (@doanhThu > 10000000)
	BEGIN
		UPDATE M_SalesPerson
				SET BonusPS += BonusPS * 0.1
				WHERE SalePSID=@maNV
	END
END
GO