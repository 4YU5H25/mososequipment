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
                      Text('Patient Name: $name'),
                    ]),
                    Row(children: [
                      Text('Patient ID: $id'),
                    ]),
                    Text('Visit Number: $visitno'),
                    Row(children: [
                      Text('Age: $age'),
                    ]),
                    Text('Sex: $sex'),
                    Text('Work Done: $workDone'),
                    Text('Weight: $weight'),
                    Text('Weight Attached: $weightattached'),
                    Text('Samples: $samples'),
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
