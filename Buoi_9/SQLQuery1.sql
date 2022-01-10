--Bài 1: (3 ?i?m)
/*Vi?t stored-procedure:*/
/*In ra dòng ‘Xin chào’ + @ten v?i @ten là tham s? ??u vào là tên Ti?ng Vi?t có d?u c?a
b?n. G?i ý:*/
/* s? d?ng UniKey ?? gõ Ti?ng Vi?t ?*/
/* chu?i unicode ph?i b?t ??u b?i N (vd: N’Ti?ng Vi?t’) ? */
/* dùng hàm cast (<bi?uTh?c> as <ki?u>) ?? ??i thành ki?u <ki?u>
c?a <bi?uTh?c>.*/
   IF OBJECT_ID('SPCHAO') IS NOT NULL
     DROP PROC SPCHAO
   GO
     CREATE PROC SPCHAO
     @TEN NVARCHAR(50)
   AS
     PRINT N'XIN CHAO ' + @TEN
EXEC SPCHAO N'BÙI QUANG HI?U'
EXEC SPCHAO N'NGUY?N TH? THÙY TRANG'

/* Nh?p vào 2 s? @s1,@s2. In ra câu ‘T?ng là : @tg’ v?i @tg=@s1+@s2. */
IF OBJECT_ID('SPTONG') IS NOT NULL
	DROP PROC SPTONG
GO
CREATE PROC SPTONG
	@S1 INT, @S2 INT
AS
	DECLARE @TG INT = @S1 + @S2 
	PRINT N'T?NG LÀ: ' + CONVERT(VARCHAR,@TG)
GO
EXEC SPTONG 6,7

/* Nh?p vào s? nguyên @n. In ra t?ng các s? ch?n t? 1 ??n @n. */
   IF OBJECT_ID('SPCHAN') IS NOT NULL
     DROP PROC SPCHAN
   GO
     CREATE PROC SPCHAN
     @N INT
   AS
     DECLARE @A INT = 2, @TONG INT = 0
	 WHILE @A <= @N
	      BEGIN
		      SELECT @TONG += @A
			  SET @A +=2
		  END
		  PRINT N'TONG CAC SO CHAN: ' + CAST (@TONG AS VARCHAR)
EXEC SPCHAN 10



IF OBJECT_ID('SPTONGCHAN') IS NOT NULL
	DROP PROC SPTONGCHAN
GO
CREATE PROC SPTONGCHAN
	@N INT
AS
	DECLARE @I INT = 1, @TG INT = 0
	WHILE @I<=@N
		BEGIN
			IF @I%2=0
				SET @TG = @TG + @I
			SET @I = @I + 1
		END
	PRINT N'T?NG LÀ: ' + CAST(@TG AS VARCHAR)
GO
EXEC SPTONGCHAN 10

/* Nh?p vào 2 s?. In ra ??c chung l?n nh?t c?a chúng theo g?i ý d??i ?ây:*/

IF OBJECT_ID('SPUCLN') IS NOT NULL
	DROP PROC SPUCLN
GO
CREATE PROC SPUCLN
	@S1  INT, @S2 INT
AS 
	WHILE (@S1 != @S2)
		BEGIN 
			IF (@S1 > @S2) 
				SET @S1 = @S1 - @S2
			ELSE 
				SET @S2 = @S2 - @S1
		END
	PRINT N'UCLN LÀ: ' + CONVERT(VARCHAR, @S1)
GO
	EXEC SPUCLN 3,30

/* b1. Không m?t tính t?ng quát gi? s? a &lt;= A*/
/* b2. N?u A chia h?t cho a thì : (a,A) = a ng??c l?i : (a,A) = (A%a,a) ho?c (a,A) =
(a,A-a)*/
/* b3. L?p l?i b1,b2 cho ??n khi ?i?u ki?n trong b2 ???c th?a*/

--Bài 2: (3 ?i?m)
/*S? d?ng c? s? d? li?u QLDA, Vi?t các Proc:*/
/* Nh?p vào @Manv, xu?t thông tin các nhân viên theo @Manv.*/

   IF OBJECT_ID('SPBAI2_1') IS NOT NULL
     DROP PROC SPBAI2_1
   GO
     CREATE PROC SPBAI2_1
	       @MANV INT
	AS
	  SELECT * FROM NHANVIEN
	  WHERE MANV = @MANV
EXEC SPBAI2_1 1

/* Nh?p vào @MaDa (mã ?? án), cho bi?t s? l??ng nhân viên tham gia ?? án ?ó */
IF OBJECT_ID('SPBAI2_2') IS NOT NULL
     DROP PROC SPBAI2_2
   GO
     CREATE PROC SPBAI2_2
	       @MADA INT
   AS 
     SELECT COUNT(MA_NVIEN) AS SLNV FROM PHANCONG
	 WHERE MADA = @MADA

	EXEC SPBAI2_2 3
/* Nh?p vào @MaDa và @Ddiem_DA (??a ?i?m ?? án), cho bi?t s? l??ng nhân viên tham
gia ?? án có mã ?? án là @MaDa và ??a ?i?m ?? án là @Ddiem_DA */

IF OBJECT_ID('SPBAI2_3') IS NOT NULL
     DROP PROC SPBAI2_3
   GO
     CREATE PROC SPBAI2_3
	       @MADA INT, @Ddiem_DA NVARCHAR(100)
   AS
     SELECT COUNT(MA_NVIEN) AS SLNV FROM PHANCONG JOIN DEAN ON PHANCONG.MADA = DEAN.MADA
	 WHERE DEAN.MADA = @MADA AND DDIEM_DA = @Ddiem_DA 

	 EXEC SPBAI2_3 1, N'HÀ N?I'
/* Nh?p vào @Trphg (mã tr??ng phòng), xu?t thông tin các nhân viên có tr??ng phòng là
@Trphg và các nhân viên này không có thân nhân.*/

---C1: KO S? D?NG PROC
SELECT * 
FROM NHANVIEN JOIN PHONGBAN ON NHANVIEN.PHG =PHONGBAN.MAPHG
WHERE TRPHG = 5 AND MANV  NOT IN (SELECT MA_NVIEN
								FROM THANNHAN)
---C2: S? D?NG PROC
------<BÀI KTRA> 

IF OBJECT_ID('SPTRPHG') IS NOT NULL
	DROP PROC SPTRPHG
GO
CREATE PROC SPTRPHG
	@Trphg INT
AS
	SELECT * FROM NHANVIEN JOIN PHONGBAN
		ON NHANVIEN.PHG = PHONGBAN.MAPHG
	WHERE TRPHG = @Trphg AND MANV NOT IN (SELECT MA_NVIEN
										FROM THANNHAN)
-----G?I
EXEC SPTRPHG 5

/* Nh?p vào @Manv và @Mapb, ki?m tra nhân viên có mã @Manv có thu?c phòng ban có
mã @Mapb hay không*/ 
IF OBJECT_ID('SPBAI2_5') IS NOT NULL
     DROP PROC SPBAI2_5
   GO
     CREATE PROC SPBAI2_5
	       @MANV INT, @MAPB INT
AS
  BEGIN 
      IF @MANV NOT IN (SELECT MANV FROM NHANVIEN WHERE PHG = @MAPB)
	  PRINT N'MANV: ' +CAST(@MANV AS VARCHAR) +
	        N' KHÔNG THU?C PHÒNG: ' + CAST(@MAPB AS VARCHAR) 
	ELSE
	  PRINT N'MANV: ' +CAST(@MANV AS VARCHAR) +
	        N' THU?C PHÒNG: ' + CAST(@MAPB AS VARCHAR) 
END

EXEC SPBAI2_5 4,5
EXEC SPBAI2_5 4,1

--Bài 3: (3 ?i?m)
/* S? d?ng c? s? d? li?u QLDA, Vi?t các Proc */
/* Thêm phòng ban có tên CNTT vào csdl QLDA, các giá tr? ???c thêm vào d??i d?ng
tham s? ??u vào, ki?m tra n?u trùng Maphg thì thông báo thêm th?t b?i*/
/* C?p nh?t phòng ban có tên CNTT thành phòng IT.*/
/* Thêm m?t nhân viên vào b?ng NhanVien, t?t c? giá tr? ??u truy?n d??i d?ng tham s? ??u
vào v?i ?i?u ki?n: */
/*nhân viên này tr?c thu?c phòng IT*/
/* Nh?n @luong làm tham s? ??u vào cho c?t Luong, n?u @luong&lt;25000 thì nhân
viên này do nhân viên có mã 009 qu?n lý, ng??c l?i do nhân viên có mã 005 qu?n
lý */
/* N?u là nhân viên nam thi nhân viên ph?i n?m trong ?? tu?i 18-65, n?u là nhân
viên n? thì ?? tu?i ph?i t? 18-60. */
IF OBJECT_ID('SPINRNV') IS NOT NULL
     DROP PROC SPINRNV
GO
    CREATE PROC SPINRNV
	    @HONV NVARCHAR(15), @TENLOT NVARCHAR(15), @TENNV NVARCHAR(15),
@MANV VARCHAR(10), @NGSINH DATETIME, @DCHI NVARCHAR(50),
@PHAI NVARCHAR(5), @LUONG MONEY, @MA_NQL VARCHAR(5), @PHG INT
AS
DECLARE @TUOI INT = DATEDIFF(YEAR, @NGSINH, GETDATE())
IF(@PHG != (SELECT MAPHG FROM PHONGBAN WHERE TENPHG = 'IT'))
PRINT N'NH?P SAI, NH?P L?I VÌ NHÂN VIÊN KHÔNG THU?C PHÒNG IT'
ELSE IF @PHAI = 'NAM' AND (@TUOI < 18 OR @TUOI > 65)
PRINT N'NHÂN VIÊN NAM PH?I TU?I T? 18 ??N 65'
ELSE IF @PHAI = N'N?' AND (@TUOI < 18 OR @TUOI > 60)
PRINT N'NHÂN VIÊN N? PH?I TU?I T? 18 ??N 60'
ELSE
INSERT INTO NHANVIEN 
VALUES(@HONV, @TENLOT,@TENNV,@MANV,@NGSINH,@DCHI,@PHAI,@LUONG,
IIF(@LUONG < 25000,'009','005'),@PHG)
-----G?I
EXEC SPINRNV'A','B','C','00000','2016-10-10','HN','NAM',16000,NULL,6
EXEC SPINRNV'A','B','C','00000','1977-10-10','HN','NAM',30000,NULL,6

SELECT * FROM NHANVIEN


--CHÈN DL VÀO B?NG DDIEM_PHG
--V?I ?K KHÔNG CÓ C?T ???C ?? TR?NG
IF OBJECT_ID('SPINRDD') IS NOT NULL
   DROP PROC SPINRDD
GO
CREATE PROC SPINRDD
     @MAPHG INT, @DIADIEM NVARCHAR(50)
AS
    IF @MAPHG IS NULL OR @DIADIEM IS NULL
	  PRINT N'C?T KHÔNG ???C ?? TR?NG'
	ELSE 
	  INSERT INTO DIADIEM_PHG VALUES(@MAPHG, @DIADIEM)

--G?I KHÔNG THÀNH CÔNG
EXEC SPINRDD 1, NULL
--G?I THÀNH CÔNG
EXEC SPINRDD 1, N'NHA TRANG'
SELECT * FROM DIADIEM_PHG
