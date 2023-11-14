import 'package:flutter_mqtt/config/helpers/mqtt/mqtt_service.dart';

abstract class MqttRepository {
  MqttService getMqttService({required String host, required int port});
}