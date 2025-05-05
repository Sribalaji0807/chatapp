import 'package:chatapp/ux/FirebaseService.dart';
import 'package:chatapp/ux/GetIt.dart';
import 'package:chatapp/ux/Provider.dart';
import 'package:chatapp/ux/SharedPreferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrWidget extends ConsumerStatefulWidget {
  const QrWidget({super.key});

  @override
  ConsumerState<QrWidget> createState() => _QrWidgetState();
}

class _QrWidgetState extends ConsumerState<QrWidget> {
  late String? userid;
  String currentView = '';
  void initState() {
    super.initState();
    userid = ref.read(credentialsProvider).userid!;
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
                ? scanQrCode()
                : showQrCode(),
      ),
    );
  }

  Widget showQrCode() {
    return QrImageView(
      data: userid!,

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

  Widget scanQrCode() {
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
      body: MobileScanner(
        onDetect: (result) {
          final code = result.barcodes.first.rawValue;
          if (code != null) {
            getIt<Firebaseservice>().addContacts(code, userid!);
            setState(() {
              currentView = '';
            });
          }
        },
      ),
    );
  }
}
