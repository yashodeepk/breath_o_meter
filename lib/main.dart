import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'dart:async';

import 'package:breath_o_meter/database.dart';
import 'package:breath_o_meter/datapage.dart';
import 'package:breath_o_meter/model/breath_record.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: BreathOMeter(),
  ));
}

class BreathOMeter extends StatefulWidget {
  @override
  _BreathOMeterState createState() => _BreathOMeterState();
}

class _BreathOMeterState extends State<BreathOMeter> {
  Timer timer;
  double holdperiod = 0;
  String buttonValue = "START";
  bool clicked = false;
  Stopwatch watch = new Stopwatch();
  dynamic db;
  @override
  void initState() {
    super.initState();
    db = DB();
  }

  updateTime(Timer timer) {
    if (watch.isRunning) {
      setState(() {
        holdperiod = watch.elapsedMilliseconds / 1000;
      });
    }
  }

  void saveData() {
    db.insertData(DataModel(
      holdPeriod: holdperiod,
      timeStamp: DateTime.now().millisecondsSinceEpoch,
    ));
    print('DB Record Entered');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.fixed,
      content: Text(
        "Record Entered!",
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.green,
      //margin: EdgeInsets.fromLTRB(20.0, 0, 20.0, 60.0),
      action: SnackBarAction(
        label: 'CLOSE',
        textColor: Colors.white,
        onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Text('Breath Hold Meter'),
          centerTitle: true,
          backgroundColor: Colors.red[800],
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DataPage()));
                },
                icon: Icon(Icons.all_inbox)),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.03,
              MediaQuery.of(context).size.height * 0.04,
              MediaQuery.of(context).size.width * 0.03,
              0.0),
          child: Column(
            children: <Widget>[
              Text(
                'Take a long breath and',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 18,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                'Press on START',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 18,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.1),
              Container(
                height: MediaQuery.of(context).size.height * 0.40,
                width: MediaQuery.of(context).size.height * 0.40,
                child: LiquidCircularProgressIndicator(
                  value: holdperiod / 100,
                  valueColor: AlwaysStoppedAnimation(Colors.red[700]),
                  backgroundColor: Colors.grey[400],
                  borderColor: Colors.red[800],
                  borderWidth: 4.0,
                  direction: Axis.vertical,
                  center: Text(
                    holdperiod.toStringAsFixed(1) + " sec",
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (clicked == true) {
                        clicked = false;
                        watch.stop();
                        holdperiod = watch.elapsedMilliseconds / 1000;
                        buttonValue = "START";
                        saveData();
                      } else {
                        clicked = true;
                        watch.start();
                        timer = new Timer.periodic(
                            new Duration(milliseconds: 100), updateTime);
                        buttonValue = "STOP";
                      }
                    });
                  },
                  child: Text('$buttonValue'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red[600]),
                    padding: MaterialStateProperty.all(EdgeInsets.all(
                        MediaQuery.of(context).size.height * 0.030)),
                    textStyle:
                        MaterialStateProperty.all(TextStyle(fontSize: 30)),
                  ),
                ),
              ),
              TextButton(
                  onPressed: () {
                    setState(() {
                      if (clicked == false) {
                        watch.reset();
                        holdperiod = 0;
                      }
                    });
                  },
                  child: Text(
                    'Reset',
                    style: TextStyle(
                      color: Colors.grey[400],
                    ),
                  ))
            ],
          ),
        ));
  }
}
