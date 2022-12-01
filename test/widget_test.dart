// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:bloc_assessment/feature_display_list/bloc/beer_bloc.dart';
import 'package:bloc_assessment/feature_display_list/repos/repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:http_mock_adapter/http_mock_adapter.dart';

class MockApiService extends Mock implements BeerRepository {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  group("Testing Product listing ", () {
    late Dio dio;
    late DioAdapter dioAdapter;

    const homeScreenurl = "https://api.punkapi.com/v2/beers";

    final sampleTestData = {
      "id": 1,
      "name": "Buzz",
      "tagline": "A Real Bitter Experience.",
      "description":
          "A light, crisp and bitter IPA brewed with English and American hops. A small batch brewed only once.",
      "image_url": "https://images.punkapi.com/v2/keg.png",
    };

    setUp(() {
      dio = Dio();
      dioAdapter = DioAdapter(dio: dio);
      dio.httpClientAdapter = dioAdapter;
    });
    blocTest<BeerBloc, BeerState>(
      "When list is empty",
      setUp: (() {
        dioAdapter.onGet(homeScreenurl, (server) {
          server.reply(200, []);
        });
      }),
      build: () => BeerBloc(beerRepository: BeerRepository()),
      act: (bloc) => bloc.add(const BeerFetchEvent()),
      wait: const Duration(microseconds: 500),
      expect: () => [const BeerLoadingState(message: 'Loading Beers')],
    );

    blocTest<BeerBloc, BeerState>(
      'When data is not empty',
      setUp: (() {
        return dioAdapter.onGet(
          homeScreenurl,
          (request) => request.reply(200, sampleTestData),
        );
      }),
      build: () => BeerBloc(beerRepository: BeerRepository()),
      act: (bloc) => bloc.add(const BeerFetchEvent()),
      wait: const Duration(microseconds: 500),
      expect: () => [
        const BeerLoadingState(message: 'Loading Beers'),
      ],
    );
  });
}
