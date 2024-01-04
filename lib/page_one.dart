import 'dart:math';

import 'package:flu_mall_test/getx/datax.dart';
import 'package:flutter/material.dart';
import 'package:flu_mall_test/model/post_info.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class PageOne extends StatelessWidget {
  const PageOne({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DataX>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('PageOne'),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text(
                'Back',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: ColoredBox(
          color: Colors.white,
          child: Obx(() {
            print(controller.posts.length);
            return DynamicGrid(posts: controller.posts);
          })),
    );
  }
}

class DynamicGrid extends StatefulWidget {
  final List<PostInfo> posts;
  const DynamicGrid({super.key, required this.posts});
  @override
  State<DynamicGrid> createState() => _DynamicGridState();
}

class _DynamicGridState extends State<DynamicGrid> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: StaggeredGrid.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: List.generate(widget.posts.length, (index) {
            final p = widget.posts[index];
            return InkWell(
              child: Container(
                color:
                    Colors.primaries[Random().nextInt(Colors.primaries.length)],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(p.imageUrl),
                    Text(
                      p.title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(p.description),
                  ],
                ),
              ),
              onTap: () => Get.toNamed('/detail/$index'),
            );
          }),
        ),
      ),
    );
  }
}
