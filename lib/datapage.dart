import 'package:flutter/material.dart';
import 'package:breath_o_meter/database.dart';
import 'package:breath_o_meter/model/breath_record.dart';
import 'package:intl/intl.dart';

class DataPage extends StatefulWidget {
  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  Future<List<DataModel>> data;
  List<DataModel> datas = [];
  DB db;
  bool fetching = true;
  @override
  void initState() {
    super.initState();
    db = DB();
    getdata();
  }

  void getdata() async {
    data = db.getData();
    datas = await db.getData();
    datas = datas.reversed.toList();
    setState(() {
      fetching = false;
    });
  }

  String timeStampFormatter(int timestamp) {
    var dt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var d12 = DateFormat('dd-MM-yyyy  hh:mm a').format(dt).toString();

    return d12;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Records'),
          centerTitle: true,
          backgroundColor: Colors.red[800],
        ),
        backgroundColor: Colors.grey[900],
        body: Stack(
          children: [
            Container(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: Text(
                          "Date - Time",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: Text(
                          "Hold Period",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ])),
            Container(
                padding: EdgeInsets.fromLTRB(15, 40, 15, 0),
                child: FutureBuilder<List<DataModel>>(
                    future: data,
                    builder: (context, snapshot) {
                      return ListView(
                        children: datas.map((trip) {
                          return Container(
                            key: Key(trip.id.toString()),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: Colors.grey[800],
                                    style: BorderStyle.solid,
                                    width: 2),
                              ),
                            ),
                            //color: Colors.white,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      //SizedBox(width: 40),
                                      Text(
                                        timeStampFormatter(trip.timeStamp) +
                                            " ",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.045,
                                        ),
                                      ),
                                      //SizedBox(width: 40),
                                      Text(
                                        double.parse(trip.holdPeriod.toString())
                                                .toStringAsFixed(2) +
                                            " ms",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.045,
                                        ),
                                      ),
                                      IconButton(
                                          icon: Icon(Icons.delete),
                                          iconSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.045,
                                          color: Colors.white,
                                          onPressed: () {
                                            setState(() {
                                              db.delete(trip.id ?? 0);
                                              getdata();
                                            });
                                          }),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }))
          ],
        ));
  }
}
