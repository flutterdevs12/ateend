import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceModel {
  String? image;
  String? uid;
  String? email;
  String? name;
  String? qr;
  String? location;
  String? number;
  Timestamp? s;
  AttendanceModel(
      {this.image,
      this.uid,
      this.email,
      this.name,
      this.number,
      this.s,
      this.location,
      this.qr});

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'uid': uid,
      'email': email,
      'Name': name,
      'Number': number,
      'Taken-At': s,
      'location': location,
      'qr-data': qr,
    };
  }
}
