import 'package:flutter/material.dart';
import 'package:flutter_mqtt/config/helpers/mqtt/mqtt_service.dart';
import 'package:flutter_mqtt/domain/repositories/mqtt_repository.dart';
import 'package:mqtt5_client/mqtt5_client.dart';

class MqttProvider extends ChangeNotifier {
  final MqttRepository mqttRepository;
  MqttProvider({required this.mqttRepository});

  String _publishTopic = '';
  String _publishMessage = '';
  String _subscribeTopic = '';
  String _subscribeMessage = '';
  String initStatus = '';
  String clientStatus = '';
  String subscriptionStatus = '';
  bool disableSubscribeTopicField = false;
  bool disableSubscribeButton = false;
  bool disableUnsubscribeButton = true;

  void setSubscribeTopic(value) {
    _subscribeTopic = value;
  }

  void setPublishMessage(value) {
    _publishMessage = value;
  }

  void setPublishTopic(value) {
    _publishTopic = value;
  }

  void setSubscribeMessage(value) {
    _subscribeMessage = value;
    notify();
  }

  String get publishTopic => _publishTopic;

  String get publishMessage => _publishMessage;

  String get subscribeTopicM => _subscribeTopic;

  String get subscribeMessage => _subscribeMessage;

  MqttService? mqttService;

  void initMqtt({required String host, required int port}) {
    try {
      mqttService = mqttRepository.getMqttService(host: host, port: port);
      initStatus = 'Mqtt service initialized';
    } catch (e) {
      initStatus = 'Error to init Mqtt service ($e)';
    }
    notify();
    mqttService?.client.onDisconnected = () {
      clientStatus = 'Client not connected';
      notify();
    };

    mqttService?.client.onConnected = () {
      clientStatus = 'Client connected';
    };

    mqttService?.client.onSubscribed = (MqttSubscription subscription) {
      subscriptionStatus = 'Subscribed client to $_subscribeTopic';
      notify();
    };

    mqttService?.client.pongCallback = () {
      print('Response client callback invoked (keep alive)');
    };

    mqttService?.client.onBadCertificate = (dynamic a) => true;
  }

  Future<void> connectClient() async {
    await mqttService?.connectClient();
    notify();
  }

  void publish() {
    if ((mqttService?.connectionStatus ?? false)) {
      mqttService?.publishMessage(
          topic: _publishTopic, message: _publishMessage);
    }
  }

  void disconnectClient() {
    mqttService?.disconnectService();
    notify();
  }

  void subscribeTopic(ValueChanged onMessage) {
    try {
      mqttService?.subscribeTopic(onData: onMessage, topicS: _subscribeTopic);
    } catch (e) {
      subscriptionStatus = 'Error subscribing client to $_subscribeTopic';
    }

    disableSubscribeTopicField = true;
    disableSubscribeButton = true;
    disableUnsubscribeButton = false;
    notify();
  }

  void unSubscribeTopic() {
    try {
      mqttService?.unsubscribeTopic(topicS: _subscribeTopic);
      subscriptionStatus = 'Unsubscribed client to $_subscribeTopic';
    } catch (e) {
      subscriptionStatus = 'Error unsubscribing client to $_subscribeTopic';
    }

    disableSubscribeTopicField = false;
    disableSubscribeButton = false;
    disableUnsubscribeButton = true;
    notify();
  }

  void notify() {
    notifyListeners();
  }
}
