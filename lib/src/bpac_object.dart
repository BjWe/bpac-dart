import 'bpac_document.dart';
import 'util.dart';

class BpacObject {
  final dynamic p;
  final BpacDocument document;

  BpacObject(this.p, this.document);

  Future<void> setText(String text) async {
    const method = "IObject::SetText";

    document.connection.check();
    await document.connection
        .execute(BpacCommand(method: method, params: {'p': p, 'text': text}));
  }

  Future<Map<String, dynamic>> getText() async {
    const method = "IObject::GetText";

    document.connection.check();
    final response = await document.connection
        .execute(BpacCommand(method: method, params: {'p': p}));

    return response.value;
  }

  Future<Map<String, dynamic>> getAttribute(BpacObjectAttribute kind) async {
    const method = "IObject::GetAttribute";

    document.connection.check();
    final response = await document.connection
        .execute(BpacCommand(method: method, params: {'p': p, 'kind': kind}));
    return response.value;
  }

  Future<Map<String, dynamic>> getData(int kind) async {
    const method = "IObject::GetData";

    document.connection.check();
    final response = await document.connection
        .execute(BpacCommand(method: method, params: {'p': p, 'kind': kind}));
    return response.value;
  }

  Future<Map<String, dynamic>> getFontBold() async {
    const method = "IObject::GetFontBold";

    document.connection.check();
    final response = await document.connection
        .execute(BpacCommand(method: method, params: {'p': p}));
    response.value['value'] = response.ret;
    return response.value;
  }

  Future<Map<String, dynamic>> getFontEffect() async {
    const method = "IObject::GetFontEffect";

    document.connection.check();
    final response = await document.connection
        .execute(BpacCommand(method: method, params: {'p': p}));
    return response.value;
  }

  Future<Map<String, dynamic>> getFontItalics() async {
    const method = "IObject::GetFontItalics";

    document.connection.check();
    final response = await document.connection
        .execute(BpacCommand(method: method, params: {'p': p}));
    response.value['value'] = response.ret;
    return response.value;
  }

  Future<Map<String, dynamic>> getFontMaxPoint() async {
    const method = "IObject::GetFontMaxPoint";

    document.connection.check();
    final response = await document.connection
        .execute(BpacCommand(method: method, params: {'p': p}));
    return response.value;
  }

  Future<Map<String, dynamic>> getFontName() async {
    const method = "IObject::GetFontName";

    document.connection.check();
    final response = await document.connection
        .execute(BpacCommand(method: method, params: {'p': p}));
    return response.value;
  }

  Future<Map<String, dynamic>> getFontStrikeout() async {
    const method = "IObject::GetFontStrikeout";

    document.connection.check();
    final response = await document.connection
        .execute(BpacCommand(method: method, params: {'p': p}));
    response.value['value'] = response.ret;
    return response.value;
  }

  Future<Map<String, dynamic>> getFontUnderline() async {
    const method = "IObject::GetFontUnderline";

    document.connection.check();
    final response = await document.connection
        .execute(BpacCommand(method: method, params: {'p': p}));
    response.value['value'] = response.ret;
    return response.value;
  }

  Future<void> setAlign(int horizontal, int vertical) async {
    const method = "IObject::SetAlign";

    document.connection.check();
    await document.connection.execute(BpacCommand(
        method: method,
        params: {'p': p, 'horizontal': horizontal, 'vertical': vertical}));
  }

  Future<void> setAttribute(BpacObjectAttribute attribute) async {
    const method = "IObject::SetAttribute";

    document.connection.check();
    await document.connection.execute(
        BpacCommand(method: method, params: {'p': p, 'attribute': attribute}));
  }

  Future<void> setData(int kind, dynamic data, dynamic param) async {
    const method = "IObject::SetData";

    final o = data.runtimeType.toString();
    final parsedData = o == "DateTime"
        ? (data as DateTime).millisecondsSinceEpoch / 1e3
        : data;

    document.connection.check();
    await document.connection.execute(BpacCommand(
        method: method,
        params: {'p': p, 'kind': kind, 'data': parsedData, 'param': param}));
  }

  Future<void> setFontBold(bool bold) async {
    const method = "IObject::SetFontBold";

    document.connection.check();
    await document.connection
        .execute(BpacCommand(method: method, params: {'p': p, 'bold': bold}));
  }

  Future<void> setFontEffect(BpacFontEffect effect) async {
    const method = "IObject::SetFontEffect";

    document.connection.check();
    await document.connection.execute(
        BpacCommand(method: method, params: {'p': p, 'effect': effect}));
  }

  Future<void> setFontItalics(bool italics) async {
    const method = "IObject::SetFontItalics";

    document.connection.check();
    await document.connection.execute(
        BpacCommand(method: method, params: {'p': p, 'italics': italics}));
  }

  Future<void> setFontMaxPoint(int point) async {
    const method = "IObject::SetFontMaxPoint";

    document.connection.check();
    await document.connection
        .execute(BpacCommand(method: method, params: {'p': p, 'point': point}));
  }

  Future<void> setFontName(String name) async {
    const method = "IObject::SetFontName";

    document.connection.check();
    await document.connection
        .execute(BpacCommand(method: method, params: {'p': p, 'name': name}));
  }

  Future<void> setFontStrikeout(bool strikeout) async {
    const method = "IObject::SetFontStrikeout";

    document.connection.check();
    await document.connection.execute(
        BpacCommand(method: method, params: {'p': p, 'strikeout': strikeout}));
  }

  Future<void> setFontUnderline(bool underline) async {
    const method = "IObject::SetFontUnderline";

    document.connection.check();
    await document.connection.execute(
        BpacCommand(method: method, params: {'p': p, 'underline': underline}));
  }

  Future<void> setPosition(int x, int y, int width, int height) async {
    const method = "IObject::SetPosition";

    document.connection.check();
    await document.connection.execute(BpacCommand(
        method: method,
        params: {'p': p, 'x': x, 'y': y, 'width': width, 'height': height}));
  }

  Future<void> setSelection(int start, int end) async {
    const method = "IObject::SetPosition";

    document.connection.check();
    await document.connection.execute(BpacCommand(
        method: method, params: {'p': p, 'start': start, 'end': end}));
  }

  Future<Map<String, dynamic>> getHeight() async {
    const method = "IObject::GetHeight";

    document.connection.check();
    final response = await document.connection
        .execute(BpacCommand(method: method, params: {'p': p}));
    return response.value;
  }

  Future<void> setHeight(int height) async {
    const method = "IObject::SetHeight";

    document.connection.check();
    await document.connection.execute(
        BpacCommand(method: method, params: {'p': p, 'height': height}));
  }

  Future<Map<String, dynamic>> getHorizontalAlign() async {
    const method = "IObject::GetHorizontalAlign";

    document.connection.check();
    final response = await document.connection
        .execute(BpacCommand(method: method, params: {'p': p}));
    return response.value;
  }

  Future<void> setHorizontalAlign(int align) async {
    const method = "IObject::SetHorizontalAlign";

    document.connection.check();
    await document.connection
        .execute(BpacCommand(method: method, params: {'p': p, 'align': align}));
  }

  Future<Map<String, dynamic>> getName() async {
    const method = "IObject::GetName";

    document.connection.check();
    final response = await document.connection
        .execute(BpacCommand(method: method, params: {'p': p}));
    return response.value;
  }

  Future<void> setName(String name) async {
    const method = "IObject::SetName";

    document.connection.check();
    await document.connection
        .execute(BpacCommand(method: method, params: {'p': p, 'name': name}));
  }

  Future<Map<String, dynamic>> getOrientation() async {
    const method = "IObject::GetOrientation";

    document.connection.check();
    final response = await document.connection
        .execute(BpacCommand(method: method, params: {'p': p}));
    return response.value;
  }

  Future<void> setOrientation(int orientation) async {
    const method = "IObject::SetOrientation";

    document.connection.check();
    await document.connection.execute(BpacCommand(
        method: method, params: {'p': p, 'orientation': orientation}));
  }

  Future<Map<String, dynamic>> getSelectionEnd() async {
    const method = "IObject::GetSelectionEnd";

    document.connection.check();
    final response = await document.connection
        .execute(BpacCommand(method: method, params: {'p': p}));
    return response.value;
  }

  Future<void> setSelectionEnd(int selection) async {
    const method = "IObject::SetSelectionEnd";

    document.connection.check();
    await document.connection.execute(
        BpacCommand(method: method, params: {'p': p, 'selection': selection}));
  }

  Future<Map<String, dynamic>> getSelectionStart() async {
    const method = "IObject::GetSelectionStart";

    document.connection.check();
    final response = await document.connection
        .execute(BpacCommand(method: method, params: {'p': p}));
    return response.value;
  }

  Future<void> setSelectionStart(int selection) async {
    const method = "IObject::SetSelectionStart";

    document.connection.check();
    await document.connection.execute(
        BpacCommand(method: method, params: {'p': p, 'selection': selection}));
  }

  Future<Map<String, dynamic>> getType() async {
    const method = "IObject::GetType";

    document.connection.check();
    final response = await document.connection
        .execute(BpacCommand(method: method, params: {'p': p}));
    return response.value;
  }

  Future<Map<String, dynamic>> getVerticalAlign() async {
    const method = "IObject::GetVerticalAlign";

    document.connection.check();
    final response = await document.connection
        .execute(BpacCommand(method: method, params: {'p': p}));
    return response.value;
  }

  Future<void> setVerticalAlign(int align) async {
    const method = "IObject::SetVerticalAlign";

    document.connection.check();
    await document.connection
        .execute(BpacCommand(method: method, params: {'p': p, 'align': align}));
  }

  Future<Map<String, dynamic>> getWidth() async {
    const method = "IObject::GetWidth";

    document.connection.check();
    final response = await document.connection
        .execute(BpacCommand(method: method, params: {'p': p}));
    return response.value;
  }

  Future<void> setWidth(int width) async {
    const method = "IObject::SetWidth";

    document.connection.check();
    await document.connection
        .execute(BpacCommand(method: method, params: {'p': p, 'width': width}));
  }

  Future<Map<String, dynamic>> getX() async {
    const method = "IObject::GetX";

    document.connection.check();
    final response = await document.connection
        .execute(BpacCommand(method: method, params: {'p': p}));
    return response.value;
  }

  Future<void> setX(int X) async {
    const method = "IObject::SetX";

    document.connection.check();
    await document.connection
        .execute(BpacCommand(method: method, params: {'p': p, 'X': X}));
  }

  Future<Map<String, dynamic>> getY() async {
    const method = "IObject::GetY";

    document.connection.check();
    final response = await document.connection
        .execute(BpacCommand(method: method, params: {'p': p}));
    return response.value;
  }

  Future<void> setY(int Y) async {
    const method = "IObject::SetY";

    document.connection.check();
    await document.connection
        .execute(BpacCommand(method: method, params: {'p': p, 'Y': Y}));
  }
}
