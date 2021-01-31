import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'Post.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String _baseUrl = "https://jsonplaceholder.typicode.com";

  Future<List<Post>> _get() async {
    http.Response response = await http.get(_baseUrl + "/posts");
    var jsonData = json.decode(response.body);

    List<Post> posts = List();
    for (var post in jsonData) {
      print("post: " + post["title"]);
      Post p = Post(post["userId"], post["id"], post["title"], post["body"]);
      posts.add(p);
    }
    return posts;
  }

  _post() async {
    Post post = Post(120, null, "Title", "Body of post");

    var body = json.encode(
      post.toJson()
    );

    http.Response response = await http.post(
      _baseUrl + "/posts",
      headers: {
        "Content-type": "application/json; charset=UTF-8"
      },
      body: body
    );

    print("Response: ${response.statusCode}");
    print("Response: ${response.body}");
  }

  _put() async {
    Post post = Post(120, null, "Title", "Body of post");

    var body = json.encode(
        post.toJson()
    );

    http.Response response = await http.put(
        _baseUrl + "/posts/2",
        headers: {
          "Content-type": "application/json; charset=UTF-8"
        },
        body: body
    );

    print("Response: ${response.statusCode}");
    print("Response: ${response.body}");
  }

  _patch() async {
    Post post = Post(120, null, "Title", "Body of post");

    var body = json.encode(
        post.toJson()
    );

    http.Response response = await http.patch(
        _baseUrl + "/posts/2",
        headers: {
          "Content-type": "application/json; charset=UTF-8"
        },
        body: body
    );

    print("Response: ${response.statusCode}");
    print("Response: ${response.body}");
  }

  _delete() async {
    http.Response response = await http.delete(
        _baseUrl + "/posts/2"
    );

    if (response.statusCode == 200) {
      // success
    } else {
      // failed
    }

    print("Response: ${response.statusCode}");
    print("Response: ${response.body}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consuming Web Service Advanced"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                RaisedButton(
                  child: Text("Save"),
                  onPressed: _post,
                ),
                RaisedButton(
                  child: Text("Update"),
                  onPressed: _patch,
                ),
                RaisedButton(
                  child: Text("Delete"),
                  onPressed: _delete,
                ),

              ],
            ),
            Expanded(
              child: FutureBuilder(
                future: _get(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                      break;
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        print("list: load error");
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (contex, index) {
                            List<Post> postsList = snapshot.data;
                            Post post = postsList[index];
                            return ListTile(
                              title: Text(post.title),
                              subtitle: Text(post.id.toString()),
                            );
                          },
                        );
                      }
                      break;
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
