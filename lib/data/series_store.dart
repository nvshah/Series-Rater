import 'series_repository.dart';
import './models/series.dart';

class SeriesStore {
  final SeriesRepository _seriesRepository;

  SeriesStore(this._seriesRepository);

  Series _series;
  Series get series => _series;

  void getRatings(String name)async{
    _series = await _seriesRepository.fetchRatings(name);
  }
}