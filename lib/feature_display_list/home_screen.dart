import 'package:bloc_assessment/di/injector.dart';
import 'package:bloc_assessment/feature_display_list/bloc/beer_bloc.dart';
import 'package:bloc_assessment/feature_display_list/repos/repository.dart';
import 'package:bloc_assessment/feature_display_list/widgets/beer_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DisplayBeerScreen extends StatelessWidget {
  const DisplayBeerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BeerBloc(
        beerRepository: getIt<BeerRepository>(),
      )..add(const BeerFetchEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Beers \u{1F37A}'),
        ),
        body: BeerBody(),
      ),
    );
  }
}
