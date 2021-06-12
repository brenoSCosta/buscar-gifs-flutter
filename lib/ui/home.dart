import 'dart:convert';

import 'package:busca_gifs/ui/gif_page.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _search;
  TextEditingController textSearch = TextEditingController();

  int _offset = 0;

  Future<Map> _getGifs() async {
    var response;

    if (_search == null || _search.isEmpty)
      response = await Dio().get(
          "https://api.giphy.com/v1/gifs/trending?api_key=Y3xbLSlOxKrcmNGkU64NcjQmNfn3LivB&limit=20&rating=g");
    else
      response = await Dio().get(
          "https://api.giphy.com/v1/gifs/search?api_key=Y3xbLSlOxKrcmNGkU64NcjQmNfn3LivB&q=$_search&limit=19&offset=$_offset&rating=g&lang=en");

    return json.decode(response.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.yellow,
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 90,
            child: Row(
              children: [
                Padding(
                    padding: EdgeInsets.all(20),
                    child: SizedBox(
                      width: 200,
                      child: TextField(
                          controller: textSearch,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                              labelText: "Pesquise aqui",
                              labelStyle: TextStyle(color: Colors.black))),
                    )),
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _search = textSearch.text;
                          _offset = 0;
                        });
                      },
                      child: Text("Buscar"),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black, onPrimary: Colors.white)),
                ),
              ],
            ),
          ),
          Expanded(
              child: FutureBuilder(
            future: _getGifs(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ));
                default:
                  if (snapshot.hasError)
                    return Container();
                  else
                    return _createGifTable(context, snapshot);
              }
            },
          ))
        ],
      ),
    );
  }

  int _getCount(List data) {
    if (_search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(15),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15),
        itemCount: _getCount(snapshot.data["data"]),
        itemBuilder: (context, index) {
          if (_search == null || index < snapshot.data["data"].length)
            return GestureDetector(
              child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: snapshot.data["data"][index]["images"]["fixed_height"]
                      ["url"],
                  height: 300.0,
                  fit: BoxFit.cover),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            GifPage(snapshot.data["data"][index])));
              },
              onLongPress: () {
                Share.share(snapshot.data["data"][index]["images"]
                    ["fixed_height"]["url"]);
              },
            );
          else
            return Container(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.add, color: Colors.black, size: 70),
                    Text(
                      "Carregar mais",
                      style: TextStyle(color: Colors.black, fontSize: 22),
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    _offset += 19;
                  });
                },
              ),
            );
        });
  }
}
