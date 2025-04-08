class LatLngAddressModel {
  Plus_code? plus_code;
  List<Results>? results;
  String? status;

  LatLngAddressModel({
      this.plus_code, 
      this.results, 
      this.status});

  LatLngAddressModel.fromJson(dynamic json) {
    plus_code = json["plus_code"] != null ? Plus_code.fromJson(json["plus_code"]) : null;
    if (json["results"] != null) {
      results = [];
      json["results"].forEach((v) {
        results!.add(Results.fromJson(v));
      });
    }
    status = json["status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (plus_code != null) {
      map["plus_code"] = plus_code!.toJson();
    }
    if (results != null) {
      map["results"] = results!.map((v) => v.toJson()).toList();
    }
    map["status"] = status;
    return map;
  }

}

class Results {
  List<Address_components>? address_components;
  String? formatted_address;
  Geometry? geometry;
  String? place_id;
  List<String>? types;

  Results({
      this.address_components, 
      this.formatted_address, 
      this.geometry, 
      this.place_id, 
      this.types});

  Results.fromJson(dynamic json) {
    if (json["address_components"] != null) {
      address_components = [];
      json["address_components"].forEach((v) {
        address_components!.add(Address_components.fromJson(v));
      });
    }
    formatted_address = json["formatted_address"];
    geometry = json["geometry"] != null ? Geometry.fromJson(json["geometry"]) : null;
    place_id = json["place_id"];
    types = json["types"] != null ? json["types"].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (address_components != null) {
      map["address_components"] = address_components!.map((v) => v.toJson()).toList();
    }
    map["formatted_address"] = formatted_address;
    if (geometry != null) {
      map["geometry"] = geometry!.toJson();
    }
    map["place_id"] = place_id;
    map["types"] = types;
    return map;
  }

}

class Geometry {
  Bounds? bounds;
  Location? location;
  String? location_type;
  Viewport? viewport;

  Geometry({
      this.bounds, 
      this.location, 
      this.location_type, 
      this.viewport});

  Geometry.fromJson(dynamic json) {
    bounds = json["bounds"] != null ? Bounds.fromJson(json["bounds"]) : null;
    location = json["location"] != null ? Location.fromJson(json["location"]) : null;
    location_type = json["location_type"];
    viewport = json["viewport"] != null ? Viewport.fromJson(json["viewport"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (bounds != null) {
      map["bounds"] = bounds!.toJson();
    }
    if (location != null) {
      map["location"] = location!.toJson();
    }
    map["location_type"] = location_type;
    if (viewport != null) {
      map["viewport"] = viewport!.toJson();
    }
    return map;
  }

}

class Viewport {
  Northeast? northeast;
  Southwest? southwest;

  Viewport({
      this.northeast, 
      this.southwest});

  Viewport.fromJson(dynamic json) {
    northeast = json["northeast"] != null ? Northeast.fromJson(json["northeast"]) : null;
    southwest = json["southwest"] != null ? Southwest.fromJson(json["southwest"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (northeast != null) {
      map["northeast"] = northeast!.toJson();
    }
    if (southwest != null) {
      map["southwest"] = southwest!.toJson();
    }
    return map;
  }

}

class Southwest {
  double? lat;
  double? lng;

  Southwest({
      this.lat, 
      this.lng});

  Southwest.fromJson(dynamic json) {
    if(json['lat'].runtimeType == int) {

      lat = 0.0;
      lng = 0.0;

    } else {

      lat = json['lat'];
      lng = json['lng'];

    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["lat"] = lat;
    map["lng"] = lng;
    return map;
  }

}

class Northeast {
  double? lat;
  double? lng;

  Northeast({
      this.lat, 
      this.lng});

  Northeast.fromJson(dynamic json) {
    if(json['lat'].runtimeType == int) {

      lat = 0.0;
      lng = 0.0;

    } else {

      lat = json['lat'];
      lng = json['lng'];

    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["lat"] = lat;
    map["lng"] = lng;
    return map;
  }

}

class Location {
  double? lat;
  double? lng;

  Location({
      this.lat, 
      this.lng});

  Location.fromJson(dynamic json) {
    if(json['lat'].runtimeType == int) {

      lat = 0.0;
      lng = 0.0;

    } else {

      lat = json['lat'];
      lng = json['lng'];

    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["lat"] = lat;
    map["lng"] = lng;
    return map;
  }

}

class Bounds {
  Northeast? northeast;
  Southwest? southwest;

  Bounds({
      this.northeast, 
      this.southwest});

  Bounds.fromJson(dynamic json) {
    northeast = json["northeast"] != null ? Northeast.fromJson(json["northeast"]) : null;
    southwest = json["southwest"] != null ? Southwest.fromJson(json["southwest"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (northeast != null) {
      map["northeast"] = northeast!.toJson();
    }
    if (southwest != null) {
      map["southwest"] = southwest!.toJson();
    }
    return map;
  }

}

class Address_components {
  String? long_name;
  String? short_name;
  List<String>? types;

  Address_components({
      this.long_name, 
      this.short_name, 
      this.types});

  Address_components.fromJson(dynamic json) {
    long_name = json["long_name"];
    short_name = json["short_name"];
    types = json["types"] != null ? json["types"].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["long_name"] = long_name;
    map["short_name"] = short_name;
    map["types"] = types;
    return map;
  }

}

class Plus_code {
  String? compoundCode;
  String? globalCode;

  Plus_code({
      this.compoundCode, 
      this.globalCode});

  Plus_code.fromJson(dynamic json) {
    compoundCode = json["compoundCode"];
    globalCode = json["globalCode"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["compoundCode"] = compoundCode;
    map["globalCode"] = globalCode;
    return map;
  }

}