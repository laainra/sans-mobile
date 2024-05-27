import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String title;
  final String desc;
  final String value;
  final IconData icon;
  final Color bgColor;

  const CardWidget({
    required this.title,
    required this.desc,
    required this.value,
    required this.icon,
    this.bgColor = Colors.transparent, // Mengatur warna latar belakang default menjadi transparan
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Aligment teks menjadi kiri
              children: [
                Text(
                  this.title,
                  style: TextStyle(fontSize: 30),
                ),
                Text(
                  this.value,
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                Text(
                  this.desc,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w200),
                ),
              ],
            ),
            Container(
              width: 200, // Atur lebar kontainer ikon
              height: 100, // Atur tinggi kontainer ikon
              color: this.bgColor,
              padding: EdgeInsets.all(10),
              child: Center(
                child: Icon(
                  this.icon,
                ),
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Mengatur kontainer menjadi lingkaran
              ),
            )
          ],
        ),
      ),
    );
  }
}
