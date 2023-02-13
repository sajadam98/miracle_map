import 'package:flutter/material.dart';

import '../../flutter_map/flutter_map.dart';

class MiracleTileLayerOption extends TileLayerOptions {
  MiracleTileLayerOption({
    final Alignment attributionAlignment = Alignment.bottomRight,
    final WidgetBuilder? attributionBuilder,
    final Key? key,
    final String? urlTemplate,
    final double tileSize = 256.0,
    final double minZoom = 0.0,
    final double maxZoom = 18.0,
    final double? minNativeZoom,
    final double? maxNativeZoom,
    final bool zoomReverse = false,
    final double zoomOffset = 0.0,
    final Map<String, String>? additionalOptions,
    final List<String> subdomains = const <String>[],
    final int keepBuffer = 2,
    final Color backgroundColor = const Color(0xFFE0E0E0),
    final ImageProvider? placeholderImage,
    final ImageProvider? errorImage,
    final TileProvider tileProvider = const CachedNetworkTileProvider(),
    final bool tms = false,
    final WMSTileLayerOptions? wmsOptions,
    final double opacity = 1.0,
    final int updateInterval = 200,
    final int tileFadeInDuration = 100,
    final double tileFadeInStart = 0.0,
    final double tileFadeInStartWhenOverride = 0.0,
    final bool overrideTilesWhenUrlChanges = false,
    final bool retinaMode = false,
    final ErrorTileCallBack? errorTileCallback,
    final Stream<Null>? rebuild,
    final TileBuilder? tileBuilder,
    final TilesContainerBuilder? tilesContainerBuilder,
    final EvictErrorTileStrategy evictErrorTileStrategy =
        EvictErrorTileStrategy.none,
    final bool fastReplace = false,
    final Stream<Null>? reset,
  }) : super(
          additionalOptions: additionalOptions,
          attributionAlignment: attributionAlignment,
          attributionBuilder: attributionBuilder,
          backgroundColor: backgroundColor,
          errorImage: errorImage,
          errorTileCallback: errorTileCallback,
          evictErrorTileStrategy: evictErrorTileStrategy,
          fastReplace: fastReplace,
          keepBuffer: keepBuffer,
          key: key,
          maxNativeZoom: maxNativeZoom,
          maxZoom: maxZoom,
          minNativeZoom: minNativeZoom,
          minZoom: minZoom,
          opacity: opacity,
          overrideTilesWhenUrlChanges: overrideTilesWhenUrlChanges,
          placeholderImage: placeholderImage,
          rebuild: rebuild,
          reset: reset,
          retinaMode: retinaMode,
          subdomains: subdomains,
          tileBuilder: tileBuilder,
          tileFadeInDuration: tileFadeInDuration,
          tileFadeInStart: tileFadeInStart,
          tileFadeInStartWhenOverride: tileFadeInStartWhenOverride,
          tileProvider: tileProvider,
          tilesContainerBuilder: tilesContainerBuilder,
          tileSize: tileSize,
          updateInterval: updateInterval,
          urlTemplate: urlTemplate,
          wmsOptions: wmsOptions,
          zoomOffset: zoomOffset,
          zoomReverse: zoomReverse,
        );
}

class CachedNetworkTileProvider extends TileProvider {
  const CachedNetworkTileProvider();

  @override
  ImageProvider getImage(
          final Coords<num> coords, final TileLayerOptions options) =>
      NetworkImage(getTileUrl(coords, options));
}
