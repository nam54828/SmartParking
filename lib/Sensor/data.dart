import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../Services/mqttManager.dart';

class sensorData extends StatefulWidget {
  const sensorData({Key? key}) : super(key: key);

  @override
  State<sensorData> createState() => _sensorDataState();

}

class _sensorDataState extends State<sensorData> {

  final MqttManager _mqttManager = MqttManager();

  double currentHumidity = 0.0;
  double currentTemperature = 0.0;
  DatabaseReference? databaseReference;
  double getCurrentTemperature() {
    return currentTemperature;
  }

  @override
  void initState() {
    super.initState();
    _connect();
  }

  void _connect() async {
    await _mqttManager.connect(
        'my_client_identifier', 'nam54828', 'DoDucNam123');
    _mqttManager.subscribe('SmartParking/humidity');
    _mqttManager.subscribe('SmartParking/temperature');
    MqttManager.client?.updates?.listen((
        List<MqttReceivedMessage<MqttMessage>> event) {
      final MqttPublishMessage receivedMessage = event[0]
          .payload as MqttPublishMessage;
      final String payload = MqttPublishPayload.bytesToStringAsString(
          receivedMessage.payload.message);
      print(
          'Received message from topic: ${event[0].topic}, payload: $payload');
      _updateCurrentHumidity(payload);
      _updateCurrentTemperature(payload);
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

  void _updateCurrentTemperature(String payload) {
    double temperatureValue = double.tryParse(payload) ?? 0.0;

    setState(() {
      currentTemperature = temperatureValue;
    });
  }

  @override
  void dispose() {
    _mqttManager.unsubscribe('SmartParking/humidity');
    _mqttManager.unsubscribe('SmartParking/temperature');
    _mqttManager.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
