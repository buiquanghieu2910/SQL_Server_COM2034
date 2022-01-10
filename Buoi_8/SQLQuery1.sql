/*Bài 1: (4 điểm)
Đưa ra thông nhân viên như sau: MaNV, TenNV, giới tính, ngày sinh, tuổi,
trạng thái. Trong đó:
- Giới tính: Dùng iif: Phái Nam thì ghi là Mr, còn lại ghi Mrs.
- Trạng thái (dùng case) : + Nếu tuổi <18: Trẻ em.
+ Tuổi từ 18 đến <60: Lao động,
+ Còn lại: Tuổi già */

SELECT MANV, TENNV,
IIF(PHAI = N'NAM', N'Mr', N'Mrs') AS GIOITINH,
NGSINH, 2021 - YEAR(NGSINH) AS TUOI,
 CASE
	   WHEN 2021 - YEAR(NGSINH) BETWEEN 0 AND 17 THEN N'TRẺ EM'
	    WHEN 2021 - YEAR(NGSINH) BETWEEN 18 AND 60 THEN N'LAO ĐỘNG'
		   ELSE N'TUỔI GIÀ'
	   END AS TRANGTHAI
FROM NHANVIEN 



/*Bài 2: (3 điểm)
Thực hiện chèn thêm một dòng dữ liệu vào bảng DEAN theo 2 bước
o Nhận thông báo “ thêm dư lieu thành cong” từ khối Try
o Thêm thất bại để nhận thông báo lỗi “Thêm dư liệu thất bại” từ khối Catch */

BEGIN TRY
   
	INSERT DEAN VALUES (N'Sản Phẩm x', 4,'Hà Nội', 5)
	PRINT N'THÊM DỮ LIỆU THÀNH CÔNG'
END TRY
  
BEGIN CATCH
    PRINT N'THÊM DỮ LIỆU THẤT BẠI'
END CATCH

SELECT * FROM DEAN
DELETE FROM DEAN WHERE MADA = 4


/* Bài 3: Sử dụng vòng lặp WHILE: (3 điểm)
Viết chương trình tính tổng số lẻ từ 1 đến n:
- Khai báo 2 biến: @a và @n. Với @a = 1 và @n = 10
- Cấu trúc điều khiển WHILE, IF .. ELSE để tìm và xuất ra màn hình tổng số
lẻ của 2 biến từ @a đến @n. */

DECLARE @A INT, @N INT, @TONG INT
SELECT @A =1, @N = 10, @TONG = 1

WHILE @A < @N
BEGIN 
SET @A =  @A+1
IF @A%2=1
SET @TONG = @TONG + @A
END 
PRINT @TONG
 