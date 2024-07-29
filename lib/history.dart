import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:temperature_app/data/models/record.dart';
import 'package:temperature_app/data/providers/temperature_api.dart';

import 'data/models/summary.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key, required this.title, required this.id});

  final String title;
  final int id;

  @override
  State<StatefulWidget> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Record> _history = [];
  List<Summary> _summary = [];

  @override
  void initState() {
    super.initState();
    _loadHistory(null);
  }

  void _loadHistory(DateTimeRange? timeRange) async {
    var data = await TemperatureApi().getHistory(
      widget.id,
      timeRange != null ? timeRange.start : DateTime.now().subtract(const Duration(hours: 24)),
      timeRange != null ? timeRange.end.add(const Duration(hours: 24)) : DateTime.now(),
    );
    var summData = await TemperatureApi().getSummary(
      widget.id,
      timeRange != null ? timeRange.start : DateTime.now().subtract(const Duration(days: 30)),
      timeRange != null ? timeRange.end.add(const Duration(hours: 24)) : DateTime.now(),
    );
    setState(() {
      _history = data;
      _summary = summData;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTimeRange? pickedRange = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2024),
        lastDate: DateTime(2101)
    );
    if (pickedRange != null) {
      _loadHistory(pickedRange);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          SizedBox(
            child: Row(
              children: [
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: const Icon(Icons.calendar_month),
                ),
                TextButton(
                  onPressed: () => _loadHistory(null),
                  child: const Text('Ultimas 24h'),
                ),
              ],
            ),
          ),
          SizedBox(
            child: Card(
              child: Column(
                children: [
                  const Text('Temperatura', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  AspectRatio(
                    aspectRatio: 2 / 1,
                    child: LineChart(
                      LineChartData(
                        lineTouchData: const LineTouchData(),
                        gridData: const FlGridData(
                          show: true,
                        ),
                        titlesData: const FlTitlesData(
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 50,
                              getTitlesWidget: timeTitleWidget,
                            )
                          ),
                        ),
                        borderData: FlBorderData(),
                        lineBarsData: [
                          LineChartBarData(
                            isCurved: true,
                            dotData: const FlDotData(show: false),
                            spots: _history.map((e) => FlSpot(e.time.toDouble(), e.temperature.toDouble())).toList()
                          ),
                        ],
                        maxY: _history.isNotEmpty ? _history.map((e) => e.temperature).reduce(max).roundToDouble() + 5 : 0,
                        minY: _history.isNotEmpty ? _history.map((e) => e.temperature).reduce(min).roundToDouble() - 5 : 0,
                      ),
                      duration: const Duration(milliseconds: 250),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            child: Card(
              child: Column(
                children: [
                  const Text('Humedad', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  AspectRatio(
                    aspectRatio: 2 / 1,
                    child: LineChart(
                      LineChartData(
                        lineTouchData: const LineTouchData(),
                        gridData: const FlGridData(
                          show: true,
                        ),
                        titlesData: const FlTitlesData(
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 50,
                              getTitlesWidget: timeTitleWidget,
                            )
                          ),
                        ),
                        borderData: FlBorderData(),
                        lineBarsData: [
                          LineChartBarData(
                            color: Colors.orange,
                            isCurved: true,
                            dotData: const FlDotData(show: false),
                            spots: _history.map((e) => FlSpot(e.time.toDouble(), e.humidity.toDouble())).toList()
                          ),
                        ],
                        maxY: 100,
                        minY: 0,
                      ),
                      duration: const Duration(milliseconds: 250),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            child: Card(
              child: Column(
                children: [
                  const Text('Temperatura Max/Min', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  AspectRatio(
                    aspectRatio: 2 / 1,
                    child: BarChart(
                      BarChartData(
                        barGroups: _summary.map((e) =>
                          BarChartGroupData(
                            x: e.time.millisecondsSinceEpoch,
                            barRods: [
                              BarChartRodData(
                                toY: e.maxTemp.toDouble(),
                                color: Colors.red,
                                width: 5
                              ),
                              BarChartRodData(
                                toY: e.minTem.toDouble(),
                                color: Colors.blue,
                                width: 5
                              )
                            ]
                          )
                        ).toList(),
                        titlesData: const FlTitlesData(
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 50,
                              getTitlesWidget: dayTitleWidget,
                            )
                          )
                        ),
                        maxY: _summary.isNotEmpty ? _summary.map((e) => e.maxTemp).reduce(max).roundToDouble() + 5 : 0,
                        minY: _summary.isNotEmpty ? _summary.map((e) => e.minTem).reduce(min).roundToDouble() < 0 ? _summary.map((e) => e.maxTemp).reduce(max).roundToDouble() - 5 : 0 : 0,
                      ),
                      swapAnimationDuration: const Duration(milliseconds: 250),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            child: Card(
              child: Column(
                children: [
                  const Text('Humedad Max/Min', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  AspectRatio(
                    aspectRatio: 2 / 1,
                    child: BarChart(
                      BarChartData(
                        barGroups: _summary.map((e) =>
                            BarChartGroupData(
                                x: e.time.millisecondsSinceEpoch,
                                barRods: [
                                  BarChartRodData(
                                      toY: e.maxHum.toDouble(),
                                      color: Colors.red,
                                      width: 5
                                  ),
                                  BarChartRodData(
                                      toY: e.minHum.toDouble(),
                                      color: Colors.blue,
                                      width: 5
                                  )
                                ]
                            )
                        ).toList(),
                        titlesData: const FlTitlesData(
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 50,
                                  getTitlesWidget: dayTitleWidget,
                                )
                            )
                        ),
                        maxY: _summary.isNotEmpty ? _summary.map((e) => e.maxHum).reduce(max).roundToDouble() + 5 : 0,
                        minY: 0,
                      ),
                      swapAnimationDuration: const Duration(milliseconds: 250),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget timeTitleWidget(double value, TitleMeta meta) {
  String fecha = DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(value.toInt()));

  Widget text = RotationTransition(
    turns: const AlwaysStoppedAnimation(45 / 360),
    child: Text(fecha),
  );
  return SideTitleWidget(axisSide: meta.axisSide, space: 10, child: text);
}

Widget dayTitleWidget(double value, TitleMeta meta) {
  String fecha = DateFormat.MMMd().format(DateTime.fromMillisecondsSinceEpoch(value.toInt()));

  Widget text = RotationTransition(
    turns: const AlwaysStoppedAnimation(45 / 360),
    child: Text(fecha),
  );
  return SideTitleWidget(axisSide: meta.axisSide, space: 10, child: text);
}

List<Record> reduceRecords(List<Record> list) {
  List<Record> newList = [];
  int counter = 0;
  int step = list.length ~/ 100;
  for (Record element in list) {
    if (counter == 0) {
      newList.add(element);
      counter++;
    } else if (counter >= step) {
      counter = 0;
    } else {
      counter++;
    }
  }
  return newList;
}