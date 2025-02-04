import 'bpac_document.dart';
import 'util.dart';
import 'bpac_object.dart';

class BpacObjects {
  final dynamic p;
  final BpacDocument document;

  BpacObjects(this.p, this.document);

  Future<BpacObject?> getItem(int index) async {
    const method = "IObjects::GetItem";
    document.connection.check();

    final arg = BpacCommand(method: method, params: {'p': p, 'index': index});

    final response =
        await document.connection.execute<Map<String, dynamic>>(arg);

    if (response.value['value'] == null || response.value['value']['p'] < 0) {
      return null;
    }

    return BpacObject(response.value['value']['p'], document);
  }

  Future<int?> getCount() async {
    const method = "IObjects::GetCount";
    document.connection.check();

    final arg = BpacCommand(method: method, params: {'p': p});

    final response =
        await document.connection.execute<Map<String, dynamic>>(arg);
    return response.value['value']?['count'];
  }

  Future<int?> getIndex(BpacObjects obj) async {
    const method = "IObjects::GetIndex";
    document.connection.check();

    final arg = BpacCommand(method: method, params: {'p': p, 'obj': obj.p});

    final response =
        await document.connection.execute<Map<String, dynamic>>(arg);
    return response.value['value']?['index'];
  }

  Future<int?> getIndexByName(String name, int indexBgn) async {
    const method = "IObjects::GetIndexByName";
    document.connection.check();

    final arg = BpacCommand(
      method: method,
      params: {'p': p, 'name': name, 'indexBgn': indexBgn},
    );

    final response =
        await document.connection.execute<Map<String, dynamic>>(arg);
    return response.value['value']?['index'];
  }

  Future<BpacObject?> insert(int index, String type, int X, int Y, int width,
      int height, dynamic option) async {
    const method = "IObjects::Insert";
    document.connection.check();

    final arg = BpacCommand(
      method: method,
      params: {
        'p': p,
        'index': index,
        'type': type,
        'X': X,
        'Y': Y,
        'width': width,
        'height': height,
        'option': option,
      },
    );

    final response =
        await document.connection.execute<Map<String, dynamic>>(arg);

    if (response.value['value'] == null || response.value['value']['p'] < 0) {
      return null;
    }

    return BpacObject(response.value['value']['p'], document);
  }

  Future<bool?> remove(int index) async {
    const method = "IObjects::Remove";
    document.connection.check();

    final arg = BpacCommand(method: method, params: {'p': p, 'index': index});

    final response = await document.connection.execute<Null>(arg);
    return response.ret;
  }
}
