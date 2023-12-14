import 'package:flutter/material.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const title = 'Daily Expenses';

    return MaterialApp(
        title : title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue,
              title: const Text(title, style: TextStyle(color: Colors.white),),
            ),
            body: ListView(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.attach_money),
                  title: Text('Clothing - \RM150.00'),
                ),
                ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Text('Clothing - \RM39.00'),
                ),
                ListTile(
                  leading: Icon(Icons.local_dining),
                  title: Text('Dinner - \RM7.00'),
                ),
              ],
            ),
            ),
        );
    }
}