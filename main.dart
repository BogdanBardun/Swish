import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swish_app/services/auth.dart';
import 'package:swish_app/services/login.dart';
import 'package:swish_app/screens/home.dart';
import 'package:http/http.dart' as http;


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}


class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: Text("Error:("),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Root();
          }
          return const Scaffold(
            body: Center(
              child: Text("Loading..."),
            ),
          );
        },
      ),
    );
  }
}


class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: Auth(auth: _auth).user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot){
      if (snapshot.connectionState == ConnectionState.active){
        if(snapshot.data?.uid == null){
        return Login(auth: _auth , firestore: _firestore);
    }else{
          return Home(auth: _auth, firestore: _firestore);
    }
      }
      else {
      return const Scaffold(body: Center(child: Text("Loading..."),),);
    }
      }
    );
  }
}
