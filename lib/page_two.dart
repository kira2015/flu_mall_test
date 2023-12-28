import 'package:flutter/material.dart';
import 'package:dio/dio.dart';


class PageTwo extends StatefulWidget {
  const PageTwo({super.key});

  @override
  State<PageTwo> createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  late Future<List<Post>> posts;

  @override
  void initState() {
    super.initState();
    posts = fetchPosts();
  }

  Future<List<Post>> fetchPosts() async {
    var dio = Dio();
    final response = await dio.get('https://resources.ninghao.net/demo/posts.json');

    if (response.statusCode == 200) {
      var receivedPosts = List<Post>.from(response.data["posts"].map((x) => Post.fromJson(x)));
      return receivedPosts;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts List'),
      ),
      body: FutureBuilder<List<Post>>(
        future: posts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.network(snapshot.data![index].imageUrl),
                  title: Text(snapshot.data![index].title),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}


class Post {
  final String title;
  final String imageUrl;

  Post({required this.title, required this.imageUrl});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }
}
