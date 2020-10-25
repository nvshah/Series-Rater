import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../data/models/series.dart';
import '../data/series_store.dart';
import '../data/series_repository.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Series Search"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        // TODO: Implement with states_rebuilder
        child: StateBuilder<SeriesStore>(
          //reactive -> ReactiveModel<SeriesStore>
          models: [Injector.getAsReactive<SeriesStore>()],
          builder: (ctxt, reactiveModel) {
            // if(reactiveModel.isWaiting){
            //   return buildLoading()
            // }else if(reactiveModel.hasData){
            //   return buildColumnWithData(reactiveModel.state.series);
            // }
            // //isIdle or Error
            // return buildInitialInput();

            //Exhaustive Switch
            return reactiveModel.whenConnectionState(
              onIdle: () => buildInitialInput(),
              onWaiting: () => buildLoading(),
              onError: (_) => buildInitialInput(),
              onData: (store) => buildColumnWithData(store.series),
            );
          },
        ),
        //child: buildInitialInput(),
      ),
    );
  }

  Widget buildInitialInput() {
    return Center(
      child: InputField(),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Column buildColumnWithData(Series series) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          series.name,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          // Display the ratings with 1 decimal place
          "${series.ratings.toStringAsFixed(1)} <--#",
          style: TextStyle(fontSize: 80),
        ),
        InputField(),
      ],
    );
  }
}

class InputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        onSubmitted: (value) => submitName(context, value),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Enter a name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  //submit name to get ratings for the same
  void submitName(BuildContext context, String name) {
    // TODO: Get ratings for the series
    final reactiveModel = Injector.getAsReactive<SeriesStore>();
    reactiveModel.setState(
      (store) => store.getRatings(name),
      //handle error from call side & without any setup on our side
      onError: (context, error) {
        if (error is NetworkError) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content:
                  Text("Couldn't fetch the Ratings. Is the device is online ?"),
            ),
          );
        }else{
          //Rethrow an unexpected error
          throw error;
        }
      },
    );
  }
}
