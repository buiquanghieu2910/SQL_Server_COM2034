--BAI 1:

IF OBJECT_ID('SPBAI1') IS NOT NULL
	DROP PROC SPBAI1
GO

CREATE PROC SPBAI1
	@MANV_NVIEN VARCHAR(10) = NULL, @TENTN NVARCHAR(50) = NULL, @PHAI NVARCHAR(10) = NULL, @NGSINH DATE = NULL, @QUANHE NVARCHAR(20) = NULL
AS
	BEGIN TRY
		IF(@MANV_NVIEN IS NULL OR @TENTN IS NULL OR @PHAI IS NULL OR @NGSINH IS NULL OR @QUANHE IS NULL)
			BEGIN
				PRINT N'C�C C?T KH�NG ???C ?? TR?NG' 
				RETURN
			END
		ELSE IF EXISTS(SELECT * FROM THANNHAN WHERE MA_NVIEN = @MANV_NVIEN AND TENTN = @TENTN)
			BEGIN
				PRINT N'L?I KH�A CH�NH, KH�A NGO?I'
				RETURN
			END
		ELSE
			BEGIN 
				INSERT INTO THANNHAN
				VALUES(@MANV_NVIEN,@TENTN,@PHAI,@NGSINH,@QUANHE)

				PRINT N'TH�M TH�NH C�NG'
			END
	END TRY
	BEGIN CATCH
		PRINT N'TH�M TH?T B?I'
	END CATCH

EXEC SPBAI1 '005',N'HIEU',N'NAM','2002-10-29',N'EM TRAI'


--BAI 2:
--C1: KHONG GIA TRI MAC DINH
IF OBJECT_ID('SPBAI2') IS NOT NULL
	DROP PROC SPBAI2
GO

CREATE PROC SPBAI2
	@MANV VARCHAR(10)
AS
	SELECT * FROM THANNHAN WHERE MA_NVIEN = @MANV

EXEC SPBAI2 '001'

--C2:  GIA TRI MAC DINH
IF OBJECT_ID('SPBAI22') IS NOT NULL
	DROP PROC SPBAI22
GO

CREATE PROC SPBAI22
	@MANV VARCHAR(10) = '001'
AS
	SELECT * FROM THANNHAN WHERE MA_NVIEN = @MANV

EXEC SPBAI22


--BAI 3:
IF OBJECT_ID('SPBAI3') IS NOT NULL
     DROP PROC SPBAI3
   GO
     CREATE PROC SPBAI3
     @N INT
   AS
     DECLARE @A INT = 1, @SUM INT = 0
	 WHILE @A <= @N
	      BEGIN
		      SELECT @SUM += @A
			  SET @A +=2
		  END
		  PRINT N'TONG CAC SO LE: ' + CAST (@SUM AS VARCHAR)
EXEC SPBAI3 10


--BAI 4:
   IF OBJECT_ID('SPBAI4') IS NOT NULL
     DROP PROC SPBAI4
   GO
     CREATE PROC SPBAI4
     @TRPHG VARCHAR(10)
   AS
     SELECT* FROM NHANVIEN JOIN PHONGBAN ON NHANVIEN.PHG = PHONGBAN.MAPHG
	 WHERE MAPHG = @TRPHG
  
  EXEC SPBAI4 001