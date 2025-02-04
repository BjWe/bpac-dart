import 'bpac_object.dart';
import 'bpac_objects.dart';
import 'bpac_printer.dart';
import 'util.dart';

class BpacDocument {
  BpacDocument._(this.connection);

  final Connection connection;

  static Future<BpacDocument> open(String path) async {
    const command = "IDocument::Open";
    final c = Connection();
    await c.connect();
    final document = BpacDocument._(c);

    final result = await document.connection
        .execute(BpacCommand(method: command, params: {'filePath': path}));
    if (!result.ret) {
      throw Exception("Failed to open Document. Please check Path");
    }

    return document;
  }

  Future<bool?> close() async {
    const command = "IDocument::Close";
    connection.check();

    final r = await connection.execute(BpacCommand(method: command));
    connection.disconnect();
    return r.ret;
  }

  Future<BpacObject> getObject(String name) async {
    const command = "IDocument::GetObject";
    connection.check();

    final arg = BpacCommand(method: command, params: {'name': name});

    final r = await connection.execute(arg);
    return BpacObject(r.value['p'], this);
  }

  Future<bool> export(ExportType type, String filePath, int dpi) async {
    const command = "IDocument::Export";
    connection.check();

    final arg = BpacCommand(
        method: command,
        params: {'type': type, 'filePath': filePath, 'dpi': dpi});

    final r = await connection.execute(arg);
    return r.ret;
  }

  Future<bool> printOut(int copyCount,
      [int option = PrintOptionConstants.bpoAutoCut]) async {
    const command = "IDocument::PrintOut";
    connection.check();

    final arg = BpacCommand(
        method: command, params: {'copyCount': copyCount, 'option': option});

    final r = await connection.execute(arg);
    return r.ret;
  }

  Future<bool> endPrint() async {
    const command = "IDocument::EndPrint";
    connection.check();

    final arg = BpacCommand(method: command);

    final r = await connection.execute(arg);
    return r.ret;
  }

  Future<bool> startPrint(String docName, int option) async {
    const command = "IDocument::StartPrint";
    connection.check();

    final arg = BpacCommand(
        method: command, params: {'docName': docName, 'option': option});

    final r = await connection.execute(arg);
    return r.ret;
  }

  Future<bool> doPrint(PrintOptionConstants dwOption, String szOption) async {
    const command = "IDocument::DoPrint";
    connection.check();

    final arg = BpacCommand(
        method: command, params: {'dwOption': dwOption, 'szOption': szOption});

    final r = await connection.execute(arg);
    return r.ret;
  }

  Future<Map<String, dynamic>> getImageData(
      ExportType type, int width, int height) async {
    const command = "IDocument::GetImageData";
    connection.check();

    final arg = BpacCommand(
        method: command,
        params: {'type': type, 'width': width, 'height': height});

    final r = await connection.execute(arg);
    return r.value['image'];
  }

  Future<int> getObjectsCount() async {
    const command = "IDocument::GetObjectsCount";
    connection.check();

    final arg = BpacCommand(method: command);

    final response = await connection.execute(arg);
    return response.value['count'];
  }

  Future<int?> getIndexByName(String name, int indexBgn) async {
    const command = "IDocument::GetIndexByName";
    connection.check();

    final arg = BpacCommand(
        method: command, params: {'name': name, 'indexBgn': indexBgn});

    final response = await connection.execute(arg);
    return response.value['index'];
  }

  Future<BpacObjects?> getObjects(String name) async {
    const command = "IDocument::GetObjects";
    connection.check();

    final arg = BpacCommand(method: command, params: {'name': name});

    final response = await connection.execute(arg);
    if (response.value['p'] >= 0) {
      return BpacObjects(response.value['p'], this);
    } else {
      return null;
    }
  }

  Future<int?> getBarcodeIndex(String name) async {
    const command = "IDocument::GetBarcodeIndex";
    connection.check();

    final arg = BpacCommand(method: command, params: {'name': name});

    final response = await connection.execute(arg);
    return response.value['index'];
  }

  Future<String?> getMediaId() async {
    const command = "IDocument::GetMediaId";
    connection.check();

    final arg = BpacCommand(method: command);

    final response = await connection.execute(arg);
    return response.value['id'];
  }

  Future<String?> getMediaName() async {
    const command = "IDocument::GetMediaName";
    connection.check();

    final arg = BpacCommand(method: command);

    final response = await connection.execute(arg);
    return response.value['name'];
  }

  Future<String?> getPrinterName() async {
    const command = "IDocument::GetPrinterName";
    connection.check();

    final arg = BpacCommand(method: command);

    final response = await connection.execute(arg);
    return response.value['name'];
  }

  Future<String?> getText(int index) async {
    const command = "IDocument::GetText";
    connection.check();

    final arg = BpacCommand(method: command, params: {'index': index});

    final response = await connection.execute(arg);
    return response.value['text'];
  }

  Future<int?> getTextCount() async {
    const command = "IDocument::GetTextCount";
    connection.check();

    final arg = BpacCommand(method: command);

    final response = await connection.execute(arg);
    return response.value['count'];
  }

  Future<int?> getTextIndex(String name) async {
    const command = "IDocument::GetTextIndex";
    connection.check();

    final arg = BpacCommand(method: command, params: {'name': name});

    final response = await connection.execute(arg);
    return response.value['index'];
  }

  Future<BpacPrinter?> getPrinter() async {
    const command = "IDocument::GetPrinter";
    connection.check();

    final arg = BpacCommand(method: command);

    final response = await connection.execute(arg);
    if (response.value['p'] >= 0) {
      return BpacPrinter(response.value['p'], connection);
    } else {
      return null;
    }
  }

  Future<String?> getCurrentSheet() async {
    const command = "IDocument::GetCurrentSheet";
    connection.check();

    final arg = BpacCommand(method: command);

    final response = await connection.execute(arg);
    return response.value['name'];
  }

  Future<int?> getCutLineCount() async {
    const command = "IDocument::GetCutLineCount";
    connection.check();

    final arg = BpacCommand(method: command);

    final response = await connection.execute(arg);
    return response.value['count'];
  }

  Future<dynamic> getCutLines() async {
    const command = "IDocument::GetCutLines";
    connection.check();

    final arg = BpacCommand(method: command);

    final response = await connection.execute(arg);
    return response.value['cutlines'];
  }

  Future<int?> getErrorCode() async {
    const command = "IDocument::GetErrorCode";
    connection.check();

    final arg = BpacCommand(method: command);

    final response = await connection.execute(arg);
    return response.value['errorCode'];
  }

  Future<int?> getMarginBottom() async {
    const command = "IDocument::GetMarginBottom";
    connection.check();

    final arg = BpacCommand(method: command);

    final response = await connection.execute(arg);
    return response.value['margin'];
  }

  Future<int?> getMarginLeft() async {
    const command = "IDocument::GetMarginLeft";
    connection.check();

    final arg = BpacCommand(method: command);

    final response = await connection.execute(arg);
    return response.value['margin'];
  }

  Future<int?> getMarginRight() async {
    const command = "IDocument::GetMarginRight";
    connection.check();

    final arg = BpacCommand(method: command);

    final response = await connection.execute(arg);
    return response.value['margin'];
  }

  Future<int?> getMarginTop() async {
    const command = "IDocument::GetMarginTop";
    connection.check();

    final arg = BpacCommand(method: command);

    final response = await connection.execute(arg);
    return response.value['margin'];
  }

  Future<int?> getOrientation() async {
    const command = "IDocument::GetOrientation";
    connection.check();

    final arg = BpacCommand(method: command);

    final response = await connection.execute(arg);
    return response.value['orientation'];
  }

  Future<List<String>?> getSheetNames() async {
    const command = "IDocument::GetSheetNames";
    connection.check();

    final arg = BpacCommand(method: command);

    final response = await connection.execute(arg);
    return response.value['names'];
  }

  Future<int?> getWidth() async {
    const command = "IDocument::GetWidth";
    connection.check();

    final arg = BpacCommand(method: command);

    final response = await connection.execute(arg);
    return response.value['width'];
  }

  Future<int?> getLength() async {
    const command = "IDocument::GetLength";
    connection.check();

    final arg = BpacCommand(method: command);

    final response = await connection.execute(arg);
    return response.value['length'];
  }

  Future<bool?> save() async {
    const command = "IDocument::Save";
    connection.check();

    final arg = BpacCommand(method: command);

    final response = await connection.execute(arg);
    return response.ret;
  }

  Future<bool?> saveAs(ExportType type, String filePath) async {
    const command = "IDocument::SaveAs";
    connection.check();

    final arg = BpacCommand(
        method: command, params: {'type': type, 'filePath': filePath});

    final response = await connection.execute(arg);
    return response.ret;
  }

  Future<void> setText(int index, String text) async {
    const method = "IDocument::SetText";

    connection.check();
    await connection.execute(
        BpacCommand(method: method, params: {'index': index, 'text': text}));
  }

  Future<bool?> setBarcodeData(int index, String text) async {
    const method = "IDocument::SetBarcodeData";
    connection.check();

    final arg =
        BpacCommand(method: method, params: {'index': index, 'text': text});

    final response = await connection.execute(arg);
    return response.ret;
  }

  Future<bool?> setMarginLeftRight(int left, int right) async {
    const method = "IDocument::SetMarginLeftRight";
    connection.check();

    final arg =
        BpacCommand(method: method, params: {'left': left, 'right': right});

    final response = await connection.execute(arg);
    return response.ret;
  }

  Future<bool?> setMediaById(int id, bool fit) async {
    const method = "IDocument::SetMediaById";
    connection.check();

    final arg =
        BpacCommand(method: method, params: {'id': id.toString(), 'fit': fit});

    final response = await connection.execute(arg);
    return response.ret;
  }

  Future<bool?> setMediaByName(String name, bool fit) async {
    const method = "IDocument::SetMediaByName";
    connection.check();

    final arg = BpacCommand(method: method, params: {'name': name, 'fit': fit});

    final response = await connection.execute(arg);
    return response.ret;
  }

  Future<bool?> setPrinter(String name, bool fit) async {
    const method = "IDocument::SetPrinter";
    connection.check();

    final arg = BpacCommand(method: method, params: {'name': name, 'fit': fit});

    final response = await connection.execute(arg);
    return response.ret;
  }

  Future<bool?> setCurrentSheet(String name) async {
    const method = "IDocument::SetCurrentSheet";
    connection.check();

    final arg = BpacCommand(method: method, params: {'name': name});

    final response = await connection.execute(arg);
    return response.ret;
  }

  Future<bool?> setMarginBottom(int margin) async {
    const method = "IDocument::SetMarginBottom";
    connection.check();

    final arg = BpacCommand(method: method, params: {'margin': margin});

    final response = await connection.execute(arg);
    return response.ret;
  }

  Future<bool?> setMarginLeft(int margin) async {
    const method = "IDocument::SetMarginLeft";
    connection.check();

    final arg = BpacCommand(method: method, params: {'margin': margin});

    final response = await connection.execute(arg);
    return response.ret;
  }

  Future<bool?> setMarginRight(int margin) async {
    const method = "IDocument::SetMarginRight";
    connection.check();

    final arg = BpacCommand(method: method, params: {'margin': margin});

    final response = await connection.execute(arg);
    return response.ret;
  }

  Future<bool?> setMarginTop(int margin) async {
    const method = "IDocument::SetMarginTop";
    connection.check();

    final arg = BpacCommand(method: method, params: {'margin': margin});

    final response = await connection.execute(arg);
    return response.ret;
  }

  Future<bool?> setLength(int length) async {
    const method = "IDocument::SetLength";
    connection.check();

    final arg = BpacCommand(method: method, params: {'length': length});

    final response = await connection.execute(arg);
    return response.ret;
  }
}
