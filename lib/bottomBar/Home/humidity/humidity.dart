import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'dart:math' as math;

import '../../../Services/mqttManager.dart';


class humidity extends StatefulWidget {
  const humidity({Key? key}) : super(key: key);

  @override
  State<humidity> createState() => _humidityState();
}

class _humidityState extends State<humidity> {
  final MqttManager _mqttManager = MqttManager();

  double currentHumidity = 0.0;
  DatabaseReference? databaseReference;
  @override
  void initState() {
    super.initState();
    setState(() {
      _connect();
      humidity();
    });
  }

  void _connect() async {
    await _mqttManager.connect('my_client_identifier', 'nam54828', 'DoDucNam123');
    _mqttManager.subscribe('SmartParking/humidity');
    MqttManager.client?.updates?.listen((List<MqttReceivedMessage<MqttMessage>> event) {
      final MqttPublishMessage receivedMessage = event[0].payload as MqttPublishMessage;
      final String payload = MqttPublishPayload.bytesToStringAsString(receivedMessage.payload.message);
      final String topic = event[0].topic;
      print('Received message from topic: ${event[0].topic}, payload: $payload');
      if (topic == 'SmartParking/humidity') {
        // Chỉ xử lý thông điệp từ chủ đề "SmartParking/humidity"
        _updateCurrentHumidity(payload);

      }
    });
  }
  void _updateCurrentHumidity(String payload) {
    // Parse payload to double (temperature value)
    double humidityValue = double.tryParse(payload) ?? 0.0;

    setState(() {
      // Update the current temperature value
      currentHumidity = humidityValue;
    });
  }

  @override
  void dispose() {
    _mqttManager.unsubscribe('SmartParking/humidity');
    _mqttManager.disconnect();
    super.dispose();
  }
  String getHumidityDescription(double humidity) {
    if (humidity >= 0 && humidity < 20) {
      return 'Very Dry 🏜️';
    } else if (humidity >= 20 && humidity < 40) {
      return 'Dry 🏖️';
    } else if (humidity >= 40 && humidity < 60) {
      return 'Moist 🌦️';
    } else if (humidity >= 60 && humidity < 80) {
      return 'Damp 🌧️';
    } else if (humidity >= 80 && humidity <= 100) {
      return 'Very Moist 🌊';
    } else {
      return 'Invalid humidity data';
    }
  }
  @override
  Widget build(BuildContext context) {
    String humidityDescription = getHumidityDescription(currentHumidity);

    return Scaffold(
      appBar: AppBar(
        title: Text("Humidity", style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18
        ),),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Humidity Gauge',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20.0),
            SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  minimum: 0,
                  maximum: 100,
                  ranges: <GaugeRange>[

                    GaugeRange(
                      startValue: 0,
                      endValue: 20,
                      color: Colors.green,

                    ),
                    GaugeRange(
                      startValue: 20,
                      endValue: 40,
                      color: Colors.yellow,
                    ),
                    GaugeRange(
                      startValue: 40,
                      endValue: 60,
                      color: Colors.orange,
                    ),
                    GaugeRange(
                      startValue: 60,
                      endValue: 80,
                      color: Colors.red,
                    ),
                    GaugeRange(
                      startValue: 80,
                      endValue: 100,
                      color: Colors.purple,
                    ),
                  ],
                  pointers: <GaugePointer>[
                    NeedlePointer(
                      value: currentHumidity,
                      enableAnimation: true,
                    ),
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                      widget: Text(
                        '$currentHumidity%',
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
              humidityDescription,
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}