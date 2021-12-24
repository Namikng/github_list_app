import 'package:flutter/material.dart';
import 'networking.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('githubAPI'),
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 100.0,
              child: Row(
                children: [
                  Expanded(
                    child: Icon(Icons.icecream),
                    flex: 3,
                  ),
                  Expanded(
                    child: Text('User name'),
                    flex: 7,
                  ),
                ],
              ),
            ),
            RepoInfo('name', 'description', 'starCount'),
          ],
        ),
      ),
    );
  }
}

class RepoInfo extends StatefulWidget {
  RepoInfo(this.repoName, this.repoDescription, this.starCount);

  final String repoName, repoDescription;
  final starCount;

  @override
  _RepoInfoState createState() => _RepoInfoState();
}

class _RepoInfoState extends State<RepoInfo> {
  @override
  void initState() {
    super.initState();
    var userInfo = getUserInfo('jakewharton');

  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.repoName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(widget.repoDescription),
              ],
            ),
            flex: 8,
          ),
          Expanded(
            child: Center(
              child: Text(
                widget.starCount,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Future<dynamic> getUserInfo(String userName) async {
    NetworkHelper networkHelper =
        NetworkHelper('https://api.github.com/users/:$userName');
    var userInfo = await networkHelper.getData();
    return userInfo;
  }

  Future<dynamic> getUserRepo(String userName) async {
    NetworkHelper networkHelper =
    NetworkHelper('https://api.github.com/users/:$userName/repos');
    var reposInfo = await networkHelper.getData();
    return reposInfo;
  }
}
