import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/cubit/top_rated_tvs_cubit.dart';
import 'package:tv/presentation/widgets/tv_card.dart';

class TopRatedTvsPage extends StatelessWidget {
  const TopRatedTvsPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<TopRatedTvsCubit>().fetch();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated TVs'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTvsCubit, TopRatedTvsState>(
          builder: (context, state) {
            if (state is TopRatedTvsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TopRatedTvsHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.tvs[index];
                  return TvCard(tv);
                },
                itemCount: state.tvs.length,
              );
            } else if (state is TopRatedTvsError) {
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
