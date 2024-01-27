import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseProvider {
  static final _databaseName = "cookingMemo.db";
  static final _databaseVersion = 1;

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

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    print("onCreate");
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
    await db.execute('''
      CREATE TABLE $tableGenres (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnPrimary INTEGER DEFAULT 0
      )
    '''
    );
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
    await db.execute('''
      CREATE TABLE $tableMaterials (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL
      )
    '''
    );
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
    await db.execute('''
      CREATE TABLE $tableMaking (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnRecipeId INTEGER NOT NULL,
        $columnBody TEXT NOT NULL,
        $columnImage TEXT DEFAULT NULL,
        $columnOrder INTEGER DEFAULT 0,
        FOREIGN KEY ( $columnRecipeId ) REFERENCES $tableRecipes ( $columnId )
      )
    '''
    );

  //  初期データ
    var genres = {
      [ "和食", 1 ],
      [ "洋食", 1 ],
      [ "中華", 1 ],
      [ "丼もの", 2 ],
      [ "麺類", 2 ],
      [ "肉", 2 ],
      [ "魚", 2 ],
    };
    for (var genre in genres) {
      await db.insert(tableGenres,
        { columnName : genre[0], columnPrimary : genre[1]}
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
          { columnName : material}
      );
    }

  }

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


  dynamic queryRecipes() async {
    Database? db = await instance.database;
    return await db!.query(tableRecipes);
  }

  Future<int>  insertRecipe(String name) async {
    Database? db = await instance.database;
    Map<String, dynamic> row = {
      columnName : name
    };
    return await db!.insert(tableRecipes, row);
  }
  // dynamic queryOneRecipe(int id) async {
  //   Database? db = await instance.database;
  //   return await db!.query(tableRecipes, where: "$columnId=?", whereArgs: [id]);
  // }
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
        SELECT $tableGenres.$columnName FROM $tableRecipeGenre
        INNER JOIN $tableGenres
        ON $tableRecipeGenre.$columnGenreId = $tableGenres.$columnId
        WHERE $tableRecipeGenre.$columnRecipeId = $id
      '''));
      res.add(await txn.rawQuery('''
        SELECT $tableMaterials.$columnName, $tableRecipeMaterial.$columnQuantity FROM $tableRecipeMaterial
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

  Future<List<Map<String, Object?>>> queryGenre() async{
    Database? db = await instance.database;
    return await db!.query(tableGenres);
  }
  Future<List<Map<String, Object?>>> queryMaterial() async{
    Database? db = await instance.database;
    return await db!.query(tableMaterials);
  }
}

