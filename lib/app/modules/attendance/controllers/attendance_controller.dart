import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facial_app_firebase/app/data/attend3nce_model.dart';
import 'package:facial_app_firebase/app/data/image_model.dart';
import 'package:facial_app_firebase/app/data/response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class AttendanceController extends GetxController {
  //TODO: Implement AttendanceController
  dynamic img1;
  Color col1 = Color.fromARGB(255, 93, 92, 92);
  final count = 0.obs;

  @override
  void onClose() {}
  void increment() => count.value++;
  @override
  void onInit() {
    super.onInit();
    getLocation();
  }

  File? image;
  String img = '';
  pickimage() async {
    final pimage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pimage == null) {
      return;
    } else {
      image = File(pimage.path);

      final bytes = File(pimage.path).readAsBytesSync();
      img = base64Encode(bytes);
    }
    update();
  }

  String scannedQrcode = 'sdfg';
  clearQr() {
    scannedQrcode = '';
    update();
  }

  Future<void> scanQR() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      scannedQrcode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(scannedQrcode);
    } on PlatformException {
      scannedQrcode = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // if (!mounted) return;

    update();
  }

  // getUserLocation() async {
  //   //call this async method from whereever you need

  //   LocationData? myLocation;
  //   String error;
  //   Location location = Location();
  //   try {
  //     myLocation = await location.getLocation();
  //   } on PlatformException catch (e) {
  //     if (e.code == 'PERMISSION_DENIED') {
  //       error = 'please grant permission';
  //       print(error);
  //     }
  //     if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
  //       error = 'permission denied- please enable it from app settings';
  //       print(error);
  //     }
  //     myLocation = null;
  //   }
  //   var currentLocation = myLocation;
  //   final coordinates = Coordinates(myLocation!.latitude, myLocation.longitude);
  //   var addresses =
  //       await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //   var first = addresses.first;
  //   log(first.toString());
  //   log(first.locality.toString());
  //   log(' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
  //   return first;
  // }
  LocationData? locationData;
  getLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    log(locationData.toString());
  }

  var baseUrl = 'https://face-verification2.p.rapidapi.com/faceverification';
  List<ResponseModel> latestResponse = [];
  ResponseModel? latestResponse2;

  Future<void> checkImages(String img2) async {
    try {
      final ImageModel imageModel = ImageModel(
          image1Base64: 'data:image/jpeg;base64,$img',
          image2Base64: 'data:image/jpeg;base64,$img2');
      var request = await http.post(
          Uri.parse(
              'https://face-verification2.p.rapidapi.com/faceverification'),
          body: imageModel.toJson(),
          headers: {
            "X-RapidAPI-Key":
                "1e4980514fmshb613bff4e0ca23ap187e06jsn90b913b01a8c",
            // "X-RapidAPI-Host": "face-verification2.p.rapidapi.com",
          });

      dynamic result = jsonDecode(request.body);
      log(result.toString());
      latestResponse2 = responseModelFromJson(request.body);
      latestResponse.add(latestResponse2!);
      log(latestResponse2!.data.toString());
    } catch (e) {
      log(e.toString());
    }
    if (latestResponse2!.data!.similarPercent != 0) {
      col1 = Color.fromARGB(255, 15, 211, 35);
    } else {
      Get.snackbar("Error", 'Photo does not match',
          backgroundColor: Color.fromARGB(255, 211, 15, 15));
      col1 = Color.fromARGB(255, 93, 92, 92);
    }
    update();
  }

  takeAttendandce(data) async {
    String loc = (locationData!.latitude!.toString() +
        locationData!.longitude.toString());
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final AttendanceModel attendanceModel = AttendanceModel();
    attendanceModel.email = data['email'];
    attendanceModel.image = img;
    attendanceModel.location = loc;
    attendanceModel.name = data['Name'];
    attendanceModel.number = data['Number'];
    attendanceModel.uid = data['uid'];
    attendanceModel.qr = scannedQrcode;
    attendanceModel.s = Timestamp.now();
    await firebaseFirestore
        .collection("Attendence")
        .doc(data['uid'])
        .set(attendanceModel.toMap());
    print('data uploaded');
    Get.snackbar('Alert', 'Attendence Taken Succesfully',
        snackPosition: SnackPosition.TOP, backgroundColor: Colors.green);
  }
}
