import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sampleapi/home/domain/product_model.dart';
import 'package:sampleapi/home/state/product_state.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final scrollController = ScrollController();
  int page = 0;
  @override
  void initState() {
    super.initState();
    getProducts();
    scrollController.addListener(_scrollListener);
  }

  Future<void> _scrollListener() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      final state = ref.watch(productStateNotfierProvider);

      state.maybeWhen(
        orElse: () => getProducts(),
        loading: (_) {},
      );
    }
  }

  Future<void> getProducts() async {
    Future.microtask(
      () {
        page == 0
            ? ref
                .read(productStateNotfierProvider.notifier)
                .getProductsFirstPage(page)
            : ref.read(productStateNotfierProvider.notifier).getProducts(page);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ProductState>(productStateNotfierProvider, (previous, next) {
      next.maybeWhen(
          orElse: () {},
          success: (_) {
            setState(() {
              page += 10;
            });
          });
    });

    final state = ref.watch(productStateNotfierProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: state.when(
          initial: (data) =>
              data.isEmpty ? const SizedBox() : productListView(data),
          loading: (data) => data.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : productListView(data),
          empty: (data) => data.isEmpty
              ? const Center(child: Text('Empty Data'))
              : productListView(data),
          noInternet: (data) => data.isEmpty
              ? const Center(child: Text('Connection Error'))
              : productListView(data),
          success: (data) {
            return productListView(data);
          },
          error: (_, data) => data.isEmpty
              ? const Center(child: Text('Empty Data'))
              : productListView(data),
        ));
  }

  Widget productListView(List<Products> data) {
    final state = ref.watch(productStateNotfierProvider);
    return RefreshIndicator(
      onRefresh: () {
        setState(() {
          page = 0;
        });
        return getProducts();
      },
      child: ListView.builder(
        controller: scrollController,
        itemCount: state.maybeMap(
            orElse: () => data.length, loading: (_) => data.length + 1),
        itemBuilder: (context, index) {
          if (index < data.length) {
            var product = data[index];
            return Card(
              child: ListTile(
                leading: Image.network(
                  product.thumbnail!,
                  fit: BoxFit.cover,
                  height: 100,
                  width: 100,
                ),
                title: Text("${product.id}, ${product.title!}"),
                subtitle: Text(product.description!),
              ),
            );
          } else {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(18.0),
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
