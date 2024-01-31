import 'package:cooking_memo_app/recipe.dart';
import 'package:cooking_memo_app/updateGenre.dart';
import 'package:cooking_memo_app/updateMaking.dart';
import 'package:cooking_memo_app/updateMaterial.dart';
import 'package:flutter/material.dart';

import 'database.dart';
import 'recipe.dart';

class UpdatePage extends StatelessWidget{
  final Object? id;
  const UpdatePage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text("編集ページ"),
    ),body: Center(
        child: UpdateField(id: id)
      ),
    );
  }
}
class UpdateField extends StatefulWidget {
  final Object? id;
  const UpdateField({Key? key, required this.id}) : super(key: key);
  @override
  _UpdateFieldState createState() => _UpdateFieldState();
}

class _UpdateFieldState extends State<UpdateField> {

  final Provider =  DatabaseProvider.instance;
  final Recipe = RecipeInfo();
  late List<dynamic> results;
  late Map<int, String> genres;
  late Map<int, String> materials;

  String name = '';


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
                      //  レシピ名
                      TextFormField(
                        validator: (value){
                          if(value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'メニュー名',
                          hintText: '料理名を入力してください',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (String text) {
                          setState((){
                            // name = text;
                            Recipe.name = text;
                          });
                        },
                        initialValue: results[0][0]['name'],
                      ),
                      //　ジャンル
                      const Text(
                        'ジャンル：',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      //　詳細はupdateGenreファイル
                      UpdateGenre(items: genres),
                      //　材料
                      const Text(
                        '材料:',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      //　詳細はupdateMaterialファイル
                      UpdateMaterial(items: materials),
                      //　作りかた
                      const Text(
                        '作り方:',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      //　詳細はupdateMakingファイル
                      const UpdateMaking(),

                      // 登録ボタン
                      ElevatedButton(
                          onPressed: (){
                          _updateAll();
                          Navigator.pushNamedAndRemoveUntil(context, '/select',
                          ModalRoute.withName('/'));
                      },
                          child: const Text("登録")
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

  //　ページ読み込み時に動作
  Future<String> _query() async {
    String id_str = widget.id.toString();
    int? id = int.tryParse(id_str);
    //　指定したレシピの詳細を取得
    if(id != null) {
      var RecipeDetail = await Provider.queryOneRecipe(id);
      results = RecipeDetail;
      Recipe.mapQuery(results);
    }
    //　ジャンルと材料の選択肢を取得
    genres = await Provider.queryGenre();
    materials = await Provider.queryMaterial();
    return 'done';
  }

  //　すべての情報をアップデートする
  void _updateAll() async {
    String id_str = widget.id.toString();
    int? id = int.tryParse(id_str);
    if(id != null) {
      var _ = await Provider.updateRecipe(id, Recipe);
    }
    Recipe.clearRecipeData();
  }

}