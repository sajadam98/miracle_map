import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:miracle_map/src/extensions.dart';

import '../../miracle_map_api.dart';
import '../enums/widget_shape.dart';
import '../enums/widget_size.dart';

class MyLocationPluginOption extends LayerOptions {
  final Alignment alignment;
  final bool moveAndZoomAtShow;
  final IconData icon;
  final WidgetShape? shape;
  final WidgetSize size;
  final Color iconBackgroundColor;

  MyLocationPluginOption({
    this.alignment = Alignment.bottomLeft,
    this.moveAndZoomAtShow = true,
    this.icon = Icons.my_location,
    this.shape = WidgetShape.round,
    this.size = WidgetSize.small,
    this.iconBackgroundColor = Colors.transparent,
    final Stream<Null>? rebuild,
    final Key? key,
  }) : super(key: key, rebuild: rebuild);
}

class MyLocationPlugin implements MapPlugin {
  @override
  Widget createLayer(
    final LayerOptions options,
    final MapState mapState,
    final Stream<Null> stream,
  ) {
    if (options is MyLocationPluginOption) {
      return MyLocationUI(options, mapState);
    }
    throw Exception('Unknown options type for MyLocationPlugin: $options');
  }

  @override
  bool supportsLayer(final LayerOptions options) =>
      options is MyLocationPluginOption;
}

class MyLocationUI extends StatefulWidget {
  final MyLocationPluginOption myLocationOpts;
  final MapState map;

  MyLocationUI(this.myLocationOpts, this.map) : super(key: myLocationOpts.key);

  @override
  _MyLocationUIState createState() => _MyLocationUIState();
}

class _MyLocationUIState extends State<MyLocationUI>
    with TickerProviderStateMixin {
  final FitBoundsOptions options =
      const FitBoundsOptions(padding: EdgeInsets.all(12.0));
  final Location _location = Location();

  /// live current location lat-long
  LatLng? _liveLatLng;

  /// update for go to current location button
  bool _gettingCurrLocation = false;

  /// listener for current location update
  StreamSubscription<LocationData>? _locationSubscription;

  _MyLocationUIState();

  @override
  void initState() {
    super.initState();

    /// Initialize and get current location
    /// then move & zoom map
    _getCurrentLocation().then((final location) {
      // build and update current location marker
      setState(() {
        _liveLatLng = location;
        if (location != null && widget.myLocationOpts.moveAndZoomAtShow) {
          widget.map.animatedMove(location, 13, this);
        }
      });
    }).catchError((final _) {});
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => Stack(
        children: [
          if (_liveLatLng != null)
            MarkerLayerWidget(
              options: MarkerLayerOptions(
                markers: [
                  Marker(
                    width: 20.0,
                    height: 20.0,
                    point: _liveLatLng!,
                    builder: (final ctx) =>
                        const Icon(Icons.radio_button_checked),
                  )
                ],
              ),
            ),
          Align(
            alignment: widget.myLocationOpts.alignment,
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: _goToCurrentLocation,
                  child: Container(
                    decoration: BoxDecoration(
                        color: widget.myLocationOpts.iconBackgroundColor,
                        borderRadius:
                            BorderRadius.all(Radius.circular(_radius))),
                    padding: const EdgeInsets.all(4),
                    child: _gettingCurrLocation
                        ? const CircularProgressIndicator()
                        : Icon(
                            widget.myLocationOpts.icon,
                            size: _size,
                          ),
                  ),
                )),
          ),
        ],
      );

  double get _radius {
    final shape = widget.myLocationOpts.shape;
    if (shape == WidgetShape.rectangle) {
      return 2;
    } else if (shape == WidgetShape.semiRound) {
      return 4;
    } else {
      return 8;
    }
  }

  double get _size {
    final size = widget.myLocationOpts.size;
    if (size == WidgetSize.tiny) {
      return 10;
    } else if (size == WidgetSize.small) {
      return 14;
    } else if (size == WidgetSize.medium) {
      return 18;
    } else if (size == WidgetSize.large) {
      return 22;
    } else {
      return 26;
    }
  }

  /// update button ui and move and zoom
  void _goToCurrentLocation() async {
    setState(() => _gettingCurrLocation = true);

    try {
      _liveLatLng = await _getCurrentLocation();
    } catch (e) {
      _liveLatLng = null;
    }
    if (_liveLatLng != null) {
      widget.map.animatedMove(_liveLatLng!, 18, this);
    }

    setState(() => _gettingCurrLocation = false);
  }

  Future<bool> _initLocation() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }
    PermissionStatus permissionGranted = await _location.hasPermission();

    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    _location.changeSettings(interval: 2200).unawait;
    _locationSubscription ??=
        _location.onLocationChanged.listen((final locationData) {
      setState(() {
        final latitude = locationData.latitude;
        final longitude = locationData.longitude;
        if (latitude != null && longitude != null) {
          _liveLatLng = LatLng(latitude, longitude);
        }
      });
    });

    return true;
  }

  Future<LatLng?> _getCurrentLocation() async {
    final bool isInit = await _initLocation();
    if (isInit) {
      final LocationData locationData = await _location.getLocation();
      final latitude = locationData.latitude;
      final longitude = locationData.longitude;
      if (latitude != null && longitude != null) {
        return LatLng(latitude, longitude);
      }
    }
    return null;
  }
}
