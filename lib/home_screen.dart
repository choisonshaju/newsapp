import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:newsapp/datamodel';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<Article> articles = [];
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData({String? search = "trending"}) async {
    setState(() {
      fetchData();
    });
    final url = Uri.parse(
        'https://newsapi.org/v2/everything?q=$search&apiKey=495c2b81698449fbb279dd821685a0e4');
    var response = await http.get(url);

    var jsonData = json.decode(response.body);

    PublicApiResponce datamodel = PublicApiResponce.fromJson(jsonData);
    setState(() {
      articles = datamodel.articles;
    });
  }

  TextEditingController searchControler = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
        elevation: 0,
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        title: Text("NEWSAPP"),
        actions: [
          Icon(Icons.notifications),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    onChanged: (value) {
                      fetchData(search: searchControler.text);
                    },
                    controller: searchControler,
                    decoration: InputDecoration(
                      hintText: "SEARCH ",
                      labelText: "SEARCH ",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(),
                Container(
                  height: 730,
                  child: RefreshIndicator(
                    onRefresh: () async {
                      fetchData();
                    },
                    child: ListView.builder(
                      itemCount: articles.length,
                      itemBuilder: (context, index) => Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 300,
                                height: 400,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        articles[index].urlToImage ?? ''),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            articles[index].title,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            articles[index].description,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
