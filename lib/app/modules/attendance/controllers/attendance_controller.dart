import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_geocoder/geocoder.dart';

import 'package:get/get.dart';
import 'package:flutter_face_api_beta/face_api.dart' as regula;
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;

import 'package:location/location.dart';

class AttendanceController extends GetxController {
  //TODO: Implement AttendanceController

  final count = 0.obs;

  @override
  void onClose() {}
  void increment() => count.value++;
  @override
  void onInit() {
    super.onInit();
    getUserLocation();
  }
  // File? image;
  // String img = '';
  // pickimage() async {
  //   final pimage = await ImagePicker().pickImage(source: ImageSource.camera);
  //   if (pimage == null) {
  //     return;
  //   } else {
  //     image = File(pimage.path);

  //     final bytes = File(pimage.path).readAsBytesSync();
  //     img = base64Encode(bytes);
  //   }
  //   update();
  // }
  String _similarity = "nil";
  var img1;
  var image1 = regula.MatchFacesImage();
  var image2 = regula.MatchFacesImage();
  var img2;
  setImage(bool first, imageFile, int type) {
    if (imageFile == null) return;

    _similarity = "nil";

    if (first) {
      image1.bitmap = base64Encode(imageFile);
      image1.imageType = type;

      img1 = Image.memory(imageFile);
      update();
      // _liveness = "nil";
    } else {
      image2.bitmap = base64Encode(img2);
      image2.imageType = type;
      _similarity = "nil";
      update();
    }

    //  else {
    //   image2.bitmap = base64Encode(imageFile);
    //   image2.imageType = type;

    //   img2 = Image.memory(imageFile);
    //   update();
    // }
  }

  Widget createImage(image, VoidCallback onPress) {
    return Material(
        child: InkWell(
      onTap: onPress,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Image(height: 150, width: 150, image: image),
      ),
    ));
  }

  pickImage(BuildContext context, bool first) async {
    // await regula.FaceSDK.presentFaceCaptureActivity().then((result) {
    //   setImage(
    //       first,
    //       base64Decode(regula.FaceCaptureResponse.fromJson(json.decode(result))!
    //           .image!
    //           .bitmap!
    //           .replaceAll("\n", "")),
    //       regula.ImageType.LIVE);
    // });
    ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
      return setImage(first, io.File(value!.path).readAsBytesSync(),
          regula.ImageType.PRINTED);
    });
    matchFaces();
    log(_similarity.toString());
  }

  matchFaces() {
    if (image1.bitmap == null ||
        image1.bitmap == "" ||
        image2.bitmap == null ||
        image2.bitmap == "") return;
    // image2 = img2;

    _similarity = "Processing...";
    update();
    var request = regula.MatchFacesRequest();
    request.images = [image1, image2];
    regula.FaceSDK.matchFaces(jsonEncode(request)).then((value) {
      var response = regula.MatchFacesResponse.fromJson(json.decode(value));
      regula.FaceSDK.matchFacesSimilarityThresholdSplit(
              jsonEncode(response!.results), 0.75)
          .then((str) {
        var split = regula.MatchFacesSimilarityThresholdSplit.fromJson(
            json.decode(str));

        _similarity = split!.matchedFaces.isNotEmpty
            ? ("${(split.matchedFaces[0]!.similarity! * 100).toStringAsFixed(2)}%")
            : "error";
      });
      log(_similarity);
      update();
    });
  }

  String scannedQrcode = '';
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

  getUserLocation() async {
    //call this async method from whereever you need

    LocationData? myLocation;
    String error;
    Location location = Location();
    try {
      myLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
      }
      myLocation = null;
    }
    var currentLocation = myLocation;
    final coordinates = Coordinates(myLocation!.latitude, myLocation.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    log(first.toString());
    log(first.locality.toString());
    log(' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    return first;
  }
}
