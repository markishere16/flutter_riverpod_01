import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// A Counter example implemented with riverpod

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class FakeHttpClient {
  Future<String> get(String url) async {
    await Future.delayed(const Duration(seconds: 1));
    return 'Response from $url';
  }
}

final fakeHttpClientProvider = Provider((ref) => FakeHttpClient());
final responseProvider =
    FutureProvider.autoDispose.family<String, String>((ref, url) async {
  final httpClient = ref.read(fakeHttpClientProvider);
  return httpClient.get(url);
});

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod Tutorial',
      home: Scaffold(
        body: Center(
          child: Consumer(
            builder: (context, watch, child) {
              final responseAsyncValue =
                  watch(responseProvider('https://flutter.dev'));
              return responseAsyncValue.map(
                data: (_) => Text(_.value),
                loading: (_) => CircularProgressIndicator(),
                error: (_) => Text(
                  _.error.toString(),
                  style: TextStyle(color: Colors.red),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
