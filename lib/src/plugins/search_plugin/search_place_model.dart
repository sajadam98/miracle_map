class SearchPlaceModel {
  int? placeId;
  String? osmType;
  int? osmId;
  List<String> boundingBox;
  String lat;
  String lon;
  String displayName;
  int? placeRank;
  String? category;
  double? importance;

  SearchPlaceModel({
    required this.boundingBox,
    required this.lat,
    required this.lon,
    required this.displayName,
    this.placeId,
    this.osmType,
    this.osmId,
    this.placeRank,
    this.category,
    this.importance,
  });

  factory SearchPlaceModel.fromJson(final dynamic json) => SearchPlaceModel(
        placeId: json['place_id'],
        osmType: json['osm_type'],
        osmId: json['osm_id'],
        boundingBox: json['bounding'] != null
            ? json['boundingbox'].cast<String>()
            : [],
        lat: json['lat'],
        lon: json['lon'],
        displayName: json['display_name'],
        placeRank: json['place_rank'],
        category: json['category'],
        importance: json['importance'],
      );

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["place_id"] = placeId;
    map["osm_type"] = osmType;
    map["osm_id"] = osmId;
    map["boundingbox"] = boundingBox;
    map["lat"] = lat;
    map["lon"] = lon;
    map["display_name"] = displayName;
    map["place_rank"] = placeRank;
    map["category"] = category;
    map["importance"] = importance;
    return map;
  }

  String get title {
    final splitted = displayName.split(',');
    if (splitted.length >= 4) {
      return splitted.take(3).join('،');
    }
    return displayName;
  }

  String get subtitle {
    final splitted = displayName.split(',');
    if (splitted.length >= 4) {
      return splitted.skip(3).join('،');
    }
    return '';
  }

  @override
  String toString() =>
      'SearchPlaceModel{placeId: $placeId, osmType: $osmType, osmId: $osmId, '
          'boundingBox: $boundingBox, lat: $lat, lon: $lon, '
          'displayName: $displayName, placeRank: $placeRank, '
          'category: $category, importance: $importance}';
}
