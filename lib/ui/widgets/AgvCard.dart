import 'package:flutter/material.dart';
class AgvCardWidget extends StatelessWidget {
  final String title;
  final String image;
  final String page;

  const AgvCardWidget({
    required this.title,
    required this.image,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, this.page),
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: 210,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(color: Color.fromARGB(96, 107, 108, 116),width: 2)
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Image.asset(
                    this.image,
                    width: 200,
                    height: 100,
                  ),
                  SizedBox(height: 20,),
                  Text(
                    this.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
