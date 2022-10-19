import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_face_api_beta/face_api.dart' as regula;
import 'package:image_picker/image_picker.dart';

class attend extends StatefulWidget {
  dynamic images;
  attend({super.key, this.images});

  @override
  State<attend> createState() => _attendState();
}

var image1 = regula.MatchFacesImage();

var image2 = regula.MatchFacesImage();
dynamic img1;
var img2 = Image.asset('assets/images/avatar.png');
String _similarity = "nil";
String _liveness = "nil";

class _attendState extends State<attend> {
  @override
  Widget build(BuildContext context) {
    img1 = Image.memory(widget.images);
    regula.ImageType.EXTERNAL;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 100),
          width: double.infinity,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // createImage(widget.images, () {
                //   showAlertDialog(context, true);
                // }),
                createImage(img2.image, () {
                  showAlertDialog(context, false);
                }),
                Container(margin: const EdgeInsets.fromLTRB(0, 0, 0, 15)),
                createButton("Match", () {
                  matchFaces();
                }),
                createButton("Liveness", () {
                  liveness();
                }),
                // createButton("Clear", () {
                //   clearResults();
                // }),
                Container(
                    margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Similarity: $_similarity",
                            style: const TextStyle(fontSize: 18)),
                        Container(
                            margin: const EdgeInsets.fromLTRB(20, 0, 0, 0)),
                        Text("Liveness: $_liveness",
                            style: const TextStyle(fontSize: 18))
                      ],
                    ))
              ])),
    );
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {}

  showAlertDialog(BuildContext context, bool first) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(title: const Text("Select option"), actions: [
            // ignore: deprecated_member_use
            TextButton(
                child: const Text("Use gallery"),
                onPressed: () {
                  ImagePicker()
                      .pickImage(source: ImageSource.gallery)
                      .then((value) {
                    return setImage(
                        first,
                        io.File(value!.path).readAsBytesSync(),
                        regula.ImageType.PRINTED);
                  });
                  Navigator.pop(context);
                }),
            // ignore: deprecated_member_use
            TextButton(
                child: const Text("Use camera"),
                onPressed: () {
                  regula.FaceSDK.presentFaceCaptureActivity().then((result) {
                    setImage(
                        first,
                        base64Decode(regula.FaceCaptureResponse.fromJson(
                                json.decode(result))!
                            .image!
                            .bitmap!
                            .replaceAll("\n", "")),
                        regula.ImageType.LIVE);
                  });
                  Navigator.pop(context);
                })
          ]);
        });
  }

  setImage(bool first, imageFile, int type) {
    if (imageFile == null) return;
    setState(() {
      _similarity = "nil";
    });
    if (first) {
      image1.bitmap = base64Encode(imageFile);
      image1.imageType = type;
      setState(() {
        widget.images = Image.memory(imageFile);
        _liveness = "nil";
      });
    } else {
      image2.bitmap = base64Encode(imageFile);
      image2.imageType = type;
      setState(() {
        img2 = Image.memory(imageFile);
      });
    }
  }

  // clearResults() {
  //   setState(() {
  //     img1 = Image.asset('assets/images/download.png');
  //     img2 = Image.asset('assets/images/download.png');
  //     _similarity = "nil";
  //     _liveness = "nil";
  //   });
  //   image1 = regula.MatchFacesImage();
  //   image2 = regula.MatchFacesImage();
  // }

  matchFaces() {
    if (image1.bitmap == null ||
        image1.bitmap == "" ||
        image2.bitmap == null ||
        image2.bitmap == "") return;
    setState(() {
      _similarity = "Processing...";
    });
    var request = regula.MatchFacesRequest();
    request.images = [image1, image2];
    regula.FaceSDK.matchFaces(jsonEncode(request)).then((value) {
      var response = regula.MatchFacesResponse.fromJson(json.decode(value));
      regula.FaceSDK.matchFacesSimilarityThresholdSplit(
              jsonEncode(response!.results), 0.75)
          .then((str) {
        var split = regula.MatchFacesSimilarityThresholdSplit.fromJson(
            json.decode(str));
        setState(() {
          _similarity = split!.matchedFaces.isNotEmpty
              ? ("${(split.matchedFaces[0]!.similarity! * 100).toStringAsFixed(2)}%")
              : "error";
        });
      });
    });
  }

  liveness() {
    regula.FaceSDK.startLiveness().then((value) {
      var result = regula.LivenessResponse.fromJson(json.decode(value));
      setImage(true, base64Decode(result!.bitmap!.replaceAll("\n", "")),
          regula.ImageType.LIVE);
      setState(() {
        _liveness = result.liveness == 0 ? "passed" : "unknown";
      });
    });
  }

  Widget createButton(String text, VoidCallback onPress) {
    return SizedBox(
      // ignore: deprecated_member_use
      width: 250,
      // ignore: deprecated_member_use
      child: TextButton(onPressed: onPress, child: Text(text)),
    );
  }

  Widget createImage(dynamic image, VoidCallback onPress) {
    return Material(
        child: InkWell(
      onTap: onPress,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Image(height: 150, width: 150, image: image),
      ),
    ));
  }
}
