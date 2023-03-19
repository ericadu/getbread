import 'dart:convert';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_bready/fixed_height_button.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:async/async.dart';

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
  String? imgUrl;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  String getNewFilepath(String filepath) {
    List<String> parts = filepath.split(".");
    return parts[0] + "_compressed." + parts[1];
  }

  Future<File> compressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        minWidth: 550, quality: 50, format: CompressFormat.jpeg);
    return result!;
  }

  void sendImage() async {
    // Replace the URL with the endpoint that you want to send the image to
    String url = 'https://7cbf-173-56-66-147.ngrok.io/generate';

    // Replace the file path with the path to your image file
    // File imageFile = _image!;
    // String newFilepath = getNewFilepath(_image!.absolute.path);
    File imageFile = _image!;

    // Create a multipart request using the http package
    var request = http.MultipartRequest('POST', Uri.parse(url));

    var stream = http.ByteStream(DelegatingStream(imageFile.openRead()));
    // Add the image file to the request
    http.MultipartFile multipartFile = http.MultipartFile(
        'file', stream, await imageFile.length(),
        filename: basename(imageFile.path));

    print(multipartFile.length);

    request.files.add(multipartFile);
    // request.files
    //     .add(await http.MultipartFile.fromPath('image', imageFile.path));

    // Send the request and wait for the response
    http.StreamedResponse response = await request.send();

    response.stream.transform(utf8.decoder).listen((value) {
      Map<String, dynamic> map = json.decode(value.toString());

      setState(() {
        imgUrl = map['image_url'];
      });
    });
    // Print the response status cod
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
                imgUrl != null
                    ? Container(
                        height: height,
                        width: width,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                alignment: Alignment.topLeft,
                                image: NetworkImage(imgUrl!),
                                fit: BoxFit.contain)),
                      )
                    : GestureDetector(
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
                if (_image != null || imgUrl != null)
                  FixedHeightRoundedWideButton(
                    text: imgUrl != null ? 'Start Over' : 'Use this image',
                    onPressed: imgUrl != null
                        ? () {
                            setState(() {
                              _image = null;
                              imgUrl = null;
                            });
                          }
                        : () {
                            sendImage();
                          },
                  )
              ],
            )));
  }
}
