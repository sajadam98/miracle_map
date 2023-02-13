import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;

import '../../../miracle_map_api.dart';
import '../../enums/widget_shape.dart';
import 'search_place_model.dart';

class SearchPluginOption extends LayerOptions {
  final Alignment alignment;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final String? hinText;
  final String country;
  final String language;
  final String themeName;
  final WidgetShape? shape;

  /// added a suffix to search query
  final String querySuffix;

  /// added a prefix to search query
  final String queryPrefix;

  /// color of icon
  final Color? iconColor;

  /// color of search box container
  final Color? searchBoxColor;

  SearchPluginOption({
    this.alignment = Alignment.topCenter,
    this.hinText = '',
    this.margin,
    this.padding,
    this.country = 'ir',
    this.language = 'fa',
    this.querySuffix = '',
    this.queryPrefix = '',
    this.themeName = 'textFieldFilled',
    this.shape = WidgetShape.round,
    this.iconColor,
    this.searchBoxColor,
    final Key? key,
    final Stream<Null>? rebuild,
  }) : super(key: key, rebuild: rebuild);
}

class SearchPlugin implements MapPlugin {
  @override
  Widget createLayer(final LayerOptions options, final MapState mapState,
      final Stream<Null> stream) {
    if (options is SearchPluginOption) {
      return SearchForm(options, mapState);
    }
    throw Exception('Unknown options type for SearchPluginOption: $options');
  }

  @override
  bool supportsLayer(final LayerOptions options) =>
      options is SearchPluginOption;
}

class SearchForm extends StatefulWidget {
  final SearchPluginOption _searchOpts;
  final MapState _map;

  SearchForm(this._searchOpts, this._map) : super(key: _searchOpts.key);

  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> with TickerProviderStateMixin {
  @override
  Widget build(final BuildContext context) => Align(
        alignment: widget._searchOpts.alignment,
        child: Container(
          margin: widget._searchOpts.margin ??
              const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          padding: widget._searchOpts.padding ??
              const EdgeInsets.only(right: 10, left: 10, bottom: 4),
          constraints: const BoxConstraints(maxWidth: 550),
          decoration: BoxDecoration(
            color: widget._searchOpts.searchBoxColor,
            borderRadius: BorderRadius.circular(_radius),
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 2),
                blurRadius: 3,
                spreadRadius: 1,
                color: Colors.black12,
              ),
              BoxShadow(
                offset: Offset(0, 1),
                blurRadius: 1,
                spreadRadius: 0,
                color: Colors.black12,
              )
            ],
          ),
          child: TypeAheadField(
            hideOnEmpty: true,
            textFieldConfiguration: TextFieldConfiguration(
              autofocus: true,
              style: DefaultTextStyle.of(context)
                  .style
                  .copyWith(fontStyle: FontStyle.italic),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: widget._searchOpts.hinText,
                icon: Icon(
                  Icons.search_rounded,
                  color: widget._searchOpts.iconColor,
                ),
              ),
              maxLines: 1,
              minLines: 1,
            ),
            suggestionsCallback: (final query) {
              final String finalQuery =
                  '${widget._searchOpts.queryPrefix} $query ${widget._searchOpts.querySuffix}'
                      .trim();
              return _searchPlaceLogic(finalQuery, widget._searchOpts.country,
                  widget._searchOpts.language);
            },
            itemBuilder: _itemBuilder,
            onSuggestionSelected: _onSuggestionSelected,
          ),
        ),
      );

  Widget _itemBuilder(final BuildContext context,
          final SearchPlaceModel searchPlaceModel) =>
      Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(Icons.location_on, color: widget._searchOpts.iconColor),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      searchPlaceModel.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      searchPlaceModel.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  void _onSuggestionSelected(final SearchPlaceModel searchPlaceModel) {
    try {
      final bounds = LatLngBounds();
      bounds.extend(LatLng(double.parse(searchPlaceModel.boundingBox[0]),
          double.parse(searchPlaceModel.boundingBox[2])));
      bounds.extend(LatLng(double.parse(searchPlaceModel.boundingBox[1]),
          double.parse(searchPlaceModel.boundingBox[3])));

      if (bounds.isValid) {
        final target = widget._map.getBoundsCenterZoom(
            bounds,
            const FitBoundsOptions(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
            ));
        widget._map.animatedMove(target.center, target.zoom, this);
      }
    } catch (e) {
      widget._map.animatedMove(
          LatLng(double.parse(searchPlaceModel.lat),
              double.parse(searchPlaceModel.lon)),
          16,
          this);
    }
  }

  double get _radius {
    final shape = widget._searchOpts.shape;
    if (shape == WidgetShape.rectangle) {
      return 2;
    } else if (shape == WidgetShape.semiRound) {
      return 4;
    } else {
      return 8;
    }
  }

  Future<List<SearchPlaceModel>> _searchPlaceLogic(
      final String query, final String country, final String language) async {
    if (query.isEmpty || query.replaceAll(' ', '').isEmpty) {
      return [];
    }

    final String url =
        'https://nominatim.openstreetmap.org/search.php?q=$query&polygon_geojson=1&accept-language=$language&countrycodes=$country&format=jsonv2';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> places = json.decode(response.body);
      return places.map<SearchPlaceModel>((final item) {
        final SearchPlaceModel viewModel = SearchPlaceModel.fromJson(item);
        return viewModel;
      }).toList();
    }
    return [];
  }
}
