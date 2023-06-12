import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class MapHomeNotice{
  GoogleMapController? mapController;

  onMapCreated(GoogleMapController controller){
    mapController = controller;
  }
}
