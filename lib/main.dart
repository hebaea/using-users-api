import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List data = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildListView(),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount:  data.length,
      itemBuilder: (context, index) {
        return _buildImage(data[index]);
        // ListTile(
        //   title: Text('data'),
        //   subtitle: Text('name : '),
        // );
      },
    );
  }

  Widget _buildImage(dynamic item) => Container(
        decoration: BoxDecoration(color: Colors.blue[50]),
        margin: EdgeInsets.all(4),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: "http://via.placeholder.com/350x150",
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            // CircleAvatar(),
            // ListTile(
            //   title: Text('data'),
            //   subtitle: Text('name : '),
            // ),
            _buildRow(item)
          ],
        ),
      );
  Widget _buildRow(dynamic item) {
    return ListTile(
      title: Text(
        item['first_name'] == null ? '' : item['first_name'],
      ),
      subtitle: Text("last_name: " + item['last_name']),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // call get json data function
    this.getJsonData();
  }

  Future<String?> getJsonData() async {
    var url = Uri.parse('https://reqres.in/api/users?page=2');

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      setState(() {
        data = jsonResponse['data'];
      });
      return "Successfull";
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
}
