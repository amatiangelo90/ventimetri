import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:venti_metri/component/round_icon_botton.dart';
import 'package:venti_metri/dao/crud_model.dart';
import 'package:venti_metri/model/product_restaurant.dart';
import 'package:venti_metri/screens/delivery/utils/costants.dart';
import 'package:venti_metri/screens/delivery/utils/utils.dart';
import 'menu_administrator.dart';

class ManageMenuItemPage extends StatefulWidget {

  static String id = 'manage_menu_page';

  final ProductRestaurant product;
  final String menuType;

  ManageMenuItemPage({@required this.product, @required this.menuType});

  @override
  _ManageMenuItemPageState createState() => _ManageMenuItemPageState();
}

class _ManageMenuItemPageState extends State<ManageMenuItemPage> {
  double _price;
  ProductRestaurant productBase;

  List<Category> _categoryPicker;
  List<DropdownMenuItem<Category>> _dropdownCategory;
  Category _selectedCategory;

  TextEditingController _nameController;
  TextEditingController _ingredientsController;

  @override
  void initState() {
    super.initState();
    productBase = this.widget.product;
    _nameController = TextEditingController(text: productBase.name);
    _ingredientsController = TextEditingController(text: Utils.getIngredientsFromProduct(productBase));
    _categoryPicker = Category.getCategoryList(this.widget.menuType);
    _dropdownCategory = buildDropdownSlotPickup(_categoryPicker);
    _price = productBase.price;
    _selectedCategory = _dropdownCategory[0].value;
  }

  onChangeDropTimeSlotPickup(Category currentCategory) {
    setState(() {
      _selectedCategory = currentCategory;
    });
  }

  List<DropdownMenuItem<Category>> buildDropdownSlotPickup(List category) {
    List<DropdownMenuItem<Category>> items = [];
    for (Category category in category) {
      items.add(
        DropdownMenuItem(
          value: category,
          child: Center(child: Text(category.cat, style: TextStyle(color: Colors.black, fontSize: 16.0,),)),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(productBase.name,  style: TextStyle(fontSize: 20.0, color: Colors.white),),
        ),
        body: Container(
          color: Colors.white,
          child: ListView(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 30.0, 5.0, 0.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                          child: Center(
                            child: Card(
                              child: TextField(
                                controller: _nameController,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Nome',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                          child: Center(
                            child: Card(
                              child: TextField(
                                controller: _ingredientsController,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Ingredienti',
                                ),
                                maxLines: 4,
                              ),
                            ),
                          ),
                        ),
                        Text('*Ricorda di dividere la lista ingredienti con la virgola (,)', style: TextStyle(fontSize: 10),),
                        /*this.widget.menuType == VIGNETO_MENU ? Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 3.0),
                          child: Center(
                            child: Card(
                              borderOnForeground: true,
                              elevation: 1.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Center(
                                    child: DropdownButton(
                                      isExpanded: true,
                                      value: _selectedCategory,
                                      items: _dropdownCategory,
                                      onChanged: onChangeDropTimeSlotPickup,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ) : SizedBox(height: 0,),*/
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              RoundIconButton(
                                icon: FontAwesomeIcons.minus,
                                function: () {
                                  setState(() {
                                    if(_price > 1)
                                      _price = _price - 0.5;
                                  });
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(_price.toString() + ' €', style: TextStyle(fontSize: 20.0,),),
                              ),
                              RoundIconButton(
                                icon: FontAwesomeIcons.plus,
                                function: () {
                                  setState(() {
                                    _price = _price + 0.5;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: [
                            RaisedButton(
                                child: Text('Disponibile',style: TextStyle(color: Colors.white, fontSize: 20.0,)),
                                color: productBase.available == 'true' ? Colors.blueAccent : Colors.grey,
                                elevation: 5.0,
                                onPressed: () async {
                                  updateProductBase('true');

                                }
                            ),
                            RaisedButton(
                                child: Text('Esaurito',style: TextStyle(color: Colors.white, fontSize: 20.0,)),
                                color: productBase.available == 'false' ? Colors.red : Colors.grey,
                                elevation: 5.0,
                                onPressed: () async {
                                  updateProductBase('false');
                                }
                            ),
                            RaisedButton(
                                child: Text('Novità',style: TextStyle(color: Colors.white, fontSize: 20.0,)),
                                color: productBase.available == 'new' ? Colors.green : Colors.grey,
                                elevation: 5.0,
                                onPressed: () async {
                                  updateProductBase('new');
                                }
                            ),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.all(23.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [

                              RaisedButton(
                                child: Text('Aggiorna',style: TextStyle(color: Colors.white, fontSize: 20.0,)),
                                color: Colors.green,
                                elevation: 5.0,
                                onPressed: () async {
                                  print('Update menu [' + this.widget.menuType + ']');
                                  print('Update menu [' + productBase.category + ']');
                                  CRUDModel crudModel = CRUDModel(this.widget.menuType);
                                  productBase.price = _price;
                                  productBase.name = _nameController.value.text.replaceAll("\"", "\'");
                                  productBase.listIngredients = _ingredientsController.value.text.split(",");
                                  /*productBase.category = _selectedCategory.cat;*/
                                  await crudModel.updateProduct(productBase, productBase.id);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(backgroundColor: Colors.green.shade500 ,
                                      content: Text('${productBase.name} aggiornato con successo')));
                                  Navigator.pushNamed(context, MenuAdministratorScreen.id);
                                },
                              ),
                              RaisedButton(
                                child: Text('Elimina',style: TextStyle(color: Colors.white, fontSize: 20.0,)),
                                color: Colors.redAccent,
                                elevation: 5.0,
                                onPressed: ()  async {
                                  return await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Conferma"),
                                        content: Text("Eliminare " + productBase.name + " ?"),
                                        actions: <Widget>[
                                          FlatButton(
                                              onPressed: () async {
                                                print('Product base id : ' + productBase.id);
                                                CRUDModel crudModel = CRUDModel(this.widget.menuType);
                                                await crudModel.removeProduct(productBase.id);
                                                Navigator.pushNamed(context, MenuAdministratorScreen.id);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(backgroundColor: Colors.green.shade500 ,
                                                    content: Text('${productBase.name} eliminato con successo')));
                                              },
                                              child: const Text("Cancella")
                                          ),
                                          FlatButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            child: const Text("Indietro"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Column(
                              children: [
                                Text('Codice prodotto'),
                                Text('[' + productBase.id + ']'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateProductBase(String state) {
    setState(() {
      productBase.available = state;
    });
  }


}

class Category {
  int id;
  String cat;

  Category(this.id, this.cat);

  static List<Category> getCategoryList(String menuType) {
    print(menuType);
    switch(menuType){
      case VIGNETO_WINELIST:
        return <Category>[
          Category(1, 'Scegli Categoria'),
          Category(2, categoryWhiteWine),
          Category(3, categoryRedWine),
          Category(4, categoryBollicineWine),
          Category(5, categoryRoseWine),
        ];
        break;
      default:
        return <Category>[
          Category(1, 'Scegli Categoria'),
          Category(2, categoryWhiteWine),
        ];
    }



  }
}