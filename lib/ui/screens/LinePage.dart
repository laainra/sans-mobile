import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class LinePage extends StatefulWidget {
  @override
  _LinePageState createState() => _LinePageState();
}

class _LinePageState extends State<LinePage> {
  final WebSocketChannel _channel = WebSocketChannel.connect(
    Uri.parse('wss://sans-agv.azurewebsites.net/ws/dashboard/line'),
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
            ))
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // AGV On/Off Button
Container(
  width: double.infinity,
  height: 50.0,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(5.0),
    gradient: LinearGradient(
      colors: [
        Color.fromRGBO(60, 39, 138, 1),
        Colors.lightBlueAccent,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  child: ElevatedButton(
    onPressed: _toggleAGV,
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.zero, // Remove padding

      elevation: 0,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,

      
    ),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(60, 39, 138, 1),
            Colors.lightBlueAccent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          _agvOn ? 'Turn Off AGV' : 'Turn On AGV',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    ),
  ),
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
