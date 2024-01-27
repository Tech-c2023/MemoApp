import 'package:flutter/material.dart';

import 'recipe.dart';

class UpdateGenre extends StatefulWidget {
  final List<Map<String, dynamic>> items;
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
              for (String item in Recipe.genreNames) ... {
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: GestureDetector(
                    onTap:(){
                      setState( (){
                        Recipe.genreNames.remove(item);
                      });
                    },
                    child: Text(item),
                  ),
                )
              }
            ],
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              DropdownButton(
                items: [
                  const DropdownMenuItem(
                    value: "",
                    child: Text("未選択"),
                  ),
                  for ( var genre in widget.items) ... {
                    DropdownMenuItem(
                      value: genre['name'].toString(),
                      child: Text(genre['name']),
                    ),
                  }
                ],
                value: Recipe.selectingGenre,
                onChanged: (String? value) {
                  setState( () {
                    Recipe.selectingGenre = value!;
                  });
                },
              ),
              ElevatedButton(
                onPressed:  (){
                  setState( () {
                    if(!Recipe.genreNames.contains(Recipe.selectingGenre) && Recipe.selectingGenre != "") {
                      Recipe.genreNames.add(Recipe.selectingGenre);
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