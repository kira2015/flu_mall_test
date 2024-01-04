import 'package:flu_mall_test/page_one.dart';
import 'package:flu_mall_test/page_two.dart';
import 'package:flutter/material.dart';
import 'package:flu_mall_test/getx/datax.dart';
import 'package:get/get.dart';

class ParentWidget extends StatelessWidget {
  const ParentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    print('ParentWidget build');
    return Scaffold(
      appBar: AppBar(
        title: Text('Parent'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.sick), Text("One")],
              ),
              onPressed: () => Get.toNamed('/list'),
            ),
            OutlinedButton(
              onPressed: () => Get.toNamed('/alert'),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.account_balance_rounded), Text("Two")],
              ),
            )
          ],
        ),
      ),
    );
  }
}
