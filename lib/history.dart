import 'dart:convert';

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
      body: Text(jsonEncode(_history)),
    );
  }
}