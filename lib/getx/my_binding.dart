import 'package:flu_mall_test/getx/datax.dart';
import 'package:get/get.dart';

class MyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=>DataX());
  }
}

class MyBinding2 extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=>DataB(), fenix: true);
  }
}