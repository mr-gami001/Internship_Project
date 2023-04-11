
import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:let_me_check/Services/busservice/Bus_breakdown.dart';
import 'package:let_me_check/Services/institute/bus.dart';
import 'package:let_me_check/Services/notificationservices.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Helper/Theme_Helper.dart';
import '../../Services/loginservice.dart';

class home_Bus extends StatefulWidget {
  const home_Bus({Key? key}) : super(key: key);

  @override
  State<home_Bus> createState() => _home_BusState();
}

class _home_BusState extends State<home_Bus> {

  Bus bus = Bus();
  Bus_breakdown bus_breakdown = Bus_breakdown();

  String sharing = 'Start Sharing Location';

  Timer? timer;

  GeoPoint? lochistory;

  NotificationServices notificationServices = NotificationServices();

  late SharedPreferences logindata;

  String? bususerid;

  GoogleMapController? _controller;
  LatLng? currentlocation;
  Icon startlocationicon = Icon(Icons.location_on_sharp,color: Colors.black,);



  rememberme()async{
    logindata = await SharedPreferences.getInstance();
    Map<String, dynamic> userdata = await cheking();
    bususerid = userdata['userid'];



  }

  @override
  void initState() {
    rememberme();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    bool isdark = (Theme.of(context).brightness == Brightness.dark);

    return Scaffold(

      drawer: Drawer(
        child: FutureBuilder(
          future: bus.fetchsbusdata(bususerid.toString()),
          builder: (context,snapshot){
            if(snapshot.hasData){
              return ListView(
                children: [

                  Container(
                    height: MediaQuery.of(context).size.height*0.2,
                    margin: EdgeInsets.only(top: 10),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: ClipOval(child: Image.network('https://picsum.photos/250',alignment: Alignment.center,filterQuality: FilterQuality.high,)),
                    ),
                  ),

                  Divider(
                    color: Colors.black54,
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,
                  ),

                  Container(
                    margin: EdgeInsets.fromLTRB(10,10,10,0),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Image.network('https://img.icons8.com/ios-glyphs/30/000000/bus.png'),
                      title: Text("Bus No.: " +snapshot.data!.busno.toString(),style: TextStyle(fontWeight: FontWeight.w900),textAlign: TextAlign.center,),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.fromLTRB(10,10,10,0),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Image.network('https://img.icons8.com/material-sharp/30/000000/id-verified.png'),
                      title: Text("User Id : "+snapshot.data!.userid.toString(),style: TextStyle(fontWeight: FontWeight.w900),textAlign: TextAlign.center,),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.fromLTRB(10, height*0.45, 10, 0),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text("Log Out",style: TextStyle(fontWeight: FontWeight.w900),textAlign: TextAlign.center,),
                      trailing: Icon(Icons.logout,color: Colors.black,),
                      onTap: ()async {
                        await logindata.clear();
                        await Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                      },
                    ),
                  ),

                ],
              );
            }

            else if(snapshot.hasError){
              return Center(child: Text(snapshot.error.toString()),);
            }

            else{
              return Center(child: CircularProgressIndicator(),);
            }

          },
        ),
      ),

      appBar: AppBar(
        title: Text('Home Bus'),
        centerTitle: true,

        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).pushNamed('/notificationhistory');
          }, icon: Icon(CupertinoIcons.bell_fill)),

            IconButton(onPressed: ()async{
              currentTheme.toggleTheme();
            }, icon: isdark ? Icon(Icons.dark_mode_rounded) : Icon(Icons.light_mode))
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              margin: EdgeInsets.all(height*0.01),
              height: height*0.67,
              child: FutureBuilder(
                future: Location().getLocation(),
                builder: (context , snapshot ){

                  if(snapshot.hasData && snapshot.data != GeoPoint(0,0)){

                    double? latitude = snapshot.data?.latitude;
                    double? longitude = snapshot.data?.longitude;
                    LatLng currentpos = LatLng(latitude!, longitude!);

                    timer = Timer(Duration(milliseconds: 20), () {
                      Location.instance.onLocationChanged.listen((LocationData locationData) async{
                        await _controller?.moveCamera(
                            CameraUpdate.newCameraPosition(
                                CameraPosition(
                                    target: LatLng(locationData.latitude! , locationData.longitude!),
                                    zoom: 14
                                )
                            )
                        );
                        //print('position changed');
                        setState(() {

                        });
                      });
                    });

                    return GoogleMap(
                      onMapCreated: (GoogleMapController controller){
                        setState(() {
                          _controller = controller;
                        });
                      },
                        initialCameraPosition: CameraPosition(
                          target: currentpos,
                          zoom: 14,
                        ),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      mapToolbarEnabled: true,
                      mapType: MapType.hybrid,

                    );
                  }
                  else{
                    return Center(child: CircularProgressIndicator(),);
                  }

                },
              ),
            ),

            Container(
              margin: EdgeInsets.fromLTRB(10,height*0.01,10,0),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: startlocationicon,
                title: Text('$sharing',style: TextStyle(fontWeight: FontWeight.w900),textAlign: TextAlign.center,),
                onTap: (){
                  setState(()  {

                    if(sharing.startsWith('Start')){

                      timer = Timer.periodic(Duration(seconds: 3), (t) async {
                        lochistory = await bus.startsharingloc(bususerid!);
                        print("Start : ${lochistory!.latitude}  ${lochistory!.longitude}");
                      });
                      // while(sharing.startsWith('Start')){
                      // var check =  bus.startsharingloc(snapshot.data!.userid.toString());
                      // print("Start : "+check.toString());
                      // }
                      sharing = 'Stop Sharing Location';
                      startlocationicon = Icon(Icons.location_off_sharp,color: Colors.black,);
                      bus_breakdown.upload_breakdown_message(bususerid!, 'Bus Started', 'Bus No. : ${bususerid.toString()} Started');
                      notificationServices.sendnotification('Bus Started', 'Bus No. : ${bususerid.toString()} Started', bususerid!);
                      notificationServices.sendnotification('Bus Started', 'Bus No. : ${bususerid.toString()} Started', 'Institute');
                      // notificationServices.sendnotification('Bus Started', 'Bus No. : ${bususerid.toString()} Started',snapshot.data!.userid.toString());

                      setState(() {});
                    }
                    else{
                      var stop = bus.stopsharingloc(bususerid!,lochistory!);
                      timer?.cancel();
                      print('Stop : '+stop.toString());
                      sharing = 'Start Sharing Location';
                      startlocationicon = Icon(Icons.location_on_sharp,color: Colors.black,);
                      bus_breakdown.upload_breakdown_message(bususerid!, 'Bus Stoped', 'Bus No. : ${bususerid.toString()} Stoped');
                      notificationServices.sendnotification('Bus Stoped', 'Bus No. : ${bususerid.toString()} Stoped', bususerid!);
                      notificationServices.sendnotification('Bus Stoped', 'Bus No. : ${bususerid.toString()} Stoped', 'Institute');
                    }
                    // await Navigator.pushNamed(context, '/busstartmap',arguments: snapshot.data?.userid.toString());

                  });
                },
              ),
            ),

            Container(
              margin: EdgeInsets.fromLTRB(10,height*0.02,10,0),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text("Break Down",style: TextStyle(fontWeight: FontWeight.w900),textAlign: TextAlign.center,),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: ()async{
                  await Navigator.pushNamed(context, '/breakdown', arguments: bususerid!);
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}