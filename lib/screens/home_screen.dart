import 'package:camera/camera.dart';
import 'package:flutter_application/screens/taken_picture_screen.dart';
import 'package:flutter_application/widgets/custom_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/models/cat_model.dart';
import 'package:flutter_application/helpers/database_helper.dart';

import '../helpers/database_helper.dart';
import '../models/cat_model.dart';

class HomeScreen extends StatefulWidget {
  final CameraDescription firstCamera;

  const HomeScreen({Key? key, required this.firstCamera}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final textControllerDescription = TextEditingController();
  final textControllerType = TextEditingController();
  final textControllerNature = TextEditingController();
  final textControllerSize = TextEditingController();
  final textControllerDistance = TextEditingController();
  int? planetID; 

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(
        title: const Text("SQLite Database"),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            TextFormField(
              controller: textControllerDescription,
              decoration: InputDecoration(
                icon: Icon(Icons.text_format_outlined),
                labelText:"Input the description"),
            ),

            TextFormField(
              controller: textControllerType,
              decoration: InputDecoration(
                icon: Icon(Icons.text_format_outlined),
                labelText:"Input the type"),
            ),

            TextFormField(
              controller: textControllerNature,
              decoration: InputDecoration(
                icon: Icon(Icons.text_format_outlined),
                labelText:"Input the nature"),
            ),

            TextFormField(
              controller: textControllerSize,
              decoration: InputDecoration(
                icon: Icon(Icons.text_format_outlined),
                labelText:"Input the size"),
            ),

            TextFormField(
              controller: textControllerDistance,
              decoration: InputDecoration(
                icon: Icon(Icons.text_format_outlined),
                labelText:"Input the distance"),
            ),
            
            Center(
              child: (FutureBuilder<List<Planet>>(
                future: DatabaseHelper.instance.getPlanets(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<Planet>> snapshot
                  ){
                    if(!snapshot.hasData){
                      return Center(
                        child: Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: const Text("Loading"),
                        ),);
                    }
                    else{
                          return snapshot.data!.isEmpty ?
                          Center(
                            child: Container(
                              child: const Text("No planets")
                              ),
                          )

                      :ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: snapshot.data!.map((planet) {
                          return Center(
                            child:ListTile(
                              title: Text('Description:${planet.Description},| Type:${planet.Type},| Nature:${planet.Nature},| Size:${planet.Size},| Distance:${planet.Distance},'),
                              onTap: (){
                                setState(() {
                                  final route = MaterialPageRoute(builder: (context) => TakenPictureScreen(camera: widget.firstCamera,));
                                  Navigator.push(context, route);
                                  textControllerDescription.text = planet.Description;
                                  textControllerType.text = planet.Type;
                                  textControllerNature.text = planet.Nature;
                                  textControllerSize.text = planet.Size;
                                  textControllerDistance.text = planet.Distance;
                                  planetID = planet.id;
                                });
                              },
                              onLongPress: (){
                                
                                setState(() {
                                  DatabaseHelper.instance.delete(planet.id!);
                                });
                              },
                            )
                          );
                        }).toList()
                      );
                  }
                }
              )
            ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () async {
          if (planetID != null){
            DatabaseHelper.instance.update(
              Planet(id: planetID, Description: textControllerDescription.text, Type: textControllerType.text, Nature: textControllerNature.text, Size: textControllerSize.text, Distance: textControllerDistance.text)
            );
          }
          else{
            DatabaseHelper.instance.add(Planet(
            Description: textControllerDescription.text,
            Type: textControllerType.text,
            Nature: textControllerNature.text,
            Size: textControllerSize.text,
            Distance: textControllerDistance.text,
          ));
          }
          
          setState(() {
            textControllerDescription.clear();
            textControllerType.clear();
            textControllerNature.clear();
            textControllerSize.clear();
            textControllerDistance.clear();
          });
        },
      ),
    );
  }
}