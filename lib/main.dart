import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ticsart_app/src/qr_screen.dart';
import 'package:ticsart_app/src/sku_identifier_screen.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  // Fetch the available cameras before initializing the app.
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String sku;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(
            tabs: [
              Text("Generar Sku"),
              Text("Ver SKU-QR"),
              Text("Scanear QR"),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            SkuIdentifierScreen(
              cameras: cameras,
              onPictureTaked: (data, context) {
                setState(() {
                  sku = data;
                });
                final tabController = DefaultTabController.of(context);
                tabController.index = 1;
              },
            ),
            QRGeneratorScreen(sku: sku),
            QRScreen(),
          ],
        ),
      ),
    );
  }
}

class QRGeneratorScreen extends StatefulWidget {
  QRGeneratorScreen({this.sku});

  final String sku;

  @override
  _QRGeneratorScreenState createState() => _QRGeneratorScreenState();
}

class _QRGeneratorScreenState extends State<QRGeneratorScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (widget.sku != null) ...[
            Text(
              "${widget.sku}",
              style: Theme.of(context).textTheme.display1,
            ),
            QrImage(
              data: "${widget.sku}",
              embeddedImage: AssetImage("assets/logos/A.jpg"),
            )
          ] else
            Text(
              "Tome una foto para generar sku",
              style: TextStyle(fontSize: 24),
            ),
        ],
      ),
    );
  }
}
