class PriceModel {
  Aeternity aeternity;
  Conflux conflux;
  Tether tether;

  PriceModel({this.aeternity});

  PriceModel.fromJson(Map<String, dynamic> json) {
    aeternity = json['aeternity'] != null ? new Aeternity.fromJson(json['aeternity']) : null;
    conflux = json['conflux-token'] != null ? new Conflux.fromJson(json['conflux-token']) : null;
    tether = json['tether'] != null ? new Tether.fromJson(json['tether']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.aeternity != null) {
      data['aeternity'] = this.aeternity.toJson();
      data['conflux-token'] = this.conflux.toJson();
      data['Tether'] = this.tether.toJson();
    }
    return data;
  }
}

class Aeternity {
  double usd;
  double cny;

  Aeternity({this.usd, this.cny});

  Aeternity.fromJson(Map<String, dynamic> json) {
    usd = json['usd'];
    cny = json['cny'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['usd'] = this.usd;
    data['cny'] = this.cny;
    return data;
  }
}

class Conflux {
  double usd;
  double cny;

  Conflux({this.usd, this.cny});

  Conflux.fromJson(Map<String, dynamic> json) {
    usd = json['usd'];
    cny = json['cny'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['usd'] = this.usd;
    data['cny'] = this.cny;
    return data;
  }
}

class Tether {
  double usd;
  double cny;

  Tether({this.usd, this.cny});

  Tether.fromJson(Map<String, dynamic> json) {
    usd = json['usd'];
    cny = json['cny'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['usd'] = this.usd;
    data['cny'] = this.cny;
    return data;
  }
}
