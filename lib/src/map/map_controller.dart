import 'package:flutter/material.dart';
import '../../flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

extension MapControllerExtensions on MapController {
  void animatedMove(
    final LatLng center,
    final double zoom,
    final TickerProvider vsync,
  ) =>
      _Utils.animatedMove(move, this.center, this.zoom, center, zoom, vsync);
}

extension MapStateExtensions on MapState {
  void animatedMove(
    final LatLng center,
    final double zoom,
    final TickerProvider vsync,
  ) {
    _Utils.animatedMove(
      (final latLng, final zoom) => move(
        latLng,
        zoom,
        source: MapEventSource.custom,
      ),
      this.center,
      this.zoom,
      center,
      zoom,
      vsync,
    );
  }
}

class _Utils {
  _Utils._();

  static void animatedMove(
    final Function(LatLng, double) move,
    final LatLng currentCenter,
    final double currentZoom,
    final LatLng center,
    final double zoom,
    final TickerProvider vsync,
  ) {
    final _latTween =
        Tween<double>(begin: currentCenter.latitude, end: center.latitude);
    final _lngTween =
        Tween<double>(begin: currentCenter.longitude, end: center.longitude);
    final _zoomTween = Tween<double>(begin: currentZoom, end: zoom);

    final controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: vsync,
    );
    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      move(
        LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),
        _zoomTween.evaluate(animation),
      );
    });

    animation.addStatusListener((final status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });
    controller.forward();
  }
}
