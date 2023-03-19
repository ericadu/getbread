import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_bready/fixed_height_button.dart';
import 'package:image_picker/image_picker.dart';

class ImageFromGallery extends StatefulWidget {
  const ImageFromGallery({
    super.key,
  });

  @override
  State<ImageFromGallery> createState() => _ImageFromGalleryState();
}

class _ImageFromGalleryState extends State<ImageFromGallery> {
  File? _image;
  late ImagePicker imagePicker;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.9;
    double height = MediaQuery.of(context).size.height * 0.6;
    return Scaffold(
        appBar: AppBar(title: const Text('Take a picture of your fridge')),
        body: Container(
            padding:
                const EdgeInsets.only(top: 40, bottom: 40, left: 20, right: 20),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: () async {
                      XFile? image = await imagePicker.pickImage(
                          source: ImageSource.camera,
                          imageQuality: 50,
                          preferredCameraDevice: CameraDevice.rear);
                      if (image != null) {
                        setState(() {
                          _image = File(image.path);
                        });
                      }
                    },
                    child: Container(
                      child: _image != null
                          ? Image.file(
                              _image!,
                              width: width,
                              height: height,
                              fit: BoxFit.fitHeight,
                            )
                          : Container(
                              decoration:
                                  const BoxDecoration(color: Colors.amber),
                              width: width,
                              height: height,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey[800],
                              ),
                            ),
                    )),
                if (_image != null)
                  FixedHeightRoundedWideButton(
                    text: 'Use this image',
                    onPressed: () {
                      print('hello');
                    },
                  )
              ],
            )));
  }
}
