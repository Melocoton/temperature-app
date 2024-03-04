import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:temperature_app/data/models/record.dart';
import 'package:temperature_app/data/providers/temperature_api.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key, required this.title, required this.id});

  final String title;
  final int id;

  @override
  State<StatefulWidget> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Record> _history = [];
  
  @override
  void initState() {
    super.initState();
    _loadHistory();
  }
  
  void _loadHistory() async {
    var data = await TemperatureApi().getHistory(
        widget.id,
        DateTime.now().subtract(const Duration(hours: 24)),
        DateTime.now(),
    );
    setState(() {
      _history = data;
    });
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
            child: Card(
              child: Column(
                children: [
                  const Text('Temperatura', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  AspectRatio(
                    aspectRatio: 2 / 1,
                    child: LineChart(
                      LineChartData(
                        lineTouchData: const LineTouchData(),
                        gridData: const FlGridData(),
                        titlesData: const FlTitlesData(),
                        borderData: FlBorderData(),
                        lineBarsData: [
                          LineChartBarData(
                              isCurved: false,
                              dotData: const FlDotData(show: false),
                              spots: _history.map((e) => FlSpot(e.time.toDouble(), e.temperature.toDouble())).toList()
                          ),
                        ],
                        maxY: _history.isNotEmpty ? _history.map((e) => e.temperature).reduce(max).toDouble() + 5 : 0,
                        minY: _history.isNotEmpty ? _history.map((e) => e.temperature).reduce(min).toDouble() - 5 : 0,
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
                        gridData: const FlGridData(),
                        titlesData: const FlTitlesData(),
                        borderData: FlBorderData(),
                        lineBarsData: [
                          LineChartBarData(
                              color: Colors.orange,
                              isCurved: false,
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
          )
        ],
      ),
    );
  }
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