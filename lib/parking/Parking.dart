class Parking {
  int? nhits;
  Parameters? parameters;
  List<Records> records = [];
  List<FacetGroups>? facetGroups;

  Parking(
      {this.nhits, this.parameters, required this.records, this.facetGroups});

  Parking.fromJson(Map<String, dynamic> json) {
    nhits = json['nhits'];
    parameters = json['parameters'] != null
        ? new Parameters.fromJson(json['parameters'])
        : null;
    if (json['records'] != null) {
      records = <Records>[];
      json['records'].forEach((v) {
        records!.add(new Records.fromJson(v));
      });
    }
    if (json['facet_groups'] != null) {
      facetGroups = <FacetGroups>[];
      json['facet_groups'].forEach((v) {
        facetGroups!.add(new FacetGroups.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nhits'] = this.nhits;
    if (this.parameters != null) {
      data['parameters'] = this.parameters!.toJson();
    }
    if (this.records != null) {
      data['records'] = this.records!.map((v) => v.toJson()).toList();
    }
    if (this.facetGroups != null) {
      data['facet_groups'] = this.facetGroups!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Parameters {
  String? dataset;
  int? rows;
  int? start;
  List<String>? facet;
  String? format;
  String? timezone;

  Parameters(
      {this.dataset,
      this.rows,
      this.start,
      this.facet,
      this.format,
      this.timezone});

  Parameters.fromJson(Map<String, dynamic> json) {
    dataset = json['dataset'];
    rows = json['rows'];
    start = json['start'];
    facet = json['facet'].cast<String>();
    format = json['format'];
    timezone = json['timezone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dataset'] = this.dataset;
    data['rows'] = this.rows;
    data['start'] = this.start;
    data['facet'] = this.facet;
    data['format'] = this.format;
    data['timezone'] = this.timezone;
    return data;
  }
}

class Records {
  String datasetid = "";
  String recordid = "";
  Fields fields = Fields(latitude: 0, longitude: 0);
  Geometry geometry = Geometry(null);
  String recordTimestamp = "";

  Records(
      {required this.datasetid,
      required this.recordid,
      required this.fields,
      required this.geometry,
      required this.recordTimestamp});

  Records.fromJson(Map<String, dynamic> json) {
    datasetid = json['datasetid'];
    recordid = json['recordid'];
    fields = (json['fields'] != null ? Fields.fromJson(json['fields']) : null)!;
    geometry = (json['geometry'] != null
        ? Geometry.fromJson(json['geometry'])
        : null)!;
    recordTimestamp = json['record_timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['datasetid'] = this.datasetid;
    data['recordid'] = this.recordid;
    if (this.fields != null) {
      data['fields'] = this.fields!.toJson();
    }
    if (this.geometry != null) {
      data['geometry'] = this.geometry!.toJson();
    }
    data['record_timestamp'] = this.recordTimestamp;
    return data;
  }
}

class Fields {
  List<double>? location;
  String? meterid;
  String? assetid;
  String? metertype;
  String? barcode;
  double latitude = 0;
  double longitude = 0;
  String? creditcard;
  String? streetname;
  String? tapandgo;

  Fields(
      {this.location,
      this.meterid,
      this.assetid,
      this.metertype,
      this.barcode,
      required this.latitude,
      required this.longitude,
      this.creditcard,
      this.streetname,
      this.tapandgo});

  Fields.fromJson(Map<String, dynamic> json) {
    location = json['location'].cast<double>();
    meterid = json['meterid'];
    assetid = json['assetid'];
    metertype = json['metertype'];
    barcode = json['barcode'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    creditcard = json['creditcard'];
    streetname = json['streetname'];
    tapandgo = json['tapandgo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['location'] = this.location;
    data['meterid'] = this.meterid;
    data['assetid'] = this.assetid;
    data['metertype'] = this.metertype;
    data['barcode'] = this.barcode;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['creditcard'] = this.creditcard;
    data['streetname'] = this.streetname;
    data['tapandgo'] = this.tapandgo;
    return data;
  }
}

class Geometry {
  String? type;
  List<double>? coordinates;

  Geometry(param0, {this.type, this.coordinates});

  Geometry.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    return data;
  }
}

class FacetGroups {
  String? name;
  List<Facets>? facets;

  FacetGroups({this.name, this.facets});

  FacetGroups.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['facets'] != null) {
      facets = <Facets>[];
      json['facets'].forEach((v) {
        facets!.add(new Facets.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.facets != null) {
      data['facets'] = this.facets!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Facets {
  String? name;
  int? count;
  String? state;
  String? path;

  Facets({this.name, this.count, this.state, this.path});

  Facets.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    count = json['count'];
    state = json['state'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['count'] = this.count;
    data['state'] = this.state;
    data['path'] = this.path;
    return data;
  }
}
