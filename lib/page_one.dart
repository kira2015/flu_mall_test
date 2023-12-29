import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flu_mall_test/model/post_info.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class PageOne extends StatefulWidget {
  const PageOne({super.key});

  @override
  State<PageOne> createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  late Future<List<PostInfo>> posts;
  @override
  void initState() {
    super.initState();
    posts = network();
  }

  Future<List<PostInfo>> network() async {
    Dio dio = Dio();
    final res = await dio.get('https://resources.ninghao.net/demo/posts.json');
    if (res.statusCode == 200) {
      final tt = List<PostInfo>.from(
          res.data['posts'].map((x) => PostInfo.fromMap(x)));
      return dataHandle(tt);
    } else {
      throw Exception('Failed to load posts');
    }
  }

  List<PostInfo> dataHandle(List<PostInfo> t) {
    for (var i = 0; i < t.length; i++) {
      final p = t[i];
      p.description =
          p.description.substring(0, i.isEven ? 10 + i : i * 10 + 10);
    }
    return t;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PageOne'),
      ),
      body: ColoredBox(
        color: Colors.white,
        child: FutureBuilder<List<PostInfo>>(
          future: posts,
          builder: (BuildContext context, AsyncSnapshot<List<PostInfo>> sna) {
            switch (sna.connectionState) {
              case ConnectionState.done:
                List<PostInfo> dd = sna.data!;
                return DynamicGrid(posts: dd);
              default:
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
        ),
      ),
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
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 20,
          children: List.generate(widget.posts.length, (index) {
            final p = widget.posts[index];
            return Container(
              color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
              child: Column(
                children: [
                  Image.network(p.imageUrl),
                  Text('第$index个'),
                  Text(p.description),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
