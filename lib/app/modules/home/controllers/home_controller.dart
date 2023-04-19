import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class HomeController extends GetxController {
  RxList<File>? files;
  TextEditingController pathDestinoController = TextEditingController();
  String diretorioDestino = '';
  GetStorage storage = GetStorage('storage');

  @override
  void onInit() {
    super.onInit();
    setDirectoryDefault();
  }

  setDirectoryDefault() async {
    if (storage.read('diretorioDestino') != null && storage.read('diretorioDestino') != '') {
      diretorioDestino = storage.read('diretorioDestino');
      pathDestinoController.text = diretorioDestino;
    } else {
      if (Platform.isWindows) {
        diretorioDestino = '${Platform.environment['USERPROFILE']}\\Downloads';
      } else if (Platform.isLinux) {
        final pasta = await getExternalStorageDirectories(type: StorageDirectory.downloads);

        if (pasta != null) {
          diretorioDestino = pasta.first.path;
        }
      }
    }
  }

  pickImages() async {
    // checkPermission();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['webp'],
    );
    if (result != null) {
      if (files == null) {
        files = (result.paths.map((path) => File(path!)).toList()).obs;

        update();
        debugPrint(files.toString());
      } else {
        for (var element in result.files) {
          files!.add(File(element.path.toString()));
          update();
          debugPrint(files.toString());
        }
      }
    } else {
      // User canceled the picker
    }
  }

  convertImages() async {
    if (files != null && files!.isNotEmpty) {
      var dir =
          Platform.isAndroid ? (await getApplicationDocumentsDirectory()) : await getApplicationSupportDirectory();
      for (var file in files!) {
        final fileFullName = file.path.split(Platform.pathSeparator).last;
        final fileName = fileFullName.split('.').first;

        if (Platform.isWindows || Platform.isLinux) {
          img.Command()
            ..decodeWebPFile(file.path)
            ..encodePng()
            ..writeToFile('$diretorioDestino${Platform.pathSeparator}$fileName.png')
            ..executeThread();

          debugPrint('imagem $fileName gravada!!!!');
        } else {
          final imageWebp = img.decodeWebP(File(file.path).readAsBytesSync());
          if (imageWebp != null) {
            final imagePng = img.encodePng(imageWebp);
            File imgFile = File('${dir.path}/$fileName.png');
            imgFile.writeAsBytesSync(imagePng);

            GallerySaver.saveImage(imgFile.path, albumName: 'Convertidas')
                .then((value) => {debugPrint('imagem $fileName gravada!!!!')});
          }
        }
      }
      files!.clear();
      update();
    }
  }
}


  /*   final imageWebp = img.decodeWebP(File(file.path).readAsBytesSync());
    if (imageWebp != null) {
      final imagePng = img.encodePng(imageWebp);
      File('./convertidas/$fileName.png').writeAsBytesSync(imagePng);
    } */




    /**
     * 
     *  void _saveNetworkImage() async {
    String path =
        'https://image.shutterstock.com/image-photo/montreal-canada-july-11-2019-600w-1450023539.jpg';
    GallerySaver.saveImage(path, albumName: albumName).then((bool success) {
      setState(() {
        print('Image is saved');
      });
    });
  }
}
     */