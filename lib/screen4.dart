// ignore_for_file: use_build_context_synchronously, prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_element, avoid_print

import 'package:biomedicalfinal/db/database.dart';
import 'package:flutter/material.dart';
// import 'package:pdf/pdf.dart';

class Report extends StatelessWidget {
  late final String? name, id, age, sex, visit, weight, area;

  Report({this.name, this.id, this.age, this.sex, this.visit, this.weight,
      this.area});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Align(
            alignment: Alignment.center,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.all(25)),
              child: const Text('Generate Report'),
              onPressed: () async {
                print('Generate button pressed');
                await _showUserData(context);
              },
            )),
      ),
    );
  }

  Future<void> _showUserData(BuildContext context) async {
    // Retrieve all user data from SQLite database
    List<Map<String, dynamic>> userDataList =
        await DatabaseHelper().getAllUserData();

    // Display user data in a DataTable
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('User Data'),
          content: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(
                    label: Text(
                  'Patient',
                )),
                DataColumn(label: Text('Age')),
                DataColumn(label: Text('Id')),
                DataColumn(label: Text('Gender')),
                DataColumn(label: Text('Weight')),
                DataColumn(label: Text('Visit Count')),
                DataColumn(label: Text('Area')),
              ],
              rows: userDataList.map((userData) {
                return DataRow(cells: [
                  DataCell(Text(userData['username'])),
                  DataCell(Text(userData['age'].toString())),
                  DataCell(Text(userData['uid'])),
                  DataCell(Text(userData['gender'])),
                  DataCell(Text(userData['weight'])),
                  DataCell(Text(userData['visit'].toString())),
                  DataCell(Text(userData['area'].toString())),
                ]);
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
