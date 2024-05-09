import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sampleapi/common/common.dart';
import 'package:sampleapi/product/feat_product.dart';

final getProductProvider =
    FutureProvider.autoDispose<ProductModel>((ref) async {
  final dio = ref.watch(dioProvider);
  return getProduct(dio);
});

Future<ProductModel> getProduct(Dio dio) async {
  try {
    final response = await dio.get('/products/1');
    final resData = response.data as Map<String, dynamic>;
    if (response.statusCode == 200) {
      var jsonData = ProductModel.fromMap(resData as dynamic);
      return jsonData;
    } else {
      return Future.error(response.statusMessage ?? 'Api response error');
    }
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.unknown) {
      return Future.error('Internet error');
    } else {
      return Future.error(e.message ?? 'Something wrongs');
    }
  }
}

final skipNumberProvider = StateProvider.autoDispose<int>((ref) {
  return 0;
});

final getProductListProvider =
    FutureProvider.autoDispose<List<ProductModel>>((ref) async {
  final dio = ref.watch(dioProvider);
  // final skipNumber = ref.read(skipNumberProvider.notifier);
  Future<List<ProductModel>> getProducts =
      getProductList(dio, ref.watch(skipNumberProvider));

  getProducts.then((value) {
    if (value.isNotEmpty) {
      ref.read(productListProvider).addAll(value);
    } else {
      ref.read(isNoMoreProvider.notifier).state = true;
    }
  });
  return getProducts;
});

Future<List<ProductModel>> getProductList(Dio dio, int skipNumber) async {
  try {
    final response = await dio.get('/products?limit=10&skip=$skipNumber');
    final resData = response.data as Map<String, dynamic>;
    if (response.statusCode == 200) {
      var data = resData['products'] as List<dynamic>;
      var jsonData = data.map((e) => ProductModel.fromMap(e)).toList();
      return jsonData;
    } else {
      return Future.error(response.statusMessage ?? 'Api response error');
    }
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.unknown) {
      return Future.error('Internet error');
    } else {
      return Future.error(e.message ?? 'Something wrongs');
    }
  }
}

final isNoMoreProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});

class ProductListNotifier extends Notifier<List<ProductModel>> {
  @override
  build() => [];
}

final productListProvider =
    NotifierProvider<ProductListNotifier, List<ProductModel>>(
  ProductListNotifier.new,
);
