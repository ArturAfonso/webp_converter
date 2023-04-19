import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:webp_converter/app/modules/home/controllers/home_controller.dart';

class SettingsController extends GetxController {
  HomeController cHome = Get.find();
  GetStorage storage = GetStorage('storage');
  RxString tema = " ".obs;

  @override
  void onInit() {
    super.onInit();
    if (storage.read('theme') != null) {
      debugPrint(storage.read('theme'));
      tema.value = storage.read('theme') == "light" ? 'dark' : 'light';
    } else {
      tema.value = "dark";
    }
  }

  changeTheme() {
    var theme = storage.read('theme');
    if (theme != null) {
      if (theme == 'light') {
        Get.changeThemeMode(ThemeMode.dark);
        storage.write('theme', ThemeMode.dark.name);
        tema.value = ThemeMode.light.name;
      } else {
        Get.changeThemeMode(ThemeMode.light);
        storage.write('theme', ThemeMode.light.name);
        tema.value = ThemeMode.dark.name;
      }
    } else {
      Get.changeThemeMode(ThemeMode.dark);
      storage.write('theme', ThemeMode.dark.name);
      tema.value = ThemeMode.light.name;
    }
  }
}
