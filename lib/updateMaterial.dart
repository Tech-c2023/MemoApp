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
    var _screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Column(
          children: [
            for (var i = 0; i < Recipe.materials.length; i++) ...{
                  Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: GestureDetector(
                      onTap:(){
                        setState( (){
                          Recipe.materials.removeAt(i);
                          Recipe.quantities.removeAt(i);
                        });
                      },
                      child: Container(
                        width: _screenSize.width*0.8,
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
                            children: <Widget>[
                              Container(
                                  width: _screenSize.width*0.4,
                                  child: Text(Recipe.materials[i])),
                              //const Text(" : "),
                              Container(
                                  alignment: Alignment.centerRight,
                                  width: _screenSize.width*0.4,
                                  child: Text(Recipe.quantities[i])),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
            }
          ],
        ),
            Container(
              width: _screenSize.width*0.8,
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

                  DropdownButton(
                    items: [
                      const DropdownMenuItem(
                        value: "",
                        child: Text("材料を選択"),
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
                  Container(
                    width: _screenSize.width*0.2,
                    alignment: Alignment.centerLeft,
                    child: TextFormField(
                      validator: (value){
                        if(value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: '数量',
                        //hintText: 'ダミーテキスト',
                        //border: OutlineInputBorder(),
                      ),
                      onChanged: (String text) {
                        setState((){
                          // name = text;
                          Recipe.selectingQuantity = text;
                        });
                      },
                      initialValue: Recipe.selectingQuantity,
                    ),
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
                ],
              ),
            ),



          ]
        );
  }
}