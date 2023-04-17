import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:let_me_check/Model/StudentModel.dart';
import 'package:let_me_check/Services/institute/student.dart';
import 'package:let_me_check/bloc/Parents_bloc/get_bus_location_bloc.dart';
import 'package:location/location.dart';

import '../../Services/institute/bus.dart';

class tracklocation extends StatefulWidget {
  const tracklocation({Key? key}) : super(key: key);

  @override
  State<tracklocation> createState() => _tracklocationState();
}

class _tracklocationState extends State<tracklocation> {
  Bus _bus = Bus();
  Student _student = Student();
  GetBusLocationBloc _getBusLocationBloc = GetBusLocationBloc();
  Timer? _timer;
  Set<Marker> _marker = {};
  var bususerid;
  GeoPoint? markerlocation;
  CameraPosition? initialpositon;
  GoogleMapController? _controller;

  // @override
  // void initState() {
  //   Location location = Location();
  //   location.onLocationChanged.listen((event) {
  //     print('location update ${event.latitude}');
  //     _controller?.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(event.latitude!,event.longitude!),zoom: 15)));
  //   });
  //   super.initState();
  // }

  @override
  void didChangeDependencies() async {
    bususerid = await ModalRoute.of(context)?.settings.arguments;
    markerlocation = await _bus.getlocation(bususerid.toString());
    _getBusLocationBloc.add(GetBusLocatioEvent(bususerid.toString()));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Track_Bus_Location").tr(),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(1),
        child: BlocBuilder<GetBusLocationBloc, buslocationState>(
          bloc: _getBusLocationBloc,
          builder: (context, state) {
            if (state is GetBusLocationState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is permissiondenied) {
              return Center(
                child: Text("Location_permission_not_Granted".tr()),
              );
            } else if (state is BusLocationGainedState) {
              _timer = Timer(Duration(milliseconds: 10), () async {
                markerlocation = await _bus.getlocation(state.bususerid);
                _marker = setmarker(markerlocation!);
                initialpositon = setcameraposition(markerlocation!);
                _controller?.moveCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: LatLng(markerlocation!.latitude,
                            markerlocation!.longitude),
                        zoom: 16)));
                print(
                    "location ** ${markerlocation!.latitude}  ${markerlocation!.longitude}");
                setState(() {});
              });
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width * 0.9,
                child: GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    setState(() {
                      _controller = controller;
                    });
                  },
                  initialCameraPosition: CameraPosition(
                      target: LatLng(
                          markerlocation!.latitude, markerlocation!.longitude),
                      zoom: 14.8),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  compassEnabled: true,
                  mapType: MapType.hybrid,
                  markers: _marker,
                ),
              );
            } else if (state is BusLocationLossState) {
              return Center(child: Text(state.error!));
            } else {
              return Text("Error").tr();
            }
          },
        ),
      ),
      floatingActionButton: Container(
          padding: EdgeInsets.only(left: 30),
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            onPressed: () {
              _controller?.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: LatLng(
                          markerlocation!.latitude, markerlocation!.longitude),
                      zoom: 16)));
            },
            isExtended: true,
            child: Icon(Icons.location_searching_outlined),
          )),
    );
  }

  setcameraposition(GeoPoint markerlocation) {
    CameraPosition cameraPosition = CameraPosition(
        target: LatLng(markerlocation.latitude, markerlocation.longitude),
        zoom: 14.8);
    return cameraPosition;
  }

  setmarker(GeoPoint location) {
    Set<Marker> _marker = {};
    _marker.add(Marker(
      markerId: MarkerId('Bus'),
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(title: 'Bus Location'),
      position: LatLng(location.latitude, location.longitude),
    ));
    return _marker;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller?.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
