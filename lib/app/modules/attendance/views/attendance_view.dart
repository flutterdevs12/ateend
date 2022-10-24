import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/attendance_controller.dart';

class AttendanceView extends GetView<AttendanceController> {
  final image;
  final address;
  final allData;
  final _attendaceController = Get.put(AttendanceController());
  AttendanceView({this.image, this.address, this.allData});
  @override
  Widget build(BuildContext context) {
    _attendaceController.img1 = Image.asset('assets/images/avatar.png');
    var newImage = Base64Decoder().convert(image);

    dynamic req;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Attendance'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GetBuilder<AttendanceController>(builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(60),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/avatar.png'),
                          ),
                        ),
                        child: _attendaceController.img.trim().isNotEmpty
                            ? CircleAvatar(
                                backgroundImage: MemoryImage(
                                  const Base64Decoder()
                                      .convert(_attendaceController.img),
                                ),
                              )
                            : Container(),
                      ),
                    );
                  }),
                ],
              ),
              IconButton(
                  onPressed: () async {
                    _attendaceController.pickimage();
                  },
                  icon: const Icon(
                    Icons.add_a_photo,
                    color: Color.fromARGB(255, 204, 208, 210),
                  )),
              // ElevatedButton(
              //     onPressed: () async {
              //       await _attendaceController.checkImages(image);
              //     },
              //     child: Text('match')),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: InkWell(onTap: () async {
                  await _attendaceController.checkImages(image);
                }, child:
                    GetBuilder<AttendanceController>(builder: (sscontext) {
                  return Card(
                    elevation: 20,
                    child: ListTile(
                      title: Text(
                        'Check-Image',
                        style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold),
                      ),
                      leading:
                          GetBuilder<AttendanceController>(builder: (dcontext) {
                        return Icon(Icons.image);
                      }),
                      trailing: Icon(
                        Icons.check,
                        color: (_attendaceController.col1),
                        size: 30,
                      ),
                    ),
                  );
                })),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                  onTap: () async {
                    await _attendaceController.scanQR();
                  },
                  child: GetBuilder<AttendanceController>(builder: (context) {
                    return Card(
                      elevation: 20,
                      child: ListTile(
                        title: Text(
                          'Scan Qr',
                          style:
                              GoogleFonts.ubuntu(fontWeight: FontWeight.bold),
                        ),
                        leading: GetBuilder<AttendanceController>(
                            builder: (dcontext) {
                          return Icon(Icons.qr_code_scanner);
                        }),
                        trailing: Icon(
                          Icons.check,
                          color: ((_attendaceController.scannedQrcode ==
                                      '-1') ||
                                  (_attendaceController.scannedQrcode == ''))
                              ? Color.fromARGB(255, 93, 92, 92)
                              : Color.fromARGB(255, 15, 211, 35),
                          size: 30,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 20),
              GetBuilder<AttendanceController>(builder: (context) {
                return Text(
                    'qr value is : ${_attendaceController.scannedQrcode}');
              }),
              ElevatedButton(
                  onPressed: () {
                    _attendaceController.takeAttendandce(allData);
                  },
                  child: Text('Submit')),
              // Text(
              //     ' ${address.subAdminArea},${address.addressLine}, ${address.featureName},${address.thoroughfare}, ${address.subThoroughfare}'),
              // SizedBox(height: 20),
              // GetBuilder<AttendanceController>(builder: (codfntext) {
              //   return _attendaceController.latestResponse2 != null
              //       ? Text(_attendaceController
              //           .latestResponse2!.data!.resultMessage
              //           .toString())
              //       : Text('no data');
              // }),
              // SizedBox(height: 20),
              // GetBuilder<AttendanceController>(builder: (contexfdgt) {
              //   return _attendaceController.latestResponse2 != null
              //       ? Text(_attendaceController.latestResponse2!.hasError
              //           .toString())
              //       : Text('no data');
              // }),
            ],
          ),
        ));
  }
}
