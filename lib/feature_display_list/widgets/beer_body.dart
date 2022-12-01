import 'package:bloc_assessment/feature_display_list/bloc/beer_bloc.dart';
import 'package:bloc_assessment/feature_display_list/models/model.dart';
import 'package:bloc_assessment/feature_display_list/widgets/beer_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BeerBody extends StatelessWidget {
  final List<BeerModel> _beers = [];
  final ScrollController _scrollController = ScrollController();

  BeerBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocConsumer<BeerBloc, BeerState>(
        listener: (context, beerState) {
          if (beerState is BeerLoadingState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(beerState.message)));
          } else if (beerState is BeerSuccessState) {
            context.read<BeerBloc>().isFetching = false;
          } else if (beerState is BeerSuccessState && beerState.beers.isEmpty) {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('No more beers')));
          } else if (beerState is BeerErrorState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(beerState.error)));
            context.read<BeerBloc>().isFetching = false;
          }
          return;
        },
        builder: (context, beerState) {
          if (beerState is BeerInitialState ||
              beerState is BeerLoadingState && _beers.isEmpty) {
            return const CircularProgressIndicator();
          } else if (beerState is BeerSuccessState) {
            _beers.addAll(beerState.beers);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          } else if (beerState is BeerErrorState && _beers.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    context.read<BeerBloc>()
                      ..isFetching = true
                      ..add(const BeerFetchEvent());
                  },
                  icon: const Icon(Icons.refresh),
                ),
                const SizedBox(height: 15),
                Text(beerState.error, textAlign: TextAlign.center),
              ],
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              if (context.read<BeerBloc>().isFetching) {
                context.read<BeerBloc>().add(const BeerRefreshEvent());
              }
            },
            child: ListView.separated(
              controller: _scrollController
                ..addListener(() {
                  if (_scrollController.offset ==
                          _scrollController.position.maxScrollExtent &&
                      !context.read<BeerBloc>().isFetching) {
                    context.read<BeerBloc>()
                      ..isFetching = true
                      ..add(const BeerFetchEvent());
                  }
                }),
              itemBuilder: (context, index) => BeerListItem(_beers[index]),
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemCount: _beers.length,
            ),
          );
        },
      ),
    );
  }
}
