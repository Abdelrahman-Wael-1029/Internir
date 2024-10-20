import 'package:flutter/material.dart';
class OneCategory extends StatefulWidget {
  const OneCategory({super.key});

  @override
  State<OneCategory> createState() => _OneCategoryState();
}

class _OneCategoryState extends State<OneCategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(
            "Programming",
            style: TextStyle(
              fontSize: 30,
              fontWeight:FontWeight.bold
          ),
        ) ,
        centerTitle: true,
        leading: IconButton(onPressed: (){}, icon:Icon(Icons.keyboard_backspace_sharp),iconSize: 40,),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child:ListView(
          children: [
            ListTile(

            )
          ]
        ),

      ),
    );
  }
}
