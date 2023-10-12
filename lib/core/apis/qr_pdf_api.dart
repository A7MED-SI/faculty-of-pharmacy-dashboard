import 'dart:typed_data';
import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart';

class QrPdfApi {
  static Future<Uint8List> generate({
    required List<Uint8List> qrImages,
    required List<String> subTypes,
  }) async {
    final pdf = PdfDocument();

    pdf.pageSettings.size = PdfPageSize.a4;
    pdf.pageSettings.margins = PdfMargins()
      ..left = 27
      ..top = 10
      ..bottom = 10
      ..right = 10;

    PdfPage page = pdf.pages.add();
    for (int i = 0; i < qrImages.length; i++) {
      if (i > 0 && i % 30 == 0) {
        page = pdf.pages.add();
      }
      final double qrLeftEdge =
          ((i % 30) % 5) * 100 + ((i % 30) % 5 > 0 ? ((i % 30) % 5) * 10 : 0);
      final double qrTopEdge = ((i % 30) ~/ 5) * 100 +
          ((i % 30) ~/ 5 > 0 ? ((i % 30) ~/ 5) * 30 : 0);
      final double stringLeftEdge =
          ((i % 30) % 5) * 100 + ((i % 30) % 5 > 0 ? ((i % 30) % 5) * 10 : 0);
      final double stringTopEdge = (((i % 30) ~/ 5) + 1) * 105 +
          ((i % 30) ~/ 5 > 0 ? ((i % 30) ~/ 5) * 25 : 0);
      page.graphics.drawImage(PdfBitmap(qrImages[i]),
          Rect.fromLTWH(qrLeftEdge, qrTopEdge, 100, 100));
      page.graphics.drawString(
          subTypes[i], PdfStandardFont(PdfFontFamily.courier, 12),
          bounds: Rect.fromLTWH(stringLeftEdge, stringTopEdge, 100, 15),
          pen: PdfPens.black,
          format: PdfStringFormat(
              lineAlignment: PdfVerticalAlignment.middle,
              alignment: PdfTextAlignment.center));
    }
    final bytes = await pdf.save();
    return Uint8List.fromList(bytes);
  }
}
