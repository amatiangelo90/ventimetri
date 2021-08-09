import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toast/toast.dart';
import 'package:venti_metri/component/round_icon_botton.dart';
import 'package:venti_metri/model/cart.dart';
import 'package:venti_metri/model/product_restaurant.dart';
import 'package:venti_metri/screens/delivery/utils/utils.dart';
import 'package:venti_metri/utils/utils.dart';


class ModalAddItem extends StatefulWidget {
  final ProductRestaurant product;
  final Function updateCountCallBack;

  ModalAddItem({
    @required this.product,
    @required this.updateCountCallBack,
  });

  @override
  _ModalAddItemState createState() => _ModalAddItemState();
}

class _ModalAddItemState extends State<ModalAddItem> {
  int _counter = 1;
  var listTypeWine = ['whitewine','redwine','rosewine','bollicine'];
  List<Cart> cartProductList = <Cart>[];
  List<String> choicedChangesList = [];

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
      content: Container(
        color: Colors.black,
        height: screenHeight - 250,
        width: screenWidth - 150,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: ListView(
            children: [
              SafeArea(
                child: Center(
                  child: Column(
                    children: [
                      Column(
                        verticalDirection: VerticalDirection.down,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text('', overflow: TextOverflow.visible , style: TextStyle(fontSize: 20.0, fontFamily: 'LoraFont'),),
                          Text(this.widget.product.name, overflow: TextOverflow.visible, style: TextStyle(color: Colors.white,fontSize: 19.0, fontFamily: 'LoraFont'),),
                          SizedBox(height: 15,),
                          Text('€ ' + this.widget.product.price.toString(), overflow: TextOverflow.visible , style: TextStyle(color: Colors.white,fontSize: 25.0, fontFamily: 'LoraFont'),),
                        ],
                      ),
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
                                  if(_counter > 1)
                                    _counter = _counter - 1;
                                });
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(_counter.toString(), style: TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: 'LoraFont'),),
                            ),
                            RoundIconButton(
                              icon: FontAwesomeIcons.plus,
                              function: () {
                                setState(() {
                                  _counter = _counter + 1;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      RaisedButton(
                          child: Text(
                            "Aggiungi al Carrello", overflow: TextOverflow.ellipsis , style: TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: 'LoraFont'),
                          ),
                          color: VENTI_METRI_MONOPOLI,
                          onPressed: (){
                            if(_counter != 0){
                              cartProductList.add(Cart(
                                  product: this.widget.product,
                                  numberOfItem: _counter,
                                  changes: choicedChangesList));
                              Toast.show(
                                  _counter.toString() + ' x ' + this.widget.product.name + ' aggiunto al carrello',
                                  context,
                                  duration: 2,
                                  backgroundColor: Colors.green.shade500,
                                  gravity: 0
                              );
                              this.widget.updateCountCallBack(cartProductList);
                            }else{
                              Toast.show(
                                  'Nessuna aggiunta',
                                  context,
                                  duration: 2,
                                  backgroundColor: Colors.redAccent,
                                  gravity: 0
                              );
                            }
                            Navigator.pop(context);
                          }
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(Utils.getIngredientsFromProduct(this.widget.product), overflow: TextOverflow.visible, style: TextStyle(color: Colors.white,fontSize: 15.0, fontFamily: 'LoraFont'),),
                      ),
                      /*Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: listTypeWine.contains(this.widget.product.category) ?
                        Text('Cantina: ' +  this.widget.product.changes[0], overflow: TextOverflow.visible , style: TextStyle(color: Colors.white,fontSize: 15.0, fontFamily: 'LoraFont'),)
                            : SizedBox(height: 0.0,),
                      ),*/
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: listTypeWine.contains(this.widget.product.category) ?
                        Text(Utils.getAllergensFromProduct(this.widget.product), overflow: TextOverflow.ellipsis , style: TextStyle(color: Colors.white,fontSize: 16.0, fontFamily: 'LoraFont'),)
                        /*: Text('Allergeni: ' +  Utils.getAllergensFromProduct(this.widget.product), overflow: TextOverflow.visible , style: TextStyle(fontSize: 13.0, fontFamily: 'LoraFont'),),*/
                            : SizedBox(height: 0.0,),
                      ),
                      /*ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        child:
                        Image.asset(this.widget.product.image, width: screenWidth - 100, height: screenHeight - 600, fit: BoxFit.fitHeight,),
                      ),*/
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> castDynamicListToStrinList(List<dynamic> changes) {
    List<String> output = [];
    changes.forEach((element) {
      output.add(element.toString());
    }
    );
    return output;
  }
}

class Content extends StatefulWidget {

  final Widget child;

  Content({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> with AutomaticKeepAliveClientMixin<Content>  {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
            fit: FlexFit.loose,
            child: widget.child
        ),
      ],
    );
  }
}
