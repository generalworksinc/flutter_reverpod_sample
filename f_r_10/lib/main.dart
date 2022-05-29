import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

//１ずつ値を増加させるためのカウンターStateProvider
final counterProvider = StateProvider((ref) => 0);

//カウンターの値を２倍にした値を提供するProvider
final doubleCounterProvider = Provider((ref) {
  final count = ref.watch(counterProvider);
  return count * 2;
});

void main() {
  runApp(ProviderScope(
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
      home: ProviderPage(),
    );
  }
}

class ProviderPage extends ConsumerWidget {
  const ProviderPage({
    super.key,
  });

  static const String title = 'ProviderPage';
  // static const String routeName = 'provider-page';

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    //doubleCounterProviderを読み取る。
    //counterProviderの状態が更新されると、doubleCounterProviderも変更され、
    //再構築される。
    final doubleCount = ref.watch(doubleCounterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(title)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            '２倍されたカウント値：',
            style: Theme.of(context).textTheme.headline6,
          ),
          // doubleCounterProviderの値を表示
          Text(
            '$doubleCount',
            style: Theme.of(context).textTheme.headline1,
          ),
          ElevatedButton(
            //counterProviderの値を+1する。
            onPressed: () => ref.read(counterProvider.notifier).update(
                (state) => state + 1,
            ),
            child: const Text('Increase Count'),
          )
        ],
      )
    );
  }

}
