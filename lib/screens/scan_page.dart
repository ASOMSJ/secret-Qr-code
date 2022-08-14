import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';

import '../service/crypt.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({Key? key}) : super(key: key);

  @override
  _ScanQRState createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> with TickerProviderStateMixin {
  late final AnimationController _animationController =
      AnimationController(vsync: this, duration: const Duration(seconds: 1))
        ..repeat(reverse: true);
  late final Animation<Offset> _animation =
      Tween<Offset>(begin: const Offset(0, -38), end: const Offset(0, 38))
          .animate(CurvedAnimation(
              parent: _animationController, curve: Curves.easeInOutCubic));

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String qrtext = '';

  QRViewController? controller;

  AESEncryption encryption = new AESEncryption();

  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  bool isOn = false;
  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    controller?.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
                cutOutSize: MediaQuery.of(context).size.width * 0.8,
                borderWidth: 10,
                borderRadius: 10,
                borderColor: Colors.blue,
                borderLength: 30,
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Text(
              " الطالب هو :${qrtext}",
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            top: 50,
            child: IconButton(
              icon: Icon(
                isOn ? Icons.flash_off : Icons.flash_on,
                color: Colors.white,
              ),
              onPressed: () async {
                await controller?.toggleFlash();
                setState(() {
                  isOn = isOn ? false : true;
                });
              },
            ),
          ),
          SlideTransition(
            position: _animation,
            child: Container(
              height: 4,
              width: MediaQuery.of(context).size.width * 0.7,
              color: Colors.blue,
            ),
          ),

        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((barcode) {
      setState(() {
        qrtext = '${barcode.code}';
        qrtext = encryption.decryptMsg(encryption.getCode(qrtext));
      });
    });
    //
  }


}
