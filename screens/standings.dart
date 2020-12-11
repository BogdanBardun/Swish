import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swish_app/services/login.dart';
import 'package:swish_app/services/auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swish_app/screens/home.dart';

class Standings extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const Standings({Key key, this.auth, this.firestore}) : super(key: key);

  @override
  _StandingsState createState() => _StandingsState();
}

class StandingsTable extends StatefulWidget {
  final List data;
  final int length;
  StandingsTable({Key key, @required this.data, @required this.length}) : super(key: key);
  @override
  _StandingsTableState createState() => _StandingsTableState();
}

class _StandingsTableState extends State<StandingsTable> {
  Widget getListItem(int i) {
    if (widget.data == null) return null;
    return Container(
      child: Container(
        margin: EdgeInsets.all(4.0),
        child: Padding(
          padding: EdgeInsets.all(4),
          child: Text(
              widget.data[i]['standing_place'].toString() + ". " +
            widget.data[i]['standing_team'].toString() + "  W: " +
                (int.parse(widget.data[i]['standing_W']) + int.parse(widget.data[i]['standing_WO'])).toString() +
                "  L: " + (int.parse(widget.data[i]['standing_L']) + int.parse(widget.data[i]['standing_LO'])).toString(),
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    var bck;
    if (bck != null) return Standings();
      if (widget.data == null) {
        return Container(
          child: Center(
            child: Text("Please wait..."),
          ),
        );
      }
      return ListView.separated(
        itemCount: widget.length,
        itemBuilder: (BuildContext context, int index) {
          return getListItem(index);
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      );
  }
}

class _StandingsState extends State<Standings> {
  List data = null;

  Future<List> getStandings(int leagid) async {
    var response = await http.get(
        Uri.encodeFull("https://allsportsapi.com/api/basketball/?&met=Standings&leagueId=${leagid}&APIkey=96a495bf88755a3e2dbb82b90f6bea080845367745a7a1f99122c267d11ed6f0"));
    return json.decode(response.body)['result']['total'].toList();
  }
  var t;

 @override
  Widget build(BuildContext context) {
   if (t != null) return t;
    return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      FlatButton(
        onPressed : () async {
          data = await getStandings(787);
          //print(data);
          setState(() {
            t = StandingsTable(data: data, length: 12);
          });
        },
        padding: EdgeInsets.all(0.0),
        child: Image.asset('images/nba.png')
      ),
      FlatButton(
        onPressed : () async {
          data = await getStandings(821);
          //(data);
          setState(() {
          t = StandingsTable(data: data, length: 18);
          });
        },
          padding: EdgeInsets.only(top: 10),
          child: Image.asset('images/euroleague.png')
      ),
      FlatButton(
        onPressed : () async {
          data = await getStandings(739);
          setState(() {
            t = StandingsTable(data: data, length: 13);
          });
        },
          padding: EdgeInsets.only(top: 10),
          child: Image.asset('images/vtb.png')
      ),
    ],
  );
  }
}