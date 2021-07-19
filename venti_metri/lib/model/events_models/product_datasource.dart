import 'package:flutter/material.dart';
import 'package:venti_metri/model/events_models/product_class.dart';

class ProductDataSource extends DataTableSource {
  int _selectedCount = 0;

  final List<Product> _products;
  ProductDataSource(this._products);

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _products.length) return null;
    final Product product = _products[index];
    return DataRow.byIndex(
        index: index,
        selected: product.selected,
        onSelectChanged: (bool value) {
          if (product.selected != value) {
            _selectedCount += value ? 1 : -1;
            assert(_selectedCount >= 0);
            product.selected = value;
            notifyListeners();
          }
        },
        cells: <DataCell>[
          DataCell(Text(product.name)),
          DataCell(Text(product.measure.toString())),
          DataCell(Text(product.price.toStringAsFixed(2))),
        ]
    );
  }

  @override
  int get rowCount => _products.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}