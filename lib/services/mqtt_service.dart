import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTService {
  final client = MqttServerClient.withPort(
    'c9182ed650f3442eb09c7c5d2f9dbfdf.s1.eu.hivemq.cloud',
    'flutter_client',
    8883,
  );

  Stream<double> connectAndListen() async* {
    client.logging(on: false);
    client.secure = true; // because of port 8883
    client.keepAlivePeriod = 20;

    final connMessage = MqttConnectMessage()
        .authenticateAs('mobile', 'MobileLab1')
        .startClean()
        .withWillQos(MqttQos.atMostOnce);
    client.connectionMessage = connMessage;

    try {
      await client.connect();
    } catch (e) {
      client.disconnect();
      return;
    }

    const topic = 'temp_topic';
    client.subscribe(topic, MqttQos.atMostOnce);

    await for (final message in client.updates!) {
      final recMess = message[0].payload as MqttPublishMessage;
      final payload =
      MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      try {
        final data = jsonDecode(payload);
        final double temp = (data['temp_value'] as num).toDouble();
        yield temp;
      } catch (e) {
        client.disconnect();
        return;
      }
    }
  }

  void disconnect() {
    client.disconnect();
  }
}
