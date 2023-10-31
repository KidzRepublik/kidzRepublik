import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfPreviewPage extends StatelessWidget {
  final String currency;
  final String totalLand;
  final String farmerName;
  final String cropName;
  final String plot_no;
  final String Sowing_date;
  final String harvestingDate;
  final String seed_used;
  final String seed_expenses;
  final String land_prep_expenses;
  final String irrigation_expenses;
  final String ferrtilizer;
  final String ferrtilizer_expenses;
  final String ferrtilizer_used;
  final String Pesticides;
  final String Pesticides_expenses;
  final String Pesticides_used;
  final String other;
  final String other_expenses;
  final String other_used;
  final String labor_expenses;
  final String total_expenditure;
  final String productivity;
  final String total_income;
  final String result;

  PdfPreviewPage(
      {Key? key,
      required this.cropName,
      required this.plot_no,
      required this.Sowing_date,
      required this.harvestingDate,
      required this.seed_used,
      required this.seed_expenses,
      required this.land_prep_expenses,
      required this.irrigation_expenses,
      required this.ferrtilizer,
      required this.ferrtilizer_expenses,
      required this.ferrtilizer_used,
      required this.Pesticides,
      required this.Pesticides_expenses,
      required this.Pesticides_used,
      required this.other,
      required this.other_expenses,
      required this.other_used,
      required this.labor_expenses,
      required this.total_expenditure,
      required this.productivity,
      required this.total_income,
      required this.result,
      required this.totalLand,
      required this.farmerName,
      required this.currency})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Preview'),
      ),
      body: PdfPreview(
        build: (context) => makePdf(),
      ),
    );
  }

  Future<Uint8List> makePdf() async {
    final pdf = pw.Document();
    final ByteData bytes = await rootBundle.load('assets/logo.png');
    final Uint8List byteList = bytes.buffer.asUint8List();
    pdf.addPage(pw.Page(
        margin: const pw.EdgeInsets.all(10),
        pageFormat: PdfPageFormat.legal,
        build: (context) {
          return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                 pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      // pw.Header(
                      //     text: "GreenAgri",
                      //     level: 1,
                      //     textStyle: pw.TextStyle(fontSize: 30)),

                pw.Container(
                    height: 30,
                    width: 500,
                    decoration: pw.BoxDecoration(
                      color: PdfColors.green900,
                    ),
                    child: pw.Center(
                      child: pw.Text(
                          "Land: $totalLand - Farmer: Mr, $farmerName",
                          style: pw.TextStyle(
                              fontSize: 16, color: PdfColors.white)),
                    )),
                      pw.Container(
                        width: 40,
                        height: 40,
                        child: pw.ClipOval(
                          child: pw.Image(pw.MemoryImage(byteList),
                              fit: pw.BoxFit.fitHeight),
                        ),
                      ),
                      // pw.Image(pw.MemoryImage(byteList),
                      //     fit: pw.BoxFit.fitHeight, height: 100, width: 100)
                    ]
                 ),
               // pw.Container(height: 10),
                pw.Container(height: 10),
                pw.Container(
                    height: 50,
                    decoration: pw.BoxDecoration(
                      color: PdfColors.blue50,
                    ),
                    child: pw.Center(
                        child: pw.Padding(
                      padding: pw.EdgeInsets.all(8.0),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                        children: [
                          pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                            children: [
                              pw.Text("Crop Name:",
                                  style: pw.TextStyle(fontSize: 14)),
                              pw.Text('$cropName',
                                  style: pw.TextStyle(fontSize: 14)),
                            ],
                          ),
                          pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                            children: [
                              pw.Text("Sowing Date:",
                                  style: pw.TextStyle(fontSize: 14)),
                              pw.Text("$Sowing_date",
                                  style: pw.TextStyle(fontSize: 14)),
                            ],
                          ),
                          pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                            children: [
                              pw.Text("Harvesting Date:",
                                  style: pw.TextStyle(fontSize: 14)),
                              pw.Text("$harvestingDate",
                                  style: pw.TextStyle(fontSize: 14)),
                            ],
                          ),
                          pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                            children: [
                              pw.Text("Total Expenditure",
                                  style: pw.TextStyle(
                                    fontSize: 14,
                                  )),
                              pw.Text("$currency $total_expenditure",
                                  style: pw.TextStyle(fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                    ))),
                pw.Container(height: 5),
                pw.Container(
                    height: 50,
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey200,
                    ),
                    child: pw.Center(
                        child: pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                        children: [
                          pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                            children: [
                              pw.Text("Production",
                                  style: pw.TextStyle(fontSize: 14)),
                              pw.Text("$productivity",
                                  style: pw.TextStyle(fontSize: 14)),
                            ],
                          ),
                          pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                            children: [
                              pw.Text("Total Income",
                                  style: pw.TextStyle(fontSize: 14)),
                              pw.Text("$currency $total_income",
                                  style: pw.TextStyle(fontSize: 14)),
                            ],
                          ),
                          pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                            children: [
                              pw.Text("$result $currency",
                                  style: pw.TextStyle(fontSize: 14)),
                              pw.Text("", style: pw.TextStyle(fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                    ))),
                pw.Container(height: 5),
                pw.Container(
                    height: 10,
                    child: pw.Center(
                      child: pw.Text("Summary of Expenditures",
                          style: pw.TextStyle(
                              fontSize: 18,
                              color: PdfColors.black,
                              fontWeight: pw.FontWeight.bold)),
                    )),
                pw.Container(height: 15),
                pw.Center(
                  child: pw.Container(
                    width: 400,
                    padding: const pw.EdgeInsets.all(1.0),
                    child: pw.TableHelper.fromTextArray(
                      context: context,
                      data: <List<dynamic>>[
                        <dynamic>[
                          'Fertilizer - $ferrtilizer',
                          '$currency. $ferrtilizer_expenses',
                        ],
                        <dynamic>[
                          'Pest - $Pesticides',
                          '$currency. $Pesticides_expenses',
                        ],
                        <dynamic>[
                          '$other',
                          '$currency. $other_expenses',
                        ],
                        <dynamic>[
                          'Seeds - $cropName',
                          '$currency. $seed_expenses',
                        ],
                      ],
                      columnWidths: {
                        0: const pw.FixedColumnWidth(20), // Date
                        1: const pw.FixedColumnWidth(20), // Expenditure
                      },
                      border: pw.TableBorder.all(
                          color: PdfColors
                              .white), // Set border color to transparent
                      headerStyle: pw.TextStyle(
                        fontSize: 14, // Reduced font size
                      ),
                      cellStyle: pw.TextStyle(
                        fontSize: 14, // Reduced font size
                      ),
                      cellAlignment: pw.Alignment.center,
                      headerAlignment: pw.Alignment.center,
                    ),
                  ),
                ),
                pw.Container(height: 10),
                pw.Container(
                    height: 10,
                    child: pw.Center(
                      child: pw.Text("Detail of Expenditures",
                          style: pw.TextStyle(
                              fontSize: 18,
                              color: PdfColors.black,
                              fontWeight: pw.FontWeight.bold)),
                    )),
                pw.Divider(borderStyle: pw.BorderStyle.dashed),
                pw.Container(
                  padding: const pw.EdgeInsets.all(1.0),
                  child: pw.TableHelper.fromTextArray(
                    context: context,
                    data: <List<dynamic>>[
                      <dynamic>[
                        'Expenditure',
                        'Descripton',
                      ],
                      <dynamic>[
                        'Plot Number',
                        '$plot_no',
                      ],
                      <dynamic>['Sowing date', '$Sowing_date'],
                      <dynamic>[
                        'Harvesting date',
                        '$harvestingDate',
                      ],
                      <dynamic>['Seed Used', '$seed_used'],
                      <dynamic>[
                        'Land Preparation Expenses',
                        '$currency. $land_prep_expenses',
                      ],
                      <dynamic>[
                        'Irrigation Expenses',
                        '$currency. $irrigation_expenses',
                      ],
                      <dynamic>['Labor Expenses', '$currency. $labor_expenses'],
                      <dynamic>['Result ', '$result $currency'],
                      <dynamic>[
                        pw.Text(
                          'Total Expenditures',
                          style: pw.TextStyle(
                            fontSize: 16,
                            // Change the color to red
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          '$currency. $total_expenditure',
                          style: pw.TextStyle(
                            fontSize: 16,
                            // Change the color to red
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                    columnWidths: {
                      0: const pw.FixedColumnWidth(180), // Date
                      1: const pw.FixedColumnWidth(180), // Expenditure
                    },
                    border: pw.TableBorder.all(),
                    headerStyle: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 14, // Reduced font size
                    ),
                    cellStyle: pw.TextStyle(
                      fontSize: 14, // Reduced font size
                    ),
                    cellAlignment: pw.Alignment.centerLeft,
                    headerAlignment: pw.Alignment.centerLeft,
                  ),
                ),
              ]);

        }));
    return pdf.save();
  }

}
