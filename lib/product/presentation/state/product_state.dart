import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ApiState { loading, error, noInternet, data }

final apiStateProvider = StateProvider<ApiState>((ref) {
  return ApiState.loading;
});

final errorProvider = StateProvider<String>((ref) {
  return 'Check Error';
});

final loadingProvider = StateProvider<bool>((ref) {
  return false;
});

final dataProvider = StateProvider<Object>((ref) {
  return Object;
});
