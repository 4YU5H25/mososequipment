// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, use_build_context_synchronously


import 'package:biomedicalfinal/db/database.dart';
import 'package:flutter/material.dart';
import 'package:biomedicalfinal/bluetoothscreen.dart';
import 'chartscreen.dart';

class screenthree extends StatefulWidget {
  @override
  State<screenthree> createState() => _screenthreeState();
}

class _screenthreeState extends State<screenthree> {
  //============DATABASE=============//
  DatabaseHelper db = DatabaseHelper();

  final _formKey = GlobalKey<FormState>();

  //=============FORM CONTROLLERS==================//

  TextEditingController _name = TextEditingController();

  TextEditingController _id = TextEditingController();

  TextEditingController _age = TextEditingController();

  TextEditingController _sex = TextEditingController();

  TextEditingController _visitno = TextEditingController();

  TextEditingController _weight = TextEditingController();

  TextEditingController _weightattachedtoDevice = TextEditingController();

  // =========== CHART ==================//

  bool isChartVisible = true;
  List<double> chartData = [];
  double area = 0;
  //============BLUETOOTH===========//
  bool receiving = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(Bluetooth.isConnected ? "Connected" : "Not Connected")),
        // appBar: AppBar(title: Text("Details")),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align children to the start
                    children: [
                      SizedBox(height: 48),
                      Padding(
                        padding: EdgeInsets.only(left: 18),
                        child: Text(
                          "Patient Name:",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Urbanist',
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(),
                          ),
                          child: TextFormField(
                            controller: _name,
                            textAlign: TextAlign.left, // Align text to the left
                            decoration: InputDecoration(
                              hintText: '',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a username';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 22),
                      Padding(
                        padding: EdgeInsets.only(left: 18),
                        child: Text(
                          "Patient Id:",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Urbanist',
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(),
                          ),
                          child: TextFormField(
                            controller: _id,
                            textAlign: TextAlign.left, // Align text to the left
                            decoration: InputDecoration(
                              hintText: '',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a id';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 22),
                      Row(children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 18),
                            child: Text(
                              "Age:",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Urbanist',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 130),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 35),
                            child: Text(
                              "Sex:",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Urbanist',
                              ),
                            ),
                          ),
                        ),
                      ]),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: 131,
                              height: 48,
                              child: Padding(
                                padding: EdgeInsets.only(left: 15, right: 15),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(),
                                  ),
                                  child: TextFormField(
                                    controller: _age,
                                    textAlign: TextAlign
                                        .left, // Align text to the left
                                    decoration: InputDecoration(
                                      hintText: '',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your age';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 100),
                          Expanded(
                            child: SizedBox(
                              width: 131,
                              height: 48,
                              child: Padding(
                                padding: EdgeInsets.only(left: 15, right: 15),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(),
                                  ),
                                  child: TextFormField(
                                    controller: _sex,
                                    textAlign: TextAlign
                                        .left, // Align text to the left
                                    decoration: InputDecoration(
                                      hintText: '',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your sex';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 22),
                      Row(children: [
                        Padding(
                          padding: EdgeInsets.only(left: 18),
                          child: Text(
                            "Visit Number:",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Urbanist',
                            ),
                          ),
                        ),
                        SizedBox(width: 73),
                        Padding(
                          padding: EdgeInsets.only(left: 35),
                          child: Text(
                            "Weight:",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Urbanist',
                            ),
                          ),
                        ),
                      ]),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 131,
                            height: 48,
                            child: Padding(
                              padding: EdgeInsets.only(left: 15, right: 15),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(),
                                ),
                                child: TextFormField(
                                  controller: _visitno,
                                  textAlign:
                                      TextAlign.left, // Align text to the left
                                  decoration: InputDecoration(
                                    hintText: '',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter visit number';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 98),
                          SizedBox(
                            width: 131,
                            height: 48,
                            child: Padding(
                              padding: EdgeInsets.only(left: 15, right: 15),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(),
                                ),
                                child: TextFormField(
                                  controller: _weight,
                                  textAlign:
                                      TextAlign.left, // Align text to the left
                                  decoration: InputDecoration(
                                    hintText: '',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter weight';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 22,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 18),
                        child: Text(
                          "Weight attached to the Device:",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Urbanist',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 22,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Container(
                          width: 280,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(),
                          ),
                          child: TextFormField(
                            controller: _weightattachedtoDevice,
                            textAlign: TextAlign.left, // Align text to the left
                            decoration: InputDecoration(
                              hintText: '',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter a Weight';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 22,
                      ),
                      Divider(
                        color: Colors.pink,
                      ),
                      SizedBox(height: 22),
                      Expanded(
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: SizedBox(
                                width: 300,
                                height: 76,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: const StadiumBorder(),
                                      backgroundColor: Colors.orange,
                                    ),
                                    child: Center(child: const Text('START')),
                                    onPressed: () async {
                                      if (Bluetooth.connection == null) {
                                        await Bluetooth.connectToDevice(
                                            Bluetooth.deviceAddress);
                                      }
                                      print("Start Button Pressed");
                                      setState(() {
                                        Bluetooth.area = 0;
                                        receiving = true;
                                        chartData.clear();
                                        Bluetooth.receivedDataList.clear();
                                        Bluetooth.receivedDataList.add(0);
                                      });
                                      if (Bluetooth.isConnected == true &&
                                          _formKey.currentState!.validate()) {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ChartScreen(
                                                  _name.text,
                                                  _id.text,
                                                  _age.text,
                                                  _sex.text,
                                                  _visitno.text,
                                                  _weight.text,
                                                  _weightattachedtoDevice
                                                      .text)),
                                        );
                                      }
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
