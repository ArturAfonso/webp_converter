import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../widgets/custom_drawer.dart';

class HomeView extends GetView<HomeController> {
  //finished
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('HomeView'),
          centerTitle: true,
        ),
        drawer: const CustomDrawer(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton.icon(
                  onPressed: () {
                    controller.pickImages();
                  },
                  icon: const Icon(Icons.add_a_photo),
                  label: const Text('adcionar imagens')),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 5),
                    child: GetBuilder<HomeController>(
                      init: controller,
                      initState: (_) {},
                      builder: (_) {
                        return ListView.separated(
                          scrollDirection: Axis.vertical,
                          itemCount: controller.files != null ? controller.files!.length : 0,
                          itemBuilder: (BuildContext context, int index) {
                            File file = controller.files![index];
                            final fileFullName = file.path.split(Platform.pathSeparator).last;
                            return Dismissible(
                              key: Key(controller.files![index].toString()),
                              direction: DismissDirection.startToEnd,
                              onDismissed: (direction) {
                                controller.files!.removeAt(index);
                                controller.update();
                              },
                              child: ListTile(
                                title: Text(
                                  fileFullName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                leading: Image.file(
                                  File(file.path),
                                  fit: BoxFit.fill,
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    controller.files!.removeAt(index);
                                    controller.update();
                                  },
                                ),
                              ),
                            ); /* SizedBox(
                        height: Get.size.height / 4,
                        width: Get.size.width / 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.file(
                            File(controller.files![index].path),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ); */
                          },
                          separatorBuilder: (BuildContext context, int index) => const Divider(),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: GetBuilder<HomeController>(
          init: controller,
          initState: (_) {},
          builder: (_) {
            return Visibility(
              visible: controller.files != null && controller.files!.value.isNotEmpty,
              child: FloatingActionButton.extended(
                onPressed: () {
                  controller.convertImages();
                },
                label: const Text('Converter'),
              ),
            );
          },
        ),
      ),
    );
  }
}
