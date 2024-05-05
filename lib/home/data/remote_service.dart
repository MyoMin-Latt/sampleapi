// ignore_for_file: file_names

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sampleapi/home/feat_home.dart';

import '../../common/common.dart';

class RemoteService {
  final Dio _dio;
  RemoteService(this._dio);

  Future<Either<String, List<Products>>> getProducts(int page) async {
    try {
      final response = await _dio.get('/products?limit=3&skip=$page');
      print("response => $response");
      final resData = response.data as Map<String, dynamic>;
      if (response.statusCode == 200) {
        var data = resData['products'] as List<dynamic>;
        var jsonData = data.map((e) => Products.fromJson(e)).toList();
        return right(jsonData);
      } else {
        return left(response.statusMessage ?? '');
      }
    } on DioException catch (e) {
      return left(e.message ?? '');
    }
  }
}

final remoteServiceProvider = Provider(
  (ref) => RemoteService(ref.watch(dioProvider)),
);
