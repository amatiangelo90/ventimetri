import 'package:flutter/material.dart';
import 'package:venti_metri/model/events_models/product_event.dart';
import 'package:venti_metri/model/expence_class.dart';

class ExpencesDataSource extends DataTableSource {
  int _selectedCount = 0;

  final List<ExpenceClass> _expencesList;
  ExpencesDataSource(this._expencesList);

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _expencesList.length) return null;
    final ExpenceClass expenceClass = _expencesList[index];
    return DataRow.byIndex(
        index: index,
        selected: bool.fromEnvironment(expenceClass.official.toLowerCase()),
        onSelectChanged: (bool value) {
          if (bool.fromEnvironment(expenceClass.official.toLowerCase()) != value) {
            _selectedCount += value ? 1 : -1;
            assert(_selectedCount >= 0);
            expenceClass.official = value.toString();
            notifyListeners();
          }
        },
        cells: <DataCell>[
          DataCell(Text(expenceClass.casuale)),
          DataCell(Text(expenceClass.amount.toString())),
          DataCell(Text(expenceClass.details.toString())),
          DataCell(Text((double.parse(expenceClass.details) * double.parse(expenceClass.amount)).toString())),
        ]
    );
  }

  @override
  int get rowCount => _expencesList.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}