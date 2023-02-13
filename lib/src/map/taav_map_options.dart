import 'package:flutter/material.dart';
import '../../flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TaavMapOptions extends MapOptions {
  TaavMapOptions({
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
          onTap: onTap == null
              ? null
              : (final _, final latLng) => onTap.call(latLng),
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
          interactiveFlags: interactive != null
              ? (interactive ? InteractiveFlag.all : InteractiveFlag.none)
              : interactiveFlags,
          nePanBoundary: nePanBoundary,
          onLongPress: onLongPress == null
              ? null
              : (final _, final latLng) => onLongPress.call(latLng),
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

typedef TapCallback = void Function(LatLng point);
typedef LongPressCallback = void Function(LatLng point);
