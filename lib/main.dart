import 'package:cooking_memo_app/detail.dart';
import 'package:cooking_memo_app/update.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'database.dart';
import 'insert.dart';
import 'select.dart';
import 'update.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build (BuildContext context){
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/insert' : (context) => InsertPage(),
        '/select' : (context) => SelectPage(),
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

class MyHomePage extends StatelessWidget {
  final Provider = DatabaseProvider.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SQLiteデモ"),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                  onPressed: _query,
                  child: const Text (
                    '照会',
                    style: TextStyle(
                        fontSize: 35
                    ),
                  )
              ),
              ElevatedButton(
                  onPressed: _queryRecipes,
                  child: const Text (
                    'レシピ名照会',
                    style: TextStyle(
                        fontSize: 35
                    ),
                  )
              ),
              ElevatedButton(
                  onPressed: _insertRecipeName,
                  child: const Text (
                    'カレー追加',
                    style: TextStyle(
                        fontSize: 35
                    ),
                  )
              ),
              ElevatedButton(
                  onPressed: (){
                    Navigator.pushNamed(context, '/insert');
                  },
                  child: const Text(
                    '登録ページへ',
                    style: TextStyle(
                        fontSize: 35
                    ),
                  )
              ),
              ElevatedButton(
                  onPressed: (){
                    Navigator.pushNamed(context, '/select');
                  },
                  child: const Text(
                    'メニュー一覧',
                    style: TextStyle(
                        fontSize: 35
                    ),
                  )
              ),

            ],
          )
      ),
    );
  }

  void _query() async {
    final allRows = await Provider.queryAllRows();
    print('すべてのデータを紹介しました。');
    // print(allRows.runtimeType);

    if (allRows.length > 0) {
      for (var table in allRows) {
        for (var row in table) {
          print(row);
        }
      }
    }
  }

  void _queryRecipes() async {
    //レシピ名の一覧を取得
    final recipeRows = await Provider.queryRecipes();
    print('レシピ名');
    if (recipeRows.length > 0) {
      for (var row in recipeRows) {
        print(row);
      }
    }
  }

  void _insertRecipeName() async {
    //  レシピ名だけを登録する
    String name = "カレーライス";
    final recipeId = await Provider.insertRecipe(name);
    print('登録しました。id : $recipeId');
  }
}