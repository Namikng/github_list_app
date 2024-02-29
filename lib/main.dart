import 'package:flutter/material.dart';
import 'models.dart';
import 'networking.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var repoInfo;
  String inputUserName = 'jakewharton';
  String userName = '';
  String userAvatarUrl = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('githubAPI'),
        ),
        body: FutureBuilder<List<Widget>>(
          future: getWidgetList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasData) {
              return ListView(children: snapshot.data!);
            } else {
              return Text('Error!!');
            }
          },
        ),
      ),
    );
  }

  Future<List<Widget>> getWidgetList() async {
    List<Widget> widgetList = [];
    Widget userInfoWidget = await getUserInfoWidget();
    widgetList.add(userInfoWidget);

    List<Widget> repoWidgetList = await getRepoWidgetList();
    widgetList.addAll(repoWidgetList);

    return widgetList;
  }

  Future<Widget> getUserInfoWidget() async {
    final userData = await getUserInfo(inputUserName);

    if (userData == null) {
      userName = '';
      userAvatarUrl = '';
    } else {
      userName = userData['name'];
      userAvatarUrl = userData['avatar_url'];
    }
    final userInfo = UserInfo(userName, userAvatarUrl);
    return userInfo.buildUserInfo();
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

  Future<List<Widget>> getRepoWidgetList() async {
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

    List<Widget> widgetList = [];
    // 정렬된 list를 다시 돌며 Widget 형태로 실제 리스트 뷰에 추가
    for (var repo in repoList) {
      widgetList.add(repo.buildRepoInfo());
    }

    return widgetList;
  }
}
