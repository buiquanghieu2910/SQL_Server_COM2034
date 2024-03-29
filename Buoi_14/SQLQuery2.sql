CREATE DATABASE QLSV
GO

CREATE TABLE SINHVIEN
(
MASV VARCHAR(10) NOT NULL,
HOTEN NVARCHAR(25) NULL,
NGAYSINH DATETIME NULL,
GIOITINH VARCHAR(5) NULL,
LOP VARCHAR(15)
PRIMARY KEY (MASV),
)
GO

CREATE TABLE DIEM
(
MASV VARCHAR(10) NOT NULL,
MAMONHOC VARCHAR(10) NOT NULL,
DIEMLAN1 FLOAT NULL,
DIEMLAN2 FLOAT NULL,
PRIMARY KEY (MAMONHOC),
CONSTRAINT FK_DIEM_SINHVIEN FOREIGN KEY(MASV) REFERENCES SINHVIEN
)
GO

INSERT [dbo].SINHVIEN([MASV], [HOTEN],[NGAYSINH],[GIOITINH],[LOP]) VALUES ('PH13812', N'B�I QUANG HI?U', 2002-10-29, N'NAM','IT16032')


--B�I 2:
IF OBJECT_ID('B2') IS NOT NULL
DROP PROC B2
GO
CREATE PROC B2
@MASV VARCHAR(10),
@HOTEN NVARCHAR(50),
@NGAYSINH DATETIME,
@GIOITINH VARCHAR(5),
@LOP VARCHAR(15) 

AS 
IF @MASV IS NULL OR @HOTEN IS NULL OR @NGAYSINH IS NULL OR @GIOITINH IS NULL OR @LOP IS NULL
PRINT N'DU LIEU NHAP KHONG NHAP LE'

ELSE
INSERT SINHVIEN VALUES(@MASV,@HOTEN,@NGAYSINH,@GIOITINH,@LOP)
PRINT N'THANH CONG'

EXEC B2 'PH13813', N'B�I QUANG HI?U', 2002, N'NAM','IT16032'
EXEC B2 'PH19345', N'B�I TH? MAI ANH', 2003, N'N?','IT16032'
SELECT *FROM SINHVIEN


IF OBJECT_ID('B22') IS NOT NULL
DROP PROC B22
GO
CREATE PROC B22
@MASV VARCHAR(10),
@MAMONHOC VARCHAR(10),
@DIEMLAN1 FLOAT,
@DIEMLAN2 FLOAT

AS 
IF @MASV IS NULL OR @MAMONHOC IS NULL OR @DIEMLAN1 IS NULL OR @DIEMLAN2 IS NULL
PRINT N'DU LIEU NHAP KHONG NHAP LE'

ELSE
INSERT SINHVIEN VALUES(@MASV,@MAMONHOC,@DIEMLAN1,@DIEMLAN2)
PRINT N'THANH CONG'

EXEC B22'PH13813', N'COM2034', 9, 9
EXEC B22 'PH19345', N'COM2034', 8, 9

SELECT * FROM DIEM


--B�I 3:
IF OBJECT_ID('B3') IS NOT NULL
	DROP FUNCTION B3
GO
CREATE FUNCTION B3
(
	@MASV VARCHAR(10)
)
RETURNS @TABLE TABLE (MASV VARCHAR(10), HOTEN NVARCHAR(30),MAMONHOC VARCHAR(10),DIEMLAN1 INT,DIEMLAN2 INT)
AS
BEGIN
INSERT INTO @TABLE
SELECT SINHVIEN.MASV,HOTEN,MAMONHOC,DIEMLAN1,DIEMLAN2 FROM SINHVIEN JOIN DIEM ON SINHVIEN.MASV=DIEM.MASV
WHERE SINHVIEN.MASV = @MASV
RETURN
END
SELECT * FROM B3('PH13812')

--B�I 4:
IF OBJECT_ID('B4') IS NOT NULL
  DROP PROC B4
GO
  CREATE PROC B4
        @MASV VARCHAR(10)
AS

  IF @MASV IS NULL
  PRINT N'DU LIEU NHAP VAO KHONG HOP LE'
  
  ELSE
   DELETE FROM DIEM 
   DELETE FROM SINHVIEN
   WHERE MASV = @MASV
   PRINT N'X�A TH�NH C�NG'

EXEC B4 'PH13813'

   SELECT * FROM SINHVIEN

   
   --B�I 4:

   IF OBJECT_ID('B4') IS NOT NULL
  DROP PROC B4
GO
  CREATE PROC B4
        @MASV VARCHAR(10)
AS
BEGIN TRY
BEGIN TRAN
DELETE dbo.DIEM WHERE MASV IN (SELECT MASV FROM dbo.DIEM WHERE MASV = @MASV)
DELETE dbo.SINHVIEN WHERE MASV IN (SELECT MASV FROM dbo.SINHVIEN WHERE MASV = @MASV)
COMMIT
END TRY
BEGIN CATCH
   ROLLBACK
 END CATCH

 EXEC B4 'PH13812'

   SELECT * FROM SINHVIEN