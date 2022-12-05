import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/presentation/bloc/search_bloc.dart';
import 'package:search/presentation/widgets/search_result.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) =>
                  context.read<SearchBloc>().add(QueryChange(query)),
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                if (state is SearchLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is SearchHasData) {
                  return SearchResult(
                    movieResults: state.movies,
                    tvResults: state.tvs,
                  );
                } else if (state is SearchError) {
                  return Center(
                    child: Text(state.message),
                  );
                } else {
                  return Center(
                    child: SizedBox(
                      child: Text(
                        'Search Movie or TV Show by title',
                        style: kSubtitle,
                      ),
                    ),
                  );
                }
              }),
            )
          ],
        ),
      ),
    );
  }
}
