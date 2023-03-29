import 'package:app_tim_kiem_viec_lam/core/providers/postProvider.dart';
import 'package:flutter/material.dart';

import 'package:hexcolor/hexcolor.dart';

import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:provider/provider.dart';
import "package:geolocator/geolocator.dart";

class OpenStreetMap extends StatefulWidget {
  const OpenStreetMap(
      {super.key,
      required this.isSeen,
      this.latitude,
      this.longitude,
      this.isBack});
  final bool isSeen;
  final double? latitude;
  final double? longitude;
  final bool? isBack;
  @override
  State<OpenStreetMap> createState() => _OpenStreetMapState();
}

class _OpenStreetMapState extends State<OpenStreetMap> {
  late PostProvider jobProvider;
  Position? _position;
  bool isLoaded = false;
  void initState() {
    super.initState();
    jobProvider = Provider.of<PostProvider>(context, listen: false);
    getCurrentPosition();

    // getCurrentPosition();
  }

  void getCurrentPosition() async {
    await Geolocator.requestPermission();
    Geolocator.getCurrentPosition().then((value) => setState(() {
          _position = value;
          isLoaded = true;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PostProvider>(
        builder: (context, jobProvider, _) {
          return isLoaded == true
              ? widget.isSeen == false
                  ? OpenStreetMapSearchAndPick(
                      locationPinIconColor: HexColor("#BB2649"),
                      center:
                          LatLong(_position!.latitude, _position!.longitude),
                      buttonColor: HexColor("#BB2649"),
                      buttonText: 'Lấy địa chỉ',
                      onPicked: (pickedData) {
                        jobProvider.setAddress = pickedData.address;
                        jobProvider.setLongtitude =
                            pickedData.latLong.longitude;
                        jobProvider.setLatitude = pickedData.latLong.latitude;
                        Navigator.of(context).pop();
                      })
                  : (widget.isBack == true
                      ? OpenStreetMapSearchAndPick(
                          center: LatLong(widget.latitude!.toDouble(),
                              widget.longitude!.toDouble()),
                          buttonColor: HexColor("#BB2649"),
                          locationPinIconColor: HexColor("#BB2649"),
                          buttonText: 'Trở về',
                          onPicked: (pickedData) {
                            Navigator.of(context).pop();
                          })
                      : OpenStreetMapSearchAndPick(
                          center: LatLong(widget.latitude!.toDouble(),
                              widget.longitude!.toDouble()),
                          buttonColor: HexColor("#BB2649").withOpacity(0),
                          buttonText: '',
                          locationPinIconColor: HexColor("#BB2649"),
                          onPicked: (pickedData) {}))
              : Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(child: CircularProgressIndicator()));
          // Column(
          //   children: [
          //     ElevatedButton(
          //         onPressed: () async {}, child: Text("Get location")),
          //     Text(
          //         "latitude: ${_position?.latitude},longtitude : ${_position?.longitude}")
          //   ],
          // );
        },
      ),
    );
  }
}
