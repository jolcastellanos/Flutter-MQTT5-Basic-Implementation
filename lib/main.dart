import 'package:flutter/material.dart';
import 'package:flutter_mqtt/config/theme/app_theme.dart';
import 'package:flutter_mqtt/domain/repositories/mqtt_repository.dart';
import 'package:flutter_mqtt/infrastructure/datasources/mqtt_datasource_impl.dart';
import 'package:flutter_mqtt/infrastructure/repositories/mqtt_repository_impl.dart';
import 'package:flutter_mqtt/presentation/provider/mqtt_provider.dart';
import 'package:flutter_mqtt/presentation/screens/mqtt_screen.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final MqttRepository mqttRepository = MqttRepositoryImpl(
      mqttDatasource: MqttDataSourceImpl()
      );
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => MqttProvider(mqttRepository: mqttRepository))],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
          title: 'Flutter MQTT',
          theme: AppTheme(selectedColor: 9).getTheme(),
          home: const MqttScreen()),
    );
  }
}
