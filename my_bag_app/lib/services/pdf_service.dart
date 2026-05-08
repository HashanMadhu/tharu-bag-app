import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> generateInvoice(Map<String, dynamic> order) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              "Tharu Bag Center - Invoice",
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            pw.Text("Customer Name: ${order['name']}"),
            pw.Text("Bag Type: ${order['bagName']}"),
            pw.Text("Mobile: ${order['phone']}"),
            pw.Text("Address: ${order['address']}"),
            pw.SizedBox(height: 20),
            pw.Text(
              "Thank you for your business!",
              style: pw.TextStyle(
                fontSize: 14,
                fontStyle: pw.FontStyle.italic,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.grey700, // අකුරු වල පාට වෙනස් කිරීමට
              ),
            ),
          ],
        );
      },
    ),
  );

  // PDF එක පෙන්වීම හෝ Print කිරීමට ඉඩ දීම
  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}
