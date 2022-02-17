import 'package:flutter/material.dart';
import 'networking.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var userInfo;
  String userName = '';
  String userAvatarUrl = '';

  @override
  void initState() {
    super.initState();
    updateUserUI();
  }

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
                    child: Image.network(userAvatarUrl),
                    flex: 3,
                  ),
                  Expanded(
                    child: Text(
                      userName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
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

  void updateUserUI() async {
    userInfo = await getUserInfo('jakewharton');
    print(userInfo['name']);
    setState(() {
      if (userInfo == null) {
        userName = '';
      }
      userName = userInfo['name'];
      userAvatarUrl = userInfo['avatar_url'];
    });
  }

  Future<dynamic> getUserInfo(String userName) async {
    NetworkHelper networkHelper =
        NetworkHelper('https://api.github.com/users/$userName');
    var userInfo = await networkHelper.getData();
    return userInfo;
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

  Future<dynamic> getUserRepo(String userName) async {
    NetworkHelper networkHelper =
        NetworkHelper('https://api.github.com/users/$userName/repos');
    var reposInfo = await networkHelper.getData();
    return reposInfo;
  }
}
