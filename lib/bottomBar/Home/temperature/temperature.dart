import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../../../Services/mqttManager.dart';



class temperature extends StatefulWidget {
  const temperature({Key? key}) : super(key: key);

  @override
  State<temperature> createState() => _temperatureState();
}

class _temperatureState extends State<temperature> {
  final MqttManager _mqttManager = MqttManager();

  double currentTemperature = 0.0;
  DatabaseReference? databaseReference;
  @override
  void initState() {
    super.initState();
    setState(() {
      _connect();
    });
  }

  void _connect() async {
    await _mqttManager.connect('my_client_identifier', 'nam54828', 'DoDucNam123');
    _mqttManager.subscribe('SmartParking/temperature');
    MqttManager.client?.updates?.listen((List<MqttReceivedMessage<MqttMessage>> event) {
      final MqttPublishMessage receivedMessage = event[0].payload as MqttPublishMessage;
      final String payload = MqttPublishPayload.bytesToStringAsString(receivedMessage.payload.message);
      final String topic = event[0].topic;
      print('Received message from topic: ${event[0].topic}, payload: $payload');
      if (topic == 'SmartParking/temperature') {
        // Chỉ xử lý thông điệp từ chủ đề "SmartParking/humidity"
        _updateCurrentTemperature(payload);
      }
    });
  }
  void _updateCurrentTemperature(String payload) {
    // Parse payload to double (temperature value)
    double temperatureValue = double.tryParse(payload) ?? 0.0;

    setState(() {
      // Update the current temperature value
      currentTemperature = temperatureValue;
    });
  }


  @override
  void dispose() {
    _mqttManager.unsubscribe('SmartParking/temperature');
    _mqttManager.disconnect();
    super.dispose();
  }
  String getTemperatureDescription(double temperature) {
    if (temperature >= 0 && temperature < 10) {
      return 'It\'s very cold ❄️';
    } else if (temperature >= 10 && temperature < 20) {
      return 'It\'s cold ☃️';
    } else if (temperature >= 20 && temperature < 30) {
      return 'It\'s moderate 🌡️';
    } else if (temperature >= 30 && temperature < 40) {
      return 'It\'s warm ☀️';
    } else if (temperature >= 40 && temperature <= 60) {
      return 'It\'s hot 🔥';
    } else {
      return 'Temperature out of range';
    }
  }
  @override
  Widget build(BuildContext context) {
    String temperatureDescription = getTemperatureDescription(currentTemperature);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Temperature", style: TextStyle(
          color: Colors.black,
          fontSize: 18
        ),),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Temperature Gauge',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20.0),
            SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  minimum: 0,
                  maximum: 60,
                  ranges: <GaugeRange>[

                    GaugeRange(
                      startValue: 0,
                      endValue: 15,
                      color: Colors.green,

                    ),
                    GaugeRange(
                      startValue: 15,
                      endValue: 30,
                      color: Colors.yellow,
                    ),
                    GaugeRange(
                      startValue: 30,
                      endValue: 45,
                      color: Colors.orange,
                    ),
                    GaugeRange(
                      startValue: 45,
                      endValue: 60,
                      color: Colors.red,
                    ),

                  ],
                  pointers: <GaugePointer>[
                    NeedlePointer(
                      value: currentTemperature,
                      enableAnimation: true,
                    ),
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                      widget: Text(
                        '$currentTemperature C',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      angle: 90,
                      positionFactor: 0.5,
                    ),

                  ],

                ),
              ],
            ),
            Text(
              temperatureDescription,
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}