import 'package:flutter/material.dart';

import 'recipe.dart';

class UpdateMaterial extends StatefulWidget {
  final Map<int, String> items;
  const UpdateMaterial({Key? key, required this.items}) : super(key: key);

  @override
  State<UpdateMaterial> createState() => _UpdateMaterialState();
}

class _UpdateMaterialState extends State<UpdateMaterial> {
  final Recipe = RecipeInfo();

  @override
  Widget build(BuildContext context) {
    var _screenSize = MediaQuery
        .of(context)
        .size;
    return Column(
        children: [
          Column(
            children: [
              //　すでに登録されたものを表示
              for (var item in Recipe.materials.keys) ...{
                GestureDetector(
                  onTap: () {
                    //クリックしたら消える
                    setState(() {
                      Recipe.materials.removeWhere((key, value) => key == item);
                      Recipe.quantities.removeWhere((key, value) =>
                      key == item);
                    });
                  },
                  child: Container(
                    width: _screenSize.width * 0.8,
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                              color: Colors.black,
                              width: 1,
                            )
                        )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              width: _screenSize.width * 0.4,
                              child: Text(Recipe.materials[item]!)
                          ),
                          Container(
                              alignment: Alignment.centerRight,
                              width: _screenSize.width * 0.4,
                              child: Text(Recipe.quantities[item]!)
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              }
            ],
          ),
          Container(
            width: _screenSize.width * 0.8,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                      color: Colors.black,
                      width: 1,
                    )
                )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //材料のドロップダウン
                DropdownButton(
                  items: [
                    const DropdownMenuItem(
                      value: 0,
                      child: Text("材料を選択"),
                    ),
                    for ( var key in widget.items.keys) ... {
                      DropdownMenuItem(
                        value: key,
                        child: Text(widget.items[key]!),
                      ),
                    }
                  ],
                  value: Recipe.selectingMaterial,
                  onChanged: (value) {
                    setState(() {
                      Recipe.selectingMaterial = int.parse(value.toString());
                    });
                  },
                ),

                //　分量の入力
                Container(
                  width: _screenSize.width * 0.2,
                  alignment: Alignment.centerLeft,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: '分量',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String text) {
                      Recipe.selectingQuantity = text;
                    },
                    controller: TextEditingController(
                        text: Recipe.selectingQuantity),
                  ),
                ),
                //　追加ボタン
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (!Recipe.materials.keys.contains(
                          Recipe.selectingMaterial) &&
                          Recipe.selectingMaterial != 0 &&
                          Recipe.selectingQuantity != "") {
                        Recipe.materials.addAll(
                            {Recipe.selectingMaterial: widget.items[Recipe
                                .selectingMaterial]!});
                        Recipe.quantities.addAll({
                          Recipe.selectingMaterial: Recipe.selectingQuantity
                        });
                        Recipe.selectingMaterial = 0;
                        Recipe.selectingQuantity = "";
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
              ],
            ),
          ),
        ]
    );
  }
}
