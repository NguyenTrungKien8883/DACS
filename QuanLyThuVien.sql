ALTER DATABASE QLTV SET SINGLE_USER WITH ROLLBACK IMMEDIATE
DROP DATABASE QLTV
CREATE DATABASE QLTV
go

USE QLTV
go
CREATE TABLE NHOMNGUOIDUNG
(
	id int IDENTITY(1,1) primary key,
	MaNhomNguoiDung AS CAST('NND' + right('000' + CAST(id as varchar(5)), 3) AS CHAR(6)) persisted ,
	TenNhomNguoiDung nvarchar(30) NOT NULL
);

go
CREATE TABLE CHUCNANG
(
     id int  primary key IDENTITY(1,1),
	 MaChucNang AS CAST('CN' + right('000' + CAST(id as varchar(3)), 3) as char(10))persisted,
     TenChucNang NVARCHAR(50) NOT NULL,
     TenForm NVARCHAR(50) NOT NULL
)

go
CREATE TABLE PHANQUYEN
(
    idNhomNguoiDung INT FOREIGN KEY REFERENCES NHOMNGUOIDUNG on delete cascade,
    idChucNang INT FOREIGN KEY REFERENCES CHUCNANG on delete cascade,
    PRIMARY KEY (idNhomNguoiDung, idChucNang)
)

go
CREATE TABLE NGUOIDUNG
(
	id INT IDENTITY PRIMARY KEY,
	MaNguoiDung  AS CAST('ND'+ RIGHT('000000' + CAST(id AS VARCHAR(4)), 4) AS CHAR(6)) PERSISTED,
    TenNguoiDung NVARCHAR(30) NOT NULL,
    ChucVu NVARCHAR(30) NOT NULL,
    TenDangNhap VARCHAR(50) UNIQUE NOT NULL,
	Email VARCHAR(50) UNIQUE NOT NULL,
    MatKhau VARCHAR(100) NOT NULL,
    idNhomNguoiDung INT REFERENCES NHOMNGUOIDUNG on delete cascade NOT NULL
)

go
CREATE TABLE THELOAI
(
	id int IDENTITY(1,1)  primary key,
	MaTheLoai As Cast('TL' + right('0000' + CAST(id as varchar(4)), 4) as char(6)) persisted,  
	TenTheLoai NVARCHAR(30) NOT NULL
)

go

CREATE TABLE TUASACH
(
	id INT IDENTITY PRIMARY KEY,
	MaTuaSach  AS cast('TS'+ right('0000' + CAST(ID AS VARCHAR(10)), 4) as char(6)) PERSISTED,
	TenTuaSach NVARCHAR(100) NOT NULL,
	idTheLoai int references THELOAI NOT NULL,
	ViTri NVARCHAR(50),
	DaAn bit DEFAULT 0
)

go

CREATE TABLE THONGBAO
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    TieuDe NVARCHAR(100) NOT NULL,
    NoiDung NVARCHAR(MAX) NOT NULL,
    NgayDang DATETIME DEFAULT GETDATE(),
    idNguoiDung INT REFERENCES NGUOIDUNG ON DELETE SET NULL
)

go
CREATE TABLE TACGIA
(
	id INT IDENTITY PRIMARY KEY,
	MATACGIA  AS CAST('TG'+ RIGHT('0000' + CAST(ID AS VARCHAR(10)), 4) AS CHAR(6))PERSISTED,
	TenTacGia NVARCHAR(30) NOT NULL
)

go
CREATE TABLE CT_TACGIA
(
	idTacGia int references TACGIA  on delete cascade,
	idTuaSach int references TUASACH on delete cascade,
	primary key (idTacGia, idTuaSach)
)

go

CREATE TABLE LOAIDOCGIA
(
	id INT IDENTITY(1,1) PRIMARY KEY,
	MaLoaiDocGia  AS CAST('LDG'+ RIGHT('000' + CAST(ID AS VARCHAR(10)), 3) AS CHAR(6))PERSISTED,
	TenLoaiDocGia NVARCHAR(30) NOT NULL
)

go
CREATE TABLE DOCGIA
(
	ID int IDENTITY(1,1) PRIMARY KEY,
	MaDocGia  AS CAST('DG'+ RIGHT('0000' + CAST(ID AS VARCHAR(10)), 4) AS CHAR(6))PERSISTED,
	TenDocGia NVARCHAR(30) NOT NULL,
	NgaySinh datetime NOT NULL, 
	DiaChi NVARCHAR(100) NOT NULL,
	SDT VARCHAR(20) UNIQUE NOT NULL,
	Khoa NVARCHAR(50) NULL,
	NgayLapThe Datetime NOT NULL, 
	NgayHetHan Datetime NOT NULL, 
	idLoaiDocGia INT references LOAIDOCGIA NOT NULL, 
	TongNoHienTai INT NOT NULL DEFAULT 0 CHECK (TongNoHienTai >= 0),
	idNguoiDung INT REFERENCES NGUOIDUNG(id) ON DELETE CASCADE
)

CREATE TABLE LOAINHANVIEN
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    MaLoaiNhanVien AS CAST('LNV' + RIGHT('000' + CAST(id AS VARCHAR(10)), 3) AS CHAR(6)) PERSISTED,
    TenLoaiNhanVien NVARCHAR(100) NOT NULL UNIQUE
)

go 
CREATE TABLE NHANVIEN
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    MaNhanVien AS CAST('NV' + RIGHT('0000' + CAST(id AS VARCHAR(10)), 4) AS CHAR(6)) PERSISTED,
    HoTen NVARCHAR(30) NOT NULL,
    NgaySinh DATE NOT NULL,
    GioiTinh NVARCHAR(10) CHECK (GioiTinh IN ('Nam', N'Nữ', N'Khác')),
    DiaChi NVARCHAR(100),
    SDT VARCHAR(20) UNIQUE NOT NULL,
    idLoaiNhanVien INT NOT NULL REFERENCES LOAINHANVIEN(id),
    NgayVaoLam DATE NOT NULL,
    Luong DECIMAL(10,2) CHECK (Luong >= 0) NOT NULL,
    idNguoiDung INT REFERENCES NGUOIDUNG(id) ON DELETE CASCADE
)

go
CREATE TABLE SACH
(
	id int IDENTITY(1,1) primary key,
	MaSach AS CAST('S'+ RIGHT('00000' + CAST(id AS VARCHAR(10)), 5) AS CHAR(6)) PERSISTED,
	idTuaSach int references TUASACH NOT NULL, 
	SoLuong int NOT NULL, 
	SoLuongConLai int NOT NULL, 
	DonGia int NOT NULL, 
	NamXB int NOT NULL, 
	NhaXB NVARCHAR(50) NOT NULL,
	MaISBN VARCHAR(20) UNIQUE,
	DaAn bit NOT NULL DEFAULT 0
)

go
CREATE TABLE PHIEUNHAPSACH
(
	SoPhieuNhap int IDENTITY(1,1) primary key,
	TongTien int NOT NULL DEFAULT 0, 
	NgayNhap Datetime NOT NULL
)
go

CREATE TABLE CT_PHIEUNHAP
(
	SoPhieuNhap int references PHIEUNHAPSACH(SoPhieuNhap),
	idSach int references SACH,
	DonGia int NOT NULL, 
	ThanhTien int NOT NULL, 
	SoLuongNhap int NOT NULL, 
	primary key (SoPhieuNhap, idSach)
)
go 
create table CUONSACH
(
	id int IDENTITY(1,1) primary key,
	MaCuonSach AS CAST('CS'+ RIGHT('0000' + CAST(id AS VARCHAR(10)), 4) AS CHAR(6)) PERSISTED,
	idSach int references SACH NOT NULL,
	TinhTrang NVARCHAR(20) NOT NULL DEFAULT 'Bình thường' CHECK (TinhTrang IN ('Bình thường', 'Hỏng', 'Đang mượn', 'Mất')),
	DaAn bit NOT NULL DEFAULT 0
)
go
create table PHIEUMUONTRA
(
	SoPhieuMuonTra int IDENTITY(1,1) primary key,
	idDocGia int references DOCGIA NOT NULL,
	idCuonSach int references CUONSACH NOT NULL,
	NgayMuon Datetime NOT NULL, 
	NgayTra Datetime, 
	HanTra Datetime NOT NULL,
	SoTienPhat int DEFAULT 0
)
go
create table PHIEUTHU
(
	SoPhieuThu int IDENTITY(1,1) primary key,
	idDocGia int references DOCGIA NOT NULL,
	SoTienThu int NOT NULL DEFAULT 0,
	NgayLap datetime NOT NULL
)
go
create table BCLUOTMUONTHEOTHELOAI
(
	id INT IDENTITY(1,1) PRIMARY KEY,
	Thang int NOT NULL, 
	Nam int NOT NULL, 
	MaBaoCao AS CAST('BCLM' + RIGHT('0' + CAST(THANG AS CHAR(2)), 2) + CAST(NAM AS CHAR(4)) AS CHAR(10)) 
				PERSISTED,
	TongSoLuotMuon int NOT NULL DEFAULT 0
)
go
create table CT_BCLUOTMUONTHEOTHELOAI
(
	idBaoCao INT references BCLUOTMUONTHEOTHELOAI,
	idTheLoai int references THELOAI,
	SoLuotMuon int NOT NULL DEFAULT 0, 
	TiLe numeric(4,2) DEFAULT 0,
	primary key (idBaoCao, idTheLoai)
)
go
create table BCSACHTRATRE
(
	Ngay datetime not null,
	idCuonSach int references CUONSACH on delete cascade,
	NgayMuon datetime NOT NULL,
	SoNgayTre int NOT NULL DEFAULT 0,
	primary key(Ngay, idCuonSach)
)
go

create table THAMSO
(
	id int identity(1,1) primary key,
	TuoiToiThieu int NOT NULL, 
	TuoiToiDa int NOT NULL, 
	ThoiHanThe int NOT NULL, 
	KhoangCachXuatBan int NOT NULL , 
	SoSachMuonToiDa int NOT NULL, 
	SoNgayMuonToiDa int NOT NULL, 
	DonGiaPhat int NOT NULL,
	AD_QDKTTienThu int NOT NULL
)


-- INSERT DATA
go
insert into NHOMNGUOIDUNG (TenNhomNguoiDung) values (N'Admin')
insert into NHOMNGUOIDUNG (TenNhomNguoiDung) values (N'Nhân Viên Thư Viện')
insert into NHOMNGUOIDUNG (TenNhomNguoiDung) values (N'Sinh Viên')
insert into NHOMNGUOIDUNG (TenNhomNguoiDung) values (N'Giảng Viên')
insert into NHOMNGUOIDUNG (TenNhomNguoiDung) values (N'Khách')


go

insert into CHUCNANG (TenChucNang, TenManHinh) VALUES ('QLDG', N'Quản Lý Độc Giả')
insert into CHUCNANG (TenChucNang, TenManHinh) VALUES ('QLS', N'Quản Lý Sách')
insert into CHUCNANG (TenChucNang, TenManHinh) VALUES ('QLPM', N'Quản Lý Phiếu Mượn Trả')
insert into CHUCNANG (TenChucNang, TenManHinh) VALUES ('QLPT', N'Quản Lý Phiếu Thu')
insert into CHUCNANG (TenChucNang, TenManHinh) VALUES ('BCTK', N'Báo Cáo Thống Kê')
insert into CHUCNANG (TenChucNang, TenManHinh) VALUES ('QLND', N'Quản Lý Người Dùng')
insert into CHUCNANG (TenChucNang, TenManHinh) VALUES ('TDQD', N'Thay Đổi Quy Định')
insert into CHUCNANG (TenChucNang, TenManHinh) VALUES ('DG', N'Là Độc Giả')

go
INSERT INTO PHANQUYEN VALUES (1, 1)
INSERT INTO PHANQUYEN VALUES (1, 2)
INSERT INTO PHANQUYEN VALUES (1, 3)
INSERT INTO PHANQUYEN VALUES (1, 4)
INSERT INTO PHANQUYEN VALUES (1, 5)
INSERT INTO PHANQUYEN VALUES (1, 6)
INSERT INTO PHANQUYEN VALUES (1, 7)

INSERT INTO PHANQUYEN VALUES (2, 1)
INSERT INTO PHANQUYEN VALUES (2, 2)
INSERT INTO PHANQUYEN VALUES (2, 3)
INSERT INTO PHANQUYEN VALUES (2, 4)
INSERT INTO PHANQUYEN VALUES (2, 5)

INSERT INTO PHANQUYEN VALUES (3, 8)

go

set dateformat dmy
go
INSERT INTO NGUOIDUNG (TenNguoiDung, ChucVu, TenDangNhap, Email, MatKhau, idNhomNguoiDung) 
VALUES (N'Admin Hệ Thống', N'Admin', 'admin', 'admin@gmail.com', '123', 1)
INSERT INTO NGUOIDUNG (TenNguoiDung, ChucVu, TenDangNhap, Email, MatKhau, idNhomNguoiDung) 
VALUES (N'Thủ Thư', N'Nhân viên thư viện', 'lib', 'lib@gmail.com', '123', 2)

INSERT INTO NGUOIDUNG (TenNguoiDung, ChucVu, TenDangNhap, Email, MatKhau, idNhomNguoiDung) VALUES (N'Nguyễn Mai Anh', N'Độc giả', 'docgia1', 'docgia1@example.com', '123', 3)
INSERT INTO NGUOIDUNG (TenNguoiDung, ChucVu, TenDangNhap, Email, MatKhau, idNhomNguoiDung) VALUES (N'Lê Thành Đô', N'Độc giả', 'docgia2', 'docgia2@example.com', '123', 3)
INSERT INTO NGUOIDUNG (TenNguoiDung, ChucVu, TenDangNhap, Email, MatKhau, idNhomNguoiDung) VALUES (N'Huỳnh Hồng Thu Giang', N'Độc giả', 'docgia3', 'docgia3@example.com', '123', 3)
INSERT INTO NGUOIDUNG (TenNguoiDung, ChucVu, TenDangNhap, Email, MatKhau, idNhomNguoiDung) VALUES (N'Trần Nhật Huy', N'Độc giả', 'docgia4', 'docgia4@example.com', '123', 3)
INSERT INTO NGUOIDUNG (TenNguoiDung, ChucVu, TenDangNhap, Email, MatKhau, idNhomNguoiDung) VALUES (N'Phan Hoàng Khánh Linh', N'Độc giả', 'docgia5', 'docgia5@example.com', '123', 3)
INSERT INTO NGUOIDUNG (TenNguoiDung, ChucVu, TenDangNhap, Email, MatKhau, idNhomNguoiDung) VALUES (N'Nguyễn Ánh Linh', N'Độc giả', 'docgia6', 'docgia6@example.com', '123', 3)
INSERT INTO NGUOIDUNG (TenNguoiDung, ChucVu, TenDangNhap, Email, MatKhau, idNhomNguoiDung) VALUES (N'Trương Họa Mi', N'Độc giả', 'docgia7', 'docgia7@example.com', '123', 3)
INSERT INTO NGUOIDUNG (TenNguoiDung, ChucVu, TenDangNhap, Email, MatKhau, idNhomNguoiDung) VALUES (N'Lê Duy Minh', N'Độc giả', 'docgia8', 'docgia8@example.com', '123', 3)
INSERT INTO NGUOIDUNG (TenNguoiDung, ChucVu, TenDangNhap, Email, MatKhau, idNhomNguoiDung) VALUES (N'Nguyễn Đăng Minh', N'Độc giả', 'docgia9', 'docgia9@example.com', '123', 3)
INSERT INTO NGUOIDUNG (TenNguoiDung, ChucVu, TenDangNhap, Email, MatKhau, idNhomNguoiDung) VALUES (N'Nguyễn Phan Nhật Minh', N'Độc giả', 'docgia10', 'docgia10@example.com', '123', 3)
INSERT INTO NGUOIDUNG (TenNguoiDung, ChucVu, TenDangNhap, Email, MatKhau, idNhomNguoiDung) VALUES (N'Trần Gia Nghĩa', N'Độc giả', 'docgia11', 'docgia11@example.com', '123', 3)
INSERT INTO NGUOIDUNG (TenNguoiDung, ChucVu, TenDangNhap, Email, MatKhau, idNhomNguoiDung) VALUES (N'Nguyễn Thị Anh Phương', N'Độc giả', 'docgia12', 'docgia12@example.com', '123', 3)
INSERT INTO NGUOIDUNG (TenNguoiDung, ChucVu, TenDangNhap, Email, MatKhau, idNhomNguoiDung) VALUES (N'Vũ Xuân Quỳnh', N'Độc giả', 'docgia13', 'docgia13@example.com', '123', 3)
INSERT INTO NGUOIDUNG (TenNguoiDung, ChucVu, TenDangNhap, Email, MatKhau, idNhomNguoiDung) VALUES (N'Nguyễn Hồ Bảo Thiên', N'Độc giả', 'docgia14', 'docgia14@example.com', '123', 3)
INSERT INTO NGUOIDUNG (TenNguoiDung, ChucVu, TenDangNhap, Email, MatKhau, idNhomNguoiDung) VALUES (N'Nguyễn Thanh Thùy', N'Độc giả', 'docgia15', 'docgia15@example.com', '123', 3)
INSERT INTO NGUOIDUNG (TenNguoiDung, ChucVu, TenDangNhap, Email, MatKhau, idNhomNguoiDung) VALUES (N'Phạm Thị Hồng Trang', N'Độc giả', 'docgia16', 'docgia16@example.com', '123', 3)
INSERT INTO NGUOIDUNG (TenNguoiDung, ChucVu, TenDangNhap, Email, MatKhau, idNhomNguoiDung) VALUES (N'Đỗ Trần Huyền Trân', N'Độc giả', 'docgia17', 'docgia17@example.com', '123', 3)
INSERT INTO NGUOIDUNG (TenNguoiDung, ChucVu, TenDangNhap, Email, MatKhau, idNhomNguoiDung) VALUES (N'Lai Tuyết Trinh', N'Độc giả', 'docgia18', 'docgia18@example.com', '123', 3)
INSERT INTO NGUOIDUNG (TenNguoiDung, ChucVu, TenDangNhap, Email, MatKhau, idNhomNguoiDung) VALUES (N'Nguyễn Hoàng Việt', N'Độc giả', 'docgia19', 'docgia19@example.com', '123', 3)
INSERT INTO NGUOIDUNG (TenNguoiDung, ChucVu, TenDangNhap, Email, MatKhau, idNhomNguoiDung) VALUES (N'Lê Hoàng Anh Vũ', N'Độc giả', 'docgia20', 'docgia20@example.com', '123', 3)
INSERT INTO NGUOIDUNG (TenNguoiDung, ChucVu, TenDangNhap, Email, MatKhau, idNhomNguoiDung) VALUES (N'Phan Lê Thảo Vy', N'Độc giả', 'docgia21', 'docgia21@example.com', '123', 3)
INSERT INTO NGUOIDUNG (TenNguoiDung, ChucVu, TenDangNhap, Email, MatKhau, idNhomNguoiDung) VALUES (N'Huỳnh Trần Tuyết Vy', N'Độc giả', 'docgia22', 'docgia22@example.com', '123', 3)
INSERT INTO NGUOIDUNG (TenNguoiDung, ChucVu, TenDangNhap, Email, MatKhau, idNhomNguoiDung) VALUES (N'Phan Trần Thiên Ân', N'Độc giả', 'docgia23', 'docgia23@example.com', '123', 3)
INSERT INTO NGUOIDUNG (TenNguoiDung, ChucVu, TenDangNhap, Email, MatKhau, idNhomNguoiDung) VALUES (N'Võ Phan Quỳnh Khanh', N'Độc giả', 'docgia24', 'docgia24@example.com', '123', 3)
INSERT INTO NGUOIDUNG (TenNguoiDung, ChucVu, TenDangNhap, Email, MatKhau, idNhomNguoiDung) VALUES (N'Nguyễn Lê Tuấn Kiệt', N'Độc giả', 'docgia25', 'docgia25@example.com', '123', 3)
INSERT INTO NGUOIDUNG (TenNguoiDung, ChucVu, TenDangNhap, Email, MatKhau, idNhomNguoiDung) VALUES (N'Trịnh Ngọc Linh', N'Độc giả', 'docgia26', 'docgia26@example.com', '123', 3)
INSERT INTO NGUOIDUNG (TenNguoiDung, ChucVu, TenDangNhap, Email, MatKhau, idNhomNguoiDung) VALUES (N'Đỗ Hoàng Phát', N'Độc giả', 'docgia27', 'docgia27@example.com', '123', 3)
INSERT INTO NGUOIDUNG (TenNguoiDung, ChucVu, TenDangNhap, Email, MatKhau, idNhomNguoiDung) VALUES (N'Đào Lương Xuân Quỳnh', N'Độc giả', 'docgia28', 'docgia28@example.com', '123', 3)
INSERT INTO NGUOIDUNG (TenNguoiDung, ChucVu, TenDangNhap, Email, MatKhau, idNhomNguoiDung) VALUES (N'Nguyễn Phan Thanh Tâm', N'Độc giả', 'docgia29', 'docgia29@example.com', '123', 3)
INSERT INTO NGUOIDUNG (TenNguoiDung, ChucVu, TenDangNhap, Email, MatKhau, idNhomNguoiDung) VALUES (N'Võ Quốc Thắng', N'Độc giả', 'docgia30', 'docgia30@example.com', '123', 3)
go

insert into THELOAI values(N'Thể loại X')
insert into THELOAI values(N'Thể loại Y')
insert into THELOAI values(N'Giáo trình')
insert into THELOAI values(N'Tài liệu tham khảo')
insert into THELOAI values(N'Văn học')
insert into THELOAI values(N'Khác')

go
insert into TUASACH (TenTuaSach, idTheLoai, DaAn) values (N'Tựa sách 1', 1, 0)
insert into TUASACH (TenTuaSach, idTheLoai, DaAn) values (N'Tựa sách 2', 2, 0)
insert into TUASACH (TenTuaSach, idTheLoai, DaAn) values (N'Cơ sở dữ liệu nâng cao', 4, 0)
insert into TUASACH (TenTuaSach, idTheLoai, DaAn) values (N'Thực hành Hệ điều hành', 3, 0)
insert into TUASACH (TenTuaSach, idTheLoai, DaAn) values (N'Các kỹ thuật trong xử lý ngôn ngữ tự nhiên', 3, 0)
insert into TUASACH (TenTuaSach, idTheLoai, DaAn) values (N'Các hệ cơ sở tri thức', 3, 0)
insert into TUASACH (TenTuaSach, idTheLoai, DaAn) values (N'Các hệ suy diễn mờ', 3, 0)
insert into TUASACH (TenTuaSach, idTheLoai, DaAn) values (N'Khai phá dữ liệu (Data Mining)', 4, 0)
insert into TUASACH (TenTuaSach, idTheLoai, DaAn) values (N'Phân tích mạng xã hội và ứng dụng', 4, 0)
insert into TUASACH (TenTuaSach, idTheLoai, DaAn) values (N'Hướng dẫn giải bài tập xác suất và thống kê toán học', 4, 0)
insert into TUASACH (TenTuaSach, idTheLoai, DaAn) values (N'Xử lý ngôn ngữ tự nhiên', 3, 0)
insert into TUASACH (TenTuaSach, idTheLoai, DaAn) values (N'Giết Con Chim Nhại', 5, 0)
insert into TUASACH (TenTuaSach, idTheLoai, DaAn) values (N'Ông Trăm Tuổi Trèo Qua Cửa Sổ Và Biến Mất', 5, 0)
insert into TUASACH (TenTuaSach, idTheLoai, DaAn) values (N'5 Centimet Trên Giây', 5, 0)
insert into TUASACH (TenTuaSach, idTheLoai, DaAn) values (N'Ông Già Và Biển Cả', 5, 0)
insert into TUASACH (TenTuaSach, idTheLoai, DaAn) values (N'Điều Kỳ Diệu Của Tiệm Tạp Hóa Namiya', 5, 0)
insert into TUASACH (TenTuaSach, idTheLoai, DaAn) values (N'Không Gia Đình', 5, 0)
insert into TUASACH (TenTuaSach, idTheLoai, DaAn) values (N'Bắt Trẻ Đồng Xanh', 5, 0)

go

INSERT INTO THONGBAO (TieuDe, NoiDung, NgayDang, idNguoiDung) VALUES
(N'Cập nhật quy định mượn sách', N'Thư viện cập nhật quy định mượn sách từ ngày 01/04/2025. Vui lòng đọc kỹ trước khi mượn.', CONVERT(DATETIME, '2025-03-15', 120), 1),
(N'Thông báo sự kiện hội sách', N'Thư viện tổ chức Hội Sách vào ngày 20/04/2025 với nhiều ưu đãi hấp dẫn.', CONVERT(DATETIME, '2025-03-14', 120), 2),
(N'Bảo trì hệ thống thư viện', N'Hệ thống thư viện sẽ bảo trì từ 22:00 ngày 16/03/2025 đến 06:00 ngày 17/03/2025.', CONVERT(DATETIME, '2025-03-13', 120), 3),
(N'Thu hồi sách quá hạn', N'Những sách mượn quá hạn từ tháng 02/2025 cần được trả trước ngày 25/03/2025 để tránh phí phạt.', CONVERT(DATETIME, '2025-03-12', 120), 4),
(N'Tuyển tình nguyện viên thư viện', N'Thư viện cần tuyển tình nguyện viên hỗ trợ hoạt động trong tháng 04/2025.', CONVERT(DATETIME, '2025-03-11', 120), 5);

go

INSERT INTO TACGIA VALUES (N'Tác Giả 1')
INSERT INTO TACGIA VALUES (N'Tác Giả 2')
INSERT INTO TACGIA VALUES (N'Nguyễn Gia Tuấn Anh')
INSERT INTO TACGIA VALUES (N'Phan Đình Duy')
INSERT INTO TACGIA VALUES (N'Nguyễn Tuấn Đăng')
INSERT INTO TACGIA VALUES (N'Đỗ Văn Nhơn')
INSERT INTO TACGIA VALUES (N'Trương Hải Bằng')
INSERT INTO TACGIA VALUES (N'Đỗ Phúc')
INSERT INTO TACGIA VALUES (N'Dương Tôn Đảm')
INSERT INTO TACGIA VALUES (N'Nguyễn Tuấn Đăng')
INSERT INTO TACGIA VALUES (N'Happer Lee')
INSERT INTO TACGIA VALUES (N'Jonas Jonasson')
INSERT INTO TACGIA VALUES (N'Shinkai Makoto')
INSERT INTO TACGIA VALUES (N'Ernest Hemingway')
INSERT INTO TACGIA VALUES (N'Namiya')
INSERT INTO TACGIA VALUES (N'Hector Malot')
INSERT INTO TACGIA VALUES (N'J. D. Salinger')

go
INSERT INTO CT_TACGIA VALUES (1, 1)
INSERT INTO CT_TACGIA VALUES (2, 2)
INSERT INTO CT_TACGIA VALUES (3, 3)
INSERT INTO CT_TACGIA VALUES (4, 4)
INSERT INTO CT_TACGIA VALUES (5, 5)
INSERT INTO CT_TACGIA VALUES (6, 6)
INSERT INTO CT_TACGIA VALUES (7, 7)
INSERT INTO CT_TACGIA VALUES (8, 8)
INSERT INTO CT_TACGIA VALUES (8, 9)
INSERT INTO CT_TACGIA VALUES (9, 10)
INSERT INTO CT_TACGIA VALUES (10, 11)
INSERT INTO CT_TACGIA VALUES (11, 12)
INSERT INTO CT_TACGIA VALUES (12, 13)
INSERT INTO CT_TACGIA VALUES (13, 14)
INSERT INTO CT_TACGIA VALUES (14, 15)
INSERT INTO CT_TACGIA VALUES (15, 16)
INSERT INTO CT_TACGIA VALUES (16, 17)
INSERT INTO CT_TACGIA VALUES (17, 18)

go
INSERT INTO LOAIDOCGIA VALUES(N'Giảng viên')
INSERT INTO LOAIDOCGIA VALUES(N'Sinh viên')
INSERT INTO LOAIDOCGIA VALUES(N'Khác')

go
INSERT INTO DOCGIA (TenDocGia, NgaySinh, DiaChi, SDT, Khoa, NgayLapThe, NgayHetHan, idLoaiDocGia, TongNoHienTai) VALUES (N'Nguyễn Mai Anh', '11/06/2003', N'123 Lê Lợi, Hà Nội', '0987654321', N'Công nghệ thông tin', '26/09/2022', '26/03/2023', 2, 0)
INSERT INTO DOCGIA (TenDocGia, NgaySinh, DiaChi, SDT, Khoa, NgayLapThe, NgayHetHan, idLoaiDocGia, TongNoHienTai) VALUES (N'Lê Thành Đô', '08/01/2003', N'45 Nguyễn Trãi, Đà Nẵng', '0987654322', N'Kinh tế', '26/09/2022', '26/03/2023', 2, 0)
INSERT INTO DOCGIA (TenDocGia, NgaySinh, DiaChi, SDT, Khoa, NgayLapThe, NgayHetHan, idLoaiDocGia, TongNoHienTai) VALUES (N'Huỳnh Hồng Thu Giang', '24/02/2003', N'67 Trần Phú, TP.HCM', '0987654323', N'Luật', '26/08/2022', '26/02/2023', 2, 0)
INSERT INTO DOCGIA (TenDocGia, NgaySinh, DiaChi, SDT, Khoa, NgayLapThe, NgayHetHan, idLoaiDocGia, TongNoHienTai) VALUES (N'Trần Nhật Huy', '03/01/2003', N'89 Lý Thường Kiệt, Huế', '0987654324', N'Khoa học xã hội', '26/08/2022', '26/02/2023', 2, 0)
INSERT INTO DOCGIA (TenDocGia, NgaySinh, DiaChi, SDT, Khoa, NgayLapThe, NgayHetHan, idLoaiDocGia, TongNoHienTai) VALUES (N'Phan Hoàng Khánh Linh', '22/06/2003', N'101 Bạch Đằng, Hải Phòng', '0987654325', N'Ngoại ngữ', '19/05/2020', '19/11/2021', 2, 0)
INSERT INTO DOCGIA (TenDocGia, NgaySinh, DiaChi, SDT, Khoa, NgayLapThe, NgayHetHan, idLoaiDocGia, TongNoHienTai) VALUES (N'Nguyễn Ánh Linh', '25/08/2003', N'76 Hoàng Diệu, Cần Thơ', '0987654326', N'Tài chính', '26/09/2022', '26/03/2023', 2, 0)
INSERT INTO DOCGIA (TenDocGia, NgaySinh, DiaChi, SDT, Khoa, NgayLapThe, NgayHetHan, idLoaiDocGia, TongNoHienTai) VALUES (N'Trương Họa Mi', '11/04/2003', N'90 Lê Văn Sỹ, TP.HCM', '0987654327', N'Y dược', '26/09/2022', '26/03/2023', 2, 0)
INSERT INTO DOCGIA (TenDocGia, NgaySinh, DiaChi, SDT, Khoa, NgayLapThe, NgayHetHan, idLoaiDocGia, TongNoHienTai) VALUES (N'Lê Duy Minh', '02/11/2003', N'120 Nguyễn Huệ, Nha Trang', '0987654328', N'Báo chí', '26/09/2022', '26/03/2023', 2, 0)
INSERT INTO DOCGIA (TenDocGia, NgaySinh, DiaChi, SDT, Khoa, NgayLapThe, NgayHetHan, idLoaiDocGia, TongNoHienTai) VALUES (N'Nguyễn Đăng Minh', '03/07/2003', N'200 Phan Chu Trinh, Đà Lạt', '0987654329', N'Quản trị kinh doanh', '26/08/2022', '26/02/2023', 2, 0)
INSERT INTO DOCGIA (TenDocGia, NgaySinh, DiaChi, SDT, Khoa, NgayLapThe, NgayHetHan, idLoaiDocGia, TongNoHienTai) VALUES (N'Nguyễn Phan Nhật Minh', '25/09/2003', N'300 Võ Văn Kiệt, TP.HCM', '0987654330', N'Kỹ thuật cơ khí', '26/09/2022', '26/03/2023', 2, 0)
INSERT INTO DOCGIA (TenDocGia, NgaySinh, DiaChi, SDT, Khoa, NgayLapThe, NgayHetHan, idLoaiDocGia, TongNoHienTai) VALUES (N'Trần Gia Nghĩa', '05/12/2003', N'123 Lê Lợi, Q1, TP.HCM', '0912345671', N'Công nghệ thông tin', '26/09/2022', '26/03/2023', 2, 0)
INSERT INTO DOCGIA (TenDocGia, NgaySinh, DiaChi, SDT, Khoa, NgayLapThe, NgayHetHan, idLoaiDocGia, TongNoHienTai) VALUES (N'Nguyễn Thị Anh Phương', '09/04/2003', N'456 Hai Bà Trưng, Q3, TP.HCM', '0912345672', N'Kinh tế', '26/09/2022', '26/03/2023', 2, 0)
INSERT INTO DOCGIA (TenDocGia, NgaySinh, DiaChi, SDT, Khoa, NgayLapThe, NgayHetHan, idLoaiDocGia, TongNoHienTai) VALUES (N'Vũ Xuân Quỳnh', '05/09/2003', N'789 Nguyễn Trãi, Q5, TP.HCM', '0912345673', N'Luật', '26/09/2022', '26/03/2023', 2, 0)
INSERT INTO DOCGIA (TenDocGia, NgaySinh, DiaChi, SDT, Khoa, NgayLapThe, NgayHetHan, idLoaiDocGia, TongNoHienTai) VALUES (N'Nguyễn Hồ Bảo Thiên', '30/07/2003', N'101 Điện Biên Phủ, Q1, TP.HCM', '0912345674', N'Y dược', '19/05/2020', '19/11/2020', 2, 0)
INSERT INTO DOCGIA (TenDocGia, NgaySinh, DiaChi, SDT, Khoa, NgayLapThe, NgayHetHan, idLoaiDocGia, TongNoHienTai) VALUES (N'Nguyễn Thanh Thùy', '18/08/2003', N'222 Võ Văn Tần, Q3, TP.HCM', '0912345675', N'Xây dựng', '26/09/2022', '26/03/2023', 2, 0)
INSERT INTO DOCGIA (TenDocGia, NgaySinh, DiaChi, SDT, Khoa, NgayLapThe, NgayHetHan, idLoaiDocGia, TongNoHienTai) VALUES (N'Phạm Thị Hồng Trang', '23/10/2003', N'333 Lý Thái Tổ, Q10, TP.HCM', '0912345676', N'Ngoại ngữ', '19/05/2020', '19/11/2020', 2, 0)
INSERT INTO DOCGIA (TenDocGia, NgaySinh, DiaChi, SDT, Khoa, NgayLapThe, NgayHetHan, idLoaiDocGia, TongNoHienTai) VALUES (N'Đỗ Trần Huyền Trân', '05/05/2003', N'444 Nguyễn Văn Cừ, Q5, TP.HCM', '0912345677', N'Tài chính', '19/05/2021', '19/11/2021', 2, 0)
INSERT INTO DOCGIA (TenDocGia, NgaySinh, DiaChi, SDT, Khoa, NgayLapThe, NgayHetHan, idLoaiDocGia, TongNoHienTai) VALUES (N'Lai Tuyết Trinh', '24/11/2003', N'555 Trần Hưng Đạo, Q1, TP.HCM', '0912345678', N'Công nghệ sinh học', '26/09/2022', '26/03/2023', 2, 0)
INSERT INTO DOCGIA (TenDocGia, NgaySinh, DiaChi, SDT, Khoa, NgayLapThe, NgayHetHan, idLoaiDocGia, TongNoHienTai) VALUES (N'Nguyễn Hoàng Việt', '19/05/2003', N'666 Phan Xích Long, Q.Phú Nhuận, TP.HCM', '0912345679', N'Truyền thông', '19/05/2021', '19/11/2021', 2, 0)
INSERT INTO DOCGIA (TenDocGia, NgaySinh, DiaChi, SDT, Khoa, NgayLapThe, NgayHetHan, idLoaiDocGia, TongNoHienTai) VALUES (N'Lê Hoàng Anh Vũ', '03/01/2003', N'777 Dương Bá Trạc, Q8, TP.HCM', '0912345680', N'Kiến trúc', '26/08/2022', '26/02/2023', 2, 0)
INSERT INTO DOCGIA (TenDocGia, NgaySinh, DiaChi, SDT, Khoa, NgayLapThe, NgayHetHan, idLoaiDocGia, TongNoHienTai) VALUES (N'Phan Lê Thảo Vy', '01/07/2003', N'888 Tô Hiến Thành, Q10, TP.HCM', '0912345681', N'Môi trường', '26/08/2022', '26/02/2023', 2, 0)
INSERT INTO DOCGIA (TenDocGia, NgaySinh, DiaChi, SDT, Khoa, NgayLapThe, NgayHetHan, idLoaiDocGia, TongNoHienTai) VALUES (N'Huỳnh Trần Tuyết Vy', '24/12/2003', N'999 Nguyễn Hữu Cảnh, Q.Bình Thạnh, TP.HCM', '0912345682', N'Kế toán', '26/09/2022', '26/03/2023', 2, 0)
INSERT INTO DOCGIA (TenDocGia, NgaySinh, DiaChi, SDT, Khoa, NgayLapThe, NgayHetHan, idLoaiDocGia, TongNoHienTai) VALUES (N'Phan Trần Thiên Ân', '14/05/2003', N'111 Tạ Quang Bửu, Q8, TP.HCM', '0912345683', N'Công nghệ thông tin', '26/09/2022', '26/03/2023', 2, 0)
INSERT INTO DOCGIA (TenDocGia, NgaySinh, DiaChi, SDT, Khoa, NgayLapThe, NgayHetHan, idLoaiDocGia, TongNoHienTai) VALUES (N'Võ Phan Quỳnh Khanh', '12/05/2003', N'222 Lạc Long Quân, Q11, TP.HCM', '0912345684', N'Kinh doanh', '26/09/2022', '26/03/2023', 2, 0)
INSERT INTO DOCGIA (TenDocGia, NgaySinh, DiaChi, SDT, Khoa, NgayLapThe, NgayHetHan, idLoaiDocGia, TongNoHienTai) VALUES (N'Nguyễn Lê Tuấn Kiệt', '23/01/2003', N'333 Thành Thái, Q10, TP.HCM', '0912345685', N'Cơ khí', '26/08/2022', '26/02/2023', 2, 0)
INSERT INTO DOCGIA (TenDocGia, NgaySinh, DiaChi, SDT, Khoa, NgayLapThe, NgayHetHan, idLoaiDocGia, TongNoHienTai) VALUES (N'Trịnh Ngọc Linh', '01/01/2003', N'444 Lê Văn Sỹ, Q.Tân Bình, TP.HCM', '0912345686', N'Du lịch', '19/05/2021', '19/11/2021', 2, 0)
INSERT INTO DOCGIA (TenDocGia, NgaySinh, DiaChi, SDT, Khoa, NgayLapThe, NgayHetHan, idLoaiDocGia, TongNoHienTai) VALUES (N'Đỗ Hoàng Phát', '28/10/2003', N'555 Âu Cơ, Q.Tân Phú, TP.HCM', '0912345687', N'Báo chí', '26/08/2022', '26/02/2023', 2, 0)
INSERT INTO DOCGIA (TenDocGia, NgaySinh, DiaChi, SDT, Khoa, NgayLapThe, NgayHetHan, idLoaiDocGia, TongNoHienTai) VALUES (N'Đào Lương Xuân Quỳnh', '21/05/2003', N'666 Hồ Văn Huê, Q.Phú Nhuận, TP.HCM', '0912345688', N'Ngôn ngữ học', '26/09/2022', '26/03/2023', 2, 0)
INSERT INTO DOCGIA (TenDocGia, NgaySinh, DiaChi, SDT, Khoa, NgayLapThe, NgayHetHan, idLoaiDocGia, TongNoHienTai) VALUES (N'Nguyễn Phan Thanh Tâm', '03/11/2003', N'777 Cộng Hòa, Q.Tân Bình, TP.HCM', '0912345689', N'Quản trị kinh doanh', '26/09/2022', '26/03/2023', 2, 0)
INSERT INTO DOCGIA (TenDocGia, NgaySinh, DiaChi, SDT, Khoa, NgayLapThe, NgayHetHan, idLoaiDocGia, TongNoHienTai) VALUES (N'Võ Quốc Thắng', '04/05/2003', N'888 Hoàng Văn Thụ, Q.Tân Bình, TP.HCM', '0912345690', N'Công nghệ ô tô', '26/08/2022', '26/02/2023', 2, 0)
go

INSERT INTO LOAINHANVIEN VALUES(N'Thủ thư')
INSERT INTO LOAINHANVIEN VALUES(N'Quản lý kho')
INSERT INTO LOAINHANVIEN VALUES(N'Nhân viên hỗ trợ')
go

INSERT INTO NHANVIEN (HoTen, NgaySinh, GioiTinh, DiaChi, SDT, idLoaiNhanVien, NgayVaoLam, Luong) VALUES (N'Nguyễn Văn An', '1990-03-15', N'Nam', N'12 Lê Lợi, Q1, TP.HCM', '0901234561', 1, '2020-06-01', 12000000.00)
INSERT INTO NHANVIEN (HoTen, NgaySinh, GioiTinh, DiaChi, SDT, idLoaiNhanVien, NgayVaoLam, Luong) VALUES (N'Trần Thị Bích Ngọc', '1992-07-22', N'Nữ', N'34 Nguyễn Trãi, Q5, TP.HCM', '0901234562', 2, '2019-08-15', 13000000.00)
INSERT INTO NHANVIEN (HoTen, NgaySinh, GioiTinh, DiaChi, SDT, idLoaiNhanVien, NgayVaoLam, Luong) VALUES (N'Phạm Hữu Minh', '1988-05-10', N'Nam', N'56 Lạc Long Quân, Q.Tân Bình, TP.HCM', '0901234563', 1, '2018-11-01', 14000000.00)
INSERT INTO NHANVIEN (HoTen, NgaySinh, GioiTinh, DiaChi, SDT, idLoaiNhanVien, NgayVaoLam, Luong) VALUES (N'Lê Hoàng Nam', '1995-02-18', N'Nam', N'78 Phan Xích Long, Q.Phú Nhuận, TP.HCM', '0901234564', 3, '2021-01-10', 11000000.00)
INSERT INTO NHANVIEN (HoTen, NgaySinh, GioiTinh, DiaChi, SDT, idLoaiNhanVien, NgayVaoLam, Luong) VALUES (N'Đặng Thanh Thảo', '1991-09-25', N'Nữ', N'90 Điện Biên Phủ, Q.Bình Thạnh, TP.HCM', '0901234565', 2, '2017-07-05', 15000000.00)
INSERT INTO NHANVIEN (HoTen, NgaySinh, GioiTinh, DiaChi, SDT, idLoaiNhanVien, NgayVaoLam, Luong) VALUES (N'Hoàng Minh Tuấn', '1993-12-05', N'Nam', N'11 Nguyễn Văn Cừ, Q.5, TP.HCM', '0901234566', 1, '2020-04-20', 12500000.00)
INSERT INTO NHANVIEN (HoTen, NgaySinh, GioiTinh, DiaChi, SDT, idLoaiNhanVien, NgayVaoLam, Luong) VALUES (N'Trương Mỹ Linh', '1989-06-30', N'Nữ', N'22 Lê Văn Sỹ, Q.Tân Bình, TP.HCM', '0901234567', 3, '2016-09-15', 13500000.00)
INSERT INTO NHANVIEN (HoTen, NgaySinh, GioiTinh, DiaChi, SDT, idLoaiNhanVien, NgayVaoLam, Luong) VALUES (N'Nguyễn Thanh Huy', '1994-08-14', N'Nam', N'33 Hồ Văn Huê, Q.Phú Nhuận, TP.HCM', '0901234568', 2, '2019-02-28', 12800000.00)
INSERT INTO NHANVIEN (HoTen, NgaySinh, GioiTinh, DiaChi, SDT, idLoaiNhanVien, NgayVaoLam, Luong) VALUES (N'Phan Thị Hồng Hạnh', '1990-11-21', N'Nữ', N'44 Lý Thường Kiệt, Q.10, TP.HCM', '0901234569', 1, '2018-05-07', 14500000.00)
INSERT INTO NHANVIEN (HoTen, NgaySinh, GioiTinh, DiaChi, SDT, idLoaiNhanVien, NgayVaoLam, Luong) VALUES (N'Võ Quốc Bảo', '1996-03-03', N'Nam', N'55 Thành Thái, Q.10, TP.HCM', '0901234570', 3, '2022-06-12', 11500000.00)
INSERT INTO NHANVIEN (HoTen, NgaySinh, GioiTinh, DiaChi, SDT, idLoaiNhanVien, NgayVaoLam, Luong) VALUES (N'Nguyễn Hoàng Dũng', '1992-01-12', N'Nam', N'123 Trần Hưng Đạo, Q.1, TP.HCM', '0901234571', 1, '2019-07-01', 15500000.00)
INSERT INTO NHANVIEN (HoTen, NgaySinh, GioiTinh, DiaChi, SDT, idLoaiNhanVien, NgayVaoLam, Luong) VALUES (N'Bùi Thị Thanh Vân', '1993-05-22', N'Nữ', N'234 Lý Tự Trọng, Q.1, TP.HCM', '0901234572', 2, '2020-09-15', 14800000.00)
INSERT INTO NHANVIEN (HoTen, NgaySinh, GioiTinh, DiaChi, SDT, idLoaiNhanVien, NgayVaoLam, Luong) VALUES (N'Lâm Tuấn Kiệt', '1987-04-05', N'Nam', N'345 Điện Biên Phủ, Q.Bình Thạnh, TP.HCM', '0901234573', 1, '2015-12-20', 16000000.00)
INSERT INTO NHANVIEN (HoTen, NgaySinh, GioiTinh, DiaChi, SDT, idLoaiNhanVien, NgayVaoLam, Luong) VALUES (N'Thái Thanh Hằng', '1994-08-30', N'Nữ', N'456 Nguyễn Văn Cừ, Q.5, TP.HCM', '0901234574', 3, '2021-03-10', 12000000.00)
INSERT INTO NHANVIEN (HoTen, NgaySinh, GioiTinh, DiaChi, SDT, idLoaiNhanVien, NgayVaoLam, Luong) VALUES (N'Vũ Minh Trí', '1995-10-10', N'Nam', N'567 Nguyễn Đình Chiểu, Q.3, TP.HCM', '0901234575', 2, '2019-06-18', 13500000.00)
INSERT INTO NHANVIEN (HoTen, NgaySinh, GioiTinh, DiaChi, SDT, idLoaiNhanVien, NgayVaoLam, Luong) VALUES (N'Huỳnh Thị Cẩm Tú', '1996-07-07', N'Nữ', N'678 Cách Mạng Tháng 8, Q.10, TP.HCM', '0901234576', 3, '2022-08-01', 11000000.00)
INSERT INTO NHANVIEN (HoTen, NgaySinh, GioiTinh, DiaChi, SDT, idLoaiNhanVien, NgayVaoLam, Luong) VALUES (N'Lê Thanh Phong', '1991-02-18', N'Nam', N'789 Nguyễn Văn Linh, Q.7, TP.HCM', '0901234577', 1, '2017-10-20', 15800000.00)
INSERT INTO NHANVIEN (HoTen, NgaySinh, GioiTinh, DiaChi, SDT, idLoaiNhanVien, NgayVaoLam, Luong) VALUES (N'Đỗ Quang Huy', '1989-06-15', N'Nam', N'890 Tô Hiến Thành, Q.10, TP.HCM', '0901234578', 3, '2016-05-05', 14000000.00)
INSERT INTO NHANVIEN (HoTen, NgaySinh, GioiTinh, DiaChi, SDT, idLoaiNhanVien, NgayVaoLam, Luong) VALUES (N'Trịnh Mỹ Duyên', '1993-12-25', N'Nữ', N'901 Lê Đại Hành, Q.11, TP.HCM', '0901234579', 2, '2018-02-14', 13200000.00)
INSERT INTO NHANVIEN (HoTen, NgaySinh, GioiTinh, DiaChi, SDT, idLoaiNhanVien, NgayVaoLam, Luong) VALUES (N'Hoàng Gia Bảo', '1997-11-11', N'Nam', N'102 Hồ Tùng Mậu, Q.1, TP.HCM', '0901234580', 1, '2023-01-01', 12500000.00)
go

INSERT INTO THAMSO VALUES(18, 55, 6, 8, 5, 4, 1000, 1)
go

CREATE TRIGGER trg_Check_Khach_DocGia
ON DOCGIA
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO DOCGIA (idNguoiDung, TenDocGia, NgaySinh, DiaChi, SDT, Khoa, NgayLapThe, NgayHetHan, idLoaiDocGia, TongNoHienTai)
    SELECT 
        i.idNguoiDung,
        CASE WHEN n.ChucVu = N'khách' THEN NULL ELSE i.TenDocGia END,
        CASE WHEN n.ChucVu = N'khách' THEN NULL ELSE i.NgaySinh END,
        CASE WHEN n.ChucVu = N'khách' THEN NULL ELSE i.DiaChi END,
        CASE WHEN n.ChucVu = N'khách' THEN NULL ELSE i.SDT END,
        CASE WHEN n.ChucVu = N'khách' THEN NULL ELSE i.Khoa END,
        CASE WHEN n.ChucVu = N'khách' THEN NULL ELSE i.NgayLapThe END,
        CASE WHEN n.ChucVu = N'khách' THEN NULL ELSE i.NgayHetHan END,
        i.idLoaiDocGia,
        CASE WHEN n.ChucVu = N'khách' THEN NULL ELSE i.TongNoHienTai END
    FROM inserted i
    JOIN NGUOIDUNG n ON i.idNguoiDung = n.id;
END
go