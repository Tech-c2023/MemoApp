import 'package:flutter/material.dart';

import 'database.dart';
import 'detail.dart';
import 'update.dart';

class SelectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("一覧ページ"),
        centerTitle: true,  // 中央寄せを設定
      ),
      body: Center(
        child: SelectField(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return InsertDialog();
            },
          ).then((_) {
            // ダイアログが閉じたら画面を再読み込み
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => SelectPage()),
            );
          });
        },
        child: Icon(Icons.add),
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("メニュー名を入力してください"),
      content: TextField(
        controller: _textController,
        autofocus: true,
        decoration: InputDecoration(labelText: "メニュー名"),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("キャンセル"),
        ),
        ElevatedButton(
          onPressed: () async {
            // 登録ボタンが押されたときの処理
            final enteredText = _textController.text;

            // データベースに新しいレコードを挿入
            await DatabaseProvider.instance.insertRecipe(enteredText);

            // ダイアログを閉じる
            Navigator.of(context).pop();

            // 画面を再読み込み
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => SelectPage()),
            );
          },
          child: Text("登録"),
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
  @override
  _SelectFieldState createState() => _SelectFieldState();
}

class _SelectFieldState extends State<SelectField> {
  final Provider = DatabaseProvider.instance;
  late List<dynamic> results;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _query(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Center(
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var result in results)
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetailPage(id: result['id']),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    result['name'],
                                    style: const TextStyle(
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UpdatePage(id: result['id']),
                                    ),
                                  ).then((_) {
                                    // 画面を再読み込み
                                    setState(() {});
                                  });
                                },
                                child: const Icon(Icons.more_horiz),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          );
        } else {
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
      },
    );
  }

  Future<String> _query() async {
    var RecipeAlls = await Provider.queryRecipes();
    results = await _setMapRecipeName(RecipeAlls);
    print('すべてのデータを紹介しました。_query');
    return 'done';
  }

  Future<List<Map<String, dynamic>>> _setMapRecipeName(dynamic s) async {
    assert(s != null);
    List<Map<String, dynamic>> res = [];
    for (var element in s) {
      Map<String, dynamic> data = {
        'id': element['_id'],
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
