import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpModelView {
  String? image;
  String? uid;
  String? email;
  String? name;

  String? number;
  Timestamp? s;
  SignUpModelView(
      {this.image, this.uid, this.email, this.name, this.number, this.s});

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'uid': uid,
      'email': email,
      'Name': name,
      'Number': number,
      'created At': s
    };
  }
}
















  // factory DataModel.fromMap(map) {
  //   return DataModel(
  //     image: map['image'],
  //     uid: map['uid'],
  //     email: map['email'],
  //     Name: map['Name'],
  //     age: map['age'],
  //     Number: map['Number'],
  //   );
  // }