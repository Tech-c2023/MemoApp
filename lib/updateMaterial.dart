import 'package:flutter/material.dart';

import 'recipe.dart';

class UpdateMaterial extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  const UpdateMaterial({Key? key, required this.items}) : super(key: key);

  @override
  State<UpdateMaterial> createState() => _UpdateMaterialState();
}

class _UpdateMaterialState extends State<UpdateMaterial> {
  final Recipe = RecipeInfo();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            for (var i = 0; i < Recipe.materials.length; i++) ...{
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: GestureDetector(
                      onTap:(){
                        setState( (){
                          Recipe.materials.removeAt(i);
                          Recipe.quantities.removeAt(i);
                        });
                      },
                      child: Row(
                        children: [
                          Text(Recipe.materials[i]),
                          const Text(" : "),
                          Text(Recipe.quantities[i]),
                        ],
                      ),
                    ),
                  ),
            }
          ],
        ),

            DropdownButton(
              items: [
                const DropdownMenuItem(
                  value: "",
                  child: Text("未選択"),
                ),
                for ( var material in widget.items) ... {
                  DropdownMenuItem(
                    value: material['name'].toString(),
                    child: Text(material['name']),
                  ),
                }
              ],
              value: Recipe.selectingMaterial,
              onChanged: (String? value) {
                setState( () {
                  Recipe.selectingMaterial = value!;
                });
              },
            ),
              TextFormField(
                validator: (value){
                  if(value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: '数量',
                  border: OutlineInputBorder(),
                ),
                onChanged: (String text) {
                  setState((){
                    // name = text;
                    Recipe.selectingQuantity = text;
                  });
                },
                initialValue: Recipe.selectingQuantity,
              ),
            ElevatedButton(
              onPressed:  (){
                setState( () {
                  if(!Recipe.materials.contains(Recipe.selectingMaterial) && Recipe.selectingMaterial != "" && Recipe.selectingQuantity != "") {
                    Recipe.materials.add(Recipe.selectingMaterial);
                    Recipe.quantities.add(Recipe.selectingQuantity);
                    print(Recipe.materials);
                    print(Recipe.quantities);
                    Recipe.selectingMaterial = "";
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
          ]
        );
  }
}