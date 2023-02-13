import 'package:flutter/material.dart';

import 'flutter_map/plugin_api.dart';

class MiracleMap extends StatelessWidget {
  /// A set of layers' options to used to create the layers on the map.
  ///
  /// Usually a list of [TileLayerOptions], [MarkerLayerOptions] and
  /// [PolylineLayerOptions].
  ///
  /// These layers will render above [children]
  final List<LayerOptions> layers;

  /// A set of layers' widgets to used to create the layers on the map.
  final List<Widget> children;

  /// [MapOptions] to create a [MapState] with.
  ///
  /// This property must not be null.
  final MapOptions options;

  /// A [MapController], used to control the map.
  final MapController? mapController;

  const MiracleMap({
    required this.options,
    this.layers = const [],
    this.children = const [],
    this.mapController,
    final Key? key,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) => FlutterMap(
        options: options,
        nonRotatedLayers: layers,
        mapController: mapController ?? MapController(),
        nonRotatedChildren: children,
      );
}
