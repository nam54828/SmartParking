import 'package:flutter/material.dart';

import '../humidity/humidity.dart';
import '../temperature/temperature.dart';


class BannerItem {
  final String imageUrl;
  final String text;
  final Widget route; // Đường dẫn đến trang được chỉ định

  BannerItem(this.imageUrl, this.text, this.route);
}

class banner extends StatelessWidget {
  final List<BannerItem> items = [
    BannerItem("images/weather.png", "What is the temperature in the parking lot?", temperature()),
    BannerItem("images/humidity.png", "What is the humidity like in the parking lot?", humidity()),
    // Thêm các mục khác nếu cần
  ];

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: items.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => items[index].route));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width*0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Image.asset(items[index].imageUrl, height: 200,),
                  Text(items[index].text, style: TextStyle(
                    color: Colors.black,
                      fontSize: 16
                  ),),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}