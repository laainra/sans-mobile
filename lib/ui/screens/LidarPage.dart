import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:flutter_joystick/flutter_joystick.dart';

class LidarPage extends StatefulWidget {
  @override
  _LidarPageState createState() => _LidarPageState();
}

class _LidarPageState extends State<LidarPage> {
  final _formKey = GlobalKey<FormState>();
  final _ngrokPortController = TextEditingController();
  WebSocketChannel? _channel;
  String _status = 'Disconnected';
  List<double> axes = [0, 0, 0, 0];
  List<int> buttons = [];

  void _connectToWebSocket(String ngrokPort) async {
    try {
      final url = 'ws://10.3.43.4:9000/ws/connect/lidar';
      _channel = await WebSocketChannel.connect(Uri.parse(url));
      _channel!.sink.add('ws://0.tcp.ap.ngrok.io:$ngrokPort');
      _channel!.stream.listen((message) {
        print('Received message: $message');
      });
      setState(() => _status = 'Connected');
    } catch (error) {
      print('Error connecting: $error');
      setState(() => _status =
          'Connection Error: Check hostname or network'); // Set user-friendly error message
    }
  }

  void _sendMessage(String message) {
    if (_channel != null && _channel!.sink != null) {
      _channel!.sink.add(message);
    } else {
      print('WebSocket connection is not open');
    }
  }

  void _sendJoystickData(List<double> axes, List<int> buttons) {
    final data = {'axes': axes, 'buttons': buttons};
    _sendMessage(jsonEncode(data));
  }

  void _showPortInputDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter Ngrok Port'),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: _ngrokPortController,
            validator: (value) =>
                value!.isEmpty ? 'Please enter a port number' : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final ngrokPort = _ngrokPortController.text;
                _connectToWebSocket(ngrokPort);
                Navigator.pop(context);
              }
            },
            child: Text('Connect'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _channel?.sink.close();
    _ngrokPortController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AGV LiDAR'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Connection Status
            Text('Status: $_status'),
            SizedBox(height: 16),

            // Connect Button
            ElevatedButton(
              onPressed: () => _showPortInputDialog(),
              child: Text('Connect'),
            ),
            SizedBox(height: 20),

            // Joystick Control
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Joystick(
                  mode: JoystickMode.all,
                  listener: (details) {
                    setState(() {
                      axes[0] = details.x;
                      axes[1] = details.y;
                    });
                    _sendJoystickData(axes, buttons);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
