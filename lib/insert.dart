import 'package:flutter/material.dart';

import 'database.dart';

class InsertPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('登録ページ'),
      ),
      body: Center(
          child: InsertTextField()
      ),
    );
  }

}

class InsertTextField extends StatefulWidget {
  @override
  _InsertTextFieldState createState() => _InsertTextFieldState();
}

class _InsertTextFieldState extends State<InsertTextField> {
  final Provider = DatabaseProvider.instance;
  String name = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
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
                    ),
                  ),
                  Text(
                    'メニュー名 : $name',
                    style: const TextStyle(
                      fontSize: 28,
                    ),
                  ),

                ],
              )
          ),

          ElevatedButton(
              onPressed: (){
                Navigator.pushNamedAndRemoveUntil(context, '/select', ModalRoute.withName('/'));
                if (_formKey.currentState!.validate()) {
                  _insert();
                }

              },
              child: const Text(
                '登録',
                style: TextStyle(
                  fontSize: 32,
                ),
              )
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                '戻る',
                style: TextStyle(
                  fontSize: 32,
                ),
              )
          )
        ],
      ),
    );
  }

  void _insert() async {
    final id = await Provider.insertRecipe(name);
    print('登録しました。id : $id');
  }
}

