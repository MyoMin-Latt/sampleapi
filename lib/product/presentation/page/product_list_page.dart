// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../feat_product.dart';

class ProductListPage extends ConsumerStatefulWidget {
  const ProductListPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductListPageState();
}

class _ProductListPageState extends ConsumerState<ProductListPage> {
  final scrollController = ScrollController();

  Future<void> getNextTime() async {
    Future.microtask(() {
      final isNoMore = ref.watch(isNoMoreProvider);
      if (!isNoMore) {
        ref.watch(skipNumberProvider.notifier).state += 10;
        ref.refresh(getProductListProvider.future);
      }
    });
  }

  Future<void> onRefresh() async {
    Future.microtask(() {
      ref.read(productListProvider).clear();
      ref.watch(isNoMoreProvider.notifier).state = false;
      ref.watch(skipNumberProvider.notifier).state = 0;
      ref.refresh(getProductListProvider.future);
    });
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
  }

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      final state = ref.watch(getProductListProvider);
      if (!state.isLoading) {
        getNextTime();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(getProductListProvider);
    final productList = ref.watch(productListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Product List')),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: state.when(
          data: (data) => productList.isNotEmpty
              ? productListViewBuilder(productList)
              : const Center(child: CircularProgressIndicator()),
          error: (e, t) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(e.toString()),
                IconButton(
                  onPressed: () => !state.isLoading ? onRefresh() : null,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          ),
          loading: () => (productList.isNotEmpty)
              ? productListViewBuilder(productList)
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  ListView productListViewBuilder(List<ProductModel> productList) {
    final isNoMore = ref.watch(isNoMoreProvider);
    return ListView.builder(
        controller: scrollController,
        itemCount: productList.length + 1,
        itemBuilder: (context, index) {
          if (index < productList.length) {
            var product = productList[index];
            return Card(
              child: ListTile(
                leading: Image.network(
                  product.thumbnail,
                  fit: BoxFit.cover,
                  height: 100,
                  width: 100,
                ),
                title: Text("${product.id}, ${product.title}"),
                subtitle: Text(product.description),
              ),
            );
          } else {
            return isNoMore
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Center(child: Text('No More Data To Get')),
                  )
                : const Padding(
                    padding: EdgeInsets.all(28.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
          }
        });
  }
}
