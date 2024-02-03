import 'package:flutter/material.dart';
import 'database.dart';

class DetailPage extends StatelessWidget {
  final Object? id;

  const DetailPage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("詳細ページ"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // 編集ボタンを押したらupdate.dartに遷移
              Navigator.pushNamed(context, '/update', arguments: id);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: DetailField(id: id),
        ),
      ),
    );
  }
}


class DetailField extends StatefulWidget {
  final Object? id;

  const DetailField({Key? key, required this.id}) : super(key: key);

  @override
  _DetailFieldState createState() => _DetailFieldState();
}

class _DetailFieldState extends State<DetailField> {
  final Provider = DatabaseProvider.instance;
  late List<dynamic> results;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _query(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(34.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  /* 料理名を表示 */
                  '${results[0][0]['name']}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                ),
                SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  children: results[1]
                      /* ジャンルタグを表示 */
                      .map<Widget>((genre) => Chip(label: Text('#${genre['name']}'))).toList(),
                ),
                SizedBox(height: 40),
                Text(
                  '材料:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: results[2]
                      .map<Widget>((material) => Text(
                    /* 材料を表示 */
                    ' - ${material['name']}: ${material['quantity']}',
                    style: TextStyle(fontSize: 20),
                  ))
                      .toList(),
                ),
                SizedBox(height: 40),
                Text(
                  '作り方:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: results[3].length,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            /* 作り方を表示 例 1)ご飯をレンジで温める */
                            ' ${results[3][index]['orderNum']}) ${results[3][index]['body']}',
                            style: TextStyle(fontSize: 20),
                          ),
                          Divider(), // 区切り線を追加
                        ],
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(), // 区切り線を追加
                          Text(
                            ' ${results[3][index]['orderNum']}) ${results[3][index]['body']}',
                            style: TextStyle(fontSize: 20),
                          ),
                          Divider(), // 区切り線を追加
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          );
        }  else if (snapshot.hasError) {
          print(snapshot.error);
          return Icon(
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
    String id_str = widget.id.toString();
    int? id = int.tryParse(id_str);
    if (id != null) {
      var RecipeDetail = await Provider.queryOneRecipe(id);
      results = RecipeDetail;
      print(results);
    }
    return 'done';
  }
}
