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

 TextEditingController _controllerRS = new TextEditingController();
 TextEditingController _controllerUSD = new TextEditingController();
 TextEditingController _controllerEURO = new TextEditingController();
 
  double dolar = 0;
  double euro = 0;
  double real = 0;

  void _changedReal(String s){

    real = double.tryParse(s) ?? 0;
    _controllerUSD.text = (real/dolar).toStringAsFixed(2);
    _controllerEURO.text = (real/euro).toStringAsFixed(2);

  }

  void _changedUSD(String s){

    double dolarInsert = double.tryParse(s) ?? 0;
    _controllerRS.text = (dolar * dolarInsert).toStringAsFixed(2);
    _controllerEURO.text = ( (dolar * dolarInsert)/ euro).toStringAsFixed(2);

  }

   void _changedEURO(String s){

    double euroInsert = double.tryParse(s) ?? 0;
    _controllerUSD.text = ( (euro * euroInsert) / dolar).toStringAsFixed(2);
    _controllerRS.text = ( (euro * euroInsert)).toStringAsFixed(2);

  }




 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("\$Conversor\$",
        style: TextStyle(fontSize: 25, color: Colors.white)),
        centerTitle: true,
        
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder(future: getData(), 
      builder: (context, snapshot){
        
        switch(snapshot.connectionState) {
            case (ConnectionState.none):
            case (ConnectionState.waiting):
            return WaitingPage();

            default: 
            if(snapshot.hasError){
              return ErrorPage();
            }
            else {
              dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"] ?? 0;
              euro = snapshot.data! ["results"]["currencies"]["EUR"]["buy"] ?? 0;
              return PageMain();
            }


        }
      })
    );
  }

  Widget ErrorPage(){
    return Center(child: Text("Error ao carregar os dados", style: TextStyle(color: Colors.amber, fontSize: 20)));
  }

  Widget WaitingPage(){
    return Center(child: Text("Carregando dados..", style: TextStyle(color: Colors.amber, fontSize: 20)));
  }

  Widget PageMain(){
    return Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
            
                Icon(Icons.monetization_on, size: 150, color: Colors.amber),
                SizedBox(height: 30),
                TextFieldPerson(Changed: _changedReal,prefix: "R\$: ", label: "Reais", controller: _controllerRS),
                SizedBox(height: 10),
                TextFieldPerson(Changed: _changedUSD, prefix: "\$USD: ",label: "Dólares", controller: _controllerUSD),
                SizedBox(height: 10),
                TextFieldPerson(Changed: _changedEURO, prefix: "\$EUR: ",label: "EURO", controller: _controllerEURO)
                
              ],
            ),
          ),
        ),
      );
  }

  Future<Map> getData() async {
    const request = "https://api.hgbrasil.com/finance?format=json&key=7f5863ad";
    http.Response response = await http.get(Uri.parse(request));
    return jsonDecode(response.body);
  }

Widget TextFieldPerson({required ValueChanged<String> Changed,required String label,  required String prefix, required TextEditingController controller}){
  return TextField(
     keyboardType: TextInputType.number,
    controller: controller,
    onChanged: Changed,
    onTap: () {
     controller.text = "";
    },
    
    style: TextStyle(
      color: Colors.amber, fontSize: 20,
    ),
    decoration: InputDecoration(
      prefix: Text(prefix,
      style: TextStyle(color: Colors.white)),
      label: Text(label,
      style: TextStyle(color: Colors.amber)),
      fillColor: Colors.amber,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10)
      )
    )
  );
}

}

