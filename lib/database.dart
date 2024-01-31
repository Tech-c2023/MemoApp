import 'package:cooking_memo_app/recipe.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// このファイルにはデータベースに対する操作のコードが書いてあります

class DatabaseProvider {

  // とりあえずデータベース内で使う名称を何度も書くと間違えたりして面倒なので、
  // 最初に定数として定義しておきます
  static const _databaseName = "cookingMemo.db";
  static const _databaseVersion = 1;

  final String tableRecipes = "recipes";
  final String columnId = "_id";
  final String columnName = "name";
  final String columnImage = "imageFilename";
  final String columnDelete = "deleteFlag";
  final String columnLike = "likeFlag";
  final String columnCreate = "createdAt";

  final String tableGenres = "genres";
  final String columnPrimary = "primaryNum";

  final String tableRecipeGenre = "recipeGenre";
  final String columnRecipeId = "recipeId";
  final String columnGenreId = "genreId";

  final String tableMaterials = "materials";

  final String tableRecipeMaterial = "recipeMaterial";
  final String columnMaterialId = "materialId";
  final String columnQuantity = "quantity";

  final String tableMaking = "makings";
  final String columnBody = "body";
  final String columnOrder = "orderNum";

  // 以下はこのクラスをシングルトンにするためのもの。だと思います。
  // 何度クラスを呼んでも、作られるインスタンスは1つだけです。
  DatabaseProvider._privateConstructor();
  static final DatabaseProvider instance = DatabaseProvider._privateConstructor();
  Database? _database;
  Future<Database?> get database async {
    //database 削除用
    // String path = join(await getDatabasesPath(), _databaseName);
    // await deleteDatabase(path);
    if (_database != null) return _database;
    _database = await _initDatabase();
  }

  //  初めてインスタンスが作られるときに呼ばれるメソッド
  //  テーブルの生成等
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion,
        onCreate: _onCreate);
  }

  /// テーブルのCREATE文
  Future _onCreate(Database db, int version) async {
    print("onCreate");
    //　大本となるレシピのテーブル
    await db.execute('''
      CREATE TABLE $tableRecipes (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnImage TEXT DEFAULT NULL,
        $columnDelete INTEGER DEFAULT 0,
        $columnLike INTEGER DEFAULT 0,
        $columnCreate TEXT DEFAULT ( datetime('now', 'localtime') )
        )
    '''
    );
    //制作者側で用意したジャンルを格納するテーブル
    await db.execute('''
      CREATE TABLE $tableGenres (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnPrimary INTEGER DEFAULT 0
      )
    '''
    );
    //　それぞれのレシピとジャンルの関係を入れるテーブル
    await db.execute('''
      CREATE TABLE $tableRecipeGenre (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnRecipeId INTEGER NOT NULL,
        $columnGenreId INTEGER NOT NULL,
        FOREIGN KEY ( $columnRecipeId ) REFERENCES $tableRecipes ( $columnId ),
        FOREIGN KEY ( $columnGenreId ) REFERENCES $tableGenres ( $columnId )
      )
    '''
    );
    // 制作者側で用意した材料を格納するテーブル
    await db.execute('''
      CREATE TABLE $tableMaterials (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL
      )
    '''
    );
    //　それぞれのレシピと材料の関係を入れるテーブル
    await db.execute('''
      CREATE TABLE $tableRecipeMaterial (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnRecipeId INTEGER NOT NULL,
        $columnMaterialId INTEGER NOT NULL,
        $columnQuantity TEXT NOT NULL,
        FOREIGN KEY ( $columnRecipeId ) REFERENCES $tableRecipes ( $columnId ),
        FOREIGN KEY ( $columnMaterialId ) REFERENCES $tableMaterials ( $columnId )
      )
    '''
    );
    //　作り方を入れるテーブル
    await db.execute('''
      CREATE TABLE $tableMaking (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnRecipeId INTEGER NOT NULL,
        $columnBody TEXT NOT NULL,
        $columnImage TEXT DEFAULT NULL,
        $columnOrder INTEGER NOT NULL,
        FOREIGN KEY ( $columnRecipeId ) REFERENCES $tableRecipes ( $columnId )
      )
    '''
    );

    //  初期データ
    var genres = {
      [ "和食", 1],
      [ "洋食", 1],
      [ "中華", 1],
      [ "丼もの", 2],
      [ "麺類", 2],
      [ "肉", 2],
      [ "魚", 2],
    };
    for (var genre in genres) {
      await db.insert(tableGenres,
          { columnName: genre[0], columnPrimary: genre[1]}
      );
    }
    var materials = [
      "じゃがいも",
      "たまねぎ",
      "にんじん",
      "きゅうり",
      "白菜",
      "ごぼう",
      "ねぎ",
      "豆腐",
      "豚肉",
      "鶏肉",
      "牛肉",
      "醤油",
      "砂糖",
      "塩",
      "味噌",
    ];
    for (var material in materials) {
      await db.insert(tableMaterials,
          { columnName: material}
      );
    }
  }

  //　すべてのテーブルのデータを取得する
  Future<List<List<Map<String, dynamic>>>> queryAllRows() async {
    Database? db = await instance.database;
    List<List<Map<String, dynamic>>> res = [];
    await db!.transaction((txn) async {
      res.add(await txn.query(tableRecipes));
      res.add(await txn.query(tableGenres));
      res.add(await txn.query(tableRecipeGenre));
      res.add(await txn.query(tableMaterials));
      res.add(await txn.query(tableRecipeMaterial));
      res.add(await txn.query(tableMaking));
    });
    return res;
  }

  //　レシピテーブルの中身を全件取ってくる
  dynamic queryRecipes() async {
    Database? db = await instance.database;
    return await db!.query(tableRecipes);
  }

  //　レシピ名を登録する
  //　引数にレシピ名の文字列をとる
  Future<int> insertRecipe(String name) async {
    Database? db = await instance.database;
    Map<String, dynamic> row = {
      columnName: name
    };
    return await db!.insert(tableRecipes, row);
  }

  //　1つのレシピの情報をすべて取ってくる(ジャンル、材料、作り方含む)
  //　引数にint型のレシピIDをとる
  dynamic queryOneRecipe(int id) async {
    Database? db = await instance.database;
    List<List<Map<String, dynamic>>> res = [];
    await db!.transaction((txn) async {
      res.add(await txn.query(
        tableRecipes,
        where: "$columnId=?",
        whereArgs: [id],
      ));
      res.add(await txn.rawQuery('''
        SELECT * FROM $tableRecipeGenre
        INNER JOIN $tableGenres
        ON $tableRecipeGenre.$columnGenreId = $tableGenres.$columnId
        WHERE $tableRecipeGenre.$columnRecipeId = $id
      '''));
      res.add(await txn.rawQuery('''
        SELECT * FROM $tableRecipeMaterial
        INNER JOIN $tableMaterials
        ON $tableRecipeMaterial.$columnMaterialId = $tableMaterials.$columnId
        WHERE $tableRecipeMaterial.$columnRecipeId = $id
      '''));
      res.add(await txn.query(
          tableMaking,
          where: "$columnRecipeId=?",
          whereArgs: [id]
      ));
    });
    return res;
  }

  //　製作者側が設定したジャンルをすべて取得する
  //　戻り値はkeyをジャンルのID(int)、valueをジャンル名(String)のmap型を返す
  Future<Map<int, String>> queryGenre() async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> results = await db!.query(tableGenres);
    Map<int, String> genres = {};
    for (var genre in results) {
      genres.addAll({genre[columnId]: genre[columnName]});
    }
    return genres;
  }

  //　製作者側が設定した材料をすべて取得する
  //戻り値はkeyを材料のID(int)、valueを材料名(String)のmap型を返す
  Future<Map<int, String>> queryMaterial() async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> results = await db!.query(tableMaterials);
    Map<int, String> materials = {};
    for (var material in results) {
      materials.addAll({material[columnId]: material[columnName]});
    }
    return materials;
  }

  // レシピの編集を行う
  Future<int> updateRecipe(int id, RecipeInfo Recipe) async {
    Database? db = await instance.database;
    await db!.transaction((txn) async {
      //とりあえず関係値のテーブル内から今編集したいレシピについてのデータを削除する
      await txn.delete(
          tableRecipeGenre, where: "$columnRecipeId=?", whereArgs: [id]);
      await txn.delete(
          tableRecipeMaterial, where: "$columnRecipeId=?", whereArgs: [id]);
      await txn.delete(
          tableMaking, where: "$columnRecipeId=?", whereArgs: [id]);
      // update
      for (var item in Recipe.genreNames.keys) {
        await txn.insert(tableRecipeGenre, {
          columnRecipeId: id,
          columnGenreId: item,
        });
      }
      for (var item in Recipe.materials.keys) {
        await txn.insert(tableRecipeMaterial, {
          columnRecipeId: id,
          columnMaterialId: item,
          columnQuantity: Recipe.quantities[item],
        });
      }
      for (var i = 0; i < Recipe.makings.length; i++) {
        await txn.insert(tableMaking, {
          columnRecipeId: id,
          columnBody: Recipe.makings[i],
          columnOrder: i + 1,
        });
      }
    });
    return 0;
  }

  //　レシピを論理削除する
  Future<int> deleteRecipe(int id) async{
    Database? db = await instance.database;
    await db!.update(
      tableRecipes,
      { columnDelete : 1 },
      where: "$columnId=?",
      whereArgs: [id],
    );
    return 0;
  }
}

