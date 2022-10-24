// To parse this JSON data, do
//
//     final responseModel = responseModelFromJson(jsonString);

import 'dart:convert';

ResponseModel responseModelFromJson(String str) =>
    ResponseModel.fromJson(json.decode(str));

String responseModelToJson(ResponseModel data) => json.encode(data.toJson());

class ResponseModel {
  ResponseModel({
    required this.statusCode,
    required this.statusMessage,
    required this.hasError,
    required this.data,
    required this.imageSpecs,
  });

  int statusCode;
  String statusMessage;
  bool hasError;
  Data? data;
  List<ImageSpec>? imageSpecs;

  factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
        statusCode: json["statusCode"],
        statusMessage: json["statusMessage"],
        hasError: json["hasError"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        imageSpecs: json["imageSpecs"] == null
            ? null
            : List<ImageSpec>.from(
                json["imageSpecs"].map((x) => ImageSpec.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "statusMessage": statusMessage,
        "hasError": hasError,
        "data": data == null ? null : data!.toJson(),
        "imageSpecs": imageSpecs == null
            ? null
            : List<dynamic>.from(imageSpecs!.map((x) => x.toJson())),
      };
}

class Data {
  Data({
    required this.resultIndex,
    required this.resultMessage,
    required this.similarPercent,
  });

  int resultIndex;
  String resultMessage;
  double similarPercent;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        resultIndex: json["resultIndex"],
        resultMessage: json["resultMessage"],
        similarPercent: json["similarPercent"] == null
            ? null
            : json["similarPercent"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "resultIndex": resultIndex,
        "resultMessage": resultMessage,
        "similarPercent": similarPercent,
      };
}

class ImageSpec {
  ImageSpec({
    required this.leftTop,
    required this.rightTop,
    required this.rightBottom,
    required this.leftBottom,
  });

  LeftBottom? leftTop;
  LeftBottom? rightTop;
  LeftBottom? rightBottom;
  LeftBottom? leftBottom;

  factory ImageSpec.fromJson(Map<String, dynamic> json) => ImageSpec(
        leftTop: json["leftTop"] == null
            ? null
            : LeftBottom.fromJson(json["leftTop"]),
        rightTop: json["rightTop"] == null
            ? null
            : LeftBottom.fromJson(json["rightTop"]),
        rightBottom: json["rightBottom"] == null
            ? null
            : LeftBottom.fromJson(json["rightBottom"]),
        leftBottom: json["leftBottom"] == null
            ? null
            : LeftBottom.fromJson(json["leftBottom"]),
      );

  Map<String, dynamic> toJson() => {
        "leftTop": leftTop == null ? null : leftTop!.toJson(),
        "rightTop": rightTop == null ? null : rightTop!.toJson(),
        "rightBottom": rightBottom == null ? null : rightBottom!.toJson(),
        "leftBottom": leftBottom == null ? null : leftBottom!.toJson(),
      };
}

class LeftBottom {
  LeftBottom({
    required this.isEmpty,
    required this.x,
    required this.y,
  });

  bool isEmpty;
  int x;
  int y;

  factory LeftBottom.fromJson(Map<String, dynamic> json) => LeftBottom(
        isEmpty: json["isEmpty"],
        x: json["x"],
        y: json["y"],
      );

  Map<String, dynamic> toJson() => {
        "isEmpty": isEmpty,
        "x": x,
        "y": y,
      };
}
