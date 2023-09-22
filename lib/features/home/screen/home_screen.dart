import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/home/drawers/community_list_drawers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userModel = ref.watch(
        userProvider)!; //homescreen은 오직 로그인이 성공한 다음에 보여주는 screen이므로 user가 null일 수 없다.
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Home'),
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: () {
                displayDrawer(context); //만약 이새끼가 매개변수가 없었으면 걍 변수로 집어 넣어도 되었을듯?
              },
              icon: Icon(Icons.menu));
        }),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(
            icon: CircleAvatar(
              backgroundImage: NetworkImage(userModel.profilePic),
            ),
            onPressed: () {},
          ),
        ],
      ),
      drawer: CommunityListDrawer(),
    );
  }
}
