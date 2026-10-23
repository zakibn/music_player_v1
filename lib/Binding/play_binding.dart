import 'package:get/get.dart';

import '../controller/player_controller.dart';

class PlayerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlayerController>(() => PlayerController());
  }
}
