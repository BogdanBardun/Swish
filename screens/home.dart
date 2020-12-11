import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swish_app/services/login.dart';
import 'package:swish_app/services/auth.dart';
import 'package:swish_app/screens/standings.dart';
import 'package:swish_app/screens/calendar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const Home({Key key, this.auth, this.firestore}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static  List<Widget> widgetOptions = <Widget>[
    Calendar(),
   Standings(),
    Column(
    children: [
      Container(
          padding: EdgeInsets.only(top: 15),
          child: Text(
          'George signs max extension with Clippers',
              style: TextStyle(fontSize: 25)
        )
      ),
      Container(
          padding: EdgeInsets.only(top: 15),
          child: Text(
            'Harden Open to Bucks, Heat. Rockets star has added Milwaukee and Miami to his preferred trade destinations',
              style: TextStyle(fontSize: 25)
          )
      ),
      Container(
          padding: EdgeInsets.only(top: 15),
          child: Text(
            'The COVID-19 positivity rate among NBA players is down to 1.5 percent from nearly nine percent a week ago',
              style: TextStyle(fontSize: 25)
          )
      ),
      Container(
          padding: EdgeInsets.only(top: 15),
          child: Text(
            'Virtus Roma withdraws from Italian Serie A',
              style: TextStyle(fontSize: 25)
          )
      ),
      Container(
          padding: EdgeInsets.only(top: 15),
          child: Text(
              'Pau Gasol wants to return to NBA, Lakers is preferable variant',
              style: TextStyle(fontSize: 25)
          )
      ),
    ],
    ),
    Text(
      'Nothing can be found at this moment',
      style: optionStyle,
    ),
    Text(
      'User profile',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var em = widget.auth.currentUser.email;
    return Scaffold(
      appBar: AppBar(
          leading:  IconButton(
            icon: const Icon(Icons.arrow_back),
            alignment: Alignment.centerLeft,
            onPressed: () {
              setState(() {
                if(_selectedIndex != 0) _selectedIndex -= 1;
                else _selectedIndex = 4;
              });
            },
          ),
        title: const Text('Swish', textAlign: TextAlign.right),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Auth(auth: widget.auth).signOut();
            },
          )
        ],
      ),
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_rounded),
            label: 'Matches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_numbered_rounded),
            label: 'Standings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notes_rounded),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box_rounded ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.orangeAccent,
        onTap: _onItemTapped,
        iconSize: 30,
      ),
    );
  }
}