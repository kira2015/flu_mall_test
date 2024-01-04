import 'package:flu_mall_test/getx/datax.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'main.dart';

class PageDetail extends GetView<DataX> {
  const PageDetail({super.key});

  void printCurrentStack() {
    var navigatorState = Get.key.currentState;

    if (navigatorState is NavigatorState) {
      var routes = navigatorState.widget.pages;
      print("Current Stack:${routes.length}");
      for (var route in routes) {
        print(route.name);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DataX>();
    final index = int.parse(Get.parameters['index']!);
    final postInfo = controller.posts[index];
    return Scaffold(
        appBar: AppBar(
          title: Text(postInfo.title),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: ColoredBox(
                color: Colors.white,
                child: Image.network(
                  postInfo.imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              child: Column(
                children: [
                  Text(
                    postInfo.description,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  TextField(
                    controller: controller.controller,
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            postInfo.description = controller.controller.text;
                            print('路由导航:${NavigationObserverX.navigationStack}');
                          },
                          child: const Text(
                            '确认',
                            style: TextStyle(fontSize: 22),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
