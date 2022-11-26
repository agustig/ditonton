import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/cubit/on_the_air_tvs_cubit.dart';
import 'package:tv/presentation/widgets/tv_card.dart';

class OnTheAirTvsPage extends StatelessWidget {
  const OnTheAirTvsPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<OnTheAirTvsCubit>().fetch();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Airing TV Shows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<OnTheAirTvsCubit, OnTheAirTvsState>(
          builder: (context, state) {
            if (state is OnTheAirTvsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is OnTheAirTvsHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.tvs[index];
                  return TvCard(tv);
                },
                itemCount: state.tvs.length,
              );
            } else if (state is OnTheAirTvsError) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return const SizedBox(key: Key('empty_state'));
            }
          },
        ),
      ),
    );
  }
}
