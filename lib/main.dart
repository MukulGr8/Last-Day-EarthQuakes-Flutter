import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:intl/intl.dart';

Map _quakes;
List _features;
void main() async{
  _quakes = await getQuakes();
  print(_quakes['features'][0]['properties']);

  _features = _quakes['features'];

  runApp(new MaterialApp(
    title: "Quakes",
    home: new Quakes(),
  ));
}

class Quakes extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("Quakes"),
        backgroundColor: Colors.red,
      ),

      body: new Center(
        child: new ListView.builder(itemCount: _features.length,padding: const EdgeInsets.all(15.0),
        itemBuilder: (BuildContext context,int position){
          if(position.isOdd) new Divider();

          final index = position;

          var format = new DateFormat.yMd().add_jm();
          var date = format.format(new DateTime.fromMicrosecondsSinceEpoch(_features[index]['properties']['time']*1000,isUtc: true));

          return new ListTile(
            title: new Text(date,style: new TextStyle(
              fontSize: 20.0,fontWeight: FontWeight.w500,color: Colors.orange
            ),),

            subtitle: new Text("${_features[index]['properties']['place']}",style: new TextStyle(
              fontSize: 16.5,fontWeight: FontWeight.normal,fontStyle: FontStyle.normal,color: Colors.grey,
            ),),

            leading: new CircleAvatar(backgroundColor: Colors.green,child: new Text(
                "${_features[index]['properties']['mag']}",
            style: new TextStyle(fontSize: 16.5,fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,color: Colors.white),),
            ),

            onTap: () {_showAlertMessage(context,"${_features[index]['properties']['place']}");},
          );
          },),
      ),
    );
  }
}

void _showAlertMessage(BuildContext context,String message){
  var alert = new AlertDialog(
    title: new Text("Quakes"),
    content: new Text(message),
    actions: <Widget>[
      new FlatButton(onPressed: () {
        Navigator.pop(context);}, child: new Text("ok") )
    ],
  );
  showDialog(context: context,builder:(context) => alert);
}

Future<Map> getQuakes() async {
  String apiUrl = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";

  http.Response response = await http.get(apiUrl);

  return json.decode(response.body);
}