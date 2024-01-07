import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../Services/mqttManager.dart';

class TemperatureProvider extends ChangeNotifier {
  final MqttManager _mqttManager = MqttManager();
  double _currentTemperature = 0.0;
  bool _isConnected = false;

  double get currentTemperature => _currentTemperature;
  bool get isConnected => _isConnected;

  void connect() async {
    await _mqttManager.connect('my_client_identifier', 'nam54828', 'DoDucNam123');
    _mqttManager.subscribe('SmartParking/temperature');
    MqttManager.client?.updates?.listen(_onMessage);
    _isConnected = true;
    notifyListeners();
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage>> event) {
    final MqttPublishMessage message = event[0].payload as MqttPublishMessage;
    final payload = MqttPublishPayload.bytesToStringAsString(message.payload.message);
    final topic = event[0].topic;

    print('Received message from topic: $topic, payload: $payload');

    if (topic == 'SmartParking/temperature') {
      _updateCurrentTemperature(double.tryParse(payload) ?? 0.0);
    }
  }

  void _updateCurrentTemperature(double newTemperature) {
    _currentTemperature = newTemperature;
    notifyListeners();
  }

  void disconnect() {
    _mqttManager.unsubscribe('SmartParking/temperature');
    _mqttManager.disconnect();
    _isConnected = false;
    notifyListeners();
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}
