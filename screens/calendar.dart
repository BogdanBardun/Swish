import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}


class _CalendarState extends State<Calendar> {
  Future<List> getLivescore(int lid) async {
    var response = await http.get(
        Uri.encodeFull("https://allsportsapi.com/api/basketball/?met=Livescore&leagueId=${lid}&APIkey=96a495bf88755a3e2dbb82b90f6bea080845367745a7a1f99122c267d11ed6f0"));
    if (json.decode(response.body)['result'] == null) return null;
    else {
      //print(json.decode(response.body)['result'].toList());
      return json.decode(response.body)['result'].toList();
    }
  }
  Future<List> getMatches(int lid) async {
    var now = new DateTime.now();
    var prevMonth = new DateTime(now.year, now.month - 1, now.day);
    now = DateTime(now.year, now.month, now.day - 1);
    var formatter = new DateFormat('yyyy-MM-dd');
    String nowDate = formatter.format(now);
    String prevmonthDate = formatter.format(prevMonth);
    var response = await http.get(
        Uri.encodeFull("https://allsportsapi.com/api/basketball/?met=Fixtures&leagueId=${lid}&APIkey=96a495bf88755a3e2dbb82b90f6bea080845367745a7a1f99122c267d11ed6f0&from=${prevmonthDate}&to=${nowDate}"));
    if (json.decode(response.body)['result'] == null) return null;
    else {
      //print(json.decode(response.body)['result'].toList());
      return json.decode(response.body)['result'].toList();
    }
  }
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  @override
  var st;
  var res, res2, res3;
  var cl;
  Widget getListItem(int i) {
    if (cl == null) return null;
      return Container(
      child: Container(
        margin: EdgeInsets.all(4.0),
        child: Padding(
          padding: EdgeInsets.all(4),
          child: Text(
            cl[i]['event_home_team'].toString() + " " +
                cl[i]['event_final_result'].toString() + " " +
                cl[i]['event_away_team'].toString(),
            style: TextStyle(fontSize: 22),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    if(st == 1) return Text(
      'No live matches now',
      style: optionStyle,
    );
    if(st == 2) return ListView.separated(
      itemCount: cl.length,
      itemBuilder: (BuildContext context, int index) {
        return getListItem(index);
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FlatButton(
            onPressed : () async {
              res = await getLivescore(787);
              res2 = await getLivescore(821);
              res3 = await getLivescore(739);
              if(res != null) {
                cl = res;
                if(res2 != null) cl += res2;
                else if(res3 != null) cl += res3;
              }
              else if(res2 != null) {
                cl = res2;
                if (res3 != null) cl += res3;
              }
              else if(res3 != null) cl = res3;
              if(cl == null)  setState(() {
                st = 1;
              });
              else setState(() {
                st = 2;
              });
            },
            padding: EdgeInsets.all(0.0),
            child: Image.asset('images/kobe.png')
        ),
        FlatButton(
            onPressed : () async {
              res = await getMatches(787);
              res2 = await getMatches(821);
              res3 = await getMatches(739);
              if(res != null) {
                cl = res;
                if(res2 != null) cl += res2;
                else if(res3 != null) cl += res3;
              }
              else if(res2 != null) {
                cl = res2;
                if (res3 != null) cl += res3;
              }
              else if(res3 != null) cl = res3;
              if(cl != null) setState(() {
                st = 2;
              });
            },
            padding: EdgeInsets.only(top: 10),
            child: Image.asset('images/eur.png')
        ),
      ],
    );
  }
}
