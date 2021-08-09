import 'package:flutter/material.dart';
import 'package:venti_metri/component/icon_content.dart';
import 'package:venti_metri/component/reusable_card.dart';
import 'package:venti_metri/model/product_restaurant.dart';
import 'package:venti_metri/utils/utils.dart';

import 'costants.dart';

class Utils{

  static getIngredientsFromProduct(ProductRestaurant product){
    String ingredientString = "";
    List<dynamic> dataIngredients = product.listIngredients;
    dataIngredients.forEach((ingredient) {
      ingredientString = ingredientString + ingredient + " | ";
    });
    return ingredientString.substring(0, ingredientString.length -2);


  }

  static getAllergensFromProduct(ProductRestaurant product){
    String allergensString = "";
    List<dynamic> dataAllergens = product.listAllergens;
    dataAllergens.forEach((allergen) {
      allergensString = allergensString + allergen + " | ";
    });
    return allergensString.substring(0, allergensString.length -2);
  }

  static List<DateTime> getUnavailableData(){
    return [
      DateTime.utc(2021,6 ,7 ,0 ,0 ,0 ,0 ,0),
      DateTime.utc(2021,6 ,14 ,0 ,0 ,0 ,0 ,0),
      DateTime.utc(2021,6 ,15 ,0 ,0 ,0 ,0 ,0),
      DateTime.utc(2021,6 ,16 ,0 ,0 ,0 ,0 ,0),
      DateTime.utc(2021,6, 21 ,0 ,0 ,0 ,0 ,0),
      DateTime.utc(2021,6, 28 ,0 ,0 ,0 ,0 ,0),
    ];
  }

  static List<DateTime> getUnavailableDataToday(){
    return [
      DateTime.utc(2021,7 ,5 ,0 ,0 ,0 ,0 ,0),
      DateTime.utc(2021,7 ,6 ,0 ,0 ,0 ,0 ,0),
      DateTime.utc(2021,7 ,11 ,0 ,0 ,0 ,0 ,0),
      DateTime.utc(2021,7 ,14 ,0 ,0 ,0 ,0 ,0),
      DateTime.utc(2021,6 ,15 ,0 ,0 ,0 ,0 ,0),
      DateTime.utc(2021,6 ,16 ,0 ,0 ,0 ,0 ,0),
      DateTime.utc(2021,6 ,19 ,0 ,0 ,0 ,0 ,0),
      DateTime.utc(2021,6 ,21 ,0 ,0 ,0 ,0 ,0),
      DateTime.utc(2021,6 ,22 ,0 ,0 ,0 ,0 ,0),
      DateTime.utc(2021,6, 23 ,0 ,0 ,0 ,0 ,0),
      DateTime.utc(2021,6, 28 ,0 ,0 ,0 ,0 ,0),
    ];
  }

  static String getWeekDay(int weekday) {
    switch(weekday){
      case 1:
        return "Lunedi";
      case 2:
        return "Martedi";
      case 3:
        return "Mercoledi";
      case 4:
        return "Gioverdi";
      case 5:
        return "Venerdi";
      case 6:
        return "Sabato";
      case 7:
        return "Domenica";
    }
    return "";
  }

  static String getMonthDay(int month) {
    switch(month){
      case 1:
        return "Gennaio";
      case 2:
        return "Febbraio";
      case 3:
        return "Marzo";
      case 4:
        return "Aprile";
      case 5:
        return "Maggio";
      case 6:
        return "Giugno";
      case 7:
        return "Luglio";
      case 8:
        return "Agosto";
      case 9:
        return "Settembre";
      case 10:
        return "Ottobre";
      case 11:
        return "Novembre";
      case 12:
        return "Dicembre";
    }
    return "";
  }

  static bool twoListContainsSameElements(List<String> changes, List<String> changesFromModal) {
    bool output = true;
    if(changes.length != changesFromModal.length){
      return false;
    }
    changes.forEach((elementChanges) {
      if(!changesFromModal.contains(elementChanges)){
        print('assign false');
        output = false;
      }
    });

    if(output){
      return true;
    }else{
      return false;
    }
  }

  static Widget buildInfoAlertDialog(context) {
    return AlertDialog(
      elevation: 2.0,
      title: Center(child: const Text('Informazioni', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),)),
      content: Container(
        child: Column(
          textDirection: TextDirection.ltr,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
              child: Row(
                children: [
                  Text('Ordini per il Delivery fino alle ',
                    style: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),),
                  Text('18.00',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.0, fontFamily: 'LoraFont'),),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
              child: Row(
                children: [
                  Text('Ordini per l\'Asporto fino alle ',
                    style: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),),
                  Text('20.00',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.0, fontFamily: 'LoraFont'),),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
              child: Row(
                children: [
                  Text('Consegna dalle ',
                    overflow: TextOverflow.visible ,style: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),),
                  Text('19.30',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.0, fontFamily: 'LoraFont'),),
                  Text(' alle ',
                    overflow: TextOverflow.visible ,style: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),),
                  Text('21.30',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.0, fontFamily: 'LoraFont'),),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
              child: Row(
                children: [
                  Text('Per delivery ordine minimo: ',
                    overflow: TextOverflow.visible, style: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),),
                  Text('40 €',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.0, fontFamily: 'LoraFont'),),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
              child: Row(
                children: [
                  Text('Costo delivery: ',
                    overflow: TextOverflow.visible, style: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),),
                  Text('3 €',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.0, fontFamily: 'LoraFont'),),
                ],
              ),
            ),
            Row(
              children: [
                Text(' (Gratis per ordini superiori a 50 €)',
                  overflow: TextOverflow.visible, style: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(''),
            ),
            const Text('Inviaci la richiesta d’ordine, ti risponderemo al più presto dopo aver verificato la disponibilità',
              overflow: TextOverflow.visible, style: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                  child: const Text('Grazie per averci scelto',
                    overflow: TextOverflow.visible, style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("Indietro"),
        ),
      ],
    );
  }

  static Widget buildChooseMenu(BuildContext context) {
    return AlertDialog(
      elevation: 2.0,
      title: Center(child: const Text('Menu', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),)),
      content: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: ReusableCard(
                color: VENTI_METRI_MONOPOLI,
                cardChild: IconContent(label: 'THAI', icon: Icons.food_bank, color: Colors.white),
                onPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Attenzione', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                        content: Text('Per il servizio delivery il minimo d\'ordine è di € 40', style: TextStyle(color: VENTI_METRI_MONOPOLI, fontSize: 16.0, fontFamily: 'LoraFont'),),
                        actions: <Widget>[
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
            ),Expanded(
              child: ReusableCard(
                color: VENTI_METRI_MONOPOLI,
                cardChild: IconContent(label: 'THAI', icon: Icons.food_bank, color: Colors.white),
                onPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Attenzione', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                        content: Text('Per il servizio delivery il minimo d\'ordine è di € 40', style: TextStyle(color: VENTI_METRI_MONOPOLI, fontSize: 16.0, fontFamily: 'LoraFont'),),
                        actions: <Widget>[
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
            ),Expanded(
              child: ReusableCard(
                color: VENTI_METRI_MONOPOLI,
                cardChild: IconContent(label: 'THAI', icon: Icons.food_bank, color: Colors.white),
                onPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Attenzione', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                        content: Text('Per il servizio delivery il minimo d\'ordine è di € 40', style: TextStyle(color: VENTI_METRI_MONOPOLI, fontSize: 16.0, fontFamily: 'LoraFont'),),
                        actions: <Widget>[
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
            ),Expanded(
              child: ReusableCard(
                color: VENTI_METRI_MONOPOLI,
                cardChild: IconContent(label: 'THAI', icon: Icons.food_bank, color: Colors.white),
                onPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Attenzione', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                        content: Text('Per il servizio delivery il minimo d\'ordine è di € 40', style: TextStyle(color: VENTI_METRI_MONOPOLI, fontSize: 16.0, fontFamily: 'LoraFont'),),
                        actions: <Widget>[
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
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("Indietro"),
        ),
      ],
    );
  }

  static String getNameByType(String type) {
    switch(type){
      case categoryWhiteWine:
        return 'Bianco';
      case categoryRedWine:
        return 'Rosso';
      case categoryDrink:
        return 'Drink';
      case categoryBollicineWine:
        return 'Bollicine';
      case categoryRoseWine:
        return 'Rosato';
    }
    return '';
  }

  static Color getColorByType(String type) {
    switch(type){
      case categoryWhiteWine:
        return Colors.yellow.shade600;
      case categoryBollicineWine:
        return Colors.tealAccent.shade400;
      case categoryDrink:
        return Colors.lightBlueAccent.shade100;
      case categoryRedWine:
        return Colors.red.shade900;
      case categoryRoseWine:
        return Colors.pinkAccent.shade100;
    }
    return Colors.black;
  }
}