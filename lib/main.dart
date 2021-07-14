import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/camera_mode/main_cam.dart';
import 'package:object_detection/picture/picture.dart';

List<CameraDescription> ourCam;

Future<void> main() async {
  // cam initialize
  WidgetsFlutterBinding.ensureInitialized();
  ourCam = await availableCameras();
  // run this app
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "iDentify : Object DEtection App",
      home: Container(
        decoration: new BoxDecoration(
            image: new DecorationImage(
                image: AssetImage("assets/bg/bg_menu.jpg"), fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.info),
                onPressed: aboutDialog,
              ),
            ],
            backgroundColor: Colors.transparent,
          ),
          extendBodyBehindAppBar: true,
          body: Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 35, right: 35),
                    child: Container(
                      width: 400,
                      height: 134,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image:
                                  ExactAssetImage('assets/bg/title_menu.png'))),
                    ),
                  ),
                  Text(
                    'An object detector android app',
                    style: TextStyle(fontSize: 16),
                  ),
                  ButtonTheme(
                    minWidth: 250,
                    child: Padding(
                      padding: EdgeInsets.only(top: 250),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(width: 300, height: 50),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromRGBO(195, 211, 155, 40),
                          ),
                          child: Text("Use Picture from phone"),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StaticImage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  ButtonTheme(
                    minWidth: 160,
                    child: Padding(
                      padding: EdgeInsets.only(top: 25, bottom: 75),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(width: 300, height: 50),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromRGBO(195, 211, 155, 40),
                          ),
                          child: Text("Switch to Real Time mode"),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LiveFeed(ourCam),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  aboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: "iDentify : An object detector app",
      applicationLegalese: "Bensay & friend haha yes",
      applicationVersion: "alpha build",
    );
  }
}
