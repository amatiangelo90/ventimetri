class ProductRestaurant {

  String id;
  String image;
  String name;
  List<dynamic> listIngredients;
  List<dynamic> listAllergens;
  List<dynamic> changes;
  double price;
  int discountApplied;
  String category;
  String available;

  ProductRestaurant(
      this.id,
      this.name,
      this.image,
      this.listIngredients,
      this.listAllergens,
      this.price,
      this.discountApplied,
      this.changes,
      this.category,
      this.available);

  factory ProductRestaurant.fromJson(dynamic json){
    return ProductRestaurant(
      json['id'] as String,
      json['name'] as String,
      json['image'] as String,
      json['ingredients'] as List,
      json['allergens'] as List,
      json['price'] as double,
      json['discountApplied'] as int,
      json['changes'] as List,
      json['category'] as String,
      json['available'] as String,
    );
  }

  factory ProductRestaurant.fromMap(
      Map snapshot,
      String id){

    double price = 0.0;

    if(snapshot['price'].runtimeType == double){
      price = snapshot['price'];
    }else if(snapshot['price'].runtimeType == int){
      int intPrice = snapshot['price'];
      price = intPrice.toDouble();
    }else{
      print('Errore parsing object');
    }

    return ProductRestaurant(
      id,
      snapshot['name'] as String,
      snapshot['image'] as String,
      snapshot['ingredients'] as List,
      snapshot['allergens'] as List,
      price,
      snapshot['discountApplied'] as int,
      snapshot['changes'] as List,
      snapshot['category'] as String,
      snapshot['available'] as String,
    );
  }

  toJson(){

    return {
    'id' : id,
    'name': name,
    'image': image,
    'ingredients' : listIngredients,
    'allergens' : listAllergens,
    'price' : price,
    'discountApplied' : discountApplied,
    'changes' : changes,
    'category' : category,
    'available' : available
    };

  }


  @override
  String toString() {
    return this.name.toString() + ' - ' + this.available.toString();
  }

}