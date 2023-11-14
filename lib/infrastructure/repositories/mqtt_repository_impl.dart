import 'package:flutter_mqtt/config/helpers/mqtt/mqtt_service.dart';
import 'package:flutter_mqtt/domain/datasources/mqtt_datasource.dart';
import 'package:flutter_mqtt/domain/repositories/mqtt_repository.dart';

class MqttRepositoryImpl implements MqttRepository {
  final MqttDatasource mqttDatasource;

  MqttRepositoryImpl({required this.mqttDatasource});

  @override
  MqttService getMqttService(
      {required String host, required int port}) {
    return mqttDatasource.getMqttService(host: host, port: port);
  }
}
