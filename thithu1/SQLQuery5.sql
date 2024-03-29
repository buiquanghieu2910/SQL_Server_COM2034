CREATE DATABASE QLNHANSU
GO
USE QLNHANSU
GO
IF OBJECT_ID('PHONGBAN') IS NOT NULL
DROP TABLE PHONGBAN
GO
CREATE TABLE PHONGBAN
(
MAPB VARCHAR(10) NOT NULL,
TENPB NVARCHAR(50) NULL
CONSTRAINT PK_PHONGBAN PRIMARY KEY(MAPB)
)
GO
IF OBJECT_ID('NHANVIEN') IS NOT NULL
DROP TABLE NHANVIEN
GO
CREATE TABLE NHANVIEN
(
MANV VARCHAR(10) NOT NULL,
HOTEN NVARCHAR(50) NULL,
GIOITINH NVARCHAR(5)NULL,
LUONG MONEY NULL,
MAPB VARCHAR(10)NULL
CONSTRAINT PK_NHANVIEN PRIMARY KEY(MANV),
CONSTRAINT FK_NHANVIEN_PHONGBAN FOREIGN KEY(MAPB) REFERENCES PHONGBAN
)
GO
IF OBJECT_ID('CHAMCONG') IS NOT NULL
DROP TABLE CHAMCONG
GO
CREATE TABLE CHAMCONG
(
MACONG VARCHAR(10) NOT NULL,
MANV VARCHAR(10) NOT NULL,
THANG INT NULL,
SONGAYLAMVIEC INT NULL,
NGPHEP INT NULL,
NGKPHEP INT NULL
CONSTRAINT PK_CHAMCONG PRIMARY KEY(MACONG),
CONSTRAINT FK_CHAMCONG_NHANVIEN FOREIGN KEY(MANV) REFERENCES NHANVIEN
)
GO
-----CAU2
IF OBJECT_ID('CAU2_1') IS NOT NULL
DROP PROC CAU2_1
GO
CREATE PROC CAU2_1
@MAPB VARCHAR(10) ,
@TENPB NVARCHAR(50)
AS 
IF @MAPB IS NULL OR @TENPB IS NULL
PRINT N'NH?P THI?U D? LI?U'
ELSE
INSERT INTO PHONGBAN VALUES(@MAPB,@TENPB)
---
GO
EXEC CAU2_1 'PB01',N'PH�NG H�NH CH�NH'
EXEC CAU2_1 'PB02',N'PH�NG NH�N S?'
EXEC CAU2_1 'PB03',N'PH�NG GIAO D?CH'


IF OBJECT_ID('CAU2_2') IS NOT NULL
DROP PROC CAU2_2
GO
CREATE PROC CAU2_2
@MANV VARCHAR(10) ,
@HOTEN NVARCHAR(50),
@GIOITINH NVARCHAR(5),
@LUONG MONEY,
@MAPB VARCHAR(10)
AS
IF @MANV IS NULL OR @HOTEN IS NULL OR @GIOITINH IS NULL OR @LUONG IS NULL OR @MAPB IS NULL
PRINT N'?I?N THI?U TH�NG TIN'
ELSE
INSERT INTO NHANVIEN VALUES(@MANV,@HOTEN,@GIOITINH,@LUONG,@MAPB)
--EXEC 
GO
EXEC CAU2_2 'NV01',N'L� V?N TH?',N'NAM',3000,'PB01'
EXEC CAU2_2 'NV02',N'NGUY?N H?NG NG?C',N'NAM',2000,'PB02'
EXEC CAU2_2 'NV03',N'L� HO�NG NH?T',N'NAM',3800,'PB03'
--------
IF OBJECT_ID('CAU2_3') IS NOT NULL
DROP PROC CAU2_3
GO
CREATE PROC CAU2_3
@MACONG VARCHAR(10) ,
@MANV VARCHAR(10) ,
@THANG INT ,
@SONGAYLAMVIEC INT,
@NGPHEP INT ,
@NGKPHEP INT 
AS
IF @MACONG IS NULL OR @MANV IS NULL OR @THANG IS NULL OR @SONGAYLAMVIEC IS NULL OR @NGPHEP IS NULL OR @NGKPHEP IS NULL
PRINT N'?I?N THI?U TH�NG TIN'
ELSE
INSERT INTO CHAMCONG VALUES(@MACONG,@MANV,@THANG,@SONGAYLAMVIEC,@NGPHEP,@NGKPHEP)
--EXEC
GO
EXEC CAU2_3 'MC01','NV01',10,30,0,0
EXEC CAU2_3 'MC02','NV02',10,20,5,5
EXEC CAU2_3 'MC03','NV03',10,14,10,6

---CAU 4
IF OBJECT_ID('CAU4') IS NOT NULL
DROP VIEW CAU4
GO
CREATE VIEW CAU4 AS
SELECT TOP 2 PHONGBAN.MAPB,TENPB,HOTEN AS SOLUONGNV
FROM PHONGBAN JOIN NHANVIEN ON PHONGBAN.MAPB=NHANVIEN.MAPB
ORDER BY SOLUONGNV DESC
SELECT*FROM CAU4
----CAU 3
IF OBJECT_ID('CAU3') IS NOT NULL
DROP FUNCTION CAU3
GO
CREATE FUNCTION CAU3
(
@MANV VARCHAR(10),
@HOTEN NVARCHAR(50),
@GIOITINH NVARCHAR(5),
@LUONG MONEY ,
@MAPB VARCHAR(10) --N� Y�U C?U T�M M� NV TH� C� C?N TRUY?N V�O FUNCTION K,?�Y L� N� B?O TRUY?N C? B?NG
)RETURNS VARCHAR(10)
AS 
BEGIN
RETURN 
(
SELECT MANV FROM NHANVIEN WHERE
		  HOTEN=@HOTEN AND
		  GIOITINH=@GIOITINH AND
		  LUONG=@LUONG AND
		  MAPB=@MAPB
		  )
		  END
---GOI
DECLARE @CAU3 VARCHAR(10)
SET @CAU3=DBO.CAU3('NV01',N'L� V?N TH?',N'NAM',3000,'PB01')
SELECT @CAU3 AS MAKH
-----
IF OBJECT_ID('SPXOANV') IS NOT NULL
 DROP PROC SPXOANV
GO
CREATE PROC SPXOANV
 @SNP INT
AS 
 BEGIN TRY
  BEGIN TRAN 
   DECLARE @BANG TABLE
    (MANV VARCHAR(10), SNP INT)
   INSERT @BANG SELECT CHAMCONG.MANV, SUM(NGPHEP) AS SONPHEP
      FROM CHAMCONG 
      GROUP BY  CHAMCONG.MANV
   DELETE CHAMCONG 
   WHERE MANV = ( SELECT MANV FROM @BANG 
       WHERE SNP > @SNP)
   DELETE NHANVIEN
   WHERE MANV = ( SELECT MANV FROM @BANG 
       WHERE SNP> @SNP)
  COMMIT TRAN

 END TRY
 BEGIN CATCH
  ROLLBACK TRAN 
 END CATCH
GO
EXEC SPXOANV 6
SELECT*FROM CHAMCONG
SELECT*FROM NHANVIEN