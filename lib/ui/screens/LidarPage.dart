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
      final url = 'wss://sans-agv.azurewebsites.net/ws/connect/lidar';
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
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel', style: TextStyle(color: Colors.white)),
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
            ),
          ),
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final ngrokPort = _ngrokPortController.text;
                if (_status == 'Connected') {
                  // Jika sudah terkoneksi, maka ganti menjadi "Disconnect"
                  setState(() {
                    _status = 'Disconnected';
                  });
                } else {
                  // Jika belum terkoneksi, maka jalankan fungsi untuk terkoneksi
                  _connectToWebSocket(ngrokPort);
                  Navigator.pop(context);
                }
              }
            },
            style: TextButton.styleFrom(
              backgroundColor:
                  _status == 'Connected' ? Colors.red : Colors.blue,
            ),
            child: Text(_status == 'Connected' ? 'Disconnect' : 'Connect',
                style: TextStyle(color: Colors.white)),
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
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
                decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(60, 39, 138, 1),
                  Colors.lightBlueAccent
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ))),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Connection Status
                  Text('Status: $_status'),
                  SizedBox(height: 16),

                  // Connect Button
                  Container(
                    width: double.infinity,
                    height: 50.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(60, 39, 138, 1),
                          Colors.lightBlueAccent
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: ElevatedButton(
  onPressed: _status == 'Connected' ? () {
    setState(() {
      _status = 'Disconnected';
    });
  } : _showPortInputDialog,
  style: ElevatedButton.styleFrom(
    shadowColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0),
    ),
    backgroundColor: Colors.transparent, // Ubah warna latar belakang menjadi transparan
  ),
  child: Text(
    _status == 'Connected' ? 'Disconnect' : 'Connect',
    style: TextStyle(
      fontSize: 20, // Ukuran teks besar
      color: Colors.white,
    ),
  ),
),

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
          ),
        ));
  }
}
