import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  XFile? imageurl;
  final ImagePicker _picker = ImagePicker();

  Future getImage(bool isCamera)async{
    XFile? image = await _picker.pickImage(
      source: (isCamera == true)? ImageSource.camera : ImageSource.gallery
    );

    setState(() {
       imageurl = image;
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pneumonia"),
        centerTitle: true,
      ),
      body: Container(
        child: imageurl==null? const Text("No Image"):
        Image.file(File(imageurl!.path)),),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(onPressed: (){
            getImage(true);
          },
          child: const Icon(Icons.camera),
          ),
          const SizedBox(height: 15,),
          FloatingActionButton(onPressed: (){
            getImage(false);
          },
          child: const Icon(Icons.photo_album,)),
        ],
      ),
    );

  }
}