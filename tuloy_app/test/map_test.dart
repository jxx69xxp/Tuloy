import 'package:flutter_test/flutter_test.dart';
import 'package:tuloy_app/core/map.dart';

void main() {
  test('tileXY puts lat/lng 0,0 at the centre of the world', () {
    final t = tileXY(0, 0, 1);
    expect(t.x, closeTo(1, 1e-9));
    expect(t.y, closeTo(1, 1e-9));
  });

  test('tileXY for Cebu City at zoom 15 matches the OSM tile', () {
    // OSM tile containing 10.3157, 123.8854 at z15 is 27660/15439.
    final t = tileXY(10.3157, 123.8854, 15);
    expect(t.x.floor(), 27660);
    expect(t.y.floor(), 15439);
  });
}
