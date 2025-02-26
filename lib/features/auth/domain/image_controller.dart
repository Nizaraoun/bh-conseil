import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ImageController extends GetxController {
  selectImage();
  saveImage(XFile imagePath);
  getImage();
  String pathimage = '';
  @override
  void onInit() {
    getImage();
    super.onInit();
  }
}

class ImageControllerImp extends ImageController {
  Rxn<Image> image = Rxn<Image>();

  @override
  selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      await saveImage(pickedImage);
      // await loadImage();
    }
    update();
  }

//save image
  @override
  saveImage(imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('id');
    // UserData.getToken().then((value) {
    //   saveimage(imagePath, value!, uid!).then((value) {
    //     if (value != '') {
    //       pathimage = baseurl + value;
    //       prefs.setString('saved_image', value);
    //       getImage();
    //     }
    //   });
    // }
    // );
  }

  @override
  getImage() {
    // UserData.getuserdata('saved_image').then((value) {
    //   if (value != "default.jpg") {
    //     pathimage = baseurl + value!;
    //     update();
    //     return pathimage;
    //   } else {
    //     pathimage = "assets/images/userimage.png";
    //     update();
    //     return pathimage;
    //   }
    // });
  }
}


//save image to local storage
  // @override
  // saveBase64Image(String base64Image) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('saved_image', base64Image);
  // }

  // @override
  // loadImage() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? base64Image = prefs.getString('saved_image');
  //   if (base64Image != null) {
  //     Uint8List bytes = base64Decode(base64Image);
  //     image.value = Image.memory(bytes);
  //   }
  // }