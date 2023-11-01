
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';

RxBool isLoading = true.obs;
int checkedInCount = 0;
int absentCount = 0;
  var startDate;
  var endDate;

class BiWeeklyReportShapePDFPreviewPage extends StatelessWidget {
  final String babyID_;
  final String babypicture_;
  final String name_;
  final String date_;
  // final  startdate;
  // final  enddate;
  final groupedActivities;
  final String class_;

  BiWeeklyReportShapePDFPreviewPage({
    Key? key,
    required this.babyID_,
    required this.name_,
    required this.date_,
    required this.class_,
    required this.babypicture_,
    // required this.startdate, required this.enddate,
    this.groupedActivities,
  }) : super(key: key);
  final collectionReference = FirebaseFirestore.instance.collection('Activity');


  @override
  Widget build(BuildContext context) {
    final mQ = MediaQuery.of(context).size;
    DateTime now = DateTime.now();
    DateTime currentDate = DateTime.now();
    DateTime fifteenDaysAgo = currentDate.subtract(Duration(days: 15));


    currentDate = DateTime(currentDate.year,currentDate.month,currentDate.day);
    fifteenDaysAgo = DateTime(fifteenDaysAgo.year,fifteenDaysAgo.month,fifteenDaysAgo.day);


    if (now.day >= 1 && now.day <= 15) {
      startDate = DateTime(now.year, now.month, 1);
      endDate = DateTime(now.year, now.month, 15);
    } else{
      startDate = DateTime(now.year, now.month, 16);
      endDate = DateTime(now.year, now.month, 31);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Preview'),
      ),
      body: PdfPreview(
        build: (context) => makePdf(mQ),
      ),
    );
  }
  Future<Uint8List> makePdf(mQ) async {
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
    pw.Column(
    children: [
    pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.center,
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Container(
            width: 40,
            height: 40,
            child: pw.ClipOval(
              child: pw.Image(pw.MemoryImage(byteList),
                  fit: pw.BoxFit.fitHeight),
            ),
          ),

          pw.Container(alignment: pw.Alignment.center,
            width: mQ.width * 0.45,
            height: mQ.height * 0.05,
            child:
            pw.Column(
              children: [
                // (Academic Session 2023-2024),
                pw.Text('BI-WEEKLY ACTIVITIES',style: pw.TextStyle(fontSize: 14,fontWeight: pw.FontWeight.bold)),
                pw.Text('(Academic Session 2023-2024)',style: pw.TextStyle(fontSize: 12,fontWeight: pw.FontWeight.bold)),
              ],
            ),
          ),
        ]),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Expanded(child: pw.Text('Date: ${DateFormat('dd MMM').format(startDate)} to ${DateFormat('dd MMM yy').format(endDate)}',textAlign: pw.TextAlign.left,style: pw.TextStyle(fontSize: 10),)),
          pw.Expanded(child:
          pw.Text(" ${(name_)}",
              textAlign: pw.TextAlign.center,    style: pw.TextStyle(
                  fontSize: 14,
                  // pw.fontFamily: 'Comic Sans MS',
                  fontWeight:pw. FontWeight.bold,
                  color: PdfColors.blue))),
          // Expanded(child: Text(,textAlign: TextAlign.center,)),
          pw.Expanded(child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text('Days Present: $checkedInCount',textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 10),),
              pw.Text('Absent: $absentCount',textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 10),),
            ],
          )),
        ],
      ),
    ],
    ),

      // countdays(startDate,endDate,mQ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(18.0),
        child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: groupedActivities.entries.map((entry) {
                  return pw.Column(
                    children: [
                  pw.Container(width: mQ.width*0.9,color: PdfColors.grey.shade(50),
                        child: pw.Text(
                          '${entry.key}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Container(width: mQ.width*0.9,color: PdfColors.green.shade(50),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: entry.value.map((activity) {
                            return pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Row(
                                  children: [
                                  pw.Expanded(child: pw.Text('${activity['Activity']}',style: pw.TextStyle(fontWeight: pw.FontWeight.bold),)),
      pw.Expanded(child: pw.Text('${activity['date_']}',textAlign: pw.TextAlign.right,style: pw.TextStyle(color: PdfColors.grey.shade(500)),)),
                                  ],
                                ),
      pw.Text('${activity['description']}'),
                                // Text('Time: ${activity['time_']}'),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
      pw.SizedBox(height: 8),
                    ],
                  );
                }).toList(),
      )
          ,
        ),


            // BiWeeklySharingWithParents(
            //   baby: babyID_,babypicture: babypicture_,babyname: name_,
            //   MoodScreen(baby: babyID_,
              // subject: 'Physical Activity',                  category: 'BiWeekly',
              // reportdate_: getCurrentDate(),
              // subjectcolor_: Colors.brown.withOpacity(0.8),biweeklystatus_: 'New',),
          ],
        )]);}));
    return pdf.save();

  }
// countdays(startDate,endDate,mQ){
//   return pw.Padding(
//     padding:  pw.EdgeInsets.all(18.0),
//     child: pw.StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('Activity')
//           .where('id', isEqualTo: babyID_)
//           .where('date_', isGreaterThanOrEqualTo: DateFormat('dd-MM-yyyy').format(startDate), isLessThanOrEqualTo: DateFormat('dd-MM-yyyy').format(endDate))
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//
//
//         snapshot.data!.docs.forEach((activity) {
//           if (activity['Activity'] == 'Checked In') {
//             checkedInCount++;
//           }
//           if (activity['Activity'] == 'Absent') {
//             absentCount++;
//           }
//         });
//
//         return pw.Container(color: PdfColors.brown.shade(50),
//           child: pw.Column(
//             children: [
//               // pw.Row(
//               //     crossAxisAlignment: pw.CrossAxisAlignment.center,
//               //     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               //     children: [
//               //       pw.Container(alignment: pw.Alignment.center,
//               //         width: mQ.width * 0.45,
//               //         height: mQ.height * 0.05,
//               //         child:
//               //         pw.Column(
//               //           children: [
//               //             // (Academic Session 2023-2024),
//               //             Text('BI-WEEKLY ACTIVITIES',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
//               //             Text('(Academic Session 2023-2024)',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold)),
//               //           ],
//               //         ),
//               //       ),
//               //       Container(alignment: Alignment.centerRight,
//               //         width: mQ.width * 0.13,
//               //         height: mQ.height * 0.05,
//               //         decoration: BoxDecoration(
//               //           shape: BoxShape.circle,
//               //           image: DecorationImage(
//               //               image: AssetImage(
//               //                 'assets/logo.png',
//               //                 // width: mQ.width * 0.07),
//               //               ),
//               //               // Image.network(babypicture_ ,
//               //               fit: BoxFit.fitWidth),
//               //         ),
//               //       ),
//               //     ]),
//               // Row(
//               //   mainAxisAlignment: MainAxisAlignment.center,
//               //   children: [
//               //     Expanded(child: Text('Date: ${DateFormat('dd MMM').format(startDate)} to ${DateFormat('dd MMM yy').format(endDate)}',textAlign: TextAlign.left,style: TextStyle(fontSize: 10),)),
//               //     Expanded(child:
//               //     Text(" ${(widget.babyname)}",
//               //         textAlign: TextAlign.center,    style: TextStyle(
//               //             fontSize: 14,
//               //             fontFamily: 'Comic Sans MS',
//               //             fontWeight: FontWeight.bold,
//               //             color: Colors.blue))),
//               //     // Expanded(child: Text(,textAlign: TextAlign.center,)),
//               //     Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end,
//               //       children: [
//               //         Text('Days Present: $checkedInCount',textAlign: TextAlign.right, style: TextStyle(fontSize: 10),),
//               //         Text('Absent: $absentCount',textAlign: TextAlign.right, style: TextStyle(fontSize: 10),),
//               //       ],
//               //     )),
//               //   ],
//               // ),
//             ],
//           ),
//         );
//       },
//     ),
//   );
// }

}
