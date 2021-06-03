import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:venti_metri/model/expence_class.dart';
import 'package:venti_metri/utils/utils.dart';

class ExpenceProfitDetails extends StatefulWidget {

  static String id = 'chart_page';

  final List<ExpenceClass> expenceList;
  final List<ExpenceClass> profitsList;
  final DateTimeRange dateTimeRange;

  ExpenceProfitDetails({@required this.expenceList,@required this.profitsList,@required  this.dateTimeRange});

  @override
  _ExpenceProfitDetailsState createState() => _ExpenceProfitDetailsState();
}

class _ExpenceProfitDetailsState extends State<ExpenceProfitDetails> {

  ScrollController scrollViewController = ScrollController();
  ScrollController scrollViewControllerGrafh = ScrollController();
  Map<double, double> _profits;
  Map<double, double> _expences;
  Map<double, String> _mapConverterDateIndex;

  @override
  void initState() {
    super.initState();
    _mapConverterDateIndex = buildMapDateConverterIndexByTimeRange(this.widget.dateTimeRange);
    _expences = buildMapGrafhByListExpence(this.widget.expenceList, _mapConverterDateIndex);
    _profits = buildMapGrafhByListExpence(this.widget.profitsList, _mapConverterDateIndex);
  }

  @override
  Widget build(BuildContext context) {
    /// !!Step2: convert data into barGroups.
    final barGroups = <BarChartGroupData>[
      for (final entry in _profits.entries)
        BarChartGroupData(
          x: entry.key.toInt(),
          barRods: [
            BarChartRodData(y: entry.value, colors: [VENTI_METRI_BLUE]),
            BarChartRodData(y: _expences[entry.key], colors: [VENTI_METRI_PINK]),
          ],
        ),
    ];

    final barChartData = BarChartData(
      barGroups: barGroups,
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.blueGrey,
        ),
      ),
      borderData: FlBorderData(show: false),
      gridData: FlGridData(show: true),

      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTitles: (double val) =>
          _mapConverterDateIndex[val],
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTitles: (double val) {
            if (val.toInt() % 100 != 0)
              return '';
            return '${val.toInt()}';
          },
        ),
      ),
    );
    return SafeArea(
      child: Container(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: VENTI_METRI_GREY,
            title: Text('Dettaglio Costi/Ricavi ' + this.widget.dateTimeRange.start.day.toString()+'/'+this.widget.dateTimeRange.start.month.toString()
                + ' - ' + this.widget.dateTimeRange.end.day.toString()+'/'+this.widget.dateTimeRange.end.month.toString() , style: TextStyle(fontSize: 15,color: Colors.white)),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
            child: Center(child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                  width: 400,
                  child: BarChart(barChartData)
              ),
              controller: scrollViewControllerGrafh ,)
            ),
          ),
          bottomNavigationBar: _buildControlWidgets(),
        ),
      ),
    );
  }
  Widget _buildControlWidgets() {
    return Container(
      height: 300,
      color: Colors.grey[200],
      child: SingleChildScrollView(
        controller: scrollViewController,
        child: Table(
          border: TableBorder(
              horizontalInside: BorderSide(
                  width: 1,
                  color: Colors.orangeAccent, style: BorderStyle.solid)),
          children: buildTableRowFromBuildedMap(
          ),
        ),
      ),
    );
  }

  Map<double, String> buildMapDateConverterIndexByTimeRange(DateTimeRange dateTimeRange) {

    Map<double, String> mapToReturn = Map();

    final daysToGenerate = dateTimeRange.end.difference(dateTimeRange.start).inDays;
    for(int i = 0; i <= daysToGenerate; i++){
      mapToReturn[i.toDouble()] = (dateTimeRange.start.add(Duration(days: i)).day.toString() +'/'+ dateTimeRange.start.add(Duration(days: i)).month.toString());
    }
    return mapToReturn;
  }

  Map<double, double> buildMapGrafhByListExpence(List<ExpenceClass> list,
      Map<double, String> mapConverterDateIndex) {

    Map<double, double> mapToReturn = Map();
    Map<String, double> mapToParse = Map();

    list.forEach((element) {
      if(mapToParse.containsKey(buildKeyFromDate(element))){
        mapToParse[buildKeyFromDate(element)] = mapToParse[buildKeyFromDate(element)] + double.parse(element.amount);
      }else{
        mapToParse[buildKeyFromDate(element)] = double.parse(element.amount);
      }
    });

    mapConverterDateIndex.forEach((key, value) {

      if(mapToParse.containsKey(value)){
        mapToReturn[key] = mapToParse[value];
      }else{
        mapToReturn[key] = 0;
      }
    });

    return mapToReturn;
  }

  String buildKeyFromDate(ExpenceClass element) {
    return DateTime.fromMillisecondsSinceEpoch(element.date.millisecondsSinceEpoch).day.toString() + '/'
        + DateTime.fromMillisecondsSinceEpoch(element.date.millisecondsSinceEpoch).month.toString();
  }

  buildTableRowFromBuildedMap() {
    List<TableRow> list = <TableRow>[];

    _expences.forEach((key, value) {
      list.add(TableRow(
          children: [
            TableCell(
              child: Text(key.toString()),
            ),
            TableCell(
              child: Text(value.toString()),
            ),
          ]
      ),);
    });

    _profits.forEach((key, value) {
      list.add(TableRow(
          children: [
            TableCell(
              child: Text(key.toString()),
            ),
            TableCell(
              child: Text(value.toString()),
            ),
          ]
      ),);
    });
    return list;


  }

}