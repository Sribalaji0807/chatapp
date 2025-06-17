import 'package:chatapp/ux/FirebaseService.dart';
import 'package:chatapp/ux/GetIt.dart';
import 'package:chatapp/ux/SharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrWidget extends ConsumerStatefulWidget {
  const QrWidget({super.key});

  @override
  ConsumerState<QrWidget> createState() => _QrWidgetState();
}

class _QrWidgetState extends ConsumerState<QrWidget> {
  late String userid;
  String currentView = '';
  late MobileScannerController controller;

  final SharedPreferencesService prefs = getIt<SharedPreferencesService>();
  @override
  void initState() {
    super.initState();
    setState(() {
      userid = prefs.userid!;
    });
    controller = MobileScannerController();
  }

  @override
  void dispose() {
    controller.stop();
    controller.dispose();
    super.dispose();
  }

  void ScannerFunc(var result) async {
    final code = result.barcodes.first.rawValue;
    if (code != null) {
      await getIt<Firebaseservice>().addContacts(code, userid);
      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          currentView = '';
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            currentView == ''
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          currentView = 'scan';
                        });
                      },
                      child: Text("Scan Qr", style: TextStyle(fontSize: 20)),
                    ),
                    Text("Or", style: TextStyle(fontSize: 20)),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          currentView = 'show';
                        });
                      },
                      child: Text("Show Code", style: TextStyle(fontSize: 20)),
                    ),
                  ],
                )
                : currentView == 'scan'
                ? scanQrCode(userid)
                : showQrCode(userid),
      ),
    );
  }

  Widget showQrCode(String userid) {
    return userid.isEmpty
        ? Container(child: Center(child: Text("No user id found")))
        : QrImageView(
          data: userid,

          version: QrVersions.auto,
          size: 200.0,
          errorStateBuilder: (cxt, err) {
            return Container(
              child: Center(
                child: Text(
                  'Uh oh! Something went wrong...',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        );
  }

  Widget scanQrCode(String userid) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              currentView = '';
            });
          },
        ),
        title: Text('Scan QR Code'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 500,
            child: MobileScanner(
              controller: controller,

              onDetect: (result) async {
                if (result.barcodes.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QrWidget()),
                  );
                  return;
                }
                ScannerFunc(result);
              },
            ),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              final image = await ImagePicker().pickImage(
                source: ImageSource.gallery,
              );
              if (image == null) return;

              final result = await controller.analyzeImage(image.path);
              ScannerFunc(result);
            },
            label: Text("Open Gallery"),
            icon: Icon(Icons.browse_gallery_rounded),
          ),
        ],
      ),
    );
  }
}
