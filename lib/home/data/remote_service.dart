// ignore_for_file: file_names

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sampleapi/home/feat_home.dart';

import '../../common/common.dart';

class RemoteService {
  final Dio _dio;
  RemoteService(this._dio);

  Future<Either<String, NetworkResult<List<Products>>>> getProducts(
      int page) async {
    try {
      print("getProducts page => $page");
      final response = await _dio.get('/products?limit=10&skip=$page');
      print("response => $response");
      final resData = response.data as Map<String, dynamic>;
      if (response.statusCode == 200) {
        var data = resData['products'] as List<dynamic>;
        var jsonData = data.map((e) => Products.fromJson(e)).toList();
        return right(NetworkResult.result(jsonData));
      } else {
        return left(response.statusMessage ?? '');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.unknown) {
        return right(const NetworkResult.noConnection());
      } else {
        return left(e.message ?? '');
      }
    }
  }
}

final remoteServiceProvider = Provider(
  (ref) => RemoteService(ref.watch(dioProvider)),
);
