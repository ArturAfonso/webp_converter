import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SettingsView'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    'Tema:    ',
                    style: TextStyle(fontSize: 20),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controller.changeTheme();
                    },
                    child: Obx(() => Text(
                          controller.tema.value,
                          style: const TextStyle(fontSize: 20),
                        )),
                  ),
                ],
              ),
              Platform.isWindows || Platform.isLinux || Platform.isMacOS
                  ? Row(
                      children: [
                        const Text(
                          'Pasta de destino:    ',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          width: Get.size.width / 3,
                          child: TextFormField(
                            decoration: InputDecoration(
                                label: controller.cHome.pathDestinoController.text == ''
                                    ? const Text('Diretorio padrão é "Downloads", clique para alterar')
                                    : null,
                                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)))),
                            controller: controller.cHome.pathDestinoController,
                            onChanged: (s) async {
                              var tempo = await FilePicker.platform
                                  .getDirectoryPath(dialogTitle: 'Selecione a pasta para salvar os arquivos');
                              debugPrint(tempo);
                              if (tempo != null && tempo.isNotEmpty) {
                                controller.cHome.pathDestinoController.text = tempo;
                                controller.cHome.diretorioDestino = tempo;
                                controller.cHome.storage.write('diretorioDestino', tempo);
                              }
                            },
                            onTap: () async {
                              var tempo = await FilePicker.platform
                                  .getDirectoryPath(dialogTitle: 'Selecione a pasta para salvar os arquivos');
                              debugPrint(tempo);
                              if (tempo != null && tempo.isNotEmpty) {
                                controller.cHome.pathDestinoController.text = tempo;
                                controller.cHome.diretorioDestino = tempo;
                                controller.cHome.storage.write('diretorioDestino', tempo);
                              }
                            },
                          ),
                        ),
                        /*   ElevatedButton(
                            onPressed: () async {
                              debugPrint(controller.cHome.diretorioDestino);
                            },
                            child: const Text('pick')), */
                      ],
                    )
                  : Row(
                      children: const [
                        Text(
                          'Pasta de destino:    ',
                          style: TextStyle(fontSize: 20),
                        ),
                        Expanded(
                          child: Text(
                            'Album chamado "Convertidas", na galeria do dispositivo',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
