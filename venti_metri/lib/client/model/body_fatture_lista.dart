import 'dart:core';

class RetrieveFattureListBody{
  String apiUid;
  String apiKey;
  int year;
  String dataInizio;
  String dataFine;
  String cliente;
  String fornitore;
  String idCliente;
  String idFornitore;
  String saldato;
  String oggetto;
  String ogniDdt;
  bool pa;
  String paTipoCliente;
  int pagina;

  RetrieveFattureListBody(this.apiUid, this.apiKey, this.year, this.dataInizio,
      this.dataFine, this.cliente, this.fornitore, this.idCliente,
      this.idFornitore, this.saldato, this.oggetto, this.ogniDdt, this.pa,
      this.paTipoCliente, this.pagina);


  toMap(){
    return {
      'api_uid': apiUid,
      'api_key': apiKey,
      'anno': year,
      'data_inizio': dataInizio,
      'data_fine': dataFine,
      'cliente': cliente,
      'fornitore': fornitore,
      'id_cliente': idCliente,
      'id_fornitore': idFornitore,
      'saldato': saldato,
      'oggetto': oggetto,
      'ogni_ddt': ogniDdt,
      'PA': pa,
      'PA_tipo_cliente': paTipoCliente,
      'pagina': pagina
    };

  }


}
