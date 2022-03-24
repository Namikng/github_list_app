import 'package:flutter/material.dart';
import 'networking.dart';

void main() {
  runApp(MyApp());
}

class UserInfo {
  final String userName;
  final String userAvatarUrl;

  UserInfo(this.userName, this.userAvatarUrl);

  Widget buildUserInfo() {
    return SizedBox(
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
    );
  }
}

class RepoInfo {
  RepoInfo(this.repoName, this.repoDescription, this.starCount);

  final String repoName, repoDescription;
  final int starCount;

  Widget buildRepoInfo() {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  repoName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(repoDescription),
              ],
            ),
            flex: 8,
          ),
          Expanded(
            child: Center(
              child: Text(
                starCount.toString(),
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
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var repoInfo;
  List<Widget> items = [];
  String inputUserName = 'jakewharton';
  String userName = '';
  String userAvatarUrl = '';

  @override
  void initState() {
    super.initState();
    updateUserUI();
    updateRepoUI();
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
          children: items,
        ),
      ),
    );
  }

  void updateUserUI() async {
    final userData = await getUserInfo(inputUserName);
    setState(() {
      if (userData == null) {
        userName = '';
      }
      userName = userData['name'];
      userAvatarUrl = userData['avatar_url'];

      final userInfo = UserInfo(userName, userAvatarUrl);
      items.add(userInfo.buildUserInfo());
    });
  }

  Future<dynamic> getUserInfo(String userName) async {
    NetworkHelper networkHelper =
        NetworkHelper('https://api.github.com/users/$userName');
    var userInfo = await networkHelper.getData();
    return userInfo;
  }

  Future<dynamic> getRepoInfo(String userName) async {
    NetworkHelper networkHelper =
        NetworkHelper('https://api.github.com/users/$userName/repos');
    var repoInfo = await networkHelper.getData();
    return repoInfo;
  }

  void updateRepoUI() async {
    List<RepoInfo> repoList = [];
    final repos = await getRepoInfo(inputUserName);
    // 일단 싹 돌면서 list에 추가
    for (var repo in repos) {
      final name = repo['name'];
      final description = repo['description'];
      final starCount = repo['stargazers_count'];

      final repoInfo = RepoInfo(
        name,
        description,
        starCount,
      );
      repoList.add(repoInfo);
    }
    // list를 starCount 순으로 정렬
    repoList.sort((a, b) => b.starCount.compareTo(a.starCount));

    // 정렬된 list를 다시 돌며 Widget 형태로 실제 리스트 뷰에 추가
    setState(() {
      for (var repo in repoList) {
        items.add(repo.buildRepoInfo());
      }
    });
  }
}
