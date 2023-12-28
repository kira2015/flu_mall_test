import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flu_mall_test/model/post_info.dart';
import 'package:flutter/scheduler.dart';

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
  double scrollviewHeight = 300;
  void updateHeight(double height) {
    if (height == scrollviewHeight) {
      return;
    }
    setState(() {
      scrollviewHeight = height;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: scrollviewHeight,
        child: WaterfallGrid(
          columnCount: 2,
          updateHeight: updateHeight,
          children: List.generate(widget.posts.length, (index) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.network(widget.posts[index].imageUrl),
                Text(widget.posts[index].title),
                Text(widget.posts[index].description),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class WaterfallGrid extends StatelessWidget {
  final List<Widget> children;
  final int columnCount;
  final Function(double) updateHeight;
  const WaterfallGrid(
      {super.key,
      required this.children,
      this.columnCount = 2,
      required this.updateHeight});

  @override
  Widget build(BuildContext context) {
    return CustomMultiChildLayout(
      delegate: WaterfallGridDelegate(
          columnCount: columnCount,
          children: children,
          updateHeight: updateHeight),
      children: List.generate(children.length, (index) {
        return LayoutId(
          id: index,
          child: children[index],
        );
      }),
    );
  }
}

class WaterfallGridDelegate extends MultiChildLayoutDelegate {
  final int columnCount;
  final List<Widget> children;
  final Function(double) updateHeight;
  double lastMaxHeight = 0.0; // 用于存储上次的高度
  WaterfallGridDelegate(
      {required this.columnCount,
      required this.children,
      required this.updateHeight});

  @override
  void performLayout(Size size) {
    // 每列的宽度
    double columnWidth = size.width / columnCount;
    // 每列的当前高度
    List<double> columnHeights = List.generate(columnCount, (index) => 0.0);

    for (int i = 0; i < children.length; i++) {
      // 假设子 Widget 的宽度等于列宽
      final childSize = layoutChild(
        i,
        BoxConstraints(
          maxWidth: columnWidth,
          minHeight: 0.0,
          maxHeight: size.height,
        ),
      );

      // 找到当前最短的列
      int shortestColumnIndex = 0;
      double shortestHeight = double.maxFinite;
      for (int j = 0; j < columnCount; j++) {
        if (columnHeights[j] < shortestHeight) {
          shortestHeight = columnHeights[j];
          shortestColumnIndex = j;
        }
      }

      // 定位子 Widget
      positionChild(
        i,
        Offset(columnWidth * shortestColumnIndex,
            columnHeights[shortestColumnIndex]),
      );

      // 更新列高
      columnHeights[shortestColumnIndex] += childSize.height;
      // 两个数中的最大值
      double maxHeight = columnHeights.reduce((a, b) => a > b ? a : b);
      print('maxHeight: $maxHeight');
      // 更新滚动视图的高度
      if (maxHeight != lastMaxHeight) {
        lastMaxHeight = maxHeight; // 更新存储的高度
        SchedulerBinding.instance.addPostFrameCallback((_) {
          updateHeight(maxHeight);
        });
      }
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return true;
  }
}
