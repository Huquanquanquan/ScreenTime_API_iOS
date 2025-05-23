import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const methodChannel = MethodChannel('flutter_screentime');

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 选择应用按钮
            ElevatedButton(
              onPressed: () async {
                var result = 'approved';
                if (Platform.isAndroid) {
                  result = await methodChannel.invokeMethod('checkPermission')
                      as String;
                }
                debugPrint('[DEBUG]result: $result');
                if (result == 'approved') {
                  await methodChannel.invokeMethod('selectApps');
                } else {
                  debugPrint('[DEBUG]Permission not granted');
                  await methodChannel.invokeMethod('requestAuthorization');
                }
              },
              child: const Text('选择应用'),
            ),
            const SizedBox(height: 16),
            
            // 应用限制按钮
            ElevatedButton(
              onPressed: () {
                methodChannel.invokeMethod('applyRestrictions');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('应用限制'),
            ),
            const SizedBox(height: 16),
            
            // 解除限制按钮
            ElevatedButton(
              onPressed: () {
                methodChannel.invokeMethod('removeRestrictions');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('解除限制'),
            ),
          ],
        ),
      ),
    );
  }
}
