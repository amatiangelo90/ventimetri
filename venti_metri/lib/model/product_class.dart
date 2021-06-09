class Product {

  String id;
  String name;
  double price;
  String category;
  String available;

  Product(
      this.id,
      this.name,
      this.price,
      this.category,
      this.available);

  factory Product.fromJson(dynamic json){
    return Product(
      json['id'] as String,
      json['name'] as String,
      json['price'] as double,
      json['category'] as String,
      json['available'] as String,
    );
  }

  factory Product.fromMap(
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

    return Product(
      id,
      snapshot['name'] as String,
      price,

      snapshot['category'] as String,
      snapshot['available'] as String,
    );
  }

  toJson(){

    return {
      'id' : id,
      'name': name,
      'price' : price,
      'category' : category,
      'available' : available
    };

  }


  @override
  String toString() {
    return this.name.toString();
  }

}