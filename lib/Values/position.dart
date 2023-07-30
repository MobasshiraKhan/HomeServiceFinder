import 'dart:async';
import 'package:flutter/foundation.dart';
// import 'package:geolocator_apple/geolocator_apple.dart';
// import 'package:geolocator_android/geolocator_android.dart';
import 'package:geolocator/geolocator.dart';

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}

// var locationSettings=defaultTargetPlatform == TargetPlatform.android?
// AndroidSettings(
//   accuracy: LocationAccuracy.high,
//   distanceFilter: 100,
//   forceLocationManager: true,
//   intervalDuration: const Duration(seconds: 1),
//   foregroundNotificationConfig: const ForegroundNotificationConfig(
//     notificationText: "Kormo Mukhi will continue to receive your location even when you aren't using it",
//     notificationTitle: "Running in Background",
//     enableWakeLock: true,
//   )
// ) :
// AppleSettings(
//   accuracy: LocationAccuracy.high,
//   activityType: ActivityType.fitness,
//   distanceFilter: 100,
//   pauseLocationUpdatesAutomatically: true,
//   showBackgroundLocationIndicator: true,
// );

// StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
//     (Position? position) {
//   print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
// });
