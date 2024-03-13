import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:temperature_app/data/models/temperature.dart';
import 'package:temperature_app/data/providers/temperature_api.dart';
import 'package:temperature_app/history.dart';

import 'data/models/device.dart';

void main() {
  runApp(const MyApp());
}

List<Device> _deviceList = [];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Termometros',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyanAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Temperatura actual'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Temperature> _temperatureList = [];

  @override
  void initState() {
    super.initState();
    _initialLoad();
  }

  void _initialLoad() async{
    _deviceList = await TemperatureApi().getDevices();
    _loadCurrentTemperature();
  }

  void _loadCurrentTemperature() async {
    var data = await TemperatureApi().getCurrentTemp();
    setState(() {
      _temperatureList = data;
    });
  }

  Future<void> _pullRefresh() async {
    _loadCurrentTemperature();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
          child: ListView(
            children: _temperatureList.map((e) => DataCard(temperatureData: e)).toList(),
          )
      ),
      floatingActionButton: Visibility(
        visible: kIsWeb || Platform.isWindows || Platform.isLinux,
        child: FloatingActionButton(
          onPressed: _loadCurrentTemperature,
          tooltip: 'Load',
          child: const Icon(Icons.refresh),
        ),
      )
    );
  }
}

class DataCard extends StatelessWidget {
  final Temperature temperatureData;
  const DataCard({
    super.key,
    required this.temperatureData
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryPage(title: 'Historico', id: temperatureData.id)))
      },
      child: Card(
          color: Theme.of(context).colorScheme.background,
          margin: const EdgeInsets.all(10),
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        getDeviceName(temperatureData.id),
                        'T: ${temperatureData.temperature.toString()}º, H: ${temperatureData.humidity.toString()}%',
                        dateFormat(temperatureData.time)
                      ].map((e) => Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          e,
                          style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5),
                        ),
                      )).toList(),
                    ),
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
}

class TemperatureText extends StatelessWidget {
  final String text;
  const TemperatureText({
    super.key,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5),
      textAlign: TextAlign.end,
    );
  }
}

String dateFormat(DateTime date){
  var str = date.toLocal().toString();
  return str.substring(0, str.length - 4);
}

String getDeviceName(int id) {
  return _deviceList.firstWhere((element) => element.id == id, orElse: () => Device(id: id, description: id.toString())).description;
}