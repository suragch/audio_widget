import 'package:flutter/material.dart';
import 'package:audio_widget/audio_widget.dart';
import 'package:provider_architecture/provider_architecture.dart';

import 'audio_viewmodal.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('AudioWidget demo')),
        body: Center(child: Body()),
      ),
    );
  }
}

class Body extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    print('rebuilding');
    return ViewModelProvider<AudioViewModel>.withConsumer(
      viewModel: AudioViewModel(),
      onModelReady: (model) => model.loadData(),
      builder: (context, model, child) => AudioWidget(
        isPlaying: model.isPlaying,
        onPlayStateChanged: (bool isPlaying) {
          print('playing: $isPlaying');
          if (isPlaying) {
            model.play();
          } else {
            model.pause();
          }
        },
        currentTime: model.currentTime,
        onSeekBarMoved: (Duration newCurrentTime) {
          model.seek(newCurrentTime);
        },
        totalTime: model.totalTime,
      ),
    );
  }
}

//import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import 'package:audio_widget/audio_widget.dart';
//
//void main() => runApp(MyApp());
//
//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return ChangeNotifierProvider<MyModel>( //      <--- ChangeNotifierProvider
//      create: (context) => MyModel(),
//      child: MaterialApp(
//        home: Scaffold(
//          appBar: AppBar(title: Text('My App')),
//          body: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//
//              Container(
//                  padding: const EdgeInsets.all(20),
//                  color: Colors.green[200],
//                  child: Consumer<MyModel>( //                  <--- Consumer
//                    builder: (context, myModel, child) {
//                      return RaisedButton(
//                        child: Text('Do something'),
//                        onPressed: (){
//                          myModel.doSomething();
//                        },
//                      );
//                    },
//                  )
//              ),
//              Consumer<MyModel>(
//                builder: (context, myModel, child) {
//                  return AudioWidget(
//                    currentTime: myModel.currentTime,
//                    totalTime: myModel.someTime,
//                  );
//                },
//              ),
//
//
//              Container(
//                padding: const EdgeInsets.all(35),
//                color: Colors.blue[200],
//                child: Consumer<MyModel>( //                    <--- Consumer
//                  builder: (context, myModel, child) {
//                    return Text(myModel.someValue);
//                  },
//                ),
//              ),
//
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}
//
//class MyModel with ChangeNotifier { //                          <--- MyModel
//  String someValue = 'Hello';
//  Duration someTime = Duration(minutes: 2);
//  Duration currentTime = Duration(seconds: 30);
//
//  void doSomething() {
//    someValue = 'Goodbye';
//    someTime = Duration(minutes: 3);
//    currentTime = Duration(minutes: 1);
//    print(someValue);
//    notifyListeners();
//  }
//}