import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

class PdfApi {
  static void download({
    required Uint8List bytes,
    required String downloadName,
  }) {
    final base64 = base64Encode(bytes);
    final anchor =
        AnchorElement(href: 'data:application/octet-stream;base64,$base64')
          ..target = 'blank';
    anchor.download = downloadName;

    document.body!.append(anchor);
    anchor.click();
    anchor.remove();
  }
}
