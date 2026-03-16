import 'package:geolocator/geolocator.dart';

class GeolocatorService {

  Future<Position> geolocate() async {

    return await Geolocator.getCurrentPosition();
  }
}
