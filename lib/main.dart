import 'package:flutter/material.dart';
import 'scr.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstPage(),
    ));

class FirstPage extends StatelessWidget {
  var _categoryNameControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        color: Colors.white,
        child: Center(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(30.0),
              ),
              Image.asset(
                'images/photobay.png',
                width: 200.0,
                height: 200.0,
              ),
              ListTile(
                title: TextFormField(
                  controller: _categoryNameControler,
                  decoration: InputDecoration(
                    labelText: 'Enter a Category',
                    hintText: 'eg: dogs,bike,cats....',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    contentPadding:
                        const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
              ),
              ListTile(
                title: Material(
                  color: Colors.lightBlue,
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(25.0),
                  child: MaterialButton(
                    height: 47.0,
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return SecondPage(
                          category: _categoryNameControler.text,
                        );
                      }));
                    },
                    child: Text(
                      'Search',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  String category;

  SecondPage({this.category});

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'photo Bay',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      // ignore: missing_return
      body: FutureBuilder(
          future: getPics(widget.category),
          // ignore: missing_return
          builder: (context, snapShot) {
            Map data = snapShot.data;
            if (snapShot.hasError) {
              print(snapShot.error);
              return Text(
                'Failed to get response from the server',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 22.0,
                ),
              );
            } else if (snapShot.hasData) {
              return Center(
                child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: <Widget>[
                          Container(
                            child: InkWell(
                              onTap: () {},
                              child: Image.network(
                                '${data['hits']['index']['largeImageURL']}',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                          ),
                        ],
                      );
                    }),
              );
            } else if (!snapShot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

Future<Map> getPics(String category) async {
  String url =
      'https://pixabay.com/api/?key=$ApiKey&q=category&image_type=photo&pretty=true';

  http.Response response = await http.get(url);
  return json.decode(response.body);
}
