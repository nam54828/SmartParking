import "package:flutter/material.dart";


import "../../Notification/notification.dart";
import "../../profile/profile.dart";
import "../ParkingReservation/parkingReservationScreen.dart";
import "../humidity/humidity.dart";
import "../temperature/temperature.dart";
import "myCar/myCar.dart";

class SelectItems {
  final String iconsUrl;
  final String text;
  final Widget route;

  SelectItems(this.iconsUrl, this.text, this.route);
}

class selectPages extends StatelessWidget {
  final List<SelectItems> selects = [
    SelectItems("directions_car", "Parking\nReservation", ParkingReservationScreen()),
    SelectItems("notifications_active", "My\nNotification", NotificationPage()),
    SelectItems("opacity", "Parking\nHumidity", humidity()),
    SelectItems("wb_cloudy", "Parking\nTemperature", temperature()),
    SelectItems("person", "My\nProfile", profile()),
    SelectItems("local_taxi", "My\nCar", myCar()),
  ];
  final Map<String, IconData> iconMap = {
    'directions_car': Icons.directions_car,
    'notifications_active': Icons.notifications_active,
    'opacity': Icons.opacity,
    'wb_cloudy': Icons.wb_cloudy,
    'person': Icons.person,
    'local_taxi': Icons.local_taxi,
    // Add more icons as needed
  };
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent:220,
      childAspectRatio: 3/2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 20),
      itemCount: selects.length,
      itemBuilder: (BuildContext, index){
          return GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => selects[index].route));
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(iconMap[selects[index].iconsUrl], size: 45, color: Colors.blueAccent,),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            selects[index].text,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
      },
    );
  }
}
