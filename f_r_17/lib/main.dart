import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final counterProvider = StateProvider((ref) => 0);

void main() {
  runApp(
      ProviderScope(
        child: const MyApp()
      ));
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

class MyHomePage extends ConsumerWidget{
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);

    //状態をwatchして表示を切り替える
    ref.listen<int>(
        counterProvider, // 購読対象のProviderを指定
        (previous, next) { // 変更前と変更後の値が受け取れる
          if (next.isEven) {
            return; //偶数なら何もしない
          }
          showDialog(context: context, builder: (context) {
            return const AlertDialog( //ダイアログを表示
              title: Text('Current Number is Odd!'),
            );
          });
        },
      onError: (error, stackTrace) {
        debugPrint('$error');
      },
    );


    return Scaffold(
      body: Text('$counter'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(counterProvider.notifier).update((state) => state + 1),
      ),
    );
  }
  
}