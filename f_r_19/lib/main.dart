import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final userNameProvider = StateProvider((ref) => 'dart-lang');

final githubUserProvider = FutureProvider<Map<String, Object?>>((ref) async {
  final username = ref.watch(userNameProvider);
  final response = await http.get(Uri.https(
      'api.github.com',
      'users/$username')
  );
  return json.decode(response.body);
});

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return ref.watch(githubUserProvider).when(
        data: (user) {
          return RefreshIndicator(
            //onRefresh: () => ref.refresh(githubUserProvider.future), //この例は間違い。ここにonRefreshの使い方イマイチ分かってない
            onRefresh: () => Future.value(0), //onRefreshを使ってない。この例では単純にuserNameの変更を、FutureProviderがwatchしてリロードしてるだけ。onRefreshの使い方イマイチ分かってない。
            child: Scaffold(
              body: ListView(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                children: [
                  ListTile(
                    title: const Text('login'),
                    subtitle: Text('${user['login'] ?? 'none'}'),
                  ),
                  ListTile(
                    title: const Text('id'),
                    subtitle: Text('${user['id'] ?? 'none'}'),
                  ),
                  ListTile(
                    title: const Text('html_url'),
                    subtitle: Text('${user['html_url'] ?? 'none'}'),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  //ユーザーを更新する
                  ref.read(userNameProvider.notifier).update((state) => 'flutter');
                },
              ),
            ),
          );
        },
        error: (error, stackTrace) => Text('$error, $stackTrace'),
        loading: () => const CircularProgressIndicator(),
    );
  }

}