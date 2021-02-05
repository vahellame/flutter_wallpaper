import 'package:flutter/material.dart';

class NetworkError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Проверьте соединение с интернетом",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16, color: Color(0xfffbfbfbf)),
          )
        ],
      ),
    );
  }
}