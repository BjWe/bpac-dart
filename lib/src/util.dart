import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'config.dart';

enum BpacObjectType {
  bobText,
  bobBarcode,
  bobImage,
  bobDateTime,
  bobClipArt,
}

enum BpacFontEffect {
  bfeNoEffects,
  bfeShadowLight,
  bfeShadow,
  bfeHorizontal,
  bfeOutline,
  bfeSurround,
  bfeFrameOut,
  bfeInvertTextColors,
}

enum BpacObjectAttribute {
  boaTextOption,
  boaFontBold,
  boaFontEffect,
  boaFontItalics,
  boaFontMaxPoint,
  boaFontName,
  boaFontStrikeout,
  boaFontUnderline,
  boaDateTimeAddSubtract,
  boaClipArtGallery,
  boaBarcodeProtocol,
}

class PrintOptionConstants {
  static const int bpoDefault = 0;
  static const int bpoAutoCut = 1;
  static const int bpoCutPause = 1;
  static const int bpoCutMark = 2;
  static const int bpoMirroring = 4;
  static const int bpoColor = 8;
  static const int bpoStamp = 128; // 0x00000080
  static const int bpoHalfCut = 512; // 0x00000200
  static const int bpoChainPrint = 1024; // 0x00000400
  static const int bpoTailCut = 2048; // 0x00000800
  static const int bpoQuality = 65536; // 0x00010000
  static const int bpoSpecialTape = 524288; // 0x00080000
  static const int bpoHighSpeed = 16777216; // 0x01000000
  static const int bpoHighResolution = 33554432; // 0x02000000
  static const int bpoCutAtEnd = 67108864; // 0x04000000
  static const int bpoIdLabel = 268435456; // 0x10000000
  static const int bpoMono = 268435456; // 0x10000000
  static const int bpoNoCut = 268435456; // 0x10000000
  static const int bpoRfid = 536870912; // 0x20000000
  static const int bpoContinue = 1073741824; // 0x40000000

  static int combine(List<int> options) {
    int result = 0;
    for (final option in options) {
      result |= option;
    }
    return result;
  }
}

enum ExportType {
  bexOpened,
  bexLbx,
  bexLbl,
  bexLbi,
  bexBmp,
  bexPAF;

  int toJson() {
    return index;
  }
}

Future<String?> findBpacHostExe() async {
  const defaultLocations = [
    'C:\\Program Files (x86)\\Common Files\\Brother\\b-PAC\\bpacHost.exe',
    'C:\\Program Files\\Common Files\\Brother\\b-PAC\\bpacHost.exe'
  ];

  for (final path in defaultLocations) {
    if (await File(path).exists()) {
      return path;
    }
  }

  //TODO: Implement Registry check

  return null;
}

class BpacCommand {
  String method;
  Map<String, dynamic> params;

  BpacCommand({
    required this.method,
    this.params = const {},
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {};
    result['method'] = method;
    result.addAll(params);

    return result;
  }
}

class IBpacResult {
  String method;
  bool ret;

  IBpacResult(this.method, this.ret);

  factory IBpacResult.fromJson(Map<String, dynamic> json) {
    return IBpacResult(json['method'], json['ret']);
  }
}

class BpacResult<T> {
  late int length;
  late T value;
  late String method;
  late bool ret;

  BpacResult(List<int> data) {
    final buffer = ByteData.sublistView(Uint8List.fromList(data));
    length = buffer.getInt32(0, Endian.host);
    final jsonStr = utf8.decode(data.sublist(4, length + 4));
    final obj = jsonDecode(jsonStr) as Map<String, dynamic>;

    if (bpacConfig.debug) {
      print('=== Data Result ===');
      print(obj);
    }

    method = obj['method'];
    ret = obj['ret'];
    obj.remove('method');
    obj.remove('ret');
    value = obj as T;
  }
}

typedef BpacProcessIOCallback = void Function(List<int> data);

class Connection {
  bool available = false;
  String? path;
  Process? process;

  StreamSubscription<List<int>>? stdoutSubscription;
  StreamSubscription<List<int>>? stderrSubscription;
  BpacProcessIOCallback? onStdout;
  BpacProcessIOCallback? onStderr;

  Future<void> connect() async {
    if (BpacConfig.bpacHostPath == null || BpacConfig.bpacHostPath!.isEmpty) {
      BpacConfig.bpacHostPath = await findBpacHostExe();
    }

    if (BpacConfig.bpacHostPath == null) {
      throw Exception('Please set Path to bpacHost.exe in BpacConfig');
    }

    process = await Process.start(BpacConfig.bpacHostPath!, []);
    path = BpacConfig.bpacHostPath;
    available = true;

    stdoutSubscription = process?.stdout.listen((data) {
      if (onStdout != null) {
        onStdout!(data);
      } else {
        if (bpacConfig.debug) {
          print('=== Data Out without mapped CB ===');
          print('Data: ${utf8.decode(data)}');
        }
      }
    });

    stderrSubscription = process?.stderr.listen((data) {
      if (onStderr != null) {
        onStderr!(data);
      } else {
        if (bpacConfig.debug) {
          print('=== Data Error without mapped CB ===');
          print('Data: ${utf8.decode(data)}');
        }
      }
    });
  }

  void disconnect() {
    process?.kill();
    path = null;
    available = false;
  }

  Future<BpacResult<TResult>> execute<TResult>(BpacCommand command) async {
    final completer = Completer<BpacResult<TResult>>();
    final commandStr = jsonEncode(command);
    final commandBytes = utf8.encode(commandStr);
    final lengthBuffer = ByteData(4)
      ..setInt32(0, commandBytes.length, Endian.host);

    onStdout = (data) {
      try {
        if (bpacConfig.debug) {
          print('=== Data Out ===');
          print('Data: ${utf8.decode(data)}');
        }

        completer.complete(BpacResult<TResult>(data));
      } catch (error) {
        disconnect();
        completer.completeError(error);
      }
    };

    onStderr = (data) {
      if (bpacConfig.debug) {
        print('execute error');
      }
      completer.completeError(Exception(utf8.decode(data)));
    };

    if (bpacConfig.debug) {
      print('=== Data In ===');
      print('Command: $commandStr');
    }

    process?.stdin.add(lengthBuffer.buffer.asUint8List());
    process?.stdin.add(commandBytes);

    return completer.future.whenComplete(() async {
      if (bpacConfig.debug) {
        print('=== Data In Completed ===');
        print('Command: $commandStr');
      }

      onStderr = null;
      onStdout = null;
    });
  }

  void check() {
    if (!available) {
      throw Exception('No connection to bpacHost Process');
    }
  }
}

class BpacConfig {
  static String? bpacHostPath;
}
