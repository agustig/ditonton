import 'package:ditonton/data/models/tv_model.dart';
import 'package:equatable/equatable.dart';

class TvResponse extends Equatable {
  final List<TvModel> tvList;

  TvResponse({required this.tvList});

  factory TvResponse.fromJson(Map<String, dynamic> json) {
    return TvResponse(
      tvList: List<TvModel>.from(
        (json["results"] as List).map((x) => TvModel.fromJson(x)).where(
            (element) =>
                element.posterPath != null && element.overview.isNotEmpty),
      ),
    );
  }

  @override
  List<Object> get props => [tvList];
}
