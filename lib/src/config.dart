class BpacConfig {
  String? bpacHostPath;
  bool debug;

  BpacConfig({this.bpacHostPath, this.debug = false});
}

final bpacConfig = BpacConfig(bpacHostPath: null);
