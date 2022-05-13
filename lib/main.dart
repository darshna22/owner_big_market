import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:owner_big_market/uploaddata/database/storage_service1.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:owner_big_market/uploaddata/screen/add_product_category_screen.dart';
import 'package:owner_big_market/uploaddata/screen/signin_screen.dart';
import 'package:owner_big_market/uploaddata/screen/splace_screen.dart';
import 'package:owner_big_market/uploaddata/screen/upload_category_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    Storage storage = Storage();

    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      allowMultiple: false,
                      type: FileType.custom,
                      allowedExtensions: ['jpg', 'pdf', 'doc', 'jpeg'],
                    );
                    if (result == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No file selected')));
                    }

                    final path = result?.files.single.path;
                    final fileName = result?.files.single.name;

                    print(path);
                    print(fileName);
                    storage
                        .uploadFiles(path!, fileName!)
                        .then((value) => SnackBar(content: Text('Done')));
                  },
                  child: const Text('file uploaded')),
              FutureBuilder(
                future: storage.getListFiles(), // async work
                builder: (BuildContext context,
                    AsyncSnapshot<firebase_storage.ListResult> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return Container(
                      child: Column(
                        children: [
                          Text('list size ${snapshot.data?.items.length}'),
                        ],
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      !snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  return Container(
                    child: Text('ll'),
                  );
                },
              ),
              FutureBuilder(
                future: storage.downloadUrl("images.jpeg"), // async work
                builder: (BuildContext context,
                    AsyncSnapshot<String> snap) {
                  if (snap.connectionState == ConnectionState.done &&
                      snap.hasData) {
                    return Container(
                      child: Column(
                        children: [
                          Text('list size ${snap.data}'),
                          Image.network(snap.data!,fit: BoxFit.fill,width: 100,height: 100,)
                        ],
                      ),
                    );
                  }
                  if (snap.connectionState == ConnectionState.waiting &&
                      !snap.hasData) {
                    return CircularProgressIndicator();
                  }
                  return Container(
                    child: Text('ll'),
                  );
                },
              ),
            ],
          ),
        ));
  }
}
