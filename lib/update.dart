import 'package:flutter/material.dart';
import 'package:cooking_memo_app/database.dart';
import 'package:cooking_memo_app/recipe.dart';
import 'package:cooking_memo_app/updateGenre.dart';
import 'package:cooking_memo_app/updateMaking.dart';
import 'package:cooking_memo_app/updateMaterial.dart';

class UpdatePage extends StatelessWidget {
  final Object? id;

  const UpdatePage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("編集ページ"),
        centerTitle: true,
      ),
      body: UpdateField(id: id),
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
  final provider = DatabaseProvider.instance;
  final recipe = RecipeInfo();
  late List<dynamic> results;
  late Map<int, String> genres;
  late Map<int, String> materials;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _query(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
          );
        } else {
          return SingleChildScrollView(
            padding: EdgeInsets.all(34.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  initialValue: results[0][0]['name'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  decoration: InputDecoration(
                    labelText: 'レシピ名',
                    hintText: '料理名を入力してください',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (text) {
                    setState(() {
                      recipe.name = text;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Text(
                  'ジャンル：',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                SizedBox(height: 12),
                UpdateGenre(items: genres), /// updateGenre.dart
                Text(
                  '材料:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                UpdateMaterial(items: materials), /// updateMaterial.dart
                SizedBox(height: 20),
                Text(
                  '作り方:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                UpdateMaking(), /// updateMaking.dart
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _updateAll(); /* 更新クエリを実行 */
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/select', /* 一覧ページに遷移 */
                      ModalRoute.withName('/'),
                    );
                  },
                  child: Text(
                      "登録する",
                    style: TextStyle(fontSize: 40),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Future<void> _query() async {
    String idStr = widget.id.toString();
    int? id = int.tryParse(idStr);
    if (id != null) {
      recipe.clearRecipeData();
      var recipeDetail = await provider.queryOneRecipe(id);
      results = recipeDetail;
      recipe.mapQuery(results);
    }
    genres = await provider.queryGenre();
    materials = await provider.queryMaterial();
  }

  void _updateAll() async {
    String idStr = widget.id.toString();
    int? id = int.tryParse(idStr);
    if (id != null) {
      await provider.updateRecipe(id, recipe);
    }
    recipe.clearRecipeData();
  }
}
