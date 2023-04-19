import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webp_converter/app/routes/app_pages.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      onDestinationSelected: (index) {
        if (index == 0) {
          Get.back;
          Get.toNamed(Routes.SETTINGS);
        }
      },
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 28, left: 16, right: 16, bottom: 16),
          child: Text(
            'Opções',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.settings),
          label: Text('Configurações'),
        ),
      ],
    );
  }
}
