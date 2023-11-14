import 'package:flutter/material.dart';
import 'package:flutter_mqtt/presentation/provider/mqtt_provider.dart';
import 'package:provider/provider.dart';


class MqttScreen extends StatelessWidget {
  const MqttScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MqttProvider mqttProvider = context.watch<MqttProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('MQTT SIMPLE IMPLEMENTATION'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('MQTT SERVICE'),
                ],
              ),
              Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomFilledButton(
                        label: 'Start MQTT',
                        onPressed: () {
                          mqttProvider.initMqtt(
                              host: 'mqtt host borker',
                              port: 8883);
                        }),
                    CustomFilledButton(
                        label: 'Connect',
                        onPressed: () async {
                          await mqttProvider.connectClient();
                        }),
                    CustomFilledButton(
                        label: 'Disconnect',
                        onPressed: () {
                          mqttProvider.disconnectClient();
                        }),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('PUBLISH')],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  CustomTextField(
                    placeholder: 'Entry a topic',
                    label: 'Topic',
                    textValue: mqttProvider.publishTopic,
                    onValue: mqttProvider.setPublishTopic,
                  ),
                  CustomTextField(
                    placeholder: 'Entry a Message!',
                    label: 'Message',
                    textValue: mqttProvider.publishMessage,
                    onValue: mqttProvider.setPublishMessage,
                  ),
                ],
              ),
              CustomFilledButton(
                  label: 'Publish message',
                  onPressed: () {
                    if (mqttProvider.publishTopic.isEmpty) return;
                    mqttProvider.publish();
                  }),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('SUBSCRIBE')],
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                placeholder: 'Entry a topic to subcribe!',
                label: 'Topic',
                dissabled: mqttProvider.disableSubscribeTopicField,
                textValue: mqttProvider.subscribeTopicM,
                onValue: mqttProvider.setSubscribeTopic,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomFilledButton(
                      onPressed: () {
                        if (mqttProvider.subscribeTopicM.isEmpty) return;
                        mqttProvider.subscribeTopic(mqttProvider.setSubscribeMessage);
                      },
                      disabled: mqttProvider.disableSubscribeButton,
                      label: 'Subscribe to topic'),
                  CustomFilledButton(
                      onPressed: () {
                        if (mqttProvider.subscribeTopicM.isEmpty) return;
                        mqttProvider.unSubscribeTopic();
                      },
                      disabled: mqttProvider.disableUnsubscribeButton,
                      label: 'Unsubscribe to topic'),
                ],
              ),
              const SizedBox(height: 10),
              CustomTextField(
                  textValue: mqttProvider.subscribeMessage,
                  placeholder: '',
                  label: 'Last message on the subscription topic',
                  dissabled: true,
                  onValue: (value){}),
              const SizedBox(height: 15),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment:CrossAxisAlignment.start,
                  children: [
                    const Text('Mqtt Status', style: TextStyle(fontWeight: FontWeight.bold),),
                    Text('Mqtt start status: ${mqttProvider.initStatus}'),
                    Text('Client status: ${mqttProvider.clientStatus}'),
                    Text('Subscription status: ${mqttProvider.subscriptionStatus}'),
                  ],
                ),
              ),
            
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.placeholder,
    required this.label,
    this.dissabled = false,
    this.textValue = '',
    required this.onValue,
  });

  final String placeholder;
  final String label;
  final bool dissabled;
  final String textValue;
  final ValueChanged onValue;

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController(text: textValue);
    final FocusNode focusNone = FocusNode();

    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Focus(
          onFocusChange: (hasFocus) {
            if (!hasFocus) {
              onValue(textController.text);
            }
          },
          child: TextField(
            focusNode: focusNone,
            readOnly: dissabled,
            controller: textController,
            onTapOutside: (event) => focusNone.unfocus(),
            decoration: InputDecoration(
                label: Text(label),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                hintText: placeholder),
          ),
        ),
      ),
    );
  }
}

class CustomFilledButton extends StatelessWidget {
  const CustomFilledButton(
      {super.key,
      required this.onPressed,
      required this.label,
      this.disabled = false});

  final VoidCallback onPressed;
  final String label;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: FilledButton(
          onPressed: disabled ? null : onPressed,
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(color)),
          child: Text(label),
        ),
      ),
    );
  }
}
