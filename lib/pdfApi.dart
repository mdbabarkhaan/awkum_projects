import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfApi {

  TableRow buildRow(List<String> cells) => TableRow(
    children: cells.map((cells) => Text(cells)).toList(),
  );

  static Future<File> generateCenteredText(List lst) async {

    final pdf = Document();
    pdf.addPage(Page(
      build: (context) {
      return Column(
        children: [
      Table(
          border: TableBorder.all(),
          columnWidths: {
            0: const FlexColumnWidth(0.8),
            1: const FlexColumnWidth(4),
            2: const FlexColumnWidth(2),
            3: const FlexColumnWidth(3),
          },
          children: [
      TableRow(children: [Text(" No"),Text(" Description"),Text(" Remarks"),Text(" Date")])
        ]),
      ListView.builder(
      itemCount: lst.length,
        itemBuilder: (context, index) {
          return Table(
              border: TableBorder.all(),
              columnWidths: {
                0: const FlexColumnWidth(0.8),
                1: const FlexColumnWidth(4),
                2: const FlexColumnWidth(2),
                3: const FlexColumnWidth(3),
              },
              children: [
            TableRow(children: [Text(" ${[index+1]}"),Text(" ${lst[index]["description"]}"),Text(" ${lst[index]["remarks"]}"),Text(" ${lst[index]["date"]}")])
          ]);
        },),
        ]
      );
    },));

    return saveDocument(name: "my_example.pdf", pdf: pdf);
  }


  static Future<File> saveDocument({String? name, Document? pdf}) async {
    final bytes = await pdf!.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/$name");
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }

}