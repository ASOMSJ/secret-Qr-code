
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:secretqrcode/models/students.dart';
import 'package:secretqrcode/service/pdfapi.dart';

class PdfPrintApi {
  static Future<File> generate( List<Students> selectIndex) async {
    final pdf = pw.Document();
    var data = await rootBundle.load("assets/Cairo-Medium.ttf");
    var myFont =pw.Font.ttf(data);
    var myStyle = pw.TextStyle(font: myFont);

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      textDirection: pw.TextDirection.rtl,
      build: (context) => [

       pw. ListView.builder(
              itemCount: selectIndex.length,
              itemBuilder: (context,index){
                return pw. Row(
                    mainAxisAlignment:pw. MainAxisAlignment.end,
                    children: [
                     pw. Text(selectIndex[index].stdName.toString(),style:myStyle ),
                   pw.SizedBox(width: 10),
                    pw. Text(selectIndex[index].stdNumber.toString(),style:myStyle ),
                    pw.  BarcodeWidget(
                        data: selectIndex[index].qrCode.toString(),
                        barcode:pw. Barcode.qrCode(),
                        width: 50,
                        height: 50,
                        padding: const pw.EdgeInsets.all(8),
                        margin: const pw.EdgeInsets.all(8),
                      ),
                    ]
                );
              },
            ),


      ],
    ));

    return PdfApi.saveDocument(name: 'student.pdf', pdf: pdf);
  }

}
