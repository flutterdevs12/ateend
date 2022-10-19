import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/attendance_controller.dart';

class AttendanceView extends GetView<AttendanceController> {
  final image;
  final address;
  final _attendaceController = Get.put(AttendanceController());
  AttendanceView({this.image, this.address});
  @override
  Widget build(BuildContext context) {
    _attendaceController.img2 = image;
    _attendaceController.img1 = Image.asset('assets/images/avatar.png');

    return Scaffold(
        appBar: AppBar(
          title: Text('AttendanceView'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GetBuilder<AttendanceController>(builder: (context) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image(
                          height: 150,
                          width: 150,
                          image: _attendaceController.img1.image),
                    );
                  }),
                ],
              ),
              IconButton(
                  onPressed: () async {
                    _attendaceController.pickImage(context, true);
                  },
                  icon: const Icon(
                    Icons.add_a_photo,
                    color: Color.fromARGB(255, 204, 208, 210),
                  )),
              ElevatedButton(
                  onPressed: () {
                    _attendaceController.matchFaces();
                  },
                  child: Text('match')),
              SizedBox(
                height: 40,
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
                              ? Colors.grey
                              : Colors.green,
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
                    _attendaceController.clearQr();
                  },
                  child: Text('Submit')),
              Text(
                  ' ${address.subAdminArea},${address.addressLine}, ${address.featureName},${address.thoroughfare}, ${address.subThoroughfare}')
            ],
          ),
        ));
  }
}
