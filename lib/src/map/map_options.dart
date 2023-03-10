import 'package:flutter/material.dart';

import '../../miracle_map_api.dart';
import 'taav_map_options.dart';

class MapOptions extends TaavMapOptions {
  MapOptions({
    final bool allowPanningOnScrollingParent = true,
    final Crs crs = const Epsg3857(),
    final LatLng? center,
    final LatLngBounds? bounds,
    final FitBoundsOptions boundsOptions = const FitBoundsOptions(),
    final double zoom = 13.0,
    final bool debugMultiFingerGestureWinner = false,
    final bool enableMultiFingerGestureRace = false,
    final double pinchZoomThreshold = 0.5,
    final int pinchZoomWinGestures =
        MultiFingerGesture.pinchZoom | MultiFingerGesture.pinchMove,
    final double pinchMoveThreshold = 40.0,
    final int pinchMoveWinGestures =
        MultiFingerGesture.pinchZoom | MultiFingerGesture.pinchMove,
    final bool enableScrollWheel = true,
    final double? minZoom,
    final double? maxZoom,
    final int interactiveFlags = InteractiveFlag.all,
    final bool? interactive,
    final bool allowPanning = true,
    final TapCallback? onTap,
    final LongPressCallback? onLongPress,
    final PositionCallback? onPositionChanged,
    final MapCreatedCallback? onMapCreated,
    final List<MapPlugin> plugins = const [],
    final bool slideOnBoundaries = false,
    final bool adaptiveBoundaries = false,
    final Size? screenSize,
    final MapController? controller,
    final LatLng? swPanBoundary,
    final LatLng? nePanBoundary,
  }) : super(
          minZoom: minZoom,
          maxZoom: maxZoom,
          onTap: onTap,
          adaptiveBoundaries: adaptiveBoundaries,
          allowPanning: allowPanning,
          bounds: bounds,
          allowPanningOnScrollingParent: allowPanningOnScrollingParent,
          boundsOptions: boundsOptions,
          center: center,
          controller: controller,
          crs: crs,
          debugMultiFingerGestureWinner: debugMultiFingerGestureWinner,
          enableMultiFingerGestureRace: enableMultiFingerGestureRace,
          enableScrollWheel: enableScrollWheel,
          interactive: interactive,
          interactiveFlags: interactiveFlags,
          nePanBoundary: nePanBoundary,
          onLongPress: onLongPress,
          onMapCreated: onMapCreated,
          onPositionChanged: onPositionChanged,
          pinchMoveThreshold: pinchMoveThreshold,
          pinchMoveWinGestures: pinchMoveWinGestures,
          pinchZoomThreshold: pinchZoomThreshold,
          pinchZoomWinGestures: pinchZoomWinGestures,
          plugins: plugins,
          screenSize: screenSize,
          slideOnBoundaries: slideOnBoundaries,
          swPanBoundary: swPanBoundary,
          zoom: zoom,
        );
}
