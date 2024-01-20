import 'package:flutter/material.dart';

import 'database.dart';

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
  late List<dynamic> results;

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
                      TextFormField(
                        validator: (value){
                          if(value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'メニュー名',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (String text) {
                          setState((){
                            name = text;
                          });
                        },
                        initialValue: results[0][0]['name'],
                      ),
                      for(var genre in results[1])
                        Text(genre),
                      for(var material in results[2])
                        Text(material),
                      for(var making in results[3])
                        Text(making)
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

  Future<String> _query() async {
    String id_str = widget.id.toString();
    int? id = int.tryParse(id_str);
    if(id != null) {
      var RecipeDetail = await Provider.queryOneRecipe(id);
      results = RecipeDetail;
    }
    return 'done';
  }

}