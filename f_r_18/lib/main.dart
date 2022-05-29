import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


final counterStateProvider = StateNotifierProvider((ref) => Counter());

class Counter extends StateNotifier<int>{
  Counter() : super(
    0
  );

  void increase() {
    state += 1;
  }

  void disp(BuildContext context, WidgetRef ref) {
    showDialog(context: context, builder: (context) {
      final counter = ref.read(counterStateProvider);
      return AlertDialog(
        title: Text('counter is${counter ?? 0}'),
      );
    });
  }
}

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
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final counter = ref.watch(counterStateProvider.notifier);

    return Scaffold(
      body: ElevatedButton(
        onPressed: () => counter.disp(context, ref),
        child: Text('disp!'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => counter.increase(),
        child: Text('+1'),
      ),
    );
  }
}
