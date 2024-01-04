import 'package:dio/dio.dart';
import 'package:flu_mall_test/model/post_info.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';


class DataX extends GetxController {
  RxList<PostInfo> posts = <PostInfo>[].obs;
  final controller = TextEditingController(text: '');
  
  void network() async {
    Dio dio = Dio();
    final res = await dio.get('https://resources.ninghao.net/demo/posts.json');
    if (res.statusCode == 200) {
      final tt = List<PostInfo>.from(
          res.data['posts'].map((x) => PostInfo.fromMap(x)));
      posts.value = dataHandle(tt);
    } else {
      print('Failed to load posts');
      throw Exception('Failed to load posts');
    }
  }

  void changeDescription(int index, String description) {
    posts[index].description = description;
  }

  void removePost({int? index, PostInfo? postInfo}) {
    assert(index != null || postInfo != null, 'index or postInfo must not be null');
    if (index != null) {
      posts.removeAt(index);
    }else {
      posts.remove(postInfo);
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
  void onInit() {
    super.onInit();
    print('DataX onInit-----------> ${posts.length}}');

    network();
  }

  @override
  void onReady() {
    super.onReady();
    print('DataX onReady');
  }
  
  @override
  void onClose() {
    print('DataX onClose..........>');
    super.onClose();
  }

  
}

class DataB extends GetxController {
  RxInt count = 0.obs;
  
  @override
  void onInit() {
    super.onInit();
    print('DataB onInit');
  }

  @override
  void onReady() {
    super.onReady();
    print('DataB onReady');
  }
  
  @override
  void onClose() {
    print('DataB onClose..........>');
    super.onClose();
  }
}
