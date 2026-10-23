import 'package:get/get.dart';

/// Register app-wide dependencies here when the app needs them.
/// Screen-specific controllers are preferably registered in their own Bindings.
class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // Example:
    // Get.put<MyService>(MyService(), permanent: true);
  }
}
