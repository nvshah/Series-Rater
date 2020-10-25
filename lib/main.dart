import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import './data/series_store.dart';
import './data/series_repository.dart';
import './pages/search_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primaryColor: Colors.indigo,
      ),
      //We need to inject the Store we want to access down the levels
      home: Injector(
        inject: [
          Inject<SeriesStore>(() => SeriesStore(FakeRatingsRepository())),
        ],
        builder: (context) => SearchPage(),
      ),
    );
  }
}