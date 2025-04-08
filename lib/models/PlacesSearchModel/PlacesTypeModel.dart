import 'dart:convert';

import 'package:flutter/foundation.dart';

class PlacesTypeModel {
  final List<Result>? results;
  final String? status;
  PlacesTypeModel({
    this.results,
    this.status,
  });

  PlacesTypeModel copyWith({
    List<Result>? results,
    String? status,
  }) {
    return PlacesTypeModel(
      results: results ?? this.results,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'results': results?.map((x) => x.toMap()).toList(),
      'status': status,
    };
  }

  static PlacesTypeModel? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
  
    return PlacesTypeModel(
      results: List<Result>.from(map['results']?.map((x) => Result.fromMap(x))),
      status: map['status'],
    );
  }

  String toJson() => json.encode(toMap());

  static PlacesTypeModel? fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'PlacesTypeModel(results: $results, status: $status)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is PlacesTypeModel &&
      listEquals(o.results, results) &&
      o.status == status;
  }

  @override
  int get hashCode => results.hashCode ^ status.hashCode;
}

class Result {
  final String? business_status;
  final Geometry? geometry;
  final String? icon;
  final String? id;
  final String? name;
  final Opening_hours? opening_hours;
  final List<Photo>? photos;
  final String? place_id;
  final Plus_code? plus_code;
  final double? rating;
  final String? reference;
  final String? scope;
  final List<String>? types;
  final int? user_ratings_total;
  final String? vicinity;
  Result({
    this.business_status,
    this.geometry,
    this.icon,
    this.id,
    this.name,
    this.opening_hours,
    this.photos,
    this.place_id,
    this.plus_code,
    this.rating,
    this.reference,
    this.scope,
    this.types,
    this.user_ratings_total,
    this.vicinity,
  });

  Result copyWith({
    String? business_status,
    Geometry? geometry,
    String? icon,
    String? id,
    String? name,
    Opening_hours? opening_hours,
    List<Photo>? photos,
    String? place_id,
    Plus_code? plus_code,
    double? rating,
    String? reference,
    String? scope,
    List<String>? types,
    int? user_ratings_total,
    String? vicinity,
  }) {
    return Result(
      business_status: business_status ?? this.business_status,
      geometry: geometry ?? this.geometry,
      icon: icon ?? this.icon,
      id: id ?? this.id,
      name: name ?? this.name,
      opening_hours: opening_hours ?? this.opening_hours,
      photos: photos ?? this.photos,
      place_id: place_id ?? this.place_id,
      plus_code: plus_code ?? this.plus_code,
      rating: rating ?? this.rating,
      reference: reference ?? this.reference,
      scope: scope ?? this.scope,
      types: types ?? this.types,
      user_ratings_total: user_ratings_total ?? this.user_ratings_total,
      vicinity: vicinity ?? this.vicinity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'business_status': business_status,
      'geometry': geometry?.toMap(),
      'icon': icon,
      'id': id,
      'name': name,
      'opening_hours': opening_hours?.toMap(),
//      'photos': photos?.map((x) => x?.toMap())?.toList(),
      'place_id': place_id,
      'plus_code': plus_code?.toMap(),
      'rating': rating,
      'reference': reference,
      'scope': scope,
      'types': types,
      'user_ratings_total': user_ratings_total,
      'vicinity': vicinity,
    };
  }

  static Result? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
  
    return Result(
      business_status: map['business_status'],
      geometry: Geometry.fromMap(map['geometry']),
      icon: map['icon'],
      id: map['id'],
      name: map['name'],
      opening_hours: Opening_hours.fromMap(map['opening_hours']),
//      photos: List<Photo>.from(map['photos']?.map((x) => Photo.fromMap(x))),
      place_id: map['place_id'],
      plus_code: Plus_code.fromMap(map['plus_code']),
      rating: map['rating']?.toDouble(),
      reference: map['reference'],
      scope: map['scope'],
      types: List<String>.from(map['types']),
      user_ratings_total: map['user_ratings_total']?.toInt(),
      vicinity: map['vicinity'],
    );
  }

  String toJson() => json.encode(toMap());

  static Result? fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Result(business_status: $business_status, geometry: $geometry, icon: $icon, id: $id, name: $name, opening_hours: $opening_hours, photos: $photos, place_id: $place_id, plus_code: $plus_code, rating: $rating, reference: $reference, scope: $scope, types: $types, user_ratings_total: $user_ratings_total, vicinity: $vicinity)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Result &&
      o.business_status == business_status &&
      o.geometry == geometry &&
      o.icon == icon &&
      o.id == id &&
      o.name == name &&
      o.opening_hours == opening_hours &&
      listEquals(o.photos, photos) &&
      o.place_id == place_id &&
      o.plus_code == plus_code &&
      o.rating == rating &&
      o.reference == reference &&
      o.scope == scope &&
      listEquals(o.types, types) &&
      o.user_ratings_total == user_ratings_total &&
      o.vicinity == vicinity;
  }

  @override
  int get hashCode {
    return business_status.hashCode ^
      geometry.hashCode ^
      icon.hashCode ^
      id.hashCode ^
      name.hashCode ^
      opening_hours.hashCode ^
      photos.hashCode ^
      place_id.hashCode ^
      plus_code.hashCode ^
      rating.hashCode ^
      reference.hashCode ^
      scope.hashCode ^
      types.hashCode ^
      user_ratings_total.hashCode ^
      vicinity.hashCode;
  }
}

class Geometry {
  final Location? location;
  final Viewport? viewport;
  Geometry({
    this.location,
    this.viewport,
  });

  Geometry copyWith({
    Location? location,
    Viewport? viewport,
  }) {
    return Geometry(
      location: location ?? this.location,
      viewport: viewport ?? this.viewport,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'location': location?.toMap(),
      'viewport': viewport?.toMap(),
    };
  }

  static Geometry? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
  
    return Geometry(
      location: Location.fromMap(map['location']),
      viewport: Viewport.fromMap(map['viewport']),
    );
  }

  String toJson() => json.encode(toMap());

  static Geometry? fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'Geometry(location: $location, viewport: $viewport)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Geometry &&
      o.location == location &&
      o.viewport == viewport;
  }

  @override
  int get hashCode => location.hashCode ^ viewport.hashCode;
}

class Location {
  final double? lat;
  final double? lng;
  Location({
    this.lat,
    this.lng,
  });

  Location copyWith({
    double? lat,
    double? lng,
  }) {
    return Location(
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }

  static Location? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
  
    return Location(
      lat: map['lat']?.toDouble(),
      lng: map['lng']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  static Location? fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'Location(lat: $lat, lng: $lng)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Location &&
      o.lat == lat &&
      o.lng == lng;
  }

  @override
  int get hashCode => lat.hashCode ^ lng.hashCode;
}

class Viewport {
  final Northeast? northeast;
  final Southwest? southwest;
  Viewport({
    this.northeast,
    this.southwest,
  });

  Viewport copyWith({
    Northeast? northeast,
    Southwest? southwest,
  }) {
    return Viewport(
      northeast: northeast ?? this.northeast,
      southwest: southwest ?? this.southwest,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'northeast': northeast?.toMap(),
      'southwest': southwest?.toMap(),
    };
  }

  static Viewport? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
  
    return Viewport(
      northeast: Northeast.fromMap(map['northeast']),
      southwest: Southwest.fromMap(map['southwest']),
    );
  }

  String toJson() => json.encode(toMap());

  static Viewport? fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'Viewport(northeast: $northeast, southwest: $southwest)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Viewport &&
      o.northeast == northeast &&
      o.southwest == southwest;
  }

  @override
  int get hashCode => northeast.hashCode ^ southwest.hashCode;
}

class Northeast {
  final double? lat;
  final double? lng;
  Northeast({
    this.lat,
    this.lng,
  });

  Northeast copyWith({
    double? lat,
    double? lng,
  }) {
    return Northeast(
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }

  static Northeast? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
  
    return Northeast(
      lat: map['lat']?.toDouble(),
      lng: map['lng']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  static Northeast? fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'Northeast(lat: $lat, lng: $lng)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Northeast &&
      o.lat == lat &&
      o.lng == lng;
  }

  @override
  int get hashCode => lat.hashCode ^ lng.hashCode;
}

class Southwest {
  final double? lat;
  final double? lng;
  Southwest({
    this.lat,
    this.lng,
  });

  Southwest copyWith({
    double? lat,
    double? lng,
  }) {
    return Southwest(
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }

  static Southwest? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
  
    return Southwest(
      lat: map['lat']?.toDouble(),
      lng: map['lng']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  static Southwest? fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'Southwest(lat: $lat, lng: $lng)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Southwest &&
      o.lat == lat &&
      o.lng == lng;
  }

  @override
  int get hashCode => lat.hashCode ^ lng.hashCode;
}

class Opening_hours {
  final bool? open_now;
  Opening_hours({
    this.open_now,
  });

  Opening_hours copyWith({
    bool? open_now,
  }) {
    return Opening_hours(
      open_now: open_now ?? this.open_now,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'open_now': open_now,
    };
  }

  static Opening_hours? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
  
    return Opening_hours(
      open_now: map['open_now'],
    );
  }

  String toJson() => json.encode(toMap());

  static Opening_hours? fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'Opening_hours(open_now: $open_now)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Opening_hours &&
      o.open_now == open_now;
  }

  @override
  int get hashCode => open_now.hashCode;
}

class Photo {
  final int? height;
  final List<String>? html_attributions;
  final String? photo_reference;
  final int? width;
  Photo({
    this.height,
    this.html_attributions,
    this.photo_reference,
    this.width,
  });

  Photo copyWith({
    int? height,
    List<String>? html_attributions,
    String? photo_reference,
    int? width,
  }) {
    return Photo(
      height: height ?? this.height,
      html_attributions: html_attributions ?? this.html_attributions,
      photo_reference: photo_reference ?? this.photo_reference,
      width: width ?? this.width,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'height': height,
      'html_attributions': html_attributions,
      'photo_reference': photo_reference,
      'width': width,
    };
  }

  static Photo? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
  
    return Photo(
      height: map['height']?.toInt(),
      html_attributions: List<String>.from(map['html_attributions']),
      photo_reference: map['photo_reference'],
      width: map['width']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  static Photo? fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Photo(height: $height, html_attributions: $html_attributions, photo_reference: $photo_reference, width: $width)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Photo &&
      o.height == height &&
      listEquals(o.html_attributions, html_attributions) &&
      o.photo_reference == photo_reference &&
      o.width == width;
  }

  @override
  int get hashCode {
    return height.hashCode ^
      html_attributions.hashCode ^
      photo_reference.hashCode ^
      width.hashCode;
  }
}

class Plus_code {
  final String? compound_code;
  final String? global_code;
  Plus_code({
    this.compound_code,
    this.global_code,
  });

  Plus_code copyWith({
    String? compound_code,
    String? global_code,
  }) {
    return Plus_code(
      compound_code: compound_code ?? this.compound_code,
      global_code: global_code ?? this.global_code,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'compound_code': compound_code,
      'global_code': global_code,
    };
  }

  static Plus_code? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
  
    return Plus_code(
      compound_code: map['compound_code'],
      global_code: map['global_code'],
    );
  }

  String toJson() => json.encode(toMap());

  static Plus_code? fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'Plus_code(compound_code: $compound_code, global_code: $global_code)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Plus_code &&
      o.compound_code == compound_code &&
      o.global_code == global_code;
  }

  @override
  int get hashCode => compound_code.hashCode ^ global_code.hashCode;
}