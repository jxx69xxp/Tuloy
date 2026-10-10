import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Web-Mercator tile coordinates (fractional) for a point at [zoom].
({double x, double y}) tileXY(double lat, double lng, int zoom) {
  final n = math.pow(2, zoom).toDouble();
  final r = lat * math.pi / 180;
  return (x: (lng + 180) / 360 * n, y: (1 - math.log(math.tan(r) + 1 / math.cos(r)) / math.pi) / 2 * n);
}

/// Opens the platform maps app on a pin (Apple Maps on iOS, Google Maps elsewhere).
Future<void> openMap(double lat, double lng, String label) => launchUrl(
  defaultTargetPlatform == TargetPlatform.iOS
      ? Uri.https('maps.apple.com', '/', {'q': label, 'll': '$lat,$lng'})
      : Uri.https('www.google.com', '/maps/search/', {'api': '1', 'query': '$lat,$lng'}),
  mode: LaunchMode.externalApplication,
);

/// Driving directions from a point to a place name, e.g. the airport.
Future<void> openDirections(double lat, double lng, String destination) => launchUrl(
  defaultTargetPlatform == TargetPlatform.iOS
      ? Uri.https('maps.apple.com', '/', {'saddr': '$lat,$lng', 'daddr': destination, 'dirflg': 'd'})
      : Uri.https('www.google.com', '/maps/dir/', {
          'api': '1',
          'origin': '$lat,$lng',
          'destination': destination,
          'travelmode': 'driving',
        }),
  mode: LaunchMode.externalApplication,
);

/// Static map preview from OpenStreetMap tiles with a pin in the middle. Tap opens the maps app.
// ponytail: raw OSM tiles are fine for light use; move to a tile provider with an API key if traffic grows.
class MapPreview extends StatelessWidget {
  const MapPreview({
    super.key,
    required this.lat,
    required this.lng,
    required this.label,
    this.height = 180,
    this.zoom = 15,
  });
  final double lat;
  final double lng;
  final String label;
  final double height;
  final int zoom;

  static const _tile = 256.0;
  static const _headers = {'User-Agent': 'TuloyApp/1.0 (hotel guest app)'};

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final t = tileXY(lat, lng, zoom);
    return Semantics(
      button: true,
      label: label,
      child: SizedBox(
        height: height,
        child: LayoutBuilder(
          builder: (context, box) {
            final w = box.maxWidth;
            final cx = t.x * _tile, cy = t.y * _tile;
            final x0 = ((cx - w / 2) / _tile).floor(), x1 = ((cx + w / 2) / _tile).floor();
            final y0 = ((cy - height / 2) / _tile).floor(), y1 = ((cy + height / 2) / _tile).floor();
            return GestureDetector(
              onTap: () => openMap(lat, lng, label),
              child: ClipRect(
                child: Stack(
                  children: [
                    Positioned.fill(child: ColoredBox(color: c.surfaceContainerHigh)),
                    for (var tx = x0; tx <= x1; tx++)
                      for (var ty = y0; ty <= y1; ty++)
                        Positioned(
                          left: tx * _tile - cx + w / 2,
                          top: ty * _tile - cy + height / 2,
                          width: _tile,
                          height: _tile,
                          child: Image.network(
                            'https://tile.openstreetmap.org/$zoom/$tx/$ty.png',
                            headers: _headers,
                            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                          ),
                        ),
                    Positioned(
                      left: w / 2 - 20,
                      top: height / 2 - 40,
                      child: Icon(
                        Icons.location_on,
                        size: 40,
                        color: c.primary,
                        shadows: const [Shadow(blurRadius: 6, color: Colors.black26)],
                      ),
                    ),
                    Positioned(
                      right: 6,
                      bottom: 4,
                      child: Text(
                        '© OpenStreetMap',
                        style: TextStyle(fontSize: 10, color: Colors.black.withValues(alpha: .6)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
