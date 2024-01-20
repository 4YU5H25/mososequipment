import 'package:biomedicalfinal/bluetoothscreen.dart';

import 'package:flutter/material.dart';
import 'package:biomedicalfinal/screen3.dart';
import 'package:biomedicalfinal/screen4.dart';
// import 'package:biomedicalfinal/screentwo.dart';
// import 'package:biomedicalfinal/splashscreen.dart';
import 'package:biomedicalfinal/splashscreenfinal.dart';

void main() {
  runApp(myapp());
}

class myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: splashscreenfinal(),
        debugShowCheckedModeBanner: false,
        routes: {
          '/screentwo': (context) => BluetoothScreen(),
          '/screenthree': (context) => screenthree(),
          '/screenfour': (context) => screenfour(),
        });
  }
}
