import 'package:cooking_memo_app/update.dart';
import 'package:flutter/material.dart';

import 'database.dart';
import 'detail.dart';

class SelectPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text("一覧ページ"),
    ),body: Center(
        child: SelectField()
    ),
    );
  }
}
class SelectField extends StatefulWidget {
  @override
  _SelectFieldState createState() => _SelectFieldState();
}

class _SelectFieldState extends State<SelectField> {

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
                      for (var result in results)
                        Column(
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                      onPressed:  (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => DetailPage(id: result['id']))
                                        );
                                      },
                                      child: Text(
                                        result['name'],
                                        style: const TextStyle(
                                          fontSize: 24,
                                        ),
                                      ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: ElevatedButton(
                                        onPressed: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => UpdatePage(id: result['id']))
                                          );
                                        },
                                        child: const Icon(
                                            Icons.more_horiz
                                        )
                                    ),
                                  ),
                                ]
                              ),
                          ],
                        )
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

  Future<String> _query() async {
    // var allRows = await Provider.queryAllRows();
    var RecipeAlls = await Provider.queryRecipes();
    print(RecipeAlls);
    results = await _setMapRecipeName(RecipeAlls);

    print('すべてのデータを紹介しました。_query');
    return 'done';
  }

  Future< List<Map<String, dynamic>> > _setMapRecipeName(dynamic s) async {
    assert( s != null);
    List<Map<String, dynamic>> res = [];
    for (var element in s) {
      Map<String, dynamic> data  = {
        'id' : element['_id'],
        'name': element['name'],
      };
      res.add(data);
    }
    return res;
  }

  void initState() {
    super.initState();
    _query();
  }
}