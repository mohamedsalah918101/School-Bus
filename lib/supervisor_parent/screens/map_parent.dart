///
/// AVANCED EXAMPLE:
/// Screen with map and search box on top. When the user selects a place through autocompletion,
/// the screen is moved to the selected location, a path that demonstrates the route is created, and a "start route"
/// box slides in to the screen.
///

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';


import 'package:permission_handler/permission_handler.dart';

class MapParentScreen extends StatefulWidget {
  MapParentScreen({Key? key, this.address}) : super(key: key);
  var address;

  @override
  State<MapParentScreen> createState() => MapParentScreenState();
}

class MapParentScreenState extends State<MapParentScreen>
    with SingleTickerProviderStateMixin {
  late PickResult selectedPlace;
  static LatLng kInitialPosition = LatLng(
      25.9411945,50.9172208); // London , arbitary value

  late GoogleMapController _controller;

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller = controller;
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    _controller.setMapStyle(value);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setDummyInitialLocation();

  }

  setInitialLocation() {
    //   kInitialPosition = LatLng(widget.address.lat, widget.address.lang);
    setState(() {});
  }

  setDummyInitialLocation() {
    kInitialPosition = LatLng(
        26.201000,50.606998); // London , arbitary value
    setState(() {});
  }

  onTapPickHere(selectedPlace) async {
    Navigator.pop(context, selectedPlace!.formattedAddress!+"/"+selectedPlace!.geometry.location.lat.toString()+","+selectedPlace!.geometry.location.lng.toString());
    // print(selectedPlace!.geometry.location.lat.toString()+"--"+selectedPlace!.geometry.location.lng.toString());
    //
    // print(selectedPlace!.url!);


    // var addressUpdateLocationResponse = await AddressRepository().getAddressUpdateLocationResponse(
    //     widget.address.id,
    //     selectedPlace.geometry.location.lat,
    //     selectedPlace.geometry.location.lng
    // );
    //
    // if (addressUpdateLocationResponse.result == false) {
    //   ToastComponent.showDialog(addressUpdateLocationResponse.message, context,
    //       gravity: Toast.center, duration: Toast.lengthLong);
    //   return;
    // }
    //
    // ToastComponent.showDialog(addressUpdateLocationResponse.message, context,
    //     gravity: Toast.center, duration: Toast.lengthLong);

  }
  // void setPermissions() async{
  //   Map<PermissionGroup, PermissionStatus> permissions =
  //   await PermissionHandler().requestPermissions([PermissionGroup.location]);
  // }

  @override
  Widget build(BuildContext context) {

    return PlacePicker(
      hintText: 'Home location',
      apiKey: OtherConfig.GOOGLE_MAP_API_KEY,
      initialPosition: kInitialPosition,
      useCurrentLocation: false,
      //selectInitialPosition: true,
      onMapCreated: _onMapCreated,
      //initialMapType: MapType.terrain,

      //usePlaceDetailSearch: true,
      onPlacePicked: (result) {
        selectedPlace = result;
        Navigator.of(context).pop();
        setState(() {});
      },
      //forceSearchOnZoomChanged: true,
      //automaticallyImplyAppBarLeading: false,
      //autocompleteLanguage: "ko",
      //region: 'au',
      //selectInitialPosition: true,
      selectedPlaceWidgetBuilder:
          (_, selectedPlace, state, isSearchBarFocused) {
        print("state: $state, isSearchBarFocused: $isSearchBarFocused");
        print(selectedPlace.toString());
        print("-------------");
        /*
        if(!isSearchBarFocused && state != SearchingState.Searching){
          ToastComponent.showDialog("Hello", context,
              gravity: Toast.center, duration: Toast.lengthLong);
        }*/
        return isSearchBarFocused
            ? Container()
            : FloatingCard(
          height: 50,
          bottomPosition: 120.0,
          // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
          leftPosition: 0.0,
          rightPosition: 0.0,
          width: 500,
          borderRadius: const BorderRadius.only(
            topLeft: const Radius.circular(8.0),
            bottomLeft: const Radius.circular(8.0),
            topRight: const Radius.circular(8.0),
            bottomRight: const Radius.circular(8.0),
          ),
          child: state == SearchingState.Searching
              ? Center(
              child: Text(
                'map location calculating',
                style: TextStyle(color:Colors.grey),
              ))
              : Padding(
            padding: const EdgeInsets.only(left: 3,right: 3),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(

                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 2.0, right: 2.0),
                        child: Text(
                          selectedPlace!.formattedAddress!,
                          maxLines: 4,
                          style:
                          TextStyle(color:Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: const BorderRadius.only(
                            topLeft: const Radius.circular(4.0),
                            bottomLeft: const Radius.circular(4.0),
                            topRight: const Radius.circular(4.0),
                            bottomRight: const Radius.circular(4.0),
                          )),
                    ),

                    child: Text(

                      'pick here',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
                      //            this will override default 'Select here' Button.
                      /*print("do something with [selectedPlace] data");
                                  print(selectedPlace.formattedAddress);
                                  print(selectedPlace.geometry.location.lat);
                                  print(selectedPlace.geometry.location.lng);*/

                      onTapPickHere(selectedPlace);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
      pinBuilder: (context, state) {
        if (state == PinState.Idle) {
          return Image.asset(
            'assets/images/delivery_map_icon.png',
            height: 60,
          );
        } else {
          return Image.asset(
            'assets/images/delivery_map_icon.png',
            height: 80,
          );
        }
      },
    );
  }

}
class OtherConfig {
  static const bool USE_PUSH_NOTIFICATION = true;
  static const bool USE_GOOGLE_MAP = true;
  static const String GOOGLE_MAP_API_KEY =
      "AIzaSyAk-SGMMrKO6ZawG4OzaCSmJK5zAduv1NA";
}