import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
        CREATE TABLE user_data(
          id INTEGER PRIMARY KEY,
          username TEXT,
          visit TEXT,
          age TEXT,
          area TEXT,
          gender TEXT,
          uid TEXT,
          weight TEXT,
          WeightAttached TEXT ,
          WorkDone TEXT,
          Samples TEXT
        )
      ''');
      },
    );
  }

  Future<void> insertUserData({
    required String username,
    required String age,
    required String area,
    required String visit,
    required String gender,
    required String id,
    required String weight,
    required String weightattached,
    required String wd,
    required List<double> samples,
  }) async {
    final String serializedArray = (samples.join(', ')).toString();
    print("Arrayyyyyy: $serializedArray");

    final Database db = await database;
    await db.insert(
      'user_data',
      {
        'username': username,
        'age': age,
        'area': area,
        'visit': visit,
        'gender': gender,
        'uid': id,
        'weight': weight,
        'WeightAttached': weightattached,
        'WorkDone': wd,
        'Samples': serializedArray
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllUserData() async {
    final Database db = await database;
    return await db.query('user_data');
  }
}

class DatabaseTable extends StatefulWidget {
  @override
  _DatabaseTableState createState() => _DatabaseTableState();
}

class _DatabaseTableState extends State<DatabaseTable> {
  List<Map<String, dynamic>> tableData = [];

  @override
  void initState() {
    super.initState();
    initDatabase().then((db) {
      db.rawQuery('SELECT * FROM user_data').then((result) {
        setState(() {
          tableData = result;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Data Table'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            columns: getColumns(),
            rows: tableData != null ? getRows() : [],
            dataRowHeight: 40.0, // Adjust the height between rows
          ),
        ),
      ),
    );
  }

  List<DataColumn> getColumns() {
    return [
      DataColumn(
        label: Text('Patient Name'),
      ),
      DataColumn(
        label: Text('Patient ID'),
      ),
      DataColumn(
        label: Text('Visit'),
      ),
      DataColumn(
        label: Text('Age'),
        numeric: true,
      ),
      DataColumn(
        label: Text('Work Done'),
      ),
      DataColumn(
        label: Text('Gender'),
      ),
      DataColumn(
        label: Text('Weight'),
      ),
      DataColumn(
        label: Text('Weight Attached'),
      ),
      DataColumn(
        label: Text('Area'),
      ),
      DataColumn(
        label: Text('Samples'),
      ),
    ];
  }

  List<DataRow> getRows() {
    return tableData.map((row) {
      return DataRow(
        cells: getCells(row),
      );
    }).toList();
  }

  List<DataCell> getCells(Map<String, dynamic> row) {
    return [
      DataCell(
        Text('${row['username']}'),
      ),
      DataCell(
        Text('${row['uid']}'),
      ),
      DataCell(
        Text('${row['visit']}'),
      ),
      DataCell(
        Text('${row['age']}'),
        showEditIcon: false,
      ),
      DataCell(
        Text('${row['area']}'),
      ),
      DataCell(
        Text('${row['gender']}'),
      ),
      DataCell(
        Text('${row['weight']}'),
      ),
      DataCell(
        Text('${row['WeightAttached']}'),
      ),
      DataCell(
        Text('${row['WorkDone']}'),
      ),
      DataCell(
        Text('${row['Samples']}'),
      ),
    ];
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE user_data(
            id INTEGER PRIMARY KEY,
            username TEXT,
            visit TEXT,
            age TEXT,
            area TEXT,
            gender TEXT,
            uid TEXT,
            weight TEXT,
            WeightAttached TEXT,
            WorkDone TEXT,
            Samples TEXT
          )
        ''');
      },
    );
  }
}
