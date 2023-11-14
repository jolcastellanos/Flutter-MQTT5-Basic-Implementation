
---

## Basic implementation of MQTT in Flutter with EMQX Broker

This repository showcases a basic implementation of the [Flutter MQTT V5 client](https://pub.dev/packages/mqtt5_client) with the EMQX broker (SSL/TSL) in Flutter.

The application allows users to send messages to a selected topic, subscribe and unsubscribe to a topic, and display the last message in it.

It utilizes Provider as a state manager to showcase the MQTT status and the messages in the subscribed topic.

## Development Setup
To get started, clone the repository and execute the following commands:
```
flutter pub get
flutter run
```

## Screenshots

<div align="center">
  <img src="/assets/screenshots/flutter_mqtt.png" height="500em" />
</div>

---
