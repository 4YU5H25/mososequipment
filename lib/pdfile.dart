import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class Pdf {
  late String name, id, workDone, visitno, sex, weight, weightattached, Samples;
  Pdf(
    this.name,
    this.id,
    this.workDone,
    this.visitno,
    this.sex,
    this.weight,
    this.weightattached,
    this.Samples,
  );

  void generate_pdf() async {
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
                      Text('Patient Name:'),
                      Text(name),
                    ]),
                    Row(children: [
                      Text('Patient ID: '),
                      Text(id),
                    ]),
                    Text('Visit Number: $visitno'),
                    Row(children: [
                      Text('Age: '),
                      Text(workDone),
                    ]),
                    Text('Sex: $sex'),
                    Text('Work Done: $workDone'),
                    Text('Weight: $weight'),
                    Text('Weight Attached: $weightattached'),
                    Text('Samples: $Samples'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
    pdf.addPage(page);
    final file = File('storage/emulated/0/Downloads/$name.pdf');
    await file.writeAsBytes(await pdf.save());
  }
}
