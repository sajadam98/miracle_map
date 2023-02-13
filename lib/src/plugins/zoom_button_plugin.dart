import 'package:flutter/material.dart';

import '../../miracle_map_api.dart';
import '../enums/widget_shape.dart';
import '../enums/widget_size.dart';

class ZoomButtonsPluginOption extends LayerOptions {
  final int minZoom;
  final int maxZoom;
  final double padding;
  final Alignment alignment;
  final Color? zoomInColor;
  final Color? zoomOutColor;
  final IconData zoomInIcon;
  final IconData zoomOutIcon;
  final WidgetShape? shape;
  final WidgetSize size;
  final String themeName;

  ZoomButtonsPluginOption({
    final Key? key,
    this.minZoom = 1,
    this.maxZoom = 18,
    this.padding = 2.0,
    this.alignment = Alignment.topRight,
    this.zoomInColor,
    this.zoomInIcon = Icons.zoom_in,
    this.zoomOutColor,
    this.zoomOutIcon = Icons.zoom_out,
    this.shape = WidgetShape.round,
    this.size = WidgetSize.small,
    this.themeName = 'iconButtonFilled',
    @Deprecated('use size instead') final bool mini = true,
    final rebuild,
  }) : super(key: key, rebuild: rebuild);
}

class ZoomButtonsPlugin implements MapPlugin {
  @override
  Widget createLayer(final LayerOptions options, final MapState mapState,
      final Stream<Null> stream) {
    if (options is ZoomButtonsPluginOption) {
      return ZoomButtons(options, mapState);
    }
    throw Exception('Unknown options type for ZoomButtonsPlugin: $options');
  }

  @override
  bool supportsLayer(final LayerOptions options) =>
      options is ZoomButtonsPluginOption;
}

class ZoomButtons extends StatefulWidget {
  final ZoomButtonsPluginOption zoomButtonsOpts;
  final MapState map;

  ZoomButtons(this.zoomButtonsOpts, this.map) : super(key: zoomButtonsOpts.key);

  @override
  State<ZoomButtons> createState() => _ZoomButtonsState();
}

class _ZoomButtonsState extends State<ZoomButtons>
    with TickerProviderStateMixin {
  final FitBoundsOptions options =
      const FitBoundsOptions(padding: EdgeInsets.all(12.0));

  @override
  Widget build(final BuildContext context) => Align(
        alignment: widget.zoomButtonsOpts.alignment,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _zoomInIcon(),
            _zoomOutIcon(),
          ],
        ),
      );

  Padding _zoomOutIcon() => Padding(
        padding: _padding(),
        child: GestureDetector(
          onTap: () {
            final zoom = widget.map.zoom - 1;
            if (zoom > widget.zoomButtonsOpts.minZoom) {
              widget.map.animatedMove(widget.map.center, zoom, this);
            }
          },
          child: Container(
            decoration: BoxDecoration(
                color: widget.zoomButtonsOpts.zoomOutColor,
                borderRadius: BorderRadius.all(Radius.circular(_radius))),
            padding: const EdgeInsets.all(4),
            child: Icon(
              widget.zoomButtonsOpts.zoomOutIcon,
              size: _size,
            ),
          ),
        ),
      );

  Padding _zoomInIcon() => Padding(
      padding: _padding().copyWith(bottom: 5),
      child: GestureDetector(
        onTap: () {
          final zoom = widget.map.zoom + 1;
          if (zoom < widget.zoomButtonsOpts.maxZoom) {
            widget.map.animatedMove(widget.map.center, zoom, this);
          }
        },
        child: Container(
          decoration: BoxDecoration(
              color: widget.zoomButtonsOpts.zoomInColor,
              borderRadius: BorderRadius.all(Radius.circular(_radius))),
          padding: const EdgeInsets.all(4),
          child: Icon(
            widget.zoomButtonsOpts.zoomInIcon,
            size: _size,
          ),
        ),
      ));

  EdgeInsets _padding() => EdgeInsets.only(
        left: widget.zoomButtonsOpts.padding,
        bottom: widget.zoomButtonsOpts.padding,
        right: widget.zoomButtonsOpts.padding,
      );

  double get _radius {
    final shape = widget.zoomButtonsOpts.shape;
    if (shape == WidgetShape.rectangle) {
      return 2;
    } else if (shape == WidgetShape.semiRound) {
      return 4;
    } else {
      return 8;
    }
  }

  double get _size {
    final size = widget.zoomButtonsOpts.size;
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
}
