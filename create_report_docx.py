from zipfile import ZipFile, ZIP_DEFLATED
from xml.sax.saxutils import escape
from pathlib import Path

out = Path(r'C:/Users/Admin/Downloads/baocao-fellow4u-dung-cong-nghe.docx')

paragraphs = [
('TRƯỜNG ĐẠI HỌC ĐÔNG Á', 'center'),
('KHOA CÔNG NGHỆ THÔNG TIN', 'center'),
('BÁO CÁO ĐỒ ÁN ỨNG DỤNG MOBILE', 'center'),
('ĐỀ TÀI: XÂY DỰNG ỨNG DỤNG FELLOW4U HỖ TRỢ TÌM KIẾM TOUR VÀ KẾT NỐI KHÁCH DU LỊCH VỚI HƯỚNG DẪN VIÊN ĐỊA PHƯƠNG', 'center'),
('Sinh viên thực hiện: Vũ Huy Đạt', None),
('Giáo viên hướng dẫn: Th.S Tạ Quốc Ý', None),
('Buôn Ma Thuột, 05/2026', 'center'),
('MỤC LỤC', 'h1'),
('CHƯƠNG 1: CƠ SỞ LÝ THUYẾT', None),
('CHƯƠNG 2: PHÂN TÍCH VÀ THIẾT KẾ HỆ THỐNG', None),
('CHƯƠNG 3: KẾT QUẢ XÂY DỰNG ỨNG DỤNG', None),
('CHƯƠNG 4: KẾT LUẬN VÀ HƯỚNG PHÁT TRIỂN', None),
('CHƯƠNG 1: CƠ SỞ LÝ THUYẾT', 'h1'),
('1.1. Giới thiệu tổng quan dự án Fellow4U', 'h2'),
('Fellow4U là ứng dụng mobile hỗ trợ khách du lịch tìm kiếm thông tin tour, tạo kế hoạch chuyến đi cá nhân, quản lý hồ sơ và trao đổi thông tin với người dùng khác thông qua chức năng nhắn tin. Ứng dụng hướng đến việc tạo ra nền tảng kết nối giữa khách du lịch và hướng dẫn viên địa phương, giúp quá trình tìm kiếm trải nghiệm du lịch trở nên thuận tiện, nhanh chóng và cá nhân hóa hơn.', None),
('Hệ thống được xây dựng theo mô hình client-server. Ứng dụng mobile đóng vai trò client, được phát triển bằng Flutter và Dart. Backend được xây dựng bằng Node.js kết hợp Express.js, cung cấp các REST API cho mobile app. Dữ liệu được lưu trữ bằng SQLite và thao tác thông qua Sequelize ORM. Hệ thống sử dụng JWT để xác thực người dùng, bcryptjs để mã hóa mật khẩu và Cloudinary để lưu trữ ảnh upload.', None),
('1.2. Công nghệ Flutter và Dart', 'h2'),
('Flutter là bộ công cụ phát triển giao diện người dùng mã nguồn mở do Google phát triển, cho phép xây dựng ứng dụng đa nền tảng từ một mã nguồn duy nhất. Flutter phù hợp với đồ án ứng dụng mobile vì có khả năng tạo giao diện hiện đại, hiệu năng tốt và hỗ trợ chạy trên Android, iOS, Web, Windows.', None),
('Dart là ngôn ngữ lập trình chính của Flutter. Dart hỗ trợ kiểu dữ liệu tĩnh, null safety, lập trình bất đồng bộ với Future/async/await, giúp xử lý các tác vụ gọi API và cập nhật giao diện mượt mà.', None),
('1.3. Node.js và Express.js', 'h2'),
('Node.js là môi trường chạy JavaScript phía máy chủ, phù hợp để xây dựng backend nhẹ, nhanh và dễ triển khai. Express.js là framework web phổ biến trên Node.js, hỗ trợ định tuyến, middleware, xử lý request/response và xây dựng REST API.', None),
('Trong dự án Fellow4U, Express.js được dùng để xây dựng các nhóm API như auth, users, tours, news, trips, chat và upload. Backend được tổ chức theo routes, controllers, middleware, models nhằm tách biệt trách nhiệm và dễ bảo trì.', None),
('1.4. SQLite và Sequelize ORM', 'h2'),
('SQLite là hệ quản trị cơ sở dữ liệu quan hệ gọn nhẹ, dữ liệu được lưu trong một file duy nhất, phù hợp với môi trường phát triển, học tập và demo đồ án. SQLite không cần cài đặt server riêng nên thuận tiện cho việc triển khai nhanh.', None),
('Sequelize là ORM cho Node.js, giúp ánh xạ bảng dữ liệu thành các model JavaScript. Thay vì viết trực tiếp nhiều câu SQL, lập trình viên có thể thao tác dữ liệu thông qua các phương thức như create, findOne, findAll, findByPk và save.', None),
('1.5. JWT, bcryptjs và bảo mật', 'h2'),
('JWT được dùng để xác thực người dùng. Sau khi đăng nhập thành công, backend sinh token và trả về cho mobile app. Ứng dụng lưu token và gửi kèm trong header Authorization: Bearer token khi gọi các API yêu cầu đăng nhập.', None),
('bcryptjs được dùng để mã hóa mật khẩu trước khi lưu database. Khi người dùng đăng nhập, hệ thống so sánh mật khẩu nhập vào với mật khẩu đã được băm trong database. Cách làm này giúp hạn chế rủi ro nếu dữ liệu bị lộ.', None),
('1.6. REST API và Cloudinary', 'h2'),
('REST API là phương thức giao tiếp giữa Flutter app và backend thông qua HTTP. Các thao tác chính được biểu diễn bằng GET, POST, PATCH. Dữ liệu request và response chủ yếu ở định dạng JSON.', None),
('Cloudinary được dùng để lưu trữ ảnh upload. Backend nhận file từ client qua multipart/form-data, kiểm tra định dạng và dung lượng, sau đó upload lên Cloudinary và trả về URL ảnh cho ứng dụng.', None),
('CHƯƠNG 2: PHÂN TÍCH VÀ THIẾT KẾ HỆ THỐNG', 'h1'),
('2.1. Mục tiêu hệ thống', 'h2'),
('Mục tiêu của hệ thống là xây dựng ứng dụng mobile giúp người dùng đăng ký, đăng nhập, xem tour, xem tin tức, tạo chuyến đi cá nhân, quản lý hồ sơ và nhắn tin với người dùng khác. Hệ thống phải có backend API để lưu trữ và xử lý dữ liệu tập trung.', None),
('2.2. Tác nhân hệ thống', 'h2'),
('Guest: người dùng chưa đăng nhập, có thể đăng ký, đăng nhập, xem một số dữ liệu công khai như tour và tin tức.', None),
('User: người dùng đã đăng nhập, có thể cập nhật hồ sơ, tạo chuyến đi, xem chuyến đi của mình, tạo hội thoại và gửi tin nhắn.', None),
('Admin: tác nhân định hướng phát triển trong tương lai, có thể quản lý người dùng, tour, tin tức và thống kê hệ thống.', None),
('2.3. Chức năng hệ thống', 'h2'),
('Các chức năng chính gồm: đăng ký tài khoản, đăng nhập, cập nhật hồ sơ, xem danh sách người dùng, xem tin tức, xem tour, tạo chuyến đi, xem chuyến đi của tôi, xem chi tiết chuyến đi, tạo hội thoại, lấy danh sách hội thoại, gửi tin nhắn, lấy tin nhắn và upload ảnh.', None),
('2.4. Use Case tổng quát', 'h2'),
('Guest thực hiện: Đăng ký, Đăng nhập, Xem tour, Xem tin tức.', None),
('User thực hiện: Quản lý hồ sơ, Tạo chuyến đi, Xem chuyến đi, Tìm kiếm người dùng, Tạo hội thoại, Gửi tin nhắn, Upload ảnh, Đăng xuất.', None),
('Admin thực hiện trong hướng phát triển: Quản lý user, Quản lý tour, Quản lý tin tức, Quản lý booking.', None),
('2.5. Activity Diagram flow', 'h2'),
('Flow đăng nhập: Start -> Mở màn hình đăng nhập -> Nhập email/mật khẩu -> Validate dữ liệu -> Gửi API login -> Backend kiểm tra tài khoản -> Trả token -> Lưu token -> Chuyển màn hình chính -> End.', None),
('Flow tạo chuyến đi: Start -> Chọn tạo chuyến đi -> Nhập thông tin -> Validate -> Gửi API tạo trip -> Xác thực JWT -> Lưu DB -> Trả kết quả -> Cập nhật giao diện -> End.', None),
('Flow gửi tin nhắn: Start -> Mở chat -> Nhập nội dung -> Kiểm tra rỗng -> Gửi API message -> Xác thực JWT -> Lưu message -> Trả dữ liệu -> Cập nhật danh sách tin nhắn -> End.', None),
('2.6. Sequence flow', 'h2'),
('Sequence đăng nhập: User -> Mobile App: nhập email/mật khẩu. Mobile App -> Backend: POST /auth/login. Backend -> Database: tìm user. Database -> Backend: trả user. Backend: so sánh password. Backend -> Mobile App: trả token. Mobile App: lưu token và chuyển màn hình.', None),
('Sequence đăng ký: User -> Mobile App: nhập thông tin. Mobile App -> Backend: POST /auth/signup. Backend -> Database: kiểm tra email. Backend: mã hóa mật khẩu. Backend -> Database: lưu user. Backend -> Mobile App: trả token.', None),
('Sequence tạo chuyến đi: User -> Mobile App: nhập trip. Mobile App -> Backend: POST /api/trips. Backend: verify JWT. Backend -> Database: lưu trip. Database -> Backend: trả trip. Backend -> Mobile App: trả kết quả.', None),
('Sequence gửi tin nhắn: User -> Mobile App: nhập tin nhắn. Mobile App -> Backend: POST /api/chat/messages. Backend: verify JWT. Backend -> Database: lưu message. Backend -> Mobile App: trả message mới.', None),
('2.7. Kiến trúc hệ thống', 'h2'),
('Hệ thống sử dụng kiến trúc Client - Server. Flutter mobile app là client, giao tiếp với Node.js Express backend thông qua REST API. Backend xử lý nghiệp vụ, xác thực và truy xuất database SQLite thông qua Sequelize ORM. Ảnh upload được lưu tại Cloudinary.', None),
('Sơ đồ kiến trúc: Flutter App -> REST API/HTTP -> Express Backend -> Sequelize ORM -> SQLite Database. Riêng upload ảnh: Express Backend -> Cloudinary -> trả URL ảnh về app.', None),
('2.8. Thiết kế cơ sở dữ liệu', 'h2'),
('Bảng Users: id, name, email, password, phone, avatar, location, createdAt, updatedAt.', None),
('Bảng Tours: id, title, description, location, price, duration, imageUrl, createdAt, updatedAt.', None),
('Bảng News: id, title, content, imageUrl, createdAt, updatedAt.', None),
('Bảng Trips: id, userId, title, location, date, time, description, imageUrl, createdAt, updatedAt.', None),
('Bảng Conversations: id, userId, participantId, createdAt, updatedAt.', None),
('Bảng Messages: id, conversationId, senderId, text, createdAt, updatedAt.', None),
('2.9. Cấu trúc API', 'h2'),
('Auth API: POST /auth/signup, POST /auth/login, PATCH /auth/update.', None),
('Core API: GET /api/users, GET /api/news, GET /api/tours.', None),
('Trip API: GET /api/trips, POST /api/trips, GET /api/trips/:id.', None),
('Chat API: GET /api/chat/conversations, POST /api/chat/conversations, GET /api/chat/messages?conversationId=..., POST /api/chat/messages.', None),
('Upload API: POST /api/upload với multipart/form-data field file.', None),
('2.10. Yêu cầu chức năng', 'h2'),
('FR01: Hệ thống cho phép đăng ký tài khoản bằng name, email, password.', None),
('FR02: Hệ thống cho phép đăng nhập và nhận JWT token.', None),
('FR03: Hệ thống cho phép cập nhật hồ sơ cá nhân.', None),
('FR04: Hệ thống cho phép xem danh sách users, news, tours.', None),
('FR05: Hệ thống cho phép tạo và xem chuyến đi cá nhân.', None),
('FR06: Hệ thống cho phép tạo hội thoại và gửi tin nhắn.', None),
('FR07: Hệ thống cho phép upload ảnh.', None),
('2.11. Yêu cầu phi chức năng', 'h2'),
('NFR01 - Bảo mật: mật khẩu phải mã hóa bằng bcryptjs, API riêng tư yêu cầu JWT, không lưu secret trong source code, upload giới hạn định dạng và dung lượng.', None),
('NFR02 - Hiệu năng: API phản hồi nhanh, dữ liệu trả về gọn, ứng dụng không bị treo khi gọi API.', None),
('NFR03 - Dễ sử dụng: giao diện rõ ràng, thông báo lỗi dễ hiểu, thao tác phù hợp người dùng phổ thông.', None),
('NFR04 - Bảo trì: backend chia route/controller/model/middleware; frontend chia screen/core/service.', None),
('NFR05 - Mở rộng: có thể thêm admin dashboard, booking, thanh toán, realtime chat và thông báo đẩy.', None),
('CHƯƠNG 3: KẾT QUẢ XÂY DỰNG ỨNG DỤNG', 'h1'),
('3.1. Giao diện người dùng', 'h2'),
('Ứng dụng đã xây dựng các màn hình chính gồm: đăng ký, đăng nhập, Explore, My Trips, Chat, Chat Detail, Notification, Profile, Settings và Edit Profile. Các màn hình được thiết kế theo phong cách mobile app du lịch, sử dụng màu sắc nhất quán và bố cục dễ thao tác.', None),
('3.2. Backend API', 'h2'),
('Backend Express đã xây dựng các route cho xác thực, dữ liệu lõi, chuyến đi, chat và upload. API sử dụng JSON cho request/response, JWT cho xác thực và Sequelize để thao tác dữ liệu SQLite.', None),
('3.3. Kiểm thử', 'h2'),
('Dự án có thể kiểm thử API bằng Postman collection. Các API đăng nhập, đăng ký, cập nhật hồ sơ, lấy danh sách tour, tạo chuyến đi và gửi tin nhắn có thể được gọi trực tiếp thông qua baseUrl http://localhost:3000.', None),
('Flutter được kiểm tra bằng lệnh flutter analyze và flutter test. Backend được kiểm tra bằng npm test.', None),
('CHƯƠNG 4: KẾT LUẬN VÀ HƯỚNG PHÁT TRIỂN', 'h1'),
('4.1. Kết luận', 'h2'),
('Dự án Fellow4U đã xây dựng được ứng dụng mobile cơ bản phục vụ lĩnh vực du lịch, hỗ trợ người dùng đăng ký, đăng nhập, xem tour, tạo chuyến đi, quản lý hồ sơ và nhắn tin. Hệ thống áp dụng Flutter cho frontend và Node.js Express cho backend, kết hợp SQLite, Sequelize, JWT và Cloudinary để tạo thành một hệ thống client-server hoàn chỉnh.', None),
('Thông qua quá trình thực hiện, sinh viên nắm được quy trình phát triển ứng dụng mobile từ phân tích yêu cầu, thiết kế cơ sở dữ liệu, xây dựng giao diện, viết backend API, xác thực người dùng đến kiểm thử API bằng Postman.', None),
('4.2. Hạn chế', 'h2'),
('Một số chức năng mới ở mức cơ bản, dữ liệu còn phục vụ demo, chưa có dashboard quản trị, chưa có booking và thanh toán thực tế, chat chưa realtime bằng WebSocket.', None),
('4.3. Hướng phát triển', 'h2'),
('Phát triển admin dashboard để quản lý người dùng, tour, tin tức, booking và thống kê.', None),
('Bổ sung chức năng booking tour, xác nhận lịch, trạng thái đặt tour và lịch sử booking.', None),
('Tích hợp thanh toán online qua VNPay, MoMo, ZaloPay hoặc Stripe.', None),
('Nâng cấp chat realtime bằng Socket.IO hoặc WebSocket.', None),
('Thêm hệ thống đánh giá tour và hướng dẫn viên.', None),
('Tích hợp bản đồ Google Maps để gợi ý địa điểm và tìm hướng dẫn viên gần vị trí người dùng.', None),
('Tích hợp Firebase Cloud Messaging để gửi thông báo đẩy.', None),
('Ứng dụng AI để gợi ý lịch trình theo ngân sách, số ngày và sở thích cá nhân.', None),
]

def p_xml(text, style=None):
    text = escape(text)
    jc = '<w:jc w:val="center"/>' if style == 'center' else ''
    size = '24'
    bold = ''
    if style == 'h1':
        size = '32'; bold = '<w:b/>'
    elif style == 'h2':
        size = '28'; bold = '<w:b/>'
    elif style == 'center':
        size = '28'; bold = '<w:b/>'
    return f'<w:p><w:pPr>{jc}</w:pPr><w:r><w:rPr>{bold}<w:sz w:val="{size}"/></w:rPr><w:t xml:space="preserve">{text}</w:t></w:r></w:p>'

body = ''.join(p_xml(t, s) for t, s in paragraphs)
document = f'''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"><w:body>{body}<w:sectPr><w:pgSz w:w="11906" w:h="16838"/><w:pgMar w:top="1440" w:right="1440" w:bottom="1440" w:left="1440"/></w:sectPr></w:body></w:document>'''
content_types = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"><Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/><Default Extension="xml" ContentType="application/xml"/><Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/></Types>'''
rels = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/></Relationships>'''
word_rels = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"/>'''

with ZipFile(out, 'w', ZIP_DEFLATED) as z:
    z.writestr('[Content_Types].xml', content_types)
    z.writestr('_rels/.rels', rels)
    z.writestr('word/document.xml', document)
    z.writestr('word/_rels/document.xml.rels', word_rels)
print(out)
