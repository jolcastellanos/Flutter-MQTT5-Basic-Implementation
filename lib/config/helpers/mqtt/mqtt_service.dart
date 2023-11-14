import 'dart:io';
import 'package:flutter/services.dart';
import 'package:mqtt5_client/mqtt5_client.dart';
import 'package:mqtt5_client/mqtt5_server_client.dart';
import 'package:uuid/uuid.dart';

class MqttService {
  final String hostName;
  final int port;
  late MqttServerClient client;
  bool connectionStatus = false;
  final clientId = const Uuid().v4();

  MqttService({
    required this.hostName,
    required this.port,
  });

  void initClient() async {
    client = MqttServerClient(hostName, clientId);
    client.keepAlivePeriod = 30;
    client.logging(on: false);
    client.secure = true;
    client.port = port;
    // ca certificate SSL/TSL
    ByteData bytes = await rootBundle.load('assets/certificates/emqxsl_ca.crt');
    final SecurityContext context = SecurityContext.defaultContext;
    context.setTrustedCertificatesBytes(bytes.buffer.asUint8List());

    final connMess = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .startClean(); // Non persistent session for testing
    client.connectionMessage = connMess;
  }

  Future<void> connectClient() async {
    try {
      await client.connect('user', 'password');
      connectionStatus = true;
    } on Exception catch (e) {
      print('Client exception - $e');
      client.disconnect();
      connectionStatus = false;
      return;
    }
  }

  void subscribeTopic({required onData, required String topicS}) {
    //MqttPublishMessage message
    client.subscribe(topicS, MqttQos.atLeastOnce);
    client.published!.listen((MqttPublishMessage message) {
      final text =
          MqttUtilities.bytesToStringAsString(message.payload.message!);
      onData(text);
    });
  }

  void publishMessage({required String topic, required String message}) {
    final builder = MqttPayloadBuilder();
    builder.addString(message);

    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  void disconnectService() async {
    await MqttUtilities.asyncSleep(2);
    client.disconnect();
    connectionStatus = false;
  }

  void unsubscribeTopic({required String topicS}) async {
    await MqttUtilities.asyncSleep(2);
    client.unsubscribeStringTopic(topicS);
  }
}
