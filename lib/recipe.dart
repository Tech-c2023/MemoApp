class RecipeInfo{
  RecipeInfo._privateConstructor();
  static final RecipeInfo _recipeInfo = RecipeInfo._privateConstructor();

  String name = "";
  String selectingGenre = "";
  List<String> genreNames = [];
  String selectingMaterial = "";
  String selectingQuantity = "";
  List<String> materials = [];
  List<String> quantities = [];
  Map<int, String> makings = {};

  factory RecipeInfo(){
    return _recipeInfo;
  }

}