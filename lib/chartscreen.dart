// ChartScreen.dart

import 'package:biomedicalfinal/bluetoothscreen.dart';
import 'package:biomedicalfinal/db/database.dart';
import 'package:flutter/material.dart';
import 'Chart.dart';
import 'screenfour.dart';

class ChartScreen extends StatefulWidget {
  late String name, id, age, sex, visitno, weight, weightattached;
  ChartScreen(this.name, this.id, this.age, this.sex, this.visitno, this.weight,
      this.weightattached,
      {Key? key})
      : super(key: key);
  @override
  _ChartScreenState createState() =>
      _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  late String name, id, age, sex, visitno, weight, weightattached;
  late bool receiving;
  late double area;
  late List<double> chartData;

  @override
  void initState() {
    super.initState();
    receiving = true;
    area = 0;
    chartData = [];
    startListeningAndUpdateChart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chart Screen'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 80),
              const Divider(
                height: 40, // Adjust the height of the divider as needed
                thickness: 2, // Adjust the thickness of the divider as needed
                color: Colors.black,
              ),
              Center(
                child: Visibility(
                  visible:
                      true, 
                  child: Chart(
                    chartData: chartData,
                  ),
                ),
              ),
              const Divider(
                height: 40, // Adjust the height of the divider as needed
                thickness: 2, // Adjust the thickness of the divider as needed
                color: Colors.black,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: SizedBox(
                  width: 320,
                  height: 76,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size.fromHeight(60.0),
                      shape: const StadiumBorder(),
                      backgroundColor: Colors.red,
                    ),
                    child: const Align(
                        alignment: Alignment.center, child: Text('STOP')),
                    onPressed: () async {
                      print("Stop  Button Pressed");
                      Bluetooth.stopBluetooth();
                      setState(() {
                        receiving = false;
                        chartData.clear();
                        Bluetooth.receivedDataList.clear();
                        Bluetooth.receivedDataList.add(0);
                      });

                      String username = widget.name;
                      String id = widget.id;
                      String age = widget.age;
                      String sex = widget.sex;
                      String visit = widget.visitno;
                      String weight = widget.weight;
                      String weightattached = widget.weightattached;

                      await DatabaseHelper().insertUserData(
                        username: username,
                        age: age,
                        gender: sex,
                        visit: visit,
                        area: area.toString(),
                        id: id,
                        weight: weight.toString(),
                        weightattached: weightattached.toString(),
                        wd: (area * (double.parse(weightattached)) * 9.8)
                            .toString(),
                      );
                      print("Data saved successfully");
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return screenfour();
                      }));
                    },
                  ),
                ),
              ),
            ], 
          ),
        ),
      ),
    );
  }

  void startListeningAndUpdateChart() {
    Future<void> updateChart() async {
      // String newData = '';
      while (receiving) {
        double parsedData = Bluetooth.receivedDataList
            .elementAt(Bluetooth.receivedDataList.length - 1);
        if (Bluetooth.receivedDataList.length >= 2 &&
            parsedData >
                Bluetooth.receivedDataList
                    .elementAt(Bluetooth.receivedDataList.length - 2 ?? 0)) {
          area += parsedData;
        }
        setState(() {
          chartData.add(parsedData);

          {
            print("parsedData Screen3: $parsedData");
            print("Chart data updated: $chartData");
            print('area: $area');
          }
        });
        await Future.delayed(const Duration(milliseconds: 1000));
      }
    }

    updateChart();
  }
}
