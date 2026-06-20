// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// Future<void> generateInvoice(Map<String, dynamic> order) async {
//   final pdf = pw.Document();

//   pdf.addPage(
//     pw.Page(
//       build: (pw.Context context) {
//         return pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             pw.Text(
//               "Tharu Bag Center - Invoice",
//               style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
//             ),
//             pw.SizedBox(height: 20),
//             pw.Text("Customer Name: ${order['name']}"),
//             pw.Text("Order Date: ${order['orderDate']}"),
//             pw.Text("Bag Type: ${order['bagName']}"),
//             pw.Text("Address: ${order['address']}"),
//             pw.Text("Price: ${order['price']}"),
//             pw.Text("Quantity: ${order['quantity']}"),
//             pw.Text("Total Price: ${order['totalPrice']}"),
//             pw.Text("Mobile: ${order['phone']}"),

//             pw.SizedBox(height: 20),
//             pw.Text(
//               "Payment Method: Cash on Delivery",
//               style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
//             ),

//             pw.SizedBox(height: 20),
//             pw.Text(
//               "Opposite Bank of Ceylon, Polpithigama",
//               style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
//             ),
//             pw.SizedBox(height: 20),
//             pw.Text(
//               "Contact Us: 074 259 9932",
//               style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
//             ),

//             pw.SizedBox(height: 20),

//             pw.Text(
//               "Thank you for your business!",
//               style: pw.TextStyle(
//                 fontSize: 14,
//                 fontStyle: pw.FontStyle.italic,
//                 fontWeight: pw.FontWeight.bold,
//                 color: PdfColors.grey700, // අකුරු වල පාට වෙනස් කිරීමට
//               ),
//             ),
//           ],
//         );
//       },
//     ),
//   );

//   // PDF එක පෙන්වීම හෝ Print කිරීමට ඉඩ දීම
//   await Printing.layoutPdf(
//     onLayout: (PdfPageFormat format) async => pdf.save(),
//   );
// }
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> generateInvoice(Map<String, dynamic> order) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a5, // Invoice වලට වඩාත්ම ගැලපෙන A5 ප්‍රමාණය
      margin: const pw.EdgeInsets.all(20),
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // 🏢 HEADER SECTION
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start, // 🎯 මෙතන 'crossAxisAlignment' ලෙස නිවැරදි කළා
                  children: [
                    pw.Text(
                      "THARU BAG CENTER",
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.brown800,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text("Opposite Bank of Ceylon, Polpithigama", style: const pw.TextStyle(fontSize: 10)),
                    pw.Text("Contact: 074 259 9932", style: const pw.TextStyle(fontSize: 10)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end, // 🎯 මෙතනත් 'crossAxisAlignment' ලෙස නිවැරදි කළා
                  children: [
                    pw.Text(
                      "INVOICE",
                      style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700),
                    ),
                    pw.Text("Date: ${order['orderDate'] ?? '-'}", style: const pw.TextStyle(fontSize: 10)),
                  ],
                ),
              ],
            ),

            pw.SizedBox(height: 10),
            pw.Divider(thickness: 1, color: PdfColors.brown300),
            pw.SizedBox(height: 10),

            // 👤 CUSTOMER DETAILS
            pw.Text(
              "BILL TO:",
              style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.grey600),
            ),
            pw.SizedBox(height: 2),
            pw.Text("${order['name']}", style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
            pw.Text("Phone: ${order['phone']}", style: const pw.TextStyle(fontSize: 11)),
            pw.Text("Address: ${order['address']}", style: const pw.TextStyle(fontSize: 11)),

            pw.SizedBox(height: 20),

            // 📊 ORDER ITEMS TABLE
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
              columnWidths: {
                0: const pw.FlexColumnWidth(3), // Bag Name
                1: const pw.FlexColumnWidth(1), // Price
                2: const pw.FlexColumnWidth(1), // Qty
                3: const pw.FlexColumnWidth(1.5), // Total
              },
              children: [
                // Table Header
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.brown100),
                  children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text('Bag Type', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11))),
                    pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text('Price', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11), textAlign: pw.TextAlign.right)),
                    pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text('Qty', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11), textAlign: pw.TextAlign.center)),
                    pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text('Total', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11), textAlign: pw.TextAlign.right)),
                  ],
                ),
                // Table Data Row
                pw.TableRow(
                  children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text("${order['bagName']}", style: const pw.TextStyle(fontSize: 11))),
                    pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text("Rs.${order['price']}", style: const pw.TextStyle(fontSize: 11), textAlign: pw.TextAlign.right)),
                    pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text("${order['quantity']}", style: const pw.TextStyle(fontSize: 11), textAlign: pw.TextAlign.center)),
                    pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text("Rs.${order['totalPrice']}", style: const pw.TextStyle(fontSize: 11), textAlign: pw.TextAlign.right)),
                  ],
                ),
              ],
            ),

            // 💰 TOTAL SECTION
            pw.SizedBox(height: 15),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Container(
                  width: 150,
                  child: pw.Column(
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text("Net Total:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                          pw.Text("Rs.${order['totalPrice']}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12, color: PdfColors.brown800)),
                        ],
                      ),
                      pw.SizedBox(height: 4),
                      pw.Divider(thickness: 1, color: PdfColors.black),
                    ],
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 20),

            // 💳 PAYMENT METHOD
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              child: pw.Text(
                "Payment Method: Cash on Delivery",
                style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.grey800),
              ),
            ),

            pw.Spacer(),

            // 🌸 FOOTER
            pw.Center(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Divider(thickness: 0.5, color: PdfColors.grey400),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    "Thank you for your business!",
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontStyle: pw.FontStyle.italic,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.brown600,
                    ),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text("Come Again!", style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}