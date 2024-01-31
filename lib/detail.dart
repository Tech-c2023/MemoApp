import 'package:flutter/material.dart';

import 'database.dart';

//　一覧ページからレシピのIDを受け取る
class DetailPage extends StatelessWidget{
  final Object? id;
  const DetailPage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text("詳細ページ"),
    ),body: Center(
        child: DetailField(id: id)
    ),
    );
  }
}
class DetailField extends StatefulWidget {
  final Object? id;
  const DetailField({Key? key, required this.id}) : super(key: key);
  @override
  _DetailFieldState createState() => _DetailFieldState();
}

class _DetailFieldState extends State<DetailField> {

  final Provider =  DatabaseProvider.instance;
  late List<dynamic> results;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _query(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(results[0][0]['name']),
                      for(var genre in results[1])
                        Text(genre.toString()),
                      for(var material in results[2])
                        Text(material.toString()),
                      for(var making in results[3])
                        Text(making.toString())
                    ],
                  )
              ),
            );
          }else if (snapshot.hasError) {
            print(snapshot.error);
              return const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                );
          }else{
            return Center(
              child: Column(
                children: const [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting result...'),
                  ),
                ],
              ),
            );
        }
    }
    );
  }

  //　指定されたレシピの内容をすべて取得
  Future<String> _query() async {
    String id_str = widget.id.toString();
    int? id = int.tryParse(id_str);
    if(id != null) {
      var RecipeDetail = await Provider.queryOneRecipe(id);
      results = RecipeDetail;
      print(results);
    }
    return 'done';
  }

  // dynamic _
}