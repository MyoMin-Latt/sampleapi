// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sampleapi/product/service/product_future_remote_service.dart';

class ProductPage extends ConsumerStatefulWidget {
  const ProductPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductPageState();
}

class _ProductPageState extends ConsumerState<ProductPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(getProductProvider);
    // print('getProductProvider.state => $state');
    // print('getProductProvider.isLoading => ${state.isLoading}');
    // print('getProductProvider.hasError => ${state.hasError}');
    // print('getProductProvider.hasValue => ${state.hasValue}');
    // print('getProductProvider -------------------------------------');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product'),
        actions: [
          IconButton(
            onPressed: () {
              ref.refresh(getProductProvider.future);
            },
            icon: const Icon(Icons.get_app),
          ),
          IconButton(
            onPressed: () {
              print('state.isLoading => ${state.isLoading}');
              print('state.isReloading => ${state.isReloading}');
              print('state.isRefreshing => ${state.isRefreshing}');
              print('state.hasError => ${state.hasError}');
              print('state.hasValue => ${state.hasValue}');
              print('state.valueOrNull => ${state.valueOrNull}');
            },
            icon: const Icon(Icons.stadium),
          ),
          const SizedBox(width: 18),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(getProductProvider.future),
        child: state.when(
          data: (data) => ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => Card(
                      child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Text('$index / ${data.title}'),
                    ),
                  ))),
          error: (e, t) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(e.toString()),
                IconButton(
                  onPressed: () => !state.isLoading
                      ? ref.refresh(getProductProvider.future)
                      : null,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
