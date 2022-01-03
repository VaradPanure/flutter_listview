// import 'package:flutter/material.dart';
// import 'package:http/http.dart'as http;
// import 'dart:async';
// import 'dart:convert';
//
//
// void main(){
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget{
//   @override
//   Widget build(BuildContext context){
//     return MaterialApp(
//       title: 'ListDemo',
//       theme: ThemeData(
//            primarySwatch: Colors.red,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//
//
//    Future<List<Users>> GetJson() async {
//     Uri url = Uri.parse("https://jsonplaceholder.typicode.com/posts");
//     var data = http.get(url);
//     List<Users> items = [];
//
//     var JsonData;
//     data.then((value) => {
//          JsonData = jsonDecode(value.body) as List
//     });
//     if(JsonData!=null) {
//       print("Its working");
//       print(JsonData);
//
//       for (var m in JsonData) {
//         Users u = Users(m["id"], m["title"]);
//         items.add(u);
//       }
//
//       return items;
//     }
//     return items;
// }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//
//         title: Text("Listview Flutter"),
//       ),
//
//       body: Container(
//            child:FutureBuilder (
//           future: GetJson(),
//           builder: (BuildContext context,AsyncSnapshot snapshot){
//               if(snapshot.data==null){
//                 return Container(
//                 child: Center(
//                 child: Text("loading...")
//                 ),
//               );
//             }
//               else{
//                     return ListView.builder(
//                       itemCount: snapshot.data.length,
//                       itemBuilder: (BuildContext context , int index){
//
//                           return ListTile(
//                             leading: CircleAvatar(
//                              backgroundImage: NetworkImage(snapshot.data[index].imageUrl),
//                              ),
//                     title: Text(snapshot.data[index].title),
//                       subtitle: Text(snapshot.data[index].id),
//                     );
//                     }
//                     );
//                     }
//                     }
//
//         ),
//       ),
//     );
//   }
// }
//
// class Users{
//   String id;
//   String title;
//
//   Users(this.id,this.title);
//
//
// }
//
//
//
//
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<User>> fetchPhotos(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsePhotos, response.body);
}

// A function that converts a response body into a List<Photo>.
List<User> parsePhotos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<User>((json) => User.fromJson(json)).toList();
}

class User {
  final int id;
  final String title;

  const User({
    required this.id,
    required this.title,

  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      title: json['title'] as String,
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'List Demo';

    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<User>>(
        future: fetchPhotos(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return PhotosList(photos: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class PhotosList extends StatelessWidget {
  const PhotosList({Key? key, required this.photos}) : super(key: key);

  final List<User> photos;

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
                      itemCount: photos.length,
                      itemBuilder: (BuildContext context , int index){

                          return ListTile(
                    title: Text(photos[index].id.toString()),
                      subtitle: Text(photos[index].title),
                    );
                    }
                    );
  }
}