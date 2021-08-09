import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:venti_metri/component/round_icon_botton.dart';
import 'package:venti_metri/dao/crud_model.dart';
import 'package:venti_metri/model/product_restaurant.dart';
import 'package:venti_metri/screens/delivery/utils/costants.dart';
import 'package:venti_metri/screens/delivery/utils/utils.dart';

import 'menu_administrator.dart';


class ManageMenuWinePage extends StatefulWidget {

  static String id = 'manage_wine_page';

  final ProductRestaurant product;
  final String menuType;

  ManageMenuWinePage({@required this.product, @required this.menuType});

  @override
  _ManageMenuWinePageState createState() => _ManageMenuWinePageState();
}

class _ManageMenuWinePageState extends State<ManageMenuWinePage> {
  double _price;
  ProductRestaurant productBase;

  TextEditingController _nameController;
  TextEditingController _cantinaController;
  TextEditingController _ingredientsController;

  @override
  void initState() {
    super.initState();
    productBase = this.widget.product;
    _nameController = TextEditingController(text: productBase.name);
    if(productBase.changes != null){
      _cantinaController = TextEditingController(text: productBase.changes[0]);
    }else{
      _cantinaController = TextEditingController(text: '');
    }


    _ingredientsController = TextEditingController(text: Utils.getIngredientsFromProduct(productBase));
    _price = productBase.price;
  }



  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
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
                                  labelText: 'Uvaggio',
                                ),
                                maxLines: 4,
                              ),
                            ),
                          ),
                        ),
                        Padding(
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
                        ),
                        Text('*Ricorda di dividere i tipi di uva con la virgola (,)', style: TextStyle(fontSize: 10),),
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
                                  updateProductBaseAvailability('true');

                                }
                            ),
                            RaisedButton(
                                child: Text('Esaurito',style: TextStyle(color: Colors.white, fontSize: 20.0,)),
                                color: productBase.available == 'false' ? Colors.red : Colors.grey,
                                elevation: 5.0,
                                onPressed: () async {
                                  updateProductBaseAvailability('false');
                                }
                            ),
                            RaisedButton(
                                child: Text('Novità',style: TextStyle(color: Colors.white, fontSize: 20.0,)),
                                color: productBase.available == 'new' ? Colors.green : Colors.grey,
                                elevation: 5.0,
                                onPressed: () async {
                                  updateProductBaseAvailability('new');
                                }
                            ),
                          ],
                        ),
                        ButtonBar(
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
                                color: productBase.category == categoryBollicineWine ? Colors.blue : Colors.grey,
                                elevation: 5.0,
                                onPressed: () async {
                                  updateProductBaseCategoryWine(categoryBollicineWine);
                                }
                            ),
                            RaisedButton(
                                child: Text('Oth',style: TextStyle(color: Colors.white, fontSize: 20.0,)),
                                color: productBase.category == categoryDrink ? Colors.blue : Colors.grey,
                                elevation: 5.0,
                                onPressed: () async {
                                  updateProductBaseCategoryWine(categoryDrink);
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
                                  productBase.name = _nameController.value.text;
                                  productBase.listIngredients = _ingredientsController.value.text.split(",");
                                  productBase.changes[0] = _cantinaController.value.text;
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

  void updateProductBaseAvailability(String state) {
    setState(() {
      productBase.available = state;
    });
  }

  void updateProductBaseCategoryWine(String categoryWine) {
    print('@@@@@@@@');
    print(categoryWine);
    print('productBase.category ->' + productBase.category);
    print('@@@@@@@@');
    setState(() {
      productBase.category = categoryWine;
    });
  }
}