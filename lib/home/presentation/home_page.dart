import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sampleapi/home/state/product_state.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    getProducts();
    super.initState();
  }

  Future<void> getProducts() async {
    Future.microtask(
        () => ref.read(productStateNotfierProvider.notifier).getProducts(0));
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ProductState>(productStateNotfierProvider, (previous, next) {
      print(next);
    });

    final state = ref.watch(productStateNotfierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: state.when(
          initial: (_) => const SizedBox(),
          loading: (_) => const Center(child: CircularProgressIndicator()),
          empty: (_) => const Center(child: Text('Empty Data')),
          success: (_) => const Center(child: Text('Got data')),
          error: (_, __) => const Center(child: Text('Empty Data'))),
    );
  }
}
