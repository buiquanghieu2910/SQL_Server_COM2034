﻿--4.
SELECT MANV, HONV, TENLOT, TENNV, NGSINH, DCHI, MAPHG, TENPHG, TRPHG
FROM NHANVIEN JOIN PHONGBAN ON PHONGBAN.MAPHG = NHANVIEN.PHG

--5.
SELECT MANV, HONV, TENLOT, TENNV, NGSINH, DCHI, MAPHG, TENPHG, TRPHG
FROM NHANVIEN JOIN PHONGBAN ON PHONGBAN.MAPHG = NHANVIEN.PHG
WHERE TENPHG LIKE N'%Nghiên Cứu%'

----LAB 02: Sử dụng biến thực hiện các công việc:
/*Chương trình tính diện tích, chu vi hình chữ nhật khi biết 
chiều dài và chiều rộng. CV = (CD + CR) * 2; DT = CD * CR*/

	-- KHAI BÁO BIẾN
	DECLARE @CV FLOAT, @DT FLOAT, @CD FLOAT, @CR FLOAT
	-- GÁN GIA TRỊ
	SET @CD = 5.5
	SET @CR = 11
	SET @CV = (@CD + @CR) *2
	SET @DT = @CD * @CR
	-- XUẤT RA MÀN HÌNH
	SELECT @CV AS CHUVIHCN, @DT AS DTHCN

/*Dựa trên csdl QLDA thực hiện truy vấn, các giá trị truyền vào và 
trả ra phải dưới dạng sử dụng biến.
1.	Cho biêt nhân viên có lương cao nhất*/
   SELECT *
   FROM NHANVIEN
   WHERE LUONG = (SELECT MAX(LUONG) FROM NHANVIEN)

   DECLARE @MAX MONEY
   SELECT @MAX = MAX(LUONG) FROM NHANVIEN
   SELECT @MAX AS LUONG_MAX 

/*2.Cho biết họ tên nhân viên (HONV, TENLOT, TENNV) có
mức lương trên mức lương trung bình của phòng "Nghiên cứu”*/
   DECLARE @LTB FLOAT
   SELECT @LTB = AVG(LUONG)
   FROM NHANVIEN JOIN PHONGBAN ON NHANVIEN.PHG = PHONGBAN.MAPHG
   WHERE TENPHG = N'NGHIÊN CỨU'
   SELECT @LTB
   --XUẤT
   SELECT HONV, TENLOT, TENNV 
   FROM NHANVIEN 
   WHERE LUONG > @LTB


/*3. Với các phòng ban có mức lương trung bình trên 30,000, 
liệt kê tên phòng ban và số lượng nhân viên của phòng ban đó.*/
   DECLARE @LTB FLOAT
   SELECT @LTB = AVG(LUONG) FROM NHANVIEN
   SELECT TENPHG, COUNT(MANV) AS SO_LUONG
   FROM NHANVIEN JOIN PHONGBAN ON NHANVIEN.PHG = PHONGBAN.MAPHG
   WHERE @LTB > 30000
   GROUP BY TENPHG
   --c2: Biến bảng
   DECLARE @BT3 TABLE
(	TENPHG	NVARCHAR(50),
	SL		INT)
INSERT INTO @BT3
	SELECT TENPHG, COUNT(MANV) AS SLNV
	FROM PHONGBAN JOIN NHANVIEN ON PHONGBAN.MAPHG = NHANVIEN.PHG
	WHERE 30000 < (SELECT AVG(LUONG) FROM NHANVIEN)
	GROUP BY TENPHG
UPDATE @BT3
SET TENPHG = 'NCKH'
WHERE TENPHG = N'NGHIÊN CỨU'
SELECT * FROM @BT3


/*4.Với mỗi phòng ban, cho biết tên phòng ban và số lượng đề án 
mà phòng ban đó chủ trì*/
   
   --CÓ SỬ DỤNG BIẾN
   DECLARE @SLDA INT
   SELECT @SLDA = COUNT(MADA)
   FROM PHONGBAN JOIN DEAN ON PHONGBAN.MAPHG = DEAN.PHONG
   SELECT TENPHG, COUNT(@SLDA) AS SLDA
   FROM PHONGBAN JOIN DEAN ON PHONGBAN.MAPHG = DEAN.PHONG
   GROUP BY TENPHG

   --KHÔNG SỬ DỤNG BIẾN
   SELECT TENPHG, COUNT(MADA) AS SO_LUONG_DA
   FROM PHONGBAN JOIN DEAN ON PHONGBAN.MAPHG = DEAN.PHONG
   GROUP BY TENPHG

   --BIẾN BẢNG
   DECLARE @BT4 TABLE 
(	TENPHG	NVARCHAR(50), SLDA INT)
INSERT INTO @BT4
	SELECT TENPHG, COUNT(MADA) AS SL
	FROM PHONGBAN JOIN DEAN ON PHONGBAN.MAPHG = DEAN.PHONG
GROUP BY TENPHG
SELECT * FROM @BT4
