import 'package:flu_mall_test/getx/my_binding.dart';
import 'package:flu_mall_test/page_detail.dart';
import 'package:flu_mall_test/page_one.dart';
import 'package:flu_mall_test/page_two.dart';
import 'package:flu_mall_test/parent.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class NavigationObserverX extends GetObserver {
  static final navigationStack = <String>[];
  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    navigationStack.removeLast();
    print('Current Navigation Stack: $navigationStack');
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    var currentRoute = route.settings.name;
    if (currentRoute != null) {
      navigationStack.add(currentRoute);
    }
    print('Current Navigation Stack: $navigationStack');
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    navigationStack.remove(route.settings.name);
    print('Current Navigation Stack: $navigationStack');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

    if (oldRoute?.settings.name != null && newRoute?.settings.name != null) {
      // 从后往前查找第一个匹配的旧路由
      for (int i = navigationStack.length - 1; i >= 0; i--) {
        if (navigationStack[i] == oldRoute!.settings.name) {
          navigationStack[i] = newRoute!.settings.name!;
          break;
        }
      }
    }

    print('Current Navigation Stack: $navigationStack');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print('MyApp build');
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      initialRoute: '/',
      routingCallback: (value) {
        print('routingCallback: ${value?.current}');
      },
      navigatorObservers: [NavigationObserverX()],
      getPages: [
        GetPage(name: '/', page: () => const MyHomePage(title: '积分商城')),
        GetPage(
            name: '/parent',
            page: () => const ParentWidget(),
            binding: MyBinding2()),
        GetPage(
            name: '/list', page: () => const PageOne(), binding: MyBinding()),
        GetPage(
            name: '/alert',
            page: () => const PageTwo(),
            participatesInRootNavigator: false),
        GetPage(name: '/detail/:index', page: () => const PageDetail())
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('MyHomePage build');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            IconButton(
              onPressed: () => Get.toNamed('/parent'),
              icon: const Icon(
                Icons.account_tree_rounded,
                size: 60,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
