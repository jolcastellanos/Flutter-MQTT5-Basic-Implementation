import 'package:flutter_mqtt/config/helpers/mqtt/mqtt_service.dart';
import 'package:flutter_mqtt/domain/datasources/mqtt_datasource.dart';

class MqttDataSourceImpl implements MqttDatasource {
  @override
  MqttService getMqttService(
      {required String host,
      required int port}) {
    MqttService mqttService = MqttService(
        hostName: host,
        port: port);
    mqttService.initClient();
    return mqttService;
  }
}
