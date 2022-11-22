import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv/presentation/provider/on_the_air_tvs_notifier.dart';
import 'package:tv/presentation/widgets/tv_card.dart';

class OnTheAirTvsPage extends StatefulWidget {
  const OnTheAirTvsPage({super.key});

  @override
  State<OnTheAirTvsPage> createState() => _OnTheAirTvsPageState();
}

class _OnTheAirTvsPageState extends State<OnTheAirTvsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<OnTheAirTvsNotifier>(context, listen: false)
          .fetchOnTheAir(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Airing TV Shows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<OnTheAirTvsNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.state == RequestState.loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = data.tvList[index];
                  return TvCard(tv);
                },
                itemCount: data.tvList.length,
              );
            } else {
              return Center(
                key: const Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}
