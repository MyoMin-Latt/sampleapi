import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sampleapi/product/feat_product.dart';

import '../../common/common.dart';

class RemoteService {
  final Dio _dio;
  RemoteService(this._dio);

  Future<ProductModel> getProduct() async {
    try {
      final response = await _dio.get('/products/1');
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
}

final productRemoteServiceProvider = Provider(
  (ref) => RemoteService(ref.watch(dioProvider)),
);
