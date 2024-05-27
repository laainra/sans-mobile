import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  final String currentPage;
  final Function(String) onPageSelected;

  const SideMenu({
    required this.currentPage,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Image.asset('assets/images/logo.png', width: 50, height: 50,),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromRGBO(198, 189, 229, 1), Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          ListTile(
            title: Text('Dashboard'),
            onTap: () {
              onPageSelected('dashboard');
              Navigator.pop(context);
              Navigator.pushNamed(context, '/dashboard'); // Navigasi ke halaman dashboard
            },
            selected: currentPage == 'dashboard',
            selectedTileColor: currentPage == 'dashboard' ? LinearGradient(
              colors: [Color.fromRGBO(60, 39, 138, 1), Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).colors.last.withOpacity(0.5) : null, // Buat gradient jika halaman aktif
          ),
          ListTile(
            title: Text('Line'),
            onTap: () {
              onPageSelected('line');
              Navigator.pop(context);
              Navigator.pushNamed(context, '/line'); // Navigasi ke halaman line
            },
            selected: currentPage == 'line',
            selectedTileColor: currentPage == 'line' ? LinearGradient(
              colors: [Color.fromRGBO(60, 39, 138, 1), Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).colors.last.withOpacity(0.5) : null, // Buat gradient jika halaman aktif
          ),
          ListTile(
            title: Text('Lidar'),
            onTap: () {
              onPageSelected('lidar');
              Navigator.pop(context);
              Navigator.pushNamed(context, '/lidar'); // Navigasi ke halaman lidar
            },
            selected: currentPage == 'lidar',
            selectedTileColor: currentPage == 'lidar' ? LinearGradient(
              colors: [Color.fromRGBO(60, 39, 138, 1), Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).colors.last.withOpacity(0.5) : null, // Buat gradient jika halaman aktif
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              // Navigasi ke halaman signin dan hapus semua rute sebelumnya dari tumpukan navigasi
              Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
