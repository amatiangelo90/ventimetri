import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:venti_metri/dao/crud_model.dart';
import 'package:venti_metri/model/cart.dart';
import 'package:venti_metri/model/order_store.dart';
import 'package:venti_metri/screens/delivery/reserve_order_screen.dart';
import 'package:venti_metri/screens/delivery/utils/costants.dart';

class HttpService {

  static sendOrderMessage(
      String number,
      String message,
      String name,
      String total,
      String time,
      List<Cart> cartItems,
      String uniqueId,
      String typeOrder,
      String datePickupDelivery,
      String hourPickupDelivery,
      String city,
      String address
      ) async {

    var url = 'https://api.whatsapp.com/send/?phone=$number&text=$message';
    print(url);

    try{
      await launch(url);
      try{
        String ORDERS_TRACKER = 'orders-tracker';
        CRUDModel crudModel = CRUDModel(ORDERS_TRACKER);

        String idToDelete = '';

        List<OrderStore> fetchCustomersList = await crudModel.fetchCustomersOrder();

        fetchCustomersList.forEach((element) {
          if(element.id == uniqueId){
            idToDelete = element.docId;
          }
        });

        if(idToDelete != ''){
          crudModel.removeProduct(idToDelete);
        }

        await crudModel.addOrder(
            uniqueId,
            name,
            total,
            time,
            cartItems,
            false,
            typeOrder,
            datePickupDelivery,
            hourPickupDelivery,
            city,
            address);

      }catch(e){
        print('Exception Crud: ' + e.toString());
      }

    }catch(e){
      print('Exception' + e.toString());
      try{
        CRUDModel crudModel = CRUDModel('errors-report');

        await crudModel.addException(
            name,
            e.toString(),
            time);

      }catch(e){
        print('Exception Crud' + e.toString());
      }
    }
  }

  static sendMessage(
      String number,
      String message,
      String name,
      String total,
      String time,
      List<Cart> cartItems,
      String uniqueId,
      String typeOrder,
      String datePickupDelivery,
      String hourPickupDelivery,
      String city,
      String address
      ) async {
    try{

      var url = 'https://api.whatsapp.com/send/?phone=$number&text=$message';
      print(url);
      await launch(url);
      CRUDModel crudModel = CRUDModel(RESERVATION_TRACKER);

      String idToDelete = '';

      List<OrderStore> fetchCustomersList = await crudModel.fetchCustomersOrder();

      fetchCustomersList.forEach((element) {
        if(element.id == uniqueId){
          idToDelete = element.docId;
        }
      });

      if(idToDelete != ''){
        crudModel.removeProduct(idToDelete);
      }

      await crudModel.addOrder(
          uniqueId,
          name,
          total,
          time,
          cartItems,
          false,
          typeOrder,
          datePickupDelivery,
          hourPickupDelivery,
          city,
          address);

    }catch(e){
      print('Exception' + e.toString());
      try{
        CRUDModel crudModel = CRUDModel('errors-report');

        await crudModel.addException(
            name,
            e.toString(),
            time);

      }catch(e){
        print('Exception Crud' + e.toString());
      }
    }
  }
}
