/*? Vi?t chuong trình xem xét có tang luong cho nhân viên hay không. Hi?n th? c?t th? 1 là
TenNV, c?t th? 2 nh?n giá tr?
o “TangLuong” n?u luong hi?n t?i c?a nhân viên nh? hon trung bình luong trong
phòng mà nhân viên dó dang làm vi?c.
o “KhongTangLuong “ n?u luong hi?n t?i c?a nhân viên l?n hon trung bình luong
trong phòng mà nhân viên dó dang làm vi?c.
? Vi?t chuong trình phân lo?i nhân viên d?a vào m?c luong.
o N?u luong nhân viên nh? hon trung bình luong mà nhân viên dó dang làm vi?c thì
x?p lo?i “nhanvien”, ngu?c l?i x?p lo?i “truongphong”*/

/* .Vi?t chuong trình hi?n th? TenNV nhu hình bên du?i, tùy vào c?t phái c?a nhân viên*/

/* Vi?t chuong trình tính thu? mà nhân viên ph?i dóng theo công th?c:
o 0&lt;luong&lt;25000 thì dóng 10% ti?n luong
o 25000&lt;luong&lt;30000 thì dóng 12% ti?n luong
o 30000&lt;luong&lt;40000 thì dóng 15% ti?n luong
o 40000&lt;luong&lt;50000 thì dóng 20% ti?n luong
o Luong&gt;50000 dóng 25% ti?n luong*/

DECLARE @LTB AS FLOAT
SELECT @LTB = AVG(LUONG) FROM NHANVIEN GROUP BY PHG
--TRUY V?N
SELECT CASE 
           WHEN PHAI = N'N?' THEN 'Ms.' + TENNV
		   WHEN PHAI = N'NAM' THEN 'Mr.' + TENNV
       END AS TENNV, LUONG,
	   CASE
	   WHEN LUONG BETWEEN 0 AND 25000 THEN LUONG * 0.1
	    WHEN LUONG BETWEEN 25000 AND 30000 THEN LUONG * 0.12
		 WHEN LUONG BETWEEN 30000 AND 40000 THEN LUONG * 0.15
		  WHEN LUONG BETWEEN 40000 AND 50000 THEN LUONG * 0.2
		   ELSE LUONG * 0.25
	   END AS THUE,
       IIF(LUONG < @LTB, N'TANG LUONG', N'KHÔNG TANG LUONG') AS DCHINH,
	   IIF(LUONG < @LTB, N'NHÂN VIÊN', N'TRƯỞNG PHÒNG') AS XLOAI
FROM NHANVIEN

/* Cho bi?t thông tin nhân viên (HONV, TENLOT, TENNV) có MaNV là s? ch?n.*/

SELECT HONV, TENLOT, TENNV, MANV
FROM NHANVIEN
WHERE CAST(RIGHT(MANV,1) AS INT) % 2 = 0

/* Cho bi?t thông tin nhân viên (HONV, TENLOT, TENNV) có MaNV là s? ch?n nhung
không tính nhân viên có MaNV là 4.*/

SELECT HONV, TENLOT, TENNV, MANV
FROM NHANVIEN
WHERE CAST(RIGHT(MANV,1) AS INT) % 2 = 0 AND MANV NOT LIKE '%4'

/*Th?c hi?n chèn thêm m?t dòng d? li?u vào b?ng PhongBan theo 2 bu?c
o Nh?n thông báo “ thêm du lieu thành cong” t? kh?i Try
o Chèn sai ki?u d? li?u c?t MaPHG d? nh?n thông báo l?i “Them du lieu that bai”
t? kh?i Catch */

BEGIN TRY
    INSERT PHONGBAN VALUES ('ABC',7,'008','10-08-2010')
	PRINT N'THÊM D? LI?U THÀNH CÔNG'
	
END TRY
  
BEGIN CATCH
    PRINT N'THÊM D? LI?U TH?T B?I'
END CATCH

SELECT * FROM PHONGBAN
DELETE FROM PHONGBAN WHERE MAPHG = 7
/*? Vi?t chuong trình khai báo bi?n @chia, th?c hi?n phép chia @chia cho s? 0 và dùng
RAISERROR d? thông báo l?i.*/

BEGIN TRY
   DECLARE @CHIA INT
   SET @CHIA = 10/0

END TRY
  
BEGIN CATCH
    DECLARE @TB NVARCHAR(200), @MD INT, @TT INT
	SELECT @TB = ERROR_MESSAGE(), @MD = ERROR_SEVERITY(), @TT = ERROR_STATE()
	RAISERROR(@TB, @MD, @TT)
END CATCH
