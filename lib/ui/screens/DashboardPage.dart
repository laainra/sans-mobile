import 'package:flutter/material.dart';
import 'package:sans_mobile/ui/widgets/AgvCard.dart';
import 'package:sans_mobile/ui/widgets/SideMenuWidget.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _currentPage = 'dashboard'; // Menyimpan halaman aktif

  void _handlePageSelected(String page) {
    setState(() {
      _currentPage = page; // Memperbarui halaman aktif
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.transparent, 
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromRGBO(60, 39, 138, 1), Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: Builder( // Gunakan Builder untuk membuat konteks yang terkait dengan Scaffold
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Gunakan Scaffold.of(context) di dalam Builder
              },
            );
          },
        ),
      ),
      drawer: SideMenu(
        currentPage: _currentPage, // Berikan nilai halaman aktif ke SideMenu
        onPageSelected: _handlePageSelected, // Berikan fungsi untuk menangani pemilihan halaman
      ),
      body:  Center(child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AgvCardWidget(title: "AGV LiDAR", image: "assets/images/lidar.png", page: '/lidar'),
              SizedBox(height: 50,),
              AgvCardWidget(title: "AGV Line", image: "assets/images/line.png", page: '/line'),
            ],
          
        ),)
      ),
    );
  }
}
