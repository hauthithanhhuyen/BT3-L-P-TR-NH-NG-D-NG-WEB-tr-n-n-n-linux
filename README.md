# BT3-L-P-TR-NH-NG-D-NG-WEB-tr-n-n-n-linux
LẬP TRÌNH ỨNG DỤNG WEB trên nền linux
# 1. Cài đặt môi trường linux: SV chọn 1 trong các phương án
<img width="916" height="408" alt="image" src="https://github.com/user-attachments/assets/c0691026-191f-4f14-89a0-56620b2d6794" />
# 2 Docker trong Ubuntu WSL c đã kết nối thành công với Docker Desktop trên Windows
<img width="1108" height="875" alt="image" src="https://github.com/user-attachments/assets/6780604c-2687-4676-90d3-2125faa9890c" />
# 3  Sử dụng 1 file docker-compose.yml để cài đặt các docker container sau: 
   mariadb (3306), phpmyadmin (8080), nodered/node-red (1880), influxdb (8086), grafana/grafana (3000), nginx (80,443)
1,TẠO FILE docker-compose.yml
<img width="1182" height="280" alt="image" src="https://github.com/user-attachments/assets/7e9f9298-7f2d-4403-9024-d1272430230e" />
2.Tạo thư mục cho Nginx
<img width="1129" height="642" alt="image" src="https://github.com/user-attachments/assets/7f372602-74d9-4745-bdcd-f475cc4ab4dc" />
4.Chạy Docker Compose
<img width="1690" height="617" alt="image" src="https://github.com/user-attachments/assets/443eed35-39ab-43c2-a0b1-a1f1c488117a" />

# 4. Lập trình web frontend+backend:
4.2 Web IOT: Giám sát dữ liệu IOT.
B1.Tạo database mới
<img width="1678" height="472" alt="image" src="https://github.com/user-attachments/assets/170fd73c-55c1-4f4a-ae66-f93398868968" />
B2.TẠO FLOW NODE-RED
1.Tạo account admin ( dùng bcrypt hash)
<img width="947" height="440" alt="image" src="https://github.com/user-attachments/assets/413bb53b-19ce-4f7e-a3ea-e153ec3a26ef" />
<img width="1394" height="449" alt="image" src="https://github.com/user-attachments/assets/f72661f3-72d6-42e0-9521-3c26749574c7" />
2.Web gọi API này khi nhấn “Gọi /api/latest” hoặc khi tự động cập nhật để hiển thị giá trị cảm biến mới nhất.
<img width="1228" height="336" alt="image" src="https://github.com/user-attachments/assets/5f325964-955a-4738-b422-270d0d2839b1" />
3.Dùng khi test nhanh API mà không cần đăng nhập, hoặc khôi phục khi có lỗi trong bản Auth
<img width="1292" height="223" alt="image" src="https://github.com/user-attachments/assets/ec31594a-63d7-40b0-b6a8-7a3f4e9d0344" />
4.fow hoàn chỉnh cho web IoT thực tế — khi người dùng đăng nhập, web lưu cookie/session, và các API khác chỉ truy cập được nếu đã đăng nhập.
<img width="1695" height="645" alt="image" src="https://github.com/user-attachments/assets/adf155a7-44bd-40d7-b74f-60d9ab08a611" />
5.Dùng để test hệ thống khi không có cảm biến thật — nó sinh dữ liệu giả như temp=28°C, hum=60% để hiển thị lên web.
<img width="831" height="230" alt="image" src="https://github.com/user-attachments/assets/4fb4e2dc-2089-42f3-be89-15d91f3019a8" />
Thay đổi trong 5s
<img width="1699" height="720" alt="image" src="https://github.com/user-attachments/assets/ca8cd8be-f95e-49d8-a236-188d2c2afb38" />

6.Kết quả 
<img width="1617" height="734" alt="image" src="https://github.com/user-attachments/assets/e608f868-0f7f-499c-86f2-1fb4c863ef99" />
7. Nginx đã chạy
<img width="1671" height="426" alt="image" src="https://github.com/user-attachments/assets/0fa6600e-c26e-46bb-8984-ee3eb51d66c3" />
8. grafana dùng để hiển thị biểu đồ
<img width="1266" height="681" alt="image" src="https://github.com/user-attachments/assets/717fd2a2-12a3-4a51-80d0-eeb0a4ccbc4c" />
Biểu đồ đo độ ẩm ,nhiệt độ
<img width="1913" height="777" alt="image" src="https://github.com/user-attachments/assets/4fb69192-dc4c-48c2-853a-4aca3213b1da" />
Trục X (ngang): là thời gian (time) 
Trục Y (dọc): là giá trị đo được – ví dụ: nhiệt độ, độ ẩm.
9.influxdb để lưu giá trị lịch sử
<img width="1480" height="899" alt="image" src="https://github.com/user-attachments/assets/7fe18284-d25e-492f-8fd1-ae291ebfd704" />
<img width="1835" height="901" alt="image" src="https://github.com/user-attachments/assets/bbe4803f-c6cf-41d4-b2df-2f171049cd09" />
<img width="1877" height="916" alt="image" src="https://github.com/user-attachments/assets/0239182d-e7d8-4b4c-a435-b16ab40f80a7" />

# 5. Nginx làm web-server
Cả 3 file thầy yêu cầu e cho vào trong 1 file .
<img width="1811" height="796" alt="image" src="https://github.com/user-attachments/assets/ddeae378-0aaf-46c1-baa3-31a56a64e6ff" />

Truy cập vào nodered qua cổng 80
<img width="1893" height="869" alt="image" src="https://github.com/user-attachments/assets/15af657f-f096-491a-b183-f89b7208993d" />
Truy cập vào grafana qua cổng 80
<img width="1850" height="914" alt="image" src="https://github.com/user-attachments/assets/5f9d6ba5-7a9e-4adb-bd71-7e30c2e45b09" />



