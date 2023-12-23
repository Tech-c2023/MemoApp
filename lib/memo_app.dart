import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MemoListScreen(),
    );
  }
}

class MemoListScreen extends StatefulWidget {
  @override
  _MemoListScreenState createState() => _MemoListScreenState();
}

class _MemoListScreenState extends State<MemoListScreen> {
  List<String> memos = [];

  TextEditingController memoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadMemos();
  }

  Future<void> loadMemos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      memos = prefs.getStringList('memos') ?? [];
    });
  }

  Future<void> saveMemos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('memos', memos);
  }

  void addMemo(String memo) {
    setState(() {
      memos.add(memo);
      saveMemos();
    });
  }

  void editMemo(int index, String newMemo) {
    setState(() {
      memos[index] = newMemo;
      saveMemos();
    });
  }

  void deleteMemo(int index) {
    setState(() {
      memos.removeAt(index);
      saveMemos();
    });
  }

  void confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('削除しますか？'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // ダイアログを閉じる
              },
              child: Text('いいえ'),
            ),
            TextButton(
              onPressed: () {
                deleteMemo(index); // メモを削除
                Navigator.pop(context); // ダイアログを閉じる
                Navigator.pop(context); // Edit Memo画面を閉じる
              },
              child: Text('はい'),
            ),
          ],
        );
      },
    );
  }
  void clearTextField() {
    memoController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('メモアプリ'),
      ),
      body: ListView.builder(
        itemCount: memos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(memos[index]),
            onTap: () {
              memoController.text = memos[index];
              String hintText = memoController.text.isEmpty ? 'Edit your memo' : '';
              showDialog(
                context: context,
                builder: (context) {
                  return WillPopScope(
                    onWillPop: () async {
                      clearTextField(); // テキストフィールドの内容を破棄
                      return true;
                    },
                    child: AlertDialog(
                      title: Text('メモを編集'),
                      content: TextField(
                        controller: memoController,
                        decoration: InputDecoration(
                          hintText: hintText,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('キャンセル'),
                        ),
                        TextButton(
                          onPressed: () {
                            confirmDelete(index);
                          },
                          child: Text('削除'),
                        ),
                        TextButton(
                          onPressed: () {
                            if (memoController.text.isNotEmpty) {
                              editMemo(index, memoController.text);
                            }
                            Navigator.pop(context);
                          },
                          child: Text('保存'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          clearTextField(); // テキストフィールドの内容を破棄
          showDialog(
            context: context,
            builder: (context) {
              return WillPopScope(
                onWillPop: () async {
                  clearTextField(); // テキストフィールドの内容を破棄
                  return true;
                },
                child: AlertDialog(
                  title: Text('メモを追加'),
                  content: TextField(
                    controller: memoController,
                    decoration: InputDecoration(hintText: 'Enter your memo'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('キャンセル'),
                    ),
                    TextButton(
                      onPressed: () {
                        if (memoController.text.isNotEmpty) {
                          addMemo(memoController.text);
                          memoController.clear();
                        }
                        Navigator.pop(context);
                      },
                      child: Text('追加'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
