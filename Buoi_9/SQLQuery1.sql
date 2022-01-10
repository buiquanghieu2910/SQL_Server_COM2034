--B�i 1: (3 ?i?m)
/*Vi?t stored-procedure:*/
/*In ra d�ng �Xin ch�o� + @ten v?i @ten l� tham s? ??u v�o l� t�n Ti?ng Vi?t c� d?u c?a
b?n. G?i �:*/
/* s? d?ng UniKey ?? g� Ti?ng Vi?t ?*/
/* chu?i unicode ph?i b?t ??u b?i N (vd: N�Ti?ng Vi?t�) ? */
/* d�ng h�m cast (<bi?uTh?c> as <ki?u>) ?? ??i th�nh ki?u <ki?u>
c?a <bi?uTh?c>.*/
   IF OBJECT_ID('SPCHAO') IS NOT NULL
     DROP PROC SPCHAO
   GO
     CREATE PROC SPCHAO
     @TEN NVARCHAR(50)
   AS
     PRINT N'XIN CHAO ' + @TEN
EXEC SPCHAO N'B�I QUANG HI?U'
EXEC SPCHAO N'NGUY?N TH? TH�Y TRANG'

/* Nh?p v�o 2 s? @s1,@s2. In ra c�u �T?ng l� : @tg� v?i @tg=@s1+@s2. */
IF OBJECT_ID('SPTONG') IS NOT NULL
	DROP PROC SPTONG
GO
CREATE PROC SPTONG
	@S1 INT, @S2 INT
AS
	DECLARE @TG INT = @S1 + @S2 
	PRINT N'T?NG L�: ' + CONVERT(VARCHAR,@TG)
GO
EXEC SPTONG 6,7

/* Nh?p v�o s? nguy�n @n. In ra t?ng c�c s? ch?n t? 1 ??n @n. */
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
	PRINT N'T?NG L�: ' + CAST(@TG AS VARCHAR)
GO
EXEC SPTONGCHAN 10

/* Nh?p v�o 2 s?. In ra ??c chung l?n nh?t c?a ch�ng theo g?i � d??i ?�y:*/

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
	PRINT N'UCLN L�: ' + CONVERT(VARCHAR, @S1)
GO
	EXEC SPUCLN 3,30

/* b1. Kh�ng m?t t�nh t?ng qu�t gi? s? a &lt;= A*/
/* b2. N?u A chia h?t cho a th� : (a,A) = a ng??c l?i : (a,A) = (A%a,a) ho?c (a,A) =
(a,A-a)*/
/* b3. L?p l?i b1,b2 cho ??n khi ?i?u ki?n trong b2 ???c th?a*/

--B�i 2: (3 ?i?m)
/*S? d?ng c? s? d? li?u QLDA, Vi?t c�c Proc:*/
/* Nh?p v�o @Manv, xu?t th�ng tin c�c nh�n vi�n theo @Manv.*/

   IF OBJECT_ID('SPBAI2_1') IS NOT NULL
     DROP PROC SPBAI2_1
   GO
     CREATE PROC SPBAI2_1
	       @MANV INT
	AS
	  SELECT * FROM NHANVIEN
	  WHERE MANV = @MANV
EXEC SPBAI2_1 1

/* Nh?p v�o @MaDa (m� ?? �n), cho bi?t s? l??ng nh�n vi�n tham gia ?? �n ?� */
IF OBJECT_ID('SPBAI2_2') IS NOT NULL
     DROP PROC SPBAI2_2
   GO
     CREATE PROC SPBAI2_2
	       @MADA INT
   AS 
     SELECT COUNT(MA_NVIEN) AS SLNV FROM PHANCONG
	 WHERE MADA = @MADA

	EXEC SPBAI2_2 3
/* Nh?p v�o @MaDa v� @Ddiem_DA (??a ?i?m ?? �n), cho bi?t s? l??ng nh�n vi�n tham
gia ?? �n c� m� ?? �n l� @MaDa v� ??a ?i?m ?? �n l� @Ddiem_DA */

IF OBJECT_ID('SPBAI2_3') IS NOT NULL
     DROP PROC SPBAI2_3
   GO
     CREATE PROC SPBAI2_3
	       @MADA INT, @Ddiem_DA NVARCHAR(100)
   AS
     SELECT COUNT(MA_NVIEN) AS SLNV FROM PHANCONG JOIN DEAN ON PHANCONG.MADA = DEAN.MADA
	 WHERE DEAN.MADA = @MADA AND DDIEM_DA = @Ddiem_DA 

	 EXEC SPBAI2_3 1, N'H� N?I'
/* Nh?p v�o @Trphg (m� tr??ng ph�ng), xu?t th�ng tin c�c nh�n vi�n c� tr??ng ph�ng l�
@Trphg v� c�c nh�n vi�n n�y kh�ng c� th�n nh�n.*/

---C1: KO S? D?NG PROC
SELECT * 
FROM NHANVIEN JOIN PHONGBAN ON NHANVIEN.PHG =PHONGBAN.MAPHG
WHERE TRPHG = 5 AND MANV  NOT IN (SELECT MA_NVIEN
								FROM THANNHAN)
---C2: S? D?NG PROC
------<B�I KTRA> 

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

/* Nh?p v�o @Manv v� @Mapb, ki?m tra nh�n vi�n c� m� @Manv c� thu?c ph�ng ban c�
m� @Mapb hay kh�ng*/ 
IF OBJECT_ID('SPBAI2_5') IS NOT NULL
     DROP PROC SPBAI2_5
   GO
     CREATE PROC SPBAI2_5
	       @MANV INT, @MAPB INT
AS
  BEGIN 
      IF @MANV NOT IN (SELECT MANV FROM NHANVIEN WHERE PHG = @MAPB)
	  PRINT N'MANV: ' +CAST(@MANV AS VARCHAR) +
	        N' KH�NG THU?C PH�NG: ' + CAST(@MAPB AS VARCHAR) 
	ELSE
	  PRINT N'MANV: ' +CAST(@MANV AS VARCHAR) +
	        N' THU?C PH�NG: ' + CAST(@MAPB AS VARCHAR) 
END

EXEC SPBAI2_5 4,5
EXEC SPBAI2_5 4,1

--B�i 3: (3 ?i?m)
/* S? d?ng c? s? d? li?u QLDA, Vi?t c�c Proc */
/* Th�m ph�ng ban c� t�n CNTT v�o csdl QLDA, c�c gi� tr? ???c th�m v�o d??i d?ng
tham s? ??u v�o, ki?m tra n?u tr�ng Maphg th� th�ng b�o th�m th?t b?i*/
/* C?p nh?t ph�ng ban c� t�n CNTT th�nh ph�ng IT.*/
/* Th�m m?t nh�n vi�n v�o b?ng NhanVien, t?t c? gi� tr? ??u truy?n d??i d?ng tham s? ??u
v�o v?i ?i?u ki?n: */
/*nh�n vi�n n�y tr?c thu?c ph�ng IT*/
/* Nh?n @luong l�m tham s? ??u v�o cho c?t Luong, n?u @luong&lt;25000 th� nh�n
vi�n n�y do nh�n vi�n c� m� 009 qu?n l�, ng??c l?i do nh�n vi�n c� m� 005 qu?n
l� */
/* N?u l� nh�n vi�n nam thi nh�n vi�n ph?i n?m trong ?? tu?i 18-65, n?u l� nh�n
vi�n n? th� ?? tu?i ph?i t? 18-60. */
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
PRINT N'NH?P SAI, NH?P L?I V� NH�N VI�N KH�NG THU?C PH�NG IT'
ELSE IF @PHAI = 'NAM' AND (@TUOI < 18 OR @TUOI > 65)
PRINT N'NH�N VI�N NAM PH?I TU?I T? 18 ??N 65'
ELSE IF @PHAI = N'N?' AND (@TUOI < 18 OR @TUOI > 60)
PRINT N'NH�N VI�N N? PH?I TU?I T? 18 ??N 60'
ELSE
INSERT INTO NHANVIEN 
VALUES(@HONV, @TENLOT,@TENNV,@MANV,@NGSINH,@DCHI,@PHAI,@LUONG,
IIF(@LUONG < 25000,'009','005'),@PHG)
-----G?I
EXEC SPINRNV'A','B','C','00000','2016-10-10','HN','NAM',16000,NULL,6
EXEC SPINRNV'A','B','C','00000','1977-10-10','HN','NAM',30000,NULL,6

SELECT * FROM NHANVIEN


--CH�N DL V�O B?NG DDIEM_PHG
--V?I ?K KH�NG C� C?T ???C ?? TR?NG
IF OBJECT_ID('SPINRDD') IS NOT NULL
   DROP PROC SPINRDD
GO
CREATE PROC SPINRDD
     @MAPHG INT, @DIADIEM NVARCHAR(50)
AS
    IF @MAPHG IS NULL OR @DIADIEM IS NULL
	  PRINT N'C?T KH�NG ???C ?? TR?NG'
	ELSE 
	  INSERT INTO DIADIEM_PHG VALUES(@MAPHG, @DIADIEM)

--G?I KH�NG TH�NH C�NG
EXEC SPINRDD 1, NULL
--G?I TH�NH C�NG
EXEC SPINRDD 1, N'NHA TRANG'
SELECT * FROM DIADIEM_PHG
