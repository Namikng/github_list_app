import 'package:flutter/material.dart';

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
