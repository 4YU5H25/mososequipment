// ignore_for_file: use_build_context_synchronously, prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_element, avoid_print

import 'package:csv/csv.dart';
import 'dart:convert';
import 'dart:io';
import 'db/database.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'pdfile.dart';
import 'pdfviewer.dart';
import 'package:intl/intl.dart';

class screenfour extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Align(
                alignment: Alignment.center,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.amber,
                      padding: const EdgeInsets.all(25)),
                  child: const Text('Generate entire Report'),
                  onPressed: () async {
                    print('Generate button pressed');
                    await requestStoragePermission();
                    await _generateAndDownloadCSV(context);
                    // await Future.delayed(Duration(milliseconds: 500));
                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DatabaseTable()));
                  },
                )),
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: Align(
                alignment: Alignment.center,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.amber,
                      padding: const EdgeInsets.all(25)),
                  child: const Text('Generate Patient Report'),
                  onPressed: () async {
                    print('Generate button pressed');
                    await requestStoragePermission();
                    final lastRowData = await DatabaseHelper().fetchLastRow();
                    Pdf pdf = Pdf(
                        lastRowData!['username'],
                        lastRowData['uid'],
                        lastRowData['WorkDone'],
                        lastRowData['age'],
                        lastRowData['visit'],
                        lastRowData['gender'],
                        lastRowData['weight'],
                        lastRowData['WeightAttached'],
                        lastRowData['Samples']);
                    pdf.generate_pdf();
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Patient Report Saved")));
                    String name = lastRowData['username'];
                    PdfViewerPage('storage/emulated/0/Download/$name.pdf');
                  },
                )),
          ),
        ],
      ),
    );
  }

  Future<void> _generateAndDownloadCSV(BuildContext context) async {
    // Retrieve all user data from SQLite database
    List<Map<String, dynamic>> userDataList =
        await DatabaseHelper().getAllUserData();

    List<String> header = [
      'Username',
      'Age',
      'UID',
      'Gender',
      'Weight',
      'Visit',
      'WeightAttached',
      'WorkDone',
      'Samples'
    ];

    // Generate CSV data for new entries only
    List<List<String>> newCsvData = [];
    for (var userData in userDataList) {
      newCsvData.add([
        userData['username'],
        userData['age'].toString(),
        userData['uid'].toString(),
        userData['gender'],
        userData['weight'].toString(),
        userData['visit'].toString(),
        userData['WeightAttached'].toString(),
        userData['WorkDone'].toString(),
        userData['Samples'].toString(),
      ]);
    }

    // Get the path to the existing CSV file
    // Directory? downloadsDir = await getExternalStorageDirectory();
    // String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    // String filePath = '${downloadsDir!.path}/Report_$timestamp.csv';

    // Get the app's documents directory

    Directory documentsDir = await getApplicationDocumentsDirectory();
    // String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String timestamp = DateFormat('yyyyMMddHHmm').format(DateTime.now());
    print("timestamp: $timestamp");

    String filePath = '${documentsDir.path}/Report_$timestamp.csv';
    print("DIrecturyyyy: $documentsDir");
    print("filleee pathhh: $filePath");

    try {
      // Check if the file exists
      bool fileExists = await File(filePath).exists();

      if (fileExists) {
        // Read existing CSV data
        String existingCsvContent = await File(filePath).readAsString();
        List<List<dynamic>> existingCsvData =
            CsvToListConverter().convert(existingCsvContent);

        // Combine existing and new data
        existingCsvData.addAll(newCsvData);

        // Write CSV data with header
        await File(filePath).writeAsString(
          const ListToCsvConverter(fieldDelimiter: '  ')
              .convert(existingCsvData),
          encoding: utf8,
        );
      } else {
        // Write CSV data with header
        await File(filePath).writeAsString(
          const ListToCsvConverter(fieldDelimiter: '  ')
              .convert([header] + newCsvData),
          encoding: utf8,
        );
      }

      String documentsFolderPath = '/storage/emulated/0/Documents';
      Directory? externalDir = await getExternalStorageDirectory();
      // String newFilePath = '${externalDir!.path}/Report_$timestamp.csv';
      // Generate a timestamp for the filename

      // Create a filename with the prefix "Report" + date and time
      String fileName = 'Report_$timestamp.csv';

      String newFilePath = '$documentsFolderPath/$fileName';

      await File(filePath).copy(newFilePath);
      print("neww file pathh: $newFilePath");
      await File(filePath).delete();

      // Show success message and open option
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Report saved to Documents!'),
          // action: SnackBarAction(
          //   label: 'Open',
          //   onPressed: () async {
          //     // OpenFile.open(newFilePath);
          //     await OpenAppFile.open(newFilePath, mimeType: 'text/csv', uti: 'public.comma-separated-values-text', locate: false);
          //     print("opened!!!");
          //   },
          // ),
        ),
      );
    } catch (e) {
      print("Error saving CSV: $e");
      // Handle the error and inform the user
    }
  }

  Future<bool> requestStoragePermission() async {
    var storage = await Permission.storage.request();

    bool s = storage == PermissionStatus.granted;
    print("Storage permission status: $s");

    if (storage == PermissionStatus.granted) {
      // Permission granted, you can access storage
      print('Storage permission granted');
      return true;
    } else if (storage == PermissionStatus.denied) {
      // Permission denied
      print('Storage permission denied');
      return false;
    } else if (storage == PermissionStatus.permanentlyDenied) {
      // Permission permanently denied
      print('Storage permission permanently denied. Open app settings.');
      await openAppSettings();
      return false;
    }

    // If status is restricted, unavailable, or limited, handle accordingly
    return false;
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
                DataColumn(label: Text('WorkDone')),
                DataColumn(label: Text('WeightAttached')),
                DataColumn(label: Text('Samples')),
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
                  DataCell(Text(userData['WorkDone'].toString())),
                  DataCell(Text(userData['WeightAttached'].toString())),
                  DataCell(Text(userData['Samples'].toString())),
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
