import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_parking/Provider/humidity_provider.dart';
import 'package:smart_parking/Provider/notification_provider.dart';
import 'package:smart_parking/Provider/reservation_provider.dart';
import 'package:smart_parking/Provider/temperature_provider.dart';
import 'package:smart_parking/Services/notifcation_service.dart';
import 'package:smart_parking/view/Home/home.dart';
import 'package:smart_parking/view/Page/onBoarding/onBoarding1.dart';
import 'package:smart_parking/view/profile/profile.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  NotificationService().initializeNotifications();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => TemperatureProvider()),
      ChangeNotifierProvider(create: (context) => HumidityProvider()),
      ChangeNotifierProvider(create: (context) => NotificationProvider()),
      ChangeNotifierProvider(create: (context) => ReservationProvider()),
    ],
    child: MyApp(),),
  );

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Parking- IoT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const onBoarding1(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  final tabbar = [
  Home(),
  profile()
  ];
  int _selectedIndex = 0;
  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabbar[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              backgroundColor: Colors.grey,
              label: "Home"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              backgroundColor: Colors.grey,
              label: "Profile"
          )
        ],
      ),
    );
  }
}

