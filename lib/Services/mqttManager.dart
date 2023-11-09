// mqtt_connection.dart

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
class MqttManager {
  static MqttServerClient? client;
  static MqttManager? _instance;

  MqttManager._();

  factory MqttManager() {
    if (_instance == null) {
      _instance = MqttManager._();
    }
    return _instance!;
  }

  Future<void> connect(String clientId, String username, String password) async {
    client = MqttServerClient('a173311e38b74a4f81fe5b6632087769.s1.eu.hivemq.cloud', '');
    client?.port = 8883;
    client?.secure = true;

    final mqttConnectMessage = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .startClean()
        .withWillTopic('my_will_message')
        .withWillMessage('my_will_message')
        .withWillQos(MqttQos.atLeastOnce)
        .withWillRetain();

    client?.connectionMessage = mqttConnectMessage;

    try {
      await client?.connect('nam54828', 'DoDucNam123');
      if (client?.connectionStatus?.state == MqttConnectionState.connected) {
        print('Connected to broker');
      } else {
        print('Connection failed - disconnecting, status is ${client?.connectionStatus}');
        client?.disconnect();
      }
    } catch (e) {
      print('Exception during connection: $e');
    }
  }

  void subscribe(String topic) {
    client?.subscribe(topic, MqttQos.atLeastOnce);
  }

  void unsubscribe(String topic) {
    client?.unsubscribe(topic);
  }

  void disconnect() {
    client?.disconnect();
  }
  void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client!.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

}
