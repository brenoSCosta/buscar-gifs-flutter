import 'package:flutter/material.dart';
import 'package:busca_gifs/ui/home.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MaterialApp(
            home: Home(),
            title: "Buscar gifs",
            theme: ThemeData(
                primaryColor: Colors.black,
                primarySwatch: Colors.grey,
                inputDecorationTheme: InputDecorationTheme(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)))),
          )));
}
