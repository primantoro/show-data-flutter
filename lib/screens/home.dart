import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/siswa.dart';
import '../network/api.dart';
import 'add.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  List<Siswa> _siswa = [];
  

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    var url = 'http://192.168.0.107/php/latihan/crud/viewData.php';
    var response = await http.get(
      Uri.parse(url),
      
      // headers: {
      //   "Access-Control-Allow-Origin": "*",
      //   'Content-Type': 'application/json',
      //   'Accept': '*/*'
      // }
    );
    return json.decode(response.body);
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
       child: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      List list = snapshot.data;
                      // return Center(
                      //   child: DataTable(
                      //     columns: [
                      //       DataColumn(label: Text('NIS')),
                      //       DataColumn(label: Text('Nama')),
                      //       DataColumn(label: Text('Kelas')),
                      //       DataColumn(label: Text('Alamat')),
                      //     ],
                      //     rows: [
                      //       DataRow(cells: [
                      //         DataCell(Text('${snapshot.data[index]['nis']}')),
                      //         DataCell(Text('${snapshot.data[index]['nama']}')),
                      //         DataCell(Text('${snapshot.data[index]['kelas']}')),
                      //         DataCell(Text('${snapshot.data[index]['alamat']}'))
                      //       ])
                      //     ],
                      //   ),
                      // );
                      return Card(
                        child: ExpansionTile(
                          title: Text(list[index]['nama']),
                          children: <Widget>[
                            ListTile(
                              title: Text('Alamat : '+list[index]['alamat']),
                              subtitle: Text('Kelas : '+list[index]['kelas']),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
     ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.push(
context,
MaterialPageRoute(builder: (context) => AddData()),);
        },
        icon: Icon(Icons.add),
        label: Text('Tambah Siswa'),
      ),
    );
  }

  

  Future<Null> _refresh() {
    return getData().then((_siswa){
      setState(() =>  _siswa,);
    });
  }
}