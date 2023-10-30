import 'package:flutter/material.dart';

class ParkingReservationScreen extends StatefulWidget {
  @override
  _ParkingReservationScreenState createState() => _ParkingReservationScreenState();
}

class _ParkingReservationScreenState extends State<ParkingReservationScreen> {
  int numberOfReservations = 0; // lưu số lượng chỗ đỗ xe
  int totalParkingSpots = 30; // Số chỗ đậu xe tổng cộng

  List<bool> availableSpots = List.generate(30, (index) => true);

  // tạo phương thức để đặt chỗ đỗ xe tại chỉ số spotIndex
  void makeReservation(int spotIndex) {
    if (numberOfReservations < 3) {
      if (availableSpots[spotIndex]) {
        Future.delayed(Duration(minutes: 30), () {
          setState(() {
            availableSpots[spotIndex] = true;
          });
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Successful Reservation'),
              content: Text(
                  'Parking spot ${spotIndex + 1} is reserved for 30 minutes.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );

        setState(() {
          numberOfReservations++;
          availableSpots[spotIndex] = false;
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Spot Already Reserved'),
              content: Text(
                  'Parking spot ${spotIndex + 1} is already reserved.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Maximum Reservations Reached'),
            content: Text(
                'You have reached the maximum number of reservations for today.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Widget buildParkingSpots(List<bool> spots) {
    return Wrap( // 1 widget trong Flutter cho phép xếp các widget con theo hàng ngang hoặc dọc theo không gian có sẵn
      spacing: 10, // khoảng cách giữa các widget theo chiều ngang
      runSpacing: 10, // Khoảng cách theo chiều dọc
      children: List.generate(spots.length, (index) {
        return GestureDetector( // dùng để bắt sự kiện chạm
          onTap: () {
            makeReservation(index);
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            width: 80,
            height: 40,
            decoration: BoxDecoration(
              color: spots[index] ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: spots[index] ? Colors.green.withOpacity(0.7) : Colors
                      .red.withOpacity(0.7),
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Spot ${index + 1}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parking Reservation'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Available Parking Spots: ${availableSpots
                    .where((spot) => spot)
                    .length}/$totalParkingSpots',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisExtent: 600,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Zone A',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      buildParkingSpots(availableSpots.sublist(0, 10)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Zone B',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      buildParkingSpots(availableSpots.sublist(10, 20)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Zone C',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      buildParkingSpots(availableSpots.sublist(20, 30)),
                    ],
                  ),
                ],
              ),
            ],
          )
        ),
      ),
    );
  }
}
