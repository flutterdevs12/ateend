// To parse this JSON data, do
//
//     final imageModel = imageModelFromJson(jsonString);

import 'dart:convert';

ImageModel imageModelFromJson(String str) =>
    ImageModel.fromJson(json.decode(str));

String imageModelToJson(ImageModel data) => json.encode(data.toJson());

class ImageModel {
  ImageModel({
    required this.image1Base64,
    required this.image2Base64,
  });

  String image1Base64;
  String image2Base64;

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        image1Base64: json["image1Base64"],
        image2Base64: json["image2Base64"],
      );

  Map<String, dynamic> toJson() => {
        "image1Base64": image1Base64,
        "image2Base64": image2Base64,
      };
}
