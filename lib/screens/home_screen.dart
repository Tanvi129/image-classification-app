import 'dart:io';
import 'dart:math';
import 'package:tflite/tflite.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  XFile? imageurl;
  final ImagePicker _picker = ImagePicker();
  bool isimageselected = false;
  String _confidence = "Not Loaded";
  String _name = "Not loaded";
  String numbers = '';
  List? _result;

  Future getImage(bool isCamera) async {
    XFile? image = await _picker.pickImage(
        source: (isCamera == true) ? ImageSource.camera : ImageSource.gallery);

    setState(() {
      imageurl = image;
      isimageselected = true;
      applyModelOnImage(imageurl);
    });
  }
  //to be called in initState

  loadmyModel() async {
    var resultant = await Tflite.loadModel(
        model: "assests/models/pneumonia.tflite",
        labels: "assests/models/labels.txt");

    print("Result after loading model: $resultant");
  }

  applyModelOnImage(XFile? file) async {
    var res = await Tflite.runModelOnImage(
        path: file!.path,
        numResults: 2,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5);

    setState(() {
      _result = res;
      String str = _result?[0]["label"];
      _name = str.substring(2);
      _confidence = _result != null
          ? (_result?[0]['confidence'] * 100.0).toString().substring(0, 2) + "%"
          : '';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadmyModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text("Pneumonia"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.black87,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 400,
              width: 400,
              child: isimageselected
                  ? Image.file(File(imageurl!.path))
                  : Container(child: Text("No Image Selected")),
            ),
            SizedBox(height: 20,),
            Text(
              "Name : $_name",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Confidence : $_confidence",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              getImage(true);
            },
            child: const Icon(Icons.camera),
          ),
          const SizedBox(
            height: 15,
          ),
          FloatingActionButton(
              onPressed: () {
                getImage(false);
              },
              child: const Icon(
                Icons.photo_album,
              )),
        ],
      ),
    );
  }
}
