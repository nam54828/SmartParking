import 'package:flutter/material.dart';

class theTerms extends StatelessWidget {
  const theTerms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
    Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_left, color: Colors.white,)),
        title: Text("Terms", style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chào mừng bạn đến với ứng dụng giữ xe thông minh của chúng tôi. Trước khi bạn bắt đầu sử dụng dịch vụ, hãy đọc kỹ và hiểu rõ các điều khoản sau đây:',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            SizedBox(height: 16.0),
            Text(
              '1. Quy định về Đặt Chỗ',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 8.0),
            Text(
              '1.1 Thời Gian Đặt Chỗ\nNgười dùng có thể đặt chỗ giữ xe trong khoảng thời gian tối đa là 30 phút.',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            SizedBox(height: 8.0),
            Text(
              '1.2 Số Lần Đặt Chỗ Trong 1 Ngày\nMỗi người dùng có thể thực hiện đặt chỗ giữ xe tối đa 3 lần trong một ngày.',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            SizedBox(height: 16.0),
            Text(
              '2. Quy định Chung',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 8.0),
            Text(
              '2.1 Trách Nhiệm của Người Dùng\nNgười dùng chịu trách nhiệm về thông tin chính xác cung cấp khi đặt chỗ, bao gồm cả thời gian đến và rời khỏi khu vực giữ xe.',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            SizedBox(height: 8.0),
            Text(
              '2.2 Hạn Chế Trách Nhiệm\nChúng tôi không chịu trách nhiệm đối với bất kỳ mất mát hoặc thiệt hại nào xuất phát từ việc sử dụng dịch vụ giữ xe của chúng tôi.',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            SizedBox(height: 8.0),
            Text(
              '2.3 Quyền Điều Chỉnh\nChúng tôi giữ quyền điều chỉnh các quy định về đặt chỗ và sử dụng dịch vụ mà không cần báo trước.',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            SizedBox(height: 8.0),
            Text(
              '2.4 Tuân Thủ Luật Pháp\nNgười dùng cam kết tuân thủ tất cả các luật lệ và quy định pháp luật liên quan đến việc sử dụng dịch vụ giữ xe thông minh của chúng tôi.',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            SizedBox(height: 16.0),
            Text(
              '3. Chấp Nhận Điều Khoản',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 8.0),
            Text(
              'Việc sử dụng ứng dụng giữ xe của chúng tôi đồng nghĩa với việc bạn chấp nhận và tuân thủ tất cả các điều khoản được nêu trên.',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            SizedBox(height: 16.0),
            Text(
              'Hãy đảm bảo rằng bạn đã đọc kỹ và hiểu rõ các điều khoản trước khi bắt đầu sử dụng dịch vụ của chúng tôi. Nếu bạn có bất kỳ câu hỏi hoặc thắc mắc nào, vui lòng liên hệ với chúng tôi để được hỗ trợ. Chúng tôi hy vọng bạn có trải nghiệm thuận lợi và an toàn khi sử dụng ứng dụng giữ xe thông minh của chúng tôi.',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
          ],
        ),
      ),
    ));
  }
}
