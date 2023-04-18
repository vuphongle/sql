CREATE DATABASE QLSV 
go
USE QLSV
go

CREATE TABLE SinhVien
(
	maSV varchar(20) primary key,
	tenSV nvarchar(50),
	maLop varchar(20)
)

CREATE TABLE LopHoc
(
	maLop varchar(20) primary key,
	tenLop nvarchar(20),
	siSo int
)

insert into LopHoc values ('ML001', N'DHKTPM17C', 0), ('ML002', N'DHKTPM17A', 0), ('ML003', N'DHKTPM17B', 0)
go


--Trigger khi inser siSo được cập nhật
CREATE TRIGGER CAPNHATSISO
ON SinhVien
FOR INSERT
AS
	BEGIN 
		UPDATE LopHoc
		SET siSo += (SELECT COUNT(*) FROM inserted) FROM LopHoc p JOIN inserted o
		on p.maLop = o.maLop 
	END
go

--Trigger khi update thay đổi maLop siSo được cập nhật
CREATE TRIGGER updatesiSo
on SinhVien
AFTER UPDATE
AS
	BEGIN
	SET NOCOUNT ON;

	DECLARE @OldMaLop nvarchar(50);
	DECLARE @NewMaLop nvarchar(50);
	DECLARE @MaSV nvarchar(50);

	SELECT @OldMaLop = d.maLop, @NewMaLop = i.maLop, @MaSV = i.maSV
	FROM inserted i
	JOIN deleted d ON i.maSV = d.maSV;
	IF (@OldMaLop <> @NewMaLop)
		BEGIN
			UPDATE LopHoc SET siSo = siSo - 1 WHERE maLop = @OldMaLop;
			UPDATE LopHoc SET siSo = siSo + 1 WHERE maLop = @NewMaLop;
		END
END

select * from LopHoc
select * from SinhVien

--Thêm dữ liệu cho SinhVien để cho siSo
insert into SinhVien values('SV001', N'Lê Vũ Phong', 'ML001')
insert into SinhVien values('SV002', N'Nguyễn Tuấn Dũng', 'ML002')
insert into SinhVien values('SV003', N'Mai Tấn Đạt', 'ML003')
insert into SinhVien values('SV004', N'Trần Nguyễn Minh Khôi', 'ML001')
insert into SinhVien values('SV005', N'Trần Hoàng Vinh', 'ML002')

--Kiểm tra lại trigger
delete SinhVien where maLop like 'ML001'

update SinhVien set maLop = 'ML002'
where maSV like 'SV001'