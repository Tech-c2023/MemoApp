import 'database.dart';

class RecipeInfo{
  //シングルトン
  RecipeInfo._privateConstructor();
  static final RecipeInfo _recipeInfo = RecipeInfo._privateConstructor();

  factory RecipeInfo(){
    return _recipeInfo;
  }

  //レシピのアップデート入力時に使う
  String name = "";
  int selectingGenre = 0;
  Map<int, String> genreNames = {};
  int selectingMaterial = 0;
  String selectingQuantity = "";
  Map<int, String> materials = {};
  Map<int, String> quantities = {};
  String selectingMaking = "";
  List<String> makings = [];

  final Provider =  DatabaseProvider.instance;

  //データベースからとってきたレシピの情報を、ここのプロパティに追加する
  void mapQuery(List<dynamic> results) {
    name = results[0][0][Provider.columnName];
    for(var i = 0; i < results[1].length; i++) {
      genreNames.addAll({results[1][i][Provider.columnId]: results[1][i][Provider.columnName]});
    }
    for(var i = 0; i < results[2].length; i++) {
      materials.addAll({results[2][i][Provider.columnId]: results[2][i][Provider.columnName]});
      quantities.addAll({results[2][i][Provider.columnId]: results[2][i][Provider.columnQuantity]});
    }
    for(var i = 0; i < results[3].length; i++) {
      makings.add(results[3][i][Provider.columnBody]);
    }
  }

  //　画面を離れたら、入力値を空にする
  void clearRecipeData(){
    name = "";
    selectingGenre = 0;
    genreNames = {};
    selectingMaterial = 0;
    selectingQuantity = "";
    materials = {};
    quantities = {};
    selectingMaking = "";
    makings = [];
  }

}