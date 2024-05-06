import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sampleapi/home/feat_home.dart';

part 'product_state.freezed.dart';

@freezed
class ProductState with _$ProductState {
  const factory ProductState.initial(List<Products> data) = _Initial;
  const factory ProductState.loading(List<Products> data) = _Loading;
  const factory ProductState.empty(List<Products> data) = _Empty;
  const factory ProductState.noInternet(List<Products> data) = _NoInternet;
  const factory ProductState.success(List<Products> data) = _Success;
  const factory ProductState.error(String message, List<Products> data) =
      _Error;
}

class ProductStateNotifier extends StateNotifier<ProductState> {
  final RemoteService _remoteService;
  ProductStateNotifier(this._remoteService)
      : super(const ProductState.initial([]));

  Future<void> getProductsFirstPage(int page) async {
    print('getProductsFirstPage $page');
    state = const ProductState.initial([]);
    await getProducts(page);
  }

  Future<void> getProducts(int page) async {
    state = ProductState.loading(state.data);
    final result = await _remoteService.getProducts(page);
    state = result.fold(
      (l) => ProductState.error(l, state.data),
      (r) => r.when(
          noConnection: () => ProductState.noInternet(state.data),
          result: (data) => data.isEmpty
              ? ProductState.empty(state.data)
              : ProductState.success([...state.data, ...data])),
    );
  }
}

final productStateNotfierProvider =
    StateNotifierProvider<ProductStateNotifier, ProductState>((ref) {
  return ProductStateNotifier(ref.watch(remoteServiceProvider));
});

final pageProvider = StateProvider.autoDispose<int>((ref) => 0);
