import 'package:bpac_dart/bpac_dart.dart';
import 'package:bpac_dart/src/config.dart';

void main() async {
  bpacConfig.bpacHostPath = "C:\\Program Files\\Common Files\\Brother\\b-PAC";
  bpacConfig.debug = true;

  var doc = await BpacDocument.open(".\\labels\\DemolabelText.lbx");

  final objCount = await doc.getObjectsCount();
  print("Objects count: $objCount");

  final field1id = await doc.getIndexByName("Field1", 0);
  print("Field1 index: $field1id");

  final field2id = await doc.getIndexByName("Field2", 0);
  print("Field2 index: $field2id");

  final printer = await doc.getPrinter();
  print("Printer: $printer");

  final printerNames = await printer?.getInstalledPrinters();
  print("Installed printers: $printerNames");

  if (printerNames != null && printerNames.isNotEmpty) {
    await doc.setPrinter(printerNames[0], false);

    final mediaName = await doc.getMediaName();
    print("Media name: $mediaName");

    await doc.setText(field1id!, "Testfeld1");
    await doc.setText(field2id!, "Testfeld2");

    await doc.startPrint(
        "Test",
        PrintOptionConstants.combine([
          PrintOptionConstants.bpoHalfCut,
          PrintOptionConstants.bpoChainPrint
        ]));
    await doc.printOut(1);
    await doc.endPrint();
  }

  await doc.close();
}
