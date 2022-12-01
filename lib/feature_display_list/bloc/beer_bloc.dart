import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:bloc_assessment/feature_display_list/models/model.dart';
import 'package:bloc_assessment/feature_display_list/repos/repository.dart';
import 'package:http/http.dart' as http;

part 'beer_event.dart';
part 'beer_state.dart';

class BeerBloc extends Bloc<BeerEvent, BeerState> {
  final BeerRepository beerRepository;
  int page = 1;
  bool isFetching = false;

  BeerBloc({required this.beerRepository}) : super(const BeerInitialState()) {
    on<BeerFetchEvent>((event, emit) async {
      emit(const BeerLoadingState(message: 'Loading Beers'));
      final response = await beerRepository.getBeers(page: page);
      if (response is http.Response) {
        if (response.statusCode == 200) {
          final beers = jsonDecode(response.body) as List;
          emit(
            BeerSuccessState(
              beers: beers.map((beer) => BeerModel.fromJson(beer)).toList(),
            ),
          );

          page++;
        } else {
          emit(BeerErrorState(error: response.body));
        }
      } else if (response is String) {
        emit(BeerErrorState(error: response));
      }
    });

    on<BeerRefreshEvent>((event, emit) async {
      emit(const BeerLoadingState(message: 'Loading Beers'));
      final response = await beerRepository.getBeers(page: 1);
      if (response is http.Response) {
        if (response.statusCode == 200) {
          final beers = jsonDecode(response.body) as List;
          emit(
            BeerSuccessState(
              beers: beers.map((beer) => BeerModel.fromJson(beer)).toList(),
            ),
          );

          page++;
        } else {
          emit(BeerErrorState(error: response.body));
        }
      } else if (response is String) {
        emit(BeerErrorState(error: response));
      }
    });
  }
}
