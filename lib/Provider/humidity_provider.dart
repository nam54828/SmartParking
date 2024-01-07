import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:smart_parking/Services/mqttManager.dart';

class HumidityProvider extends ChangeNotifier{
  final MqttManager _mqttManager = MqttManager();
  double _currentHumidity = 0.0;
  bool _isConnected = false;

  double get currentHumidity => _currentHumidity;
  bool get isConnected => _isConnected;

  void connect() async {
    await _mqttManager.connect('my_client_identifier', 'nam54828', 'DoDucNam123');
    _mqttManager.subscribe('SmartParking/humidity');
    MqttManager.client?.updates?.listen(_onMessage);
    _isConnected = true;
    notifyListeners();
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage>> event) {
    final MqttPublishMessage message = event[0].payload as MqttPublishMessage;
    final payload = MqttPublishPayload.bytesToStringAsString(message.payload.message);
    final topic = event[0].topic;

    print('Received message from topic: $topic, payload: $payload');

    if(topic == 'SmartParking/humidity'){
      _updateCurrentHumidity(double.tryParse(payload) ?? 0.0);
    }
  }

  void _updateCurrentHumidity(double newHumidity) {
    _currentHumidity = newHumidity;
  }

  void disconnect() {
    _mqttManager.unsubscribe('SmartParking/humidity');
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