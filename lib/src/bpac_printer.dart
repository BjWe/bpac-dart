import 'util.dart';

class BpacPrinter {
  final int? p;
  final Connection connection;

  BpacPrinter(this.p, this.connection);

  static Future<BpacPrinter> getPrinterClass() async {
    final c = Connection();
    await c.connect();
    return BpacPrinter(null, c);
  }

  Future<List<String>?> getInstalledPrinters() async {
    const method = "IPrinter::GetInstalledPrinters";
    connection.check();

    final arg = BpacCommand(method: method, params: {'p': p});

    final response = await connection.execute<Map<String, dynamic>>(arg);
    return response.value['printers']?.cast<String>();
  }

  Future<String?> getMediaId() async {
    const method = "IPrinter::GetMediaId";
    connection.check();

    final arg = BpacCommand(method: method, params: {'p': p});

    final response = await connection.execute<Map<String, dynamic>>(arg);
    return response.value['id'];
  }

  Future<String?> getMediaName() async {
    const method = "IPrinter::GetMediaName";
    connection.check();

    final arg = BpacCommand(method: method, params: {'p': p});

    final response = await connection.execute<Map<String, dynamic>>(arg);
    return response.value['name'];
  }

  Future<int?> getPrintedTapeLength() async {
    const method = "IPrinter::GetPrintedTapeLength";
    connection.check();

    final arg = BpacCommand(method: method, params: {'p': p});

    final response = await connection.execute<Map<String, dynamic>>(arg);
    return response.value['length'];
  }

  Future<List<int>?> getSupportedMediaIds() async {
    const method = "IPrinter::GetSupportedMediaIds";
    connection.check();

    final arg = BpacCommand(method: method, params: {'p': p});

    final response = await connection.execute<Map<String, dynamic>>(arg);
    return response.value['mediaIds']?.cast<int>();
  }

  Future<List<String>?> getSupportedMediaNames() async {
    const method = "IPrinter::GetSupportedMediaNames";
    connection.check();

    final arg = BpacCommand(method: method, params: {'p': p});

    final response = await connection.execute<Map<String, dynamic>>(arg);
    return response.value['mediaNames']?.cast<String>();
  }

  Future<bool?> isMediaIdSupported(String id) async {
    const method = "IPrinter::IsMediaIdSupported";
    connection.check();

    final arg = BpacCommand(method: method, params: {'p': p, 'id': id});

    final response = await connection.execute<Map<String, dynamic>>(arg);
    return response.value['ret'];
  }

  Future<bool?> isMediaNameSupported(String name) async {
    const method = "IPrinter::IsMediaNameSupported";
    connection.check();

    final arg = BpacCommand(method: method, params: {'p': p, 'name': name});

    final response = await connection.execute<Map<String, dynamic>>(arg);
    return response.value['ret'];
  }

  Future<bool?> isPrinterOnline(String name) async {
    const method = "IPrinter::IsPrinterOnline";
    connection.check();

    final arg = BpacCommand(method: method, params: {'p': p, 'name': name});

    final response = await connection.execute<Map<String, dynamic>>(arg);
    return response.value['ret'];
  }

  Future<bool?> isPrinterSupported(String name) async {
    const method = "IPrinter::IsPrinterSupported";
    connection.check();

    final arg = BpacCommand(method: method, params: {'p': p, 'name': name});

    final response = await connection.execute<Map<String, dynamic>>(arg);
    return response.value['ret'];
  }

  Future<int?> errorCode() async {
    const method = "IPrinter::GetErrorCode";
    connection.check();

    final arg = BpacCommand(method: method, params: {'p': p});

    final response = await connection.execute<Map<String, dynamic>>(arg);
    return response.value['errorCode'];
  }

  Future<String?> errorString() async {
    const method = "IPrinter::GetErrorString";
    connection.check();

    final arg = BpacCommand(method: method, params: {'p': p});

    final response = await connection.execute<Map<String, dynamic>>(arg);
    return response.value['errorString'];
  }

  Future<String?> name() async {
    const method = "IPrinter::GetName";
    connection.check();

    final arg = BpacCommand(method: method, params: {'p': p});

    final response = await connection.execute<Map<String, dynamic>>(arg);
    return response.value['name'];
  }

  Future<String?> portName() async {
    const method = "IPrinter::GetPortName";
    connection.check();

    final arg = BpacCommand(method: method, params: {'p': p});

    final response = await connection.execute<Map<String, dynamic>>(arg);
    return response.value['port'];
  }
}
