import 'package:flutter_mqtt/config/helpers/mqtt/mqtt_service.dart';

abstract class MqttDatasource {
  MqttService getMqttService({required String host, required int port});
}
