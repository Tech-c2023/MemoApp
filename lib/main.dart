import 'package:cooking_memo_app/detail.dart';
import 'package:cooking_memo_app/update.dart';
import 'package:flutter/material.dart';
import 'select.dart';
import 'update.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build (BuildContext context){
    return MaterialApp(
      initialRoute: '/select',
      routes: {
        // '/': (context) => MyHomePage(),
        // '/insert' : (context) => InsertPage(),
        '/select' : (context) => const SelectPage(),
      },
      onGenerateRoute: (settings) {
        final args = settings.arguments;
        switch(settings.name){
          case '/detail' :
            return MaterialPageRoute(
                builder: (context) =>
                    DetailPage(id: args )
            );
          case '/update' :
            return MaterialPageRoute(
                builder: (context) =>
                    UpdatePage(id: args)
            );
        }
        return null;
      },
    );
  }
}