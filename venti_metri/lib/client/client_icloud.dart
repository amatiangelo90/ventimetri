import 'dart:convert';
import 'package:dio/dio.dart';

import 'model/body_fatture_lista.dart';

class ICloudClient{


  static Future<Response> retrieveListaFatture(String url, RetrieveFattureListBody retrieveFattureListBody) async {
    var dio = Dio();

    String body = json.encode(retrieveFattureListBody.toMap());
    Response post;
    try{
      post = await dio.post(
        url,
        data: body,
        /*options: Options(
          headers: {
            "Access-Control-Allow-Headers": "date,content-type,content-length,server,vary,content-encoding,x-aspnet-version,x-powered-by",
            "Access-Control-Allow-Methods": "GET, HEAD, POST, PUT, DELETE, CONNECT, OPTIONS, TRACE, PATCH",
            "Access-Control-Allow-Origin": "https://api.fattureincloud.it",
            "Access-Control-Expose-Headers": "date, content-type, content-length, server, vary, content-encoding, x-aspnet-version, x-powered-by",
          },
        ),*/
        options: Options(
          headers: {
            "sec-fetch-mode": "cors",
            "sec-fetch-site": "cross-site",
            "sec-fetch-des": "empty",
            "accept": "*/*",
            "method": "POST",
          },
        ),
      );
    }catch(e){
      print(e);
    }
    return post;
  }

}