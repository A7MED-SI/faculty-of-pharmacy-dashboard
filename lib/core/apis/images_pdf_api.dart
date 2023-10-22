import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:pharmacy_dashboard/core/apis/pdf_api.dart';
import '../../layers/data/models/subject_image/subject_image.dart';

class ImagesPdfApi {
  static Future<void> generateThenDownload({
    required List<SubjectImage> images,
    required String subjectName,
  }) async {
    images.sort(
      (a, b) {
        return b.id.compareTo(a.id);
      },
    );
    final pdf = pw.Document();
    var data = await rootBundle.load("assets/fonts/arial.ttf");
    var myFont = pw.Font.ttf(data);
    pw.Widget buildTable(List<SubjectImage> images) {
      const tableHeaders = ['Image Title', 'ID'];

      return pw.TableHelper.fromTextArray(
        border: null,
        cellAlignment: pw.Alignment.centerLeft,
        tableDirection: pw.TextDirection.rtl,
        headerDecoration: const pw.BoxDecoration(
          borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
          color: PdfColors.blue500,
        ),
        headerHeight: 25,
        cellHeight: 40,
        cellAlignments: {
          0: pw.Alignment.centerLeft,
          1: pw.Alignment.centerRight,
        },
        headerStyle: pw.TextStyle(
          color: PdfColors.white,
          fontSize: 12,
          fontWeight: pw.FontWeight.bold,
          font: myFont,
        ),
        cellStyle: pw.TextStyle(
          fontSize: 10,
          font: myFont,
        ),
        rowDecoration: const pw.BoxDecoration(
          border: pw.Border(
            bottom: pw.BorderSide(
              color: PdfColors.black,
              width: .5,
            ),
          ),
        ),
        headers: List<String>.generate(
          tableHeaders.length,
          (col) => tableHeaders[col],
        ),
        data: List<List<String>>.generate(
          images.length,
          (row) => List<String>.generate(
            tableHeaders.length,
            (col) => col == 0 ? images[row].title : images[row].id.toString(),
          ),
        ),
      );
    }

    pdf.addPage(pw.MultiPage(
      pageTheme: const pw.PageTheme(
        pageFormat: PdfPageFormat.a4,
      ),
      build: (context) {
        return [
          buildTable(images),
        ];
      },
    ));
    final bytes = await pdf.save();

    PdfApi.download(downloadName: '$subjectName.pdf', bytes: bytes);
  }
}
