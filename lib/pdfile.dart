import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class Pdf {
  late String name,
      id,
      workDone,
      age,
      visitno,
      sex,
      weight,
      weightattached,
      samples;
  Pdf(
    this.name,
    this.id,
    this.workDone,
    this.age,
    this.visitno,
    this.sex,
    this.weight,
    this.weightattached,
    this.samples,
  );

  Future<String> generate_pdf() async {
    final pdf = Document();

    final page = Page(
      pageFormat: PdfPageFormat.a4,
      build: (Context context) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1),
          ),
          child: Column(
            children: [
              Center(
                  // child: Image(),
                  ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text('Patient Name: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            font: Font.times(),
                          )),
                      Text(name, style: TextStyle(font: Font.times())),
                    ]),
                    Row(children: [
                      Text('Patient ID: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            font: Font.times(),
                          )),
                      Text(id, style: TextStyle(font: Font.times())),
                    ]),
                    Row(children: [
                      Text('Age: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            font: Font.times(),
                          )),
                      Text(age, style: TextStyle(font: Font.times())),
                    ]),
                    Row(children: [
                      Text('Sex: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            font: Font.times(),
                          )),
                      Text(sex, style: TextStyle(font: Font.times())),
                    ]),
                    Row(children: [
                      Text('Weight: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            font: Font.times(),
                          )),
                      Text(weight, style: TextStyle(font: Font.times())),
                    ]),
                    Row(children: [
                      Text('Weight Attached to equipment: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            font: Font.times(),
                          )),
                      Text(weightattached,
                          style: TextStyle(font: Font.times())),
                    ]),
                    Row(children: [
                      Text('Work Done: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            font: Font.times(),
                          )),
                      Text(workDone, style: TextStyle(font: Font.times())),
                    ]),
                    Row(children: [
                      Text('Samples: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            font: Font.times(),
                          )),
                      Text(samples, style: TextStyle(font: Font.courier())),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
    pdf.addPage(page);
    final file = File('storage/emulated/0/Download/$name.pdf');
    await file.writeAsBytes(await pdf.save());

    return 'storage/emulated/0/Download/$name.pdf';
  }
}
