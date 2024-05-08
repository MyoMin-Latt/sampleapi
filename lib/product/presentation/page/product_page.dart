import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sampleapi/product/presentation/presentation.dart';
import 'package:sampleapi/product/presentation/state/product_state.dart';

import '../../feat_product.dart';

class ProductPage extends ConsumerStatefulWidget {
  const ProductPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductPageState();
}

class _ProductPageState extends ConsumerState<ProductPage> {
  @override
  void initState() {
    super.initState();
    getProduct();
  }

  Future<void> getProduct() async {
    Future.microtask(() async {
      ref.read(apiStateProvider.notifier).state = ApiState.loading;
      var data = ref.read(productRemoteServiceProvider).getProduct();
      data.then((value) {
        ref.read(dataProvider.notifier).state = value;
        ref.read(apiStateProvider.notifier).state = ApiState.data;
      }).onError((error, stackTrace) {
        print("onError => ${error.toString()}");
        error.toString().contains('Internet')
            ? () {
                print('ApiState.noInternet');
                ref.read(errorProvider.notifier).state = error.toString();
                ref.read(apiStateProvider.notifier).state = ApiState.noInternet;
              }
            : () {
                print('ApiState.error');
                ref.read(errorProvider.notifier).state = error.toString();
                ref.read(apiStateProvider.notifier).state = ApiState.error;
              };
      }).catchError((err) {
        print('Error: $err'); // Prints 401.
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(apiStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product'),
        actions: [
          IconButton(onPressed: getProduct, icon: const Icon(Icons.get_app)),
          const SizedBox(width: 18),
        ],
      ),
      body: switch (state) {
        ApiState.loading => const Center(child: CircularProgressIndicator()),
        ApiState.error => Center(child: Text(ref.watch(errorProvider))),
        ApiState.noInternet => Center(child: Text(ref.watch(errorProvider))),
        ApiState.data => const Center(child: Text('data'))
      },
    );
  }
}
