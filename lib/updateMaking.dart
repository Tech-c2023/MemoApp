import 'package:flutter/material.dart';
import 'recipe.dart';

class UpdateMaking extends StatefulWidget {
  const UpdateMaking({Key? key}) : super(key: key);

  @override
  State<UpdateMaking> createState() => _UpdateMakingState();
}

class _UpdateMakingState extends State<UpdateMaking> {
  final Recipe = RecipeInfo();

  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            //すでに登録されているものを表示
            for (var i = 0; i < Recipe.makings.length; i++) ...{
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 20),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        Recipe.makings.removeAt(i);
                      });
                    },
                    child: Row(
                      children: [
                        Text("${i + 1} ) "), /* 例: 1) */
                        Expanded(
                          child: Text( /* 例: 卵をかき混ぜる */
                            Recipe.makings[i],
                            maxLines: 4, /* 4行まで表示可 */
                            overflow: TextOverflow.ellipsis, /* 4行以降は3点リーダー */
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            },
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  /* 手順を入力するテキストフィールド */
                  child: TextFormField(
                    validator: (value){
                      if(value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: '作り方を入力してください',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String text) {
                      Recipe.selectingMaking = text;
                    },
                    controller: TextEditingController(text: Recipe.selectingMaking),
                  ),
                ),
                SizedBox(width: 8), // ボタンとテキストフィールドの間に間隔を設ける
                /* 手順を追加するボタン */
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (!Recipe.makings.contains(Recipe.selectingMaking) && Recipe.selectingMaking != "") {
                        Recipe.makings.add(Recipe.selectingMaking);
                        Recipe.selectingMaking = "";
                      }
                    });
                  },
                  child: const Text(
                    "追加",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),

          ]
        );
  }
}