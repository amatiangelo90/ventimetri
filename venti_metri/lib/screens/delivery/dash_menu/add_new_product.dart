import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:venti_metri/component/round_icon_botton.dart';
import 'package:venti_metri/dao/crud_model.dart';
import 'package:venti_metri/model/product_restaurant.dart';
import 'package:venti_metri/screens/delivery/utils/costants.dart';
import 'package:venti_metri/screens/delivery/utils/utils.dart';
import 'package:venti_metri/utils/utils.dart';

import 'menu_administrator.dart';


class AddNewProductScreen extends StatefulWidget {

  static String id = 'add_product';

  @override
  _AddNewProductScreenState createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {

  ProductRestaurant productBase;
  double _price;
  TextEditingController _nameController;
  TextEditingController _ingredientsController;
  TextEditingController _cantinaController;

  Category _selectedCategory;
  List<Category> _categoryPicker;
  List<DropdownMenuItem<Category>> _dropdownCategory;


  @override
  void initState() {
    super.initState();
    productBase = ProductRestaurant('', '', 'images/logo_home_nero.png', [""], [""], 0.0, 0, ["-"], '', 'true');
    _nameController = TextEditingController(text: productBase.name);
    _ingredientsController = TextEditingController(text: Utils.getIngredientsFromProduct(productBase));
    _cantinaController = TextEditingController(text: '');
    _price = 0.0;
    _categoryPicker = Category.getCategoryList();
    _dropdownCategory = buildDropdownSlotPickup(_categoryPicker);
    _selectedCategory = _dropdownCategory[0].value;
  }

  onChangeCategory(Category currentCategory) {
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
          child: Center(child: Text(category.nameItalian, style: TextStyle(color: Colors.black, fontSize: 16.0,),)),
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
          title: Text('Aggiungi Nuovo Prodotto',style: TextStyle(color: Colors.white, fontSize: 20.0,)),
          backgroundColor: Colors.black,
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
                                      onChanged: onChangeCategory,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
                                  labelText: _selectedCategory.menuType == VIGNETO_WINELIST ? 'Uvaggio' :'Ingredienti',
                                ),
                                maxLines: 2,
                              ),
                            ),
                          ),
                        ),
                        Text('*Ricorda di dividere la lista ingredienti con la virgola (,)', style: TextStyle(fontSize: 10),),
                        _selectedCategory.menuType == VIGNETO_WINELIST ? Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                          child: Center(
                            child: Card(
                              child: TextField(
                                controller: _cantinaController,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Cantina',
                                ),
                              ),
                            ),
                          ),
                        ) : SizedBox(height: 0,),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  RoundIconButton(
                                    icon: FontAwesomeIcons.minus,
                                    color: VENTI_METRI_BLUE,
                                    function: () {
                                      setState(() {
                                        if(_price > 5)
                                          _price = _price - 5;
                                      });
                                    },
                                  ),
                                  Text('- 5')
                                ],
                              ),
                              Column(
                                children: [
                                  RoundIconButton(
                                    icon: FontAwesomeIcons.minus,
                                    color: VENTI_METRI_BLUE,
                                    function: () {
                                      setState(() {
                                        if(_price > 1)
                                          _price = _price - 0.5;
                                      });
                                    },
                                  ),
                                  Text('- 0.5')
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(_price.toString() + ' €', style: TextStyle(fontSize: 20.0,),),
                                    Text('')
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  RoundIconButton(
                                    icon: FontAwesomeIcons.plus,
                                    color: VENTI_METRI_BLUE,
                                    function: () {
                                      setState(() {
                                        _price = _price + 0.5;
                                      });
                                    },
                                  ),
                                  Text('+ 0.5')
                                ],
                              ),
                              Column(
                                children: [
                                  RoundIconButton(
                                    icon: FontAwesomeIcons.plus,
                                    color: VENTI_METRI_BLUE,
                                    function: () {
                                      setState(() {
                                        if(_price < 1000)
                                          _price = _price + 5;
                                      });
                                    },
                                  ),
                                  Text('+ 5')
                                ],
                              ),
                            ],
                          ),
                        ),
                        _selectedCategory.menuType == VIGNETO_WINELIST ? ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: [
                            RaisedButton(
                                child: Text('Red',style: TextStyle(color: Colors.white, fontSize: 20.0,)),
                                color: productBase.category == categoryRedWine ? Colors.red : Colors.grey,
                                elevation: 5.0,
                                onPressed: () async {
                                  updateProductBaseCategoryWine(categoryRedWine);
                                }
                            ),
                            RaisedButton(
                                child: Text('Rosè',style: TextStyle(color: Colors.white, fontSize: 20.0,)),
                                color: productBase.category == categoryRoseWine ? Colors.pinkAccent : Colors.grey,
                                elevation: 5.0,
                                onPressed: () async {
                                  updateProductBaseCategoryWine(categoryRoseWine);
                                }
                            ),
                            RaisedButton(
                                child: Text('Wh',style: TextStyle(color: Colors.white, fontSize: 20.0,)),
                                color: productBase.category == categoryWhiteWine ? Colors.yellow : Colors.grey,
                                elevation: 5.0,
                                onPressed: () async {
                                  updateProductBaseCategoryWine(categoryWhiteWine);
                                }
                            ),
                            RaisedButton(
                                child: Text('Bol',style: TextStyle(color: Colors.white, fontSize: 20.0,)),
                                color: productBase.category == categoryBollicineWine ? Colors.greenAccent : Colors.grey,
                                elevation: 5.0,
                                onPressed: () async {
                                  updateProductBaseCategoryWine(categoryBollicineWine);
                                }
                            ),
                            RaisedButton(
                                child: Text('Oth',style: TextStyle(color: Colors.white, fontSize: 20.0,)),
                                color: productBase.category == categoryDrink ? Colors.lightBlue : Colors.grey,
                                elevation: 5.0,
                                onPressed: () async {
                                  updateProductBaseCategoryWine(categoryDrink);
                                }
                            ),
                          ],
                        ) : SizedBox(height: 0,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        ),
                        RaisedButton(
                            child: Text(_selectedCategory.menuType == VIGNETO_WINELIST ? 'Crea Vino' : 'Crea Prodotto',style: TextStyle(color: Colors.white, fontSize: 20.0,)),
                            color: Colors.teal.shade800,
                            elevation: 5.0,
                            onPressed: () async {
                              if(_selectedCategory.menuType != 'Scegli Tipo Menu'){
                                if(_price == 0.0){
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(backgroundColor: Colors.deepOrange.shade800 ,
                                      content: Text('Prezzo mancante')));
                                }else{
                                  if(_nameController.value.text == ''){
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(backgroundColor: Colors.deepOrange.shade800 ,
                                        content: Text('Nome prodotto mancante')));
                                  }else{
                                    if(_selectedCategory.menuType == VIGNETO_WINELIST && productBase.category == ''){
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(backgroundColor: Colors.deepOrange.shade800 ,
                                          content: Text('Selezionare una fra le voci rosso, bianco, rosato o bollicine')));
                                    }else{
                                      print('Creazione Prodotto');
                                      CRUDModel crudModel = CRUDModel(_selectedCategory.menuType);
                                      productBase.name = (_nameController.value.text).replaceAll('"', '\'');
                                      productBase.price = _price;
                                      productBase.listIngredients = _ingredientsController.value.text.split(",");
                                      productBase.changes[0] = _cantinaController.value.text;
                                      print(productBase.toJson());
                                      await crudModel.addProduct(productBase);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(backgroundColor: Colors.green.shade500 ,
                                          content: Text('${_nameController.value.text} creato per la categoria ${_selectedCategory.nameItalian}')));
                                      Navigator.pushNamed(context, MenuAdministratorScreen.id);
                                    }
                                  }

                                }

                              }else{
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(backgroundColor: Colors.deepOrange.shade800 ,
                                    content: Text('Seleziona un tipo di menu')));
                              }
                            }
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

  void updateProductBaseCategoryWine(String categoryWine) {
    setState(() {
      productBase.category = categoryWine;
    });
  }
}

class Category {
  int id;
  String menuType;
  String nameItalian;

  Category(this.id, this.menuType, this.nameItalian);

  static List<Category> getCategoryList() {

    return <Category>[
      Category(1, 'Scegli Tipo Menu', 'Scegli Tipo Menu'),
      Category(2, VIGNETO_MENU, 'Menu'),
      Category(8, VIGNETO_WINELIST, 'Vini'),

    ];
  }
}