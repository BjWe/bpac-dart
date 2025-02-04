# bpac-dart

A Dart port of [bpac-js](https://github.com/NilsFa1/bpac-js), a JavaScript library for interacting with Brother's b-PAC SDK for label printing.

## Overview
This library allows Dart applications to control Brother label printers using the b-PAC SDK. It provides functions to open label templates, modify text and barcode fields, and send print commands.

> [!IMPORTANT]  
> Much of the code has been automatically translated and not everything has been thoroughly tested.

## Features
- Open Brother label templates (.lbx)
- Modify text, barcode, and image fields
- Print labels using the b-PAC SDK

## Installation
Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  bpac_dart:
    git:
      url: https://github.com/bjwe/bpac-dart.git
```

Then run:
```sh
dart pub get
```

## Requirements
- Windows OS (b-PAC SDK is Windows-only)
- Brother b-PAC SDK installed ([Download here](https://www.brother.com/product/dev/bpac/))
- A compatible Brother label printer

## Usage
Import the package and initialize the b-PAC interface:

```dart
import 'package:bpac_dart/bpac_dart.dart';

void main() async {
  var doc = await BpacDocument.open(".\\DemolabelText.lbx");

  final object = await doc.getObject("helloworld");
  await object.setText("Hello World");

  final mediaName = await doc.getMediaName();
  print("Media name: $mediaName");

  await doc.startPrint(
        "Test",
        PrintOptionConstants.combine([
          PrintOptionConstants.bpoHalfCut,
          PrintOptionConstants.bpoChainPrint
        ]));
  await doc.printOut(1);
  await doc.endPrint();

  await doc.close();
}
```


## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgments
- [Brother b-PAC SDK](https://www.brother.com/product/dev/bpac/)
- [bpac-js](https://github.com/NilsFa1/bpac-js) for the original JavaScript implementation.

## Contributing
Pull requests and issues are welcome! Feel free to contribute and improve the library.

