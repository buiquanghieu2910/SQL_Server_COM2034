CREATE DATABASE QLHH
GO

CREATE TABLE KHACHHANG
(
MAKH VARCHAR(10) NOT NULL,
TENKHACHHANG NVARCHAR(25) NULL,
DIACHI NVARCHAR(50) NULL,
DIENTHOAI VARCHAR(10) NULL,
GIOITINH NVARCHAR(5) NULL
PRIMARY KEY (MAKH),
)
GO

CREATE TABLE MATHANG
(
MAMH VARCHAR(10) NOT NULL,
TENMH NVARCHAR(25) NULL,
DONGIA MONEY NULL,
PRIMARY KEY (MAMH),
)
GO

CREATE TABLE DONHANG
(
MAMH VARCHAR(10) NOT NULL,
MAKH VARCHAR(10) NOT NULL,
NGAYDANGHANG DATETIME NULL,
NGAYGIAOHANG DATETIME NULL,
SOLUONG INT NULL
CONSTRAINT PK_DONHANG PRIMARY KEY (MAMH, MAKH),
CONSTRAINT FK_DONHANG_KHACHHANG FOREIGN KEY(MAKH) REFERENCES KHACHHANG,
CONSTRAINT FK_DONHANG_MATHANG FOREIGN KEY(MAKH) REFERENCES MATHANG
)
GO


--BAI 2:
IF OBJECT_ID('B2') IS NOT NULL
DROP PROC B2
GO
CREATE PROC B2
@MAKH VARCHAR(10),
@TENKHACHHANG NVARCHAR(25),
@DIACHI NVARCHAR(50),
@DIENTHOAI VARCHAR(10),
@GIOITINH NVARCHAR(5)

AS 
IF @MAKH IS NULL OR @TENKHACHHANG IS NULL OR @DIACHI IS NULL OR @DIENTHOAI IS NULL OR @GIOITINH IS NULL
PRINT N'DU LIEU NHAP KHONG NHAP LE'

ELSE
INSERT KHACHHANG VALUES(@MAKH,@TENKHACHHANG,@DIACHI,@DIENTHOAI,@GIOITINH)
PRINT N'THANH CONG'

EXEC B2 'PH13813', N'BUI QUANG HIEU', N'HA HOI', '0395962002','NAM'
EXEC B2 'PH13911', N'LA VAN THO', N'HAI PHONG', '0716392645','NAM'
EXEC B2 'PH13941', N'LE HOANG NHAT', N'NGHE AN', '0984697023','NAM'
SELECT *FROM KHACHHANG




IF OBJECT_ID('B22') IS NOT NULL
DROP PROC B22
GO
CREATE PROC B22
@MAMH VARCHAR(10),
@TENMH NVARCHAR(25),
@DONGIA MONEY
AS 
IF @MAMH IS NULL OR @TENMH IS NULL OR @DONGIA IS NULL
PRINT N'DU LIEU NHAP KHONG NHAP LE'

ELSE
INSERT MATHANG VALUES(@MAMH, @TENMH, @DONGIA )
PRINT N'THANH CONG'

EXEC B22 'MH001', N'LAPTOP', 1000
EXEC B22 'MH002', N'DIEN THOAI', 1100
EXEC B22 'MH003', N'TIVI', 1500
SELECT *FROM MATHANG


IF OBJECT_ID('B23') IS NOT NULL
DROP PROC B23
GO
CREATE PROC B23
@MAMH VARCHAR(10),
@MAKH VARCHAR(10),
@NGAYDANGHANG DATETIME,
@NGAYGIAOHANG DATETIME,
@SOLUONG INT

AS 
IF @MAMH IS NULL OR @MAKH IS NULL OR @NGAYDANGHANG IS NULL OR @NGAYGIAOHANG IS NULL OR @SOLUONG IS NULL
PRINT N'DU LIEU NHAP KHONG NHAP LE'

ELSE
INSERT DONHANG VALUES(@MAMH,@MAKH,@NGAYDANGHANG,@NGAYGIAOHANG,@SOLUONG)
PRINT N'THANH CONG'

EXEC B23 'MH002', 'PH13812','2021-06-01', '2021-06-05', 2
EXEC B23 'MH001', 'PH13941','2021-05-29', '2021-06-01', 1
EXEC B23 'MH003', 'PH13911','2021-06-06', '2021-06-15', 3
SELECT *FROM DONHANG


--BAI 3:
IF OBJECT_ID('B3') IS NOT NULL
	DROP FUNCTION B3
GO
CREATE FUNCTION B3
(

	@MAKH VARCHAR(10), @TENKHACHHANG NVARCHAR(25), @DIACHI NVARCHAR(50), @DIENTHOAI VARCHAR(10), @GIOITINH NVARCHAR(5)
)
RETURNS VARCHAR(10) 
AS
BEGIN
 RETURN(
SELECT KHACHHANG.MAKH FROM KHACHHANG
WHERE TENKHACHHANG = @TENKHACHHANG AND DIACHI = @DIACHI AND DIENTHOAI = @DIENTHOAI AND GIOITINH = @GIOITINH
)
END
GO

DECLARE @MAKH VARCHAR(10) 
SET @MAKH = dbo.B3('PH13812', N'BUI QUANG HIEU', N'HA NOI', '0395962002' ,'NAM')
SELECT @MAKH AS MAKH


--BAI 4: 

   IF OBJECT_ID('TOP2') IS NOT NULL
       DROP VIEW TOP2
   GO
   CREATE VIEW TOP2
   AS
     SELECT TOP 2 TENKHACHHANG, TENMH, NGAYDANGHANG, NGAYGIAOHANG, SOLUONG, DONGIA, (SOLUONG*DONGIA) AS THANHTIEN 
	 FROM KHACHHANG JOIN DONHANG ON KHACHHANG.MAKH = DONHANG.MAKH 
	                JOIN MATHANG ON MATHANG.MAMH = DONHANG.MAMH

	GROUP BY TENKHACHHANG, TENMH, NGAYDANGHANG, NGAYGIAOHANG, SOLUONG, DONGIA
	ORDER BY THANHTIEN DESC
	
	SELECT * FROM TOP2



--BAI 5:

   IF OBJECT_ID('B5') IS NOT NULL
  DROP PROC B5
GO
  CREATE PROC B5
        @MAMH VARCHAR(10)
AS
BEGIN TRY
BEGIN TRAN
DELETE dbo.DONHANG WHERE MAMH IN (SELECT MAMH FROM dbo.MATHANG WHERE MAMH = @MAMH)
DELETE dbo.MATHANG WHERE MAMH IN (SELECT MAMH FROM dbo.MATHANG WHERE MAMH = @MAMH)
COMMIT
END TRY
BEGIN CATCH
   ROLLBACK
 END CATCH

 EXEC B5 'MH002'

   SELECT * FROM MATHANG