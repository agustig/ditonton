import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/cubit/popular_tvs_cubit.dart';
import 'package:tv/presentation/widgets/tv_card.dart';

class PopularTvsPage extends StatelessWidget {
  const PopularTvsPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<PopularTvsCubit>().fetch();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular TVs'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTvsCubit, PopularTvsState>(
          builder: (context, state) {
            if (state is PopularTvsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PopularTvsHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.tvs[index];
                  return TvCard(tv);
                },
                itemCount: state.tvs.length,
              );
            } else if (state is PopularTvsError) {
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
