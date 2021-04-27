import 'package:final_project/categoary/Item.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';

class GetLocation extends StatefulWidget {
  GetLocation({this.item});
  Item item;
  @override
  _GetLocationState createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  Future<String> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    Position position;
    Address adds;
    double lat;
    double lon;
    String location;

// Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    print(permission);
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
// Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

// When we reach here, permissions are granted and we can
// continue accessing the position of the device.
    position = await Geolocator.getCurrentPosition();
    lat = position.latitude;
    lon = position.longitude;
    adds = await GeoCode().reverseGeocoding(latitude: lat, longitude: lon);
    location = adds.city;
    print(location);
    return location;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.black54)),
      onPressed: () {
        _determinePosition().then((String local) {
          setState(() {
            widget.item.location = local;
            print(local);
          });
        });
      },
      child: Text('Set your location'),
    );
  }
}
