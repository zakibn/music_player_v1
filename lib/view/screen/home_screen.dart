import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Structure')),
      body: Center(
        child: Text(
          controller.title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
