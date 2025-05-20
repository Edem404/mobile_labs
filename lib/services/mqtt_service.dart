import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTService {
  final client = MqttServerClient.withPort(
    'c9182ed650f3442eb09c7c5d2f9dbfdf.s1.eu.hivemq.cloud',
    'flutter_client',
    8883,
  );

  MQTTService() {
    client.secure = true;
    client.logging(on: true);
    client.keepAlivePeriod = 20;
  }

  static void _parseJson(Map<String, dynamic> message) {
    final sendPort = message['sendPort'] as SendPort;
    final payload = message['payload'] as String;

    try {
      final data = jsonDecode(payload);
      final double temp = (data['temp_value'] as num).toDouble();
      sendPort.send(temp);
    } catch (e) {
      sendPort.send(null);
    }
  }

  Future<double?> _parseInIsolate(String payload) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(_parseJson, {
      'sendPort': receivePort.sendPort,
      'payload': payload,
    });
    return await receivePort.first as double?;
  }

  Stream<double> connectAndListen() async* {
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

    if (client.connectionStatus?.state != MqttConnectionState.connected) {
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
        final temp = await _parseInIsolate(payload);
        if (temp != null) {
          yield temp;
        }
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
