import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/on_the_air_tvs_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnTheAirTvsPage extends StatefulWidget {
  static const ROUTE_NAME = '/on_the_air';

  @override
  _OnTheAirTvsPageState createState() => _OnTheAirTvsPageState();
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
        title: Text('Airing TV Shows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<OnTheAirTvsNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.loading) {
              return Center(
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
                key: Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}
