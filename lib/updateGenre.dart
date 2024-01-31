import 'package:flutter/material.dart';

import 'recipe.dart';

class UpdateGenre extends StatefulWidget {
  final Map<int, String> items;
  const UpdateGenre({Key? key, required this.items}) : super(key: key);

  @override
  State<UpdateGenre> createState() => _UpdateGenresState();
}

class _UpdateGenresState extends State<UpdateGenre> {
  final Recipe = RecipeInfo();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              //拗ねに登録、入力されたジャンルを表示
              for (String item in Recipe.genreNames.values) ... {
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: GestureDetector(
                    onTap:(){
                      setState( (){
                        //　クリックしたら、消える
                        Recipe.genreNames.removeWhere((key, value) => value == item);
                      });
                    },
                    child: Text(item),
                  ),
                )
              }
            ],
          ),
          // ジャンルのドロップダウン
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              DropdownButton(
                items: [
                  const DropdownMenuItem(
                    value: 0,
                    child: Text("未選択"),
                  ),
                  // 画面遷移時に渡されたitemsに初期登録されているジャンル名が入っている
                  for ( var key in widget.items.keys) ... {
                    DropdownMenuItem(
                      value: key,
                      child: Text(widget.items[key]!),
                    ),
                  }
                ],
                value: Recipe.selectingGenre,
                onChanged: (value) {
                  setState( () {
                    Recipe.selectingGenre = int.parse(value.toString());
                  });
                },
              ),
              //追加ボタン
              ElevatedButton(
                onPressed:  (){
                  setState( () {
                    if(!Recipe.genreNames.keys.contains(Recipe.selectingGenre) && Recipe.selectingGenre != 0) {
                      Recipe.genreNames.addAll({Recipe.selectingGenre : widget.items[Recipe.selectingGenre]!});
                    }
                  });
                },
                child: const Text(
                  "追加",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ]
          )

        ],
      ),
    );
  }
}