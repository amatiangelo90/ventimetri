import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:uuid/uuid.dart';
import 'package:venti_metri/dao/crud_model.dart';
import 'package:venti_metri/model/cart.dart';
import 'package:venti_metri/model/product_restaurant.dart';
import 'package:venti_metri/screens/delivery/utils/costants.dart';
import 'package:venti_metri/screens/delivery/utils/utils.dart';
import 'package:venti_metri/utils/utils.dart';


import '../home_screen.dart';
import 'add_modal_screen.dart';
import 'cart_screen.dart';
import 'dash_menu/menu_administrator.dart';

class VentiMetriRestaurantScreen extends StatefulWidget {
  static String id = 'venti_restaurant_screen';

  final String covers;

  VentiMetriRestaurantScreen({@required this.covers});

  @override
  _VentiMetriRestaurantScreenState createState() => _VentiMetriRestaurantScreenState();
}

class _VentiMetriRestaurantScreenState extends State<VentiMetriRestaurantScreen> {

  String _sessionId;
  List<ProductRestaurant> fromOsteriaProductList = <ProductRestaurant>[];
  List<ProductRestaurant> wineProductList = <ProductRestaurant>[];

  List<Cart> cartProductList = <Cart>[];
  final scaffoldState = GlobalKey<ScaffoldState>();
  final _passwordController = TextEditingController();
  String currentMenuType = VIGNETO_WINELIST;
  int currentMenuItem = 0;


  PageController controller = PageController(
      initialPage: 0);

  void updateCurrentMenuItemCount(List<Cart> cartItemToAdd){

    setState(() {

      var _present = false;
      currentMenuItem = currentMenuItem + cartItemToAdd[0].numberOfItem;

      cartProductList.forEach((element) {
        if(element.product.name == cartItemToAdd[0].product.name
            && _twoListContainsSameElements(element.changes, cartItemToAdd[0].changes)){
          element.numberOfItem = element.numberOfItem + cartItemToAdd[0].numberOfItem;
          _present = true;
        }
      });

      if(!_present){
        cartProductList.addAll(cartItemToAdd);
      }
    });
  }

  void removeProductFromCart(int cartListToRemove) {
    setState(() {
      if(cartListToRemove == null){
        currentMenuItem = 0;
      }else{
        currentMenuItem = currentMenuItem - cartListToRemove;
      }
    });
  }


  void updateMenuType(int menuType){
    switch(menuType){
      case 0:
        currentMenuType = VIGNETO_WINELIST;
        controller.jumpToPage(0);
        break;
      case 1:
        currentMenuType = VIGNETO_MENU;
        controller.jumpToPage(1);
        break;
    }
  }

  ScrollController scrollViewColtroller = ScrollController();

  @override
  void initState() {
    scrollViewColtroller = ScrollController();
    scrollViewColtroller.addListener(_scrollListener);
    _sessionId = Uuid().v1();
    super.initState();
  }

  _scrollListener() {
    if (scrollViewColtroller.offset >=
        scrollViewColtroller.position.maxScrollExtent &&
        !scrollViewColtroller.position.outOfRange) {
      setState(() {
        _direction = true;
      });
    }
    if (scrollViewColtroller.offset <=
        scrollViewColtroller.position.minScrollExtent &&
        !scrollViewColtroller.position.outOfRange) {
      setState(() {
        _direction = false;
      });
    }
  }

  bool _direction = false;

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    scrollViewColtroller.dispose();
  }

  _moveUp() {
    scrollViewColtroller.animateTo(scrollViewColtroller.offset - 450,
        curve: Curves.linear, duration: Duration(milliseconds: 200));
  }

  _moveDown() {
    scrollViewColtroller.animateTo(scrollViewColtroller.offset + 450,
        curve: Curves.linear, duration: Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[

          Visibility(
            visible: _direction,
            maintainSize: false,
            child: FloatingActionButton(
              backgroundColor: VENTI_METRI_MONOPOLI,
              onPressed: () {
                _moveUp();
              },
              child: RotatedBox(
                  quarterTurns: 1, child: Icon(Icons.chevron_left)),
            ),
          ),
          Visibility(
            maintainSize: false,
            visible: !_direction,
            child: FloatingActionButton(
              backgroundColor: VENTI_METRI_MONOPOLI,
              onPressed: () {
                _moveDown();
              },
              child: RotatedBox(
                  quarterTurns: 3, child: Icon(Icons.chevron_left)),
            ),
          )
        ],
      ),
      key: scaffoldState,
      body: NotificationListener<ScrollUpdateNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollViewColtroller.position.userScrollDirection ==
              ScrollDirection.reverse) {
            setState(() {
              _direction = true;
            });
          } else {
            if (scrollViewColtroller.position.userScrollDirection ==
                ScrollDirection.forward) {
              setState(() {
                _direction = false;
              });
            }
          }
          return true;
        },
        child: Container(
          color: VENTI_METRI_BLUE,
          width: screenWidth,
          height: screenHeight,
          child: Scaffold(
            backgroundColor: VENTI_METRI_BLUE,
            appBar: AppBar(
              iconTheme: IconThemeData(color: VENTI_METRI_MONOPOLI),
              backgroundColor: VENTI_METRI_BLUE,
              elevation: 3.0,
              title: Column(
                children: [
                  Text('Menù',
                    style: TextStyle(fontSize: 16.0, color: Colors.white, fontFamily: 'LoraFont'),
                  ),
                  Text('Sessione ' +_sessionId , style: TextStyle(color: Colors.white, fontSize: 7.0, fontFamily: 'LoraFont'),),

                ],
              ),
              centerTitle: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Stack(
                    children: <Widget>[
                      IconButton(icon: Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                      ),
                          onPressed: (){

                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => CartScreen(
                                  cartItems: cartProductList,
                                  function: removeProductFromCart,
                                  uniqueId: _sessionId,
                                  covers: this.widget.covers,
                                ),
                                ),
                              );
                          }),
                      currentMenuItem == 0 ? Text('') :
                      Positioned(
                        top: 6.0,
                        right: 10.0,
                        child: Stack(
                          children: <Widget>[
                            Icon(Icons.brightness_1, size: 15, color: Colors.redAccent,),
                            Positioned(
                              right: 5.0,
                              top: 2.0,
                              child: Center(child: Text(currentMenuItem.toString() , style: TextStyle(fontSize: 8.0, color: Colors.white, fontFamily: 'LoraFont'),
                              ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => {
                  Navigator.pushNamed(context, HomeScreen.id)
                },
              ),
            ),
            body: SafeArea(
              child: PageView(
                controller: controller,
                scrollDirection: Axis.horizontal,
                children: [
                  SingleChildScrollView(
                    controller: scrollViewColtroller,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Coperti : ' + this.widget.covers, style: TextStyle(fontSize: 15, color: Colors.white),),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: getMenuNameFromCurrentMenu(VIGNETO_WINELIST),
                        ),
                        Container(
                            color: VENTI_METRI_BLUE,
                            child: FutureBuilder(
                              initialData: <Widget>[Column(
                                children: [
                                  Center(child: CircularProgressIndicator()),
                                  SizedBox(),
                                  Center(child: Text('Caricamento menù..',
                                    style: TextStyle(fontSize: 16.0,
                                        color: VENTI_METRI_MONOPOLI,
                                        fontFamily: 'LoraFont'),
                                  ),),
                                ],
                              )],
                              future: createList(VIGNETO_WINELIST),
                              builder: (context, snapshot){
                                if(snapshot.hasData){
                                  return Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: ListView(
                                      primary: false,
                                      shrinkWrap: true,
                                      children: snapshot.data,
                                    ),
                                  );
                                }else{
                                  return CircularProgressIndicator();
                                }
                              },
                            )
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    controller: scrollViewColtroller,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Coperti : ' + this.widget.covers, style: TextStyle(fontSize: 15, color: Colors.white),),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: getMenuNameFromCurrentMenu(VIGNETO_MENU),
                        ),
                        Container(
                            color: VENTI_METRI_BLUE,
                            child: FutureBuilder(
                              initialData: <Widget>[Column(
                                children: [
                                  Center(child: CircularProgressIndicator()),
                                  SizedBox(),
                                  Center(child: Text('Caricamento menù..',
                                    style: TextStyle(fontSize: 16.0,
                                        color: VENTI_METRI_MONOPOLI,
                                        fontFamily: 'LoraFont'),
                                  ),),
                                ],
                              )],
                              future: createList(VIGNETO_MENU),
                              builder: (context, snapshot){
                                if(snapshot.hasData){
                                  return Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: ListView(
                                      primary: false,
                                      shrinkWrap: true,
                                      children: snapshot.data,
                                    ),
                                  );
                                }else{
                                  return CircularProgressIndicator();
                                }
                              },
                            )
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Future<List<Widget>> createList(String currentMenuType) async{

    List<Widget> items = <Widget>[];

    List<ProductRestaurant> productList = await getCurrentProductList(currentMenuType);

    productList.forEach((product) {
      if(listTypeBeverage.contains(product.category)){
        items.add(
          InkWell(
            hoverColor: Colors.blueGrey,
            splashColor: Colors.greenAccent,
            highlightColor: Colors.blueGrey.withOpacity(0.5),
            onTap: () {
              product.available == 'true' ?
              showDialog(
                  context: context,
                  builder: (context) {
                    return ModalAddItem(product: product, updateCountCallBack: updateCurrentMenuItemCount);
                  }
              ) : showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                      content: Text(product.name + ' Esaurito', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Indietro"),
                        ),
                      ],
                    );
                  }
              );
            },
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child: Container(
                decoration: BoxDecoration(
                    color: VENTI_METRI_BLUE,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                        color: product.available == 'true' ? VENTI_METRI_MONOPOLI : Colors.deepOrange.shade900,
                        spreadRadius: product.available == 'true' ? 1.0 : 1.0,
                      ),
                    ]
                ),
                child: ClipRect(
                  child: Banner(
                    message: Utils.getNameByType(product.category),
                    color: Utils.getColorByType(product.category),
                    location: BannerLocation.topEnd,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
                          child: Image.asset(product.image, width: 90.0, height: 90.0, fit: BoxFit.scaleDown,),
                        ),
                        SizedBox(
                          width: 240.0,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
                                  child: Text(product.name, style: TextStyle(fontSize: 16.0,color: Colors.white, fontFamily: 'LoraFont'),),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text(Utils.getIngredientsFromProduct(product), overflow: TextOverflow.ellipsis , style: TextStyle(fontSize: 11.0, color: Colors.white, fontFamily: 'LoraFont'),),
                                ),
                                product.available == 'true' ? Padding(
                                  padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
                                  child: Text('', style: TextStyle(fontSize: 10.0,color: Colors.white, fontFamily: 'LoraFont'),),
                                ) : Padding(
                                  padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
                                  child: Text('Esaurito', style: TextStyle(fontSize: 16.0,color: Colors.deepOrange.shade900, fontFamily: 'LoraFont'),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text('€ ' + product.price.toString(), overflow: TextOverflow.ellipsis , style: TextStyle(fontSize: 14.0, color: Colors.white, fontFamily: 'LoraFont'),),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      } else{
        items.add(
          product.available == 'false' ?
          InkWell(
            hoverColor: Colors.blueGrey,
            splashColor: Colors.greenAccent,
            highlightColor: Colors.blueGrey.withOpacity(0.5),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                      content: Text(product.name + ' Esaurito', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Indietro"),
                        ),
                      ],
                    );
                  }
              );
            },
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child: Container(
                decoration: BoxDecoration(
                    color: VENTI_METRI_MONOPOLI,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 1.0,
                        blurRadius: 1.0,
                      ),
                    ]
                ),
                child: ClipRect(
                  child: Banner(
                    message: 'Esaurito',
                    location: BannerLocation.topEnd,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
                          child: Image.asset(product.image, width: 90.0, height: 90.0, fit: BoxFit.cover,),
                        ),
                        SizedBox(
                          width: 250.0,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
                                  child: Text(product.name, style: TextStyle(color: Colors.white, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text(Utils.getIngredientsFromProduct(product), overflow: TextOverflow.ellipsis , style: TextStyle(color: Colors.white, fontSize: 11.0, fontFamily: 'LoraFont'),),
                                ),
                                Text('',),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text('€ ' + product.price.toString(), overflow: TextOverflow.ellipsis , style: TextStyle(color: Colors.white, fontSize: 14.0, fontFamily: 'LoraFont'),),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ) : product.available == 'new' ?
          InkWell(
            hoverColor: Colors.blueGrey,
            splashColor: Colors.greenAccent,
            highlightColor: Colors.blueGrey.withOpacity(0.5),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return ModalAddItem(product: product, updateCountCallBack: updateCurrentMenuItemCount);
                  }
              );
            },
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child: Container(
                decoration: BoxDecoration(
                    color: VENTI_METRI_BLUE,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                        color: VENTI_METRI_MONOPOLI,
                        spreadRadius: 1.0,
                        blurRadius: 1.0,
                      ),
                    ]
                ),
                child: ClipRect(
                  child: Banner(
                    message: 'Novità',
                    color: Colors.green,
                    location: BannerLocation.topEnd,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
                          child: Image.asset(product.image, width: 90.0, height: 90.0, fit: BoxFit.cover,),
                        ),
                        SizedBox(
                          width: 250.0,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
                                  child: Text(product.name, style: TextStyle(color: Colors.white, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text(Utils.getIngredientsFromProduct(product), overflow: TextOverflow.ellipsis , style: TextStyle(color: Colors.white, fontSize: 11.0, fontFamily: 'LoraFont'),),
                                ),
                                Text('',),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text('€ ' + product.price.toString(), overflow: TextOverflow.ellipsis , style: TextStyle(color: Colors.white, fontSize: 14.0, fontFamily: 'LoraFont'),),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
              : InkWell(
            hoverColor: Colors.blueGrey,
            splashColor: Colors.greenAccent,
            highlightColor: Colors.blueGrey.withOpacity(0.5),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return ModalAddItem(product: product, updateCountCallBack: updateCurrentMenuItemCount);
                  }
              );
            },
            onLongPress: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return ModalAddItem(product: product, updateCountCallBack: updateCurrentMenuItemCount);
                  }
              );
            },
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child: Container(
                decoration: BoxDecoration(
                    color: VENTI_METRI_BLUE,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                        color: VENTI_METRI_MONOPOLI,
                        spreadRadius: 1.0,
                        blurRadius: 1.0,
                      ),
                    ]
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
                      child: Image.asset(product.image, width: 90.0, height: 90.0, fit: BoxFit.fitHeight,),
                    ),
                    SizedBox(
                      width: 250.0,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
                              child: Text(product.name, style: TextStyle(color: Colors.white,fontSize: 16.0, fontFamily: 'LoraFont'),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text(Utils.getIngredientsFromProduct(product), overflow: TextOverflow.ellipsis , style: TextStyle(color: Colors.white,fontSize: 11.0, fontFamily: 'LoraFont'),),
                            ),
                            Text('',),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text('€ ' + product.price.toString(), overflow: TextOverflow.ellipsis , style: TextStyle(color: Colors.white,fontSize: 14.0, fontFamily: 'LoraFont'),),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }
    );
    return items;
  }

  bool _twoListContainsSameElements(List<String> changes, List<String> changesFromModal) {
    bool output = true;
    if(changes.length != changesFromModal.length){
      return false;
    }
    changes.forEach((elementChanges) {
      if(!changesFromModal.contains(elementChanges)){
        output = false;
      }
    });

    if(output){
      return true;
    }else{
      return false;
    }
  }

  Widget getMenuNameFromCurrentMenu(String currentMenuType) {
    String menuType = '';
    String image = '';
    String image_1 = '';
    String image_2 = '';
    int previousMenu;
    int nextMenu;
    bool showPhotos = true;

    switch(currentMenuType){
      case VIGNETO_WINELIST:
        showPhotos = false;
        menuType = 'Bevande';
        image = 'images/xxx.jpg';
        image_2 = 'images/clipart/beef.png';
        image_1 = 'images/clipart/hamb.png';
        nextMenu = 1;
        break;
      case VIGNETO_MENU:
        showPhotos = false;
        menuType = 'Cucina';
        image = 'images/clipart/asahi.jpeg';
        image_1 = 'images/clipart/singhia.png';
        image_2 = 'images/clipart/chang.jpg';
        previousMenu = 0;
        break;
    }
    return Column(
      children: [
        Card(
          color: Colors.white,
          elevation: 3.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              currentMenuType == VIGNETO_WINELIST? Text('') :
              GestureDetector(
                child: Icon(Icons.chevron_left),
                onTap: (){
                  setState(() {
                    updateMenuType(previousMenu);
                  });
                },
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(menuType, style: TextStyle(fontSize: 18.0, color: VENTI_METRI_BLUE, fontFamily: 'LoraFont')),
                ),
              ),
              currentMenuType == VIGNETO_MENU? Text('') :
              GestureDetector(
                child: Icon(Icons.chevron_right),
                onTap: (){
                  setState(() {
                    updateMenuType(nextMenu);
                  });
                },
              ),
            ],
          ),
        ),
        showPhotos ? Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 2),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
                        child: Image.asset(image, width: 90.0, height: 90.0, fit: BoxFit.contain,),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
                        child: Image.asset(image_1, width: 90.0, height: 90.0, fit: BoxFit.contain,),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
                        child: Image.asset(image_2, width: 90.0, height: 90.0, fit: BoxFit.contain,),
                      ),

                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.0,),
            ],
          ),
        ) : Text(''),
      ],
    );
  }

  Future<List<ProductRestaurant>> getCurrentProductList(String currentMenuType) async {

    switch(currentMenuType){
      case VIGNETO_MENU:
        if(fromOsteriaProductList.isEmpty){
          CRUDModel crudModel = CRUDModel(currentMenuType);
          fromOsteriaProductList = await crudModel.fetchRestaurantProducts();
          return fromOsteriaProductList;
        }else{
          return fromOsteriaProductList;
        }
        break;
      case VIGNETO_WINELIST:
        if(wineProductList.isEmpty){
          CRUDModel crudModel = CRUDModel(currentMenuType);
          wineProductList = await crudModel.fetchWine();
          return wineProductList;
        }else{
          return wineProductList;
        }
        break;
    }
  }
}




