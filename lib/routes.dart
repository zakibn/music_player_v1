import 'package:get/get.dart';

import 'Binding/play_binding.dart';
import 'Binding/home_binding.dart';
import 'core/Constant/app_routes.dart';
import 'view/screen/home_screen.dart';
import 'view/screen/player_screen.dart';

class AppPages {
  static final List<GetPage<dynamic>> pages = [
    GetPage(
      name: AppRoutes.playerScreen,
      page: () => const PlayerScreen(),
      binding: PlayerBinding(),
    ),
    /* GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ), */
  ];
}
