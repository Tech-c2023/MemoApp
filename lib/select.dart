import 'package:flutter/material.dart';

import 'database.dart';
import 'recipe.dart';

class SelectPage extends StatelessWidget{
  const SelectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("一覧ページ"),
        centerTitle: true,
    ),body: const Center(
        child: SelectField()
    ),
      // 料理名の登録(+ボタンを右下に)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return InsertDialog();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class InsertDialog extends StatefulWidget {
  @override
  _InsertDialogState createState() => _InsertDialogState();
}

class _InsertDialogState extends State<InsertDialog> {
  final _textController = TextEditingController();
  final Provider =  DatabaseProvider.instance;

  //　メニュー名登録用ポップアップ
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("メニュー名を入力してください"),
      content: TextField(
        controller: _textController,
        autofocus: true,
        decoration: const InputDecoration(labelText: "メニュー名"),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("キャンセル"),
        ),
        ElevatedButton(
          onPressed: () async {
            // 登録ボタンが押されたときの処理
            final enteredText = _textController.text;
            if(enteredText != ""){
              // データベースに新しいレコードを挿入
              await Provider.insertRecipe(enteredText);
            }
            // ダイアログを閉じる
            Navigator.pop(context);
            //一覧を再表示
            Navigator.pushReplacementNamed(context, '/select');
          },
          child: const Text("登録"),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

class SelectField extends StatefulWidget {
  const SelectField({Key? key}) : super(key: key);

  @override
  _SelectFieldState createState() => _SelectFieldState();
}

class _SelectFieldState extends State<SelectField> {

  var Provider =  DatabaseProvider.instance;
  final Recipe = RecipeInfo();
  late List<dynamic> results;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _query(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              //一覧表示
                child:ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (BuildContext context, int index){
                      final item = results[index];
                      //　横にシュッてしたら、削除する
                      return Dismissible(
                        key: ValueKey<int>(item['id']),
                        onDismissed: (direction){
                          _deleteRecipe(item['id']);
                          results.removeAt(index);
                        },
                        background: Container(color: Colors.red),
                        child: _listItem(item['name'], item['id']),
                      );
                    }
                )
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

  //　ページの読み込み時に呼ばれる
  //　レシピテーブルから全件取ってくる
  Future<List<dynamic>> _query() async {
    try{
      var RecipeAlls = await Provider.queryRecipes();
      results = await _setMapRecipeName(RecipeAlls);
    }catch(e){
      results = await _query();
    }
    return results;

  }

  //　とってきたデータを扱いやすくするために型を整理
  Future< List<Map<String, dynamic>> > _setMapRecipeName(dynamic s) async {
    assert( s != null);
    List<Map<String, dynamic>> res = [];
    for (var element in s) {
      if(element[Provider.columnDelete] != 1){
        Map<String, dynamic> data  = {
          'id' : element[Provider.columnId],
          'name': element[Provider.columnName],
        };
        res.add(data);
      }
    }
    return res;
  }

  //　listViewで回す用のwidget
  Widget _listItem(String name, int id){
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // レシピ名のボタン
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    )
                  ),
                  onPressed:  (){
                    // 各詳細ページへ
                    Navigator.pushNamed(context, '/detail' ,arguments: id);
                  },
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              //　三点ドットのボタン
              Align(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ),
                    onPressed: (){
                      // 編集ページへ
                      Navigator.pushNamed(
                          context,
                          '/update',
                          arguments: id
                      ).then((value){
                        //　編集ページから戻ってきたら、編集時に使っていたクラスの中身を消去
                        Recipe.clearRecipeData();
                      });
                    },
                    child: const Icon(
                        Icons.more_horiz
                    )
                ),
              ),
            ]
        ),
      ],
    );
  }

  //　レシピの論理削除を呼び出す
  Future<void> _deleteRecipe(int id) async {
    var i = await Provider.deleteRecipe(id);
  }

}