import 'dart:convert';
import 'dart:io';

import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

import 'package:bpac_dart/bpac_dart.dart';
import 'package:bpac_dart/src/config.dart';

class ConfigPrinter {
  final String name;
  final String printer;

  ConfigPrinter(this.name, this.printer);

  static ConfigPrinter fromJson(Map<String, dynamic> json) {
    return ConfigPrinter(json['name'], json['printer']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'printer': printer,
    };
  }

  static List<ConfigPrinter> fromJsonList(List<dynamic> json) {
    return json.map((e) => ConfigPrinter.fromJson(e)).toList();
  }
}

class ConfigField {
  final String id;
  final String description;
  final bool? required;
  final String? defaultvalue;
  final String? allowedregex;

  ConfigField(
      {required this.id,
      required this.description,
      this.required,
      this.defaultvalue,
      this.allowedregex});

  static ConfigField fromJson(Map<String, dynamic> json) {
    return ConfigField(
      id: json['id'],
      description: json['description'],
      required: json['required'],
      defaultvalue: json['defaultvalue'],
      allowedregex: json['allowedregex'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'required': required,
      'defaultvalue': defaultvalue,
      'allowedregex': allowedregex,
    };
  }

  static List<ConfigField> fromJsonList(List<dynamic> json) {
    return json.map((e) => ConfigField.fromJson(e)).toList();
  }
}

class ConfigDocument {
  final String name;
  final String filepath;
  final String? color;
  final String? icon;
  final List<ConfigField> fields;
  final List<String> allowedprinters;

  ConfigDocument(
      {required this.name,
      required this.filepath,
      this.color,
      this.icon,
      required this.fields,
      required this.allowedprinters});

  static ConfigDocument fromJson(Map<String, dynamic> json) {
    return ConfigDocument(
      name: json['name'],
      filepath: json['filepath'],
      color: json['color'],
      icon: json['icon'],
      fields: ConfigField.fromJsonList(json['fields']),
      allowedprinters: List<String>.from(json['allowedprinters']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'filepath': filepath,
      'color': color,
      'icon': icon,
      'fields': fields,
      'allowedprinters': allowedprinters,
    };
  }

  static List<ConfigDocument> fromJsonList(List<dynamic> json) {
    return json.map((e) => ConfigDocument.fromJson(e)).toList();
  }
}

class Config {
  final bool? debug;
  final int serverport;
  final String bpacHostPath;
  final List<ConfigPrinter> printers;
  final List<ConfigDocument> documents;

  Config(
      {this.debug,
      required this.serverport,
      required this.bpacHostPath,
      required this.printers,
      required this.documents});

  static Config fromJson(Map<String, dynamic> json) {
    return Config(
      debug: json['debug'],
      serverport: json['serverport'] ?? 8000,
      bpacHostPath: json['bpacHostPath'],
      printers: ConfigPrinter.fromJsonList(json['printers']),
      documents: ConfigDocument.fromJsonList(json['documents']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'debug': debug,
      'serverport': serverport,
      'bpacHostPath': bpacHostPath,
      'printers': printers.map((e) => e.toJson()).toList(),
      'documents': documents.map((e) => e.toJson()).toList(),
    };
  }

  static Config loadFromFile(String path) {
    final file = File(path);
    final json = jsonDecode(file.readAsStringSync());
    return Config.fromJson(json);
  }

  void saveToFile(String path) {
    final file = File(path);
    file.writeAsStringSync(jsonEncode(toJson()));
  }
}

void main(List<String> arguments) async {
  String configfile = 'webprintconfig.json';
  // check if config file is provided as named argument -c or --config
  for (var i = 0; i < arguments.length; i++) {
    if (arguments[i] == '-c' || arguments[i] == '--config') {
      if (i + 1 < arguments.length) {
        configfile = arguments[i + 1];
      }
    }
  }

  late Config config;
  try {
    config = Config.loadFromFile(configfile);
  } catch (e) {
    print('Error loading config file: $e');
    exit(1);
  }

  bpacConfig.bpacHostPath = config.bpacHostPath;
  bpacConfig.debug = config.debug ?? false;

  final app = Router();

  app.get('/documents', (Request request) {
    return Response.ok(
        jsonEncode(config.documents.map((e) => e.toJson()).toList()),
        headers: {'Content-Type': 'application/json'});
  });

  app.get('/printers/<printer|[\\s\\w-()%]+>/documents',
      (Request request, String printer) {
    // test if printer exists
    String testPrinter = Uri.decodeComponent(printer);
    if (!config.printers.any((element) => element.name == testPrinter)) {
      if (bpacConfig.debug) {
        print('Printer not found: $testPrinter');
      }
      return Response(404, body: 'Printer not found');
    }

    return Response.ok(
        jsonEncode(config.documents
            .where((doc) => doc.allowedprinters.contains(testPrinter))
            .map((e) => e.toJson())
            .toList()),
        headers: {'Content-Type': 'application/json'});
  });

  app.get('/printers', (Request request) {
    return Response.ok(
        jsonEncode(config.printers.map((e) => e.toJson()).toList()),
        headers: {'Content-Type': 'application/json'});
  });

  app.get('/installedprinters', (Request request) async {
    var printer = await BpacPrinter.getPrinterClass();
    var printerNames = await printer.getInstalledPrinters();
    printer.connection.disconnect();
    return Response.ok(jsonEncode(printerNames),
        headers: {'Content-Type': 'application/json'});
  });

  app.post('/print', (Request request) async {
    // accept only application/json
    var contentType = request.headers['content-type'];
    // check if additional content type parameters are present
    if (contentType != null) {
      contentType = contentType.split(';').first;
    }
    if (contentType != 'application/json') {
      return Response(415, body: 'Unsupported Media Type');
    }

    Map<String, dynamic> body;
    try {
      body = jsonDecode(await request.readAsString());
    } catch (e) {
      return Response(400, body: 'Bad Request');
    }

    try {
      String document = body['document'];
      String printer = body['printer'];
      Map<String, dynamic> fields = body['fields'];
      int copies = body['copies'];
      bool testprint = body['testprint'] ?? false;

      // check if printer exists
      ConfigPrinter? printerEntry;
      for (var printerItem in config.printers) {
        if (printerItem.name == printer) {
          printerEntry = printerItem;
          break;
        }
      }

      if (printerEntry == null) {
        return Response(404, body: 'Printer not found');
      }

      // check if document exists
      ConfigDocument? docEntry;
      for (var doc in config.documents) {
        if (doc.name == document) {
          docEntry = doc;
          break;
        }
      }

      if (docEntry == null) {
        return Response(404, body: 'Document not found');
      }

      // check if printer is allowed for document
      if (!docEntry.allowedprinters.contains(printer)) {
        return Response(403, body: 'Printer not allowed for document');
      }

      // check if all required fields are present
      for (var field in docEntry.fields) {
        if (field.required == true && !fields.containsKey(field.id)) {
          return Response(400, body: 'Missing required field: ${field.id}');
        }
      }

      // check if all fields are valid
      for (var field in docEntry.fields) {
        if (fields.containsKey(field.id)) {
          if (field.allowedregex != null) {
            final regex = RegExp(field.allowedregex!);
            if (!regex.hasMatch(fields[field.id]!)) {
              return Response(400,
                  body: 'Invalid value for field: ${field.id}');
            }
          }
        }
      }

      // build field value list
      Map<String, String> fieldValues = {};
      for (var field in docEntry.fields) {
        if (fields.containsKey(field.id)) {
          fieldValues[field.id] = fields[field.id]!;
        } else {
          fieldValues[field.id] = field.defaultvalue ?? '';
        }
      }

      // dump fieldValues
      if (bpacConfig.debug) {
        print(fieldValues);
      }

      // open document
      var doc = await BpacDocument.open(docEntry.filepath);

      // set field values
      for (var field in fieldValues.entries) {
        final object = await doc.getObject(field.key);
        await object.setText(field.value);
      }

      // set printer
      if (bpacConfig.debug) {
        print('Setting printer to $printer');
      }
      await doc.setPrinter(printer, false);

      // print document
      if (!testprint) {
        await doc.startPrint(
            document,
            PrintOptionConstants.combine([
              PrintOptionConstants.bpoHalfCut,
              PrintOptionConstants.bpoChainPrint
            ]));
        await doc.printOut(copies);
        await doc.endPrint();
      }

      // close document
      await doc.close();

      return Response.ok('Printed');
    } catch (e) {
      // format error
      return Response(400, body: 'Bad Request - format error - $e');
    }
  });

  print('Starting server on port ${config.serverport}');
  await io.serve(app, '0.0.0.0', config.serverport);
}
