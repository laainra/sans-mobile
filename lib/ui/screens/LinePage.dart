import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class LinePage extends StatefulWidget {
  @override
  _LinePageState createState() => _LinePageState();
}

class _LinePageState extends State<LinePage> {
  final WebSocketChannel _channel = WebSocketChannel.connect(
    Uri.parse('ws://10.3.43.4:9000/ws/dashboard/line'),
  );
  bool _agvOn = false;
  double _speed = 50;
  double _totalSpeed = 0;
  int _speedCount = 0;

  @override
  void initState() {
    super.initState();
    _agvOn = (localStorage.getItem('agvOn') == 'true');
  }

  void _toggleAGV() {
    setState(() {
      _agvOn = !_agvOn;
      localStorage.setItem('agvOn', _agvOn.toString());
      final payload = _agvOn ? 'kecepatan:50' : 'kecepatan:0';
      final topic = _agvOn ? 'On' : 'Off';

      _channel.sink.add(jsonEncode({'payload': payload, 'topic': topic}));
      print('AGV ${_agvOn ? "Nyala" : "Mati"}');
    });
  }

  void _setSpeed(double speed) {
    final payload = 'kecepatan:$speed';
    final topic = 'setSpeed';

    if (speed >= 0 && speed <= 100) {
      _channel.sink.add(jsonEncode({'payload': payload, 'topic': topic}));
      setState(() {
        _speed = speed;
        _totalSpeed += speed;
        _speedCount++;
        final averageSpeed = _totalSpeed / _speedCount;
        print('Average Speed: ${averageSpeed.toStringAsFixed(2)}');
      });
    } else {
      print('Please enter a valid speed between 0 and 100.');
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AGV Line Control'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // AGV On/Off Button
            ElevatedButton(
              onPressed: _toggleAGV,
              child: Text(_agvOn ? 'Turn Off AGV' : 'Turn On AGV'),
            ),
            SizedBox(height: 16),

            // Speed Slider
            Text('Speed: ${_speed.toInt()}'),
            Slider(
              value: _speed,
              min: 0,
              max: 100,
              divisions: 100,
              label: _speed.toInt().toString(),
              onChanged: (value) {
                _setSpeed(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class localStorage {
  static Map<String, String> _storage = {};

  static String? getItem(String key) {
    return _storage[key];
  }

  static void setItem(String key, String value) {
    _storage[key] = value;
  }
}
