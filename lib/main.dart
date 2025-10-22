import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main(){

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage()
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController _controllerBR = new TextEditingController();

  TextEditingController _controllerUSD = new TextEditingController();
  

 TextEditingController _controllerEURO = new TextEditingController();
  


  double dolar = 0;
  double euro = 0;

  bool isNumber(String s){
    try{
      double x = double.parse(s);
      return true;
    }
    catch(e){
      return false;
    }
  }

  void _changedBR(String a){

    if(_controllerBR.text.isEmpty){
      _controllerUSD.text = "";
      _controllerEURO.text = "";
    }

    if(isNumber(a)) {
       double real = double.parse(a);
    _controllerUSD.text = (real/dolar).toStringAsFixed(2);
    _controllerEURO.text= (real/euro).toStringAsFixed(2);
    }
      else {
    String a = _controllerBR.text;
    _controllerBR.text ="";
     for(int i=0;i<a.length-1;i++){
      _controllerBR.text += a[i];
     }
  }
  
  }

  void _changedUSD(String a){

      if(_controllerUSD.text.isEmpty){
      _controllerBR.text = "";
      _controllerEURO.text = "";
    }

    if(isNumber(a)) {
       double real = double.parse(a);
    _controllerBR.text = (real * dolar).toStringAsFixed(2);
    _controllerEURO.text = ((real * dolar) / euro).toStringAsFixed(2);
  
    }

      else {
    String a = _controllerUSD.text;
    _controllerUSD.text ="";
     for(int i=0;i<a.length-1;i++){
      _controllerUSD.text += a[i];
     }
  }
  }

    void _changedEURO(String a){

        if(_controllerEURO.text.isEmpty){
      _controllerUSD.text = "";
      _controllerBR.text = "";
    }

      if(isNumber(a)){
  double real = double.parse(a);
    _controllerBR.text = (real * euro).toStringAsFixed(2);
    _controllerUSD.text = ( ((real * euro) / dolar)).toStringAsFixed(2);
  }
  else {
    String a = _controllerEURO.text;
    _controllerEURO.text ="";
     for(int i=0;i<a.length-1;i++){
      _controllerEURO.text += a[i];
     }
  }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Conversor",
        style: TextStyle(
          fontSize: 25,
          color: Colors.white
        )),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: getData(),
        builder:(context, snapshot){

          switch(snapshot.connectionState){

            case ConnectionState.none:
            case ConnectionState.waiting:

            return Center(child: Text("Carregando dados...",
            style: TextStyle(color: Colors.amber, fontSize: 20)));
            
            default: 
            if(snapshot.hasError){

               return Center(child: Text("Não foi possivel carregar os dados 404 no found :(",
            style: TextStyle(color: Colors.amber, fontSize: 20)));
           
            }
            else {
              dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
              euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];

         return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.monetization_on, size: 150, color: Colors.amber),
                  TextField(
                    controller: _controllerBR,
                    onChanged: _changedBR,
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      label: Text("Reais",
                      style: TextStyle(
                        color: Colors.amber
                      )),
                      prefix: Text("R\$: ",
                      style: TextStyle(
                        color: Colors.white
                      )),
                      fillColor: Colors.amber,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    )
                  ),
                  Divider(),
            
                  TextField(
                    controller: _controllerUSD,
                    onChanged: _changedUSD,
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      label: Text("Dolas",
                      style: TextStyle(
                        color: Colors.amber
                      )),
                      prefix: Text("\$: ",
                      style: TextStyle(
                        color: Colors.white
                      )),
                      fillColor: Colors.amber,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    )
                  ),
            
                  Divider(),
            
                  TextField(
                    controller: _controllerEURO,
                    onChanged: _changedEURO,
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      label: Text("Euro",
                      style: TextStyle(
                        color: Colors.amber
                      )),
                      prefix: Text("E\$: ",
                      style: TextStyle(
                        color: Colors.white
                      )),
                      fillColor: Colors.amber,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    )
                  ),
                ],
              )
            ),
          ),
            
        );
            }
        }
        }
        
      )
    );
  }

  Future<Map> getData() async{
    final String request = "https://api.hgbrasil.com/finance?format=json&key=7f5863ad";
    http.Response response = await http.get(Uri.parse(request));

    return jsonDecode(response.body);
  }
}