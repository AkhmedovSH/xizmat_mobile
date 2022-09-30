import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';


import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../components/simple_app_bar.dart';
import '../../components/widgets.dart';

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  final Completer<GoogleMapController> _controller = Completer();
  dynamic position = {
    'gpsPointX': '',
    'gpsPointY': '',
  };
  List<Marker> marker = [];
  CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(41.311081, 69.240562),
    zoom: 13.0,
  );

  handleTab(LatLng tappedPoint) {
    setState(() {
      position['gpsPointX'] = tappedPoint.latitude.toString();
      position['gpsPointY'] = tappedPoint.longitude.toString();
      marker = [];
      marker.add(
        Marker(markerId: MarkerId(tappedPoint.toString()), position: tappedPoint),
      );
    });
  }

  getPermission() async {
    // if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
    //   print('has permission');
    // } else {
    //   print('else');
    // }
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.deniedForever && permission != LocationPermission.denied) {
      final GoogleMapController controller = await _controller.future;
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if (mounted) {
        setState(() {
          handleTab(LatLng(position.latitude, position.longitude));
          kGooglePlex = CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 13.0,
          );
          controller.animateCamera(CameraUpdate.newCameraPosition(kGooglePlex));
        });
      }
    }
  }

  @override
  void initState() {
    getPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: SimpleAppBar(
            appBar: AppBar(),
            title: 'Выберите место назначения',
            bg: Colors.transparent,
            style: false,
          ),
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: GoogleMap(
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              compassEnabled: false,
              myLocationEnabled: true,
              mapToolbarEnabled: false,
              initialCameraPosition: kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },
              markers: Set.from(marker),
              onTap: handleTab,
            ),
          ),
          floatingActionButton: Container(
            margin: EdgeInsets.only(left: 32),
            child: Button(
              onClick: () {
                setState(() {
                  Get.arguments['stepOrder']['gpsPointX'] = position['gpsPointX'];
                  Get.arguments['stepOrder']['gpsPointY'] = position['gpsPointY'];
                });
                Get.toNamed('/calendar', arguments: {'stepOrder': Get.arguments['stepOrder']});
              },
              text: 'Продолжить',
            ),
          ),
        ),
      ],
    );
  }
}
