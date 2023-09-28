import 'package:flutter/material.dart';
import 'package:saferoad/Home/ui/widgets/SideMenuWidget.dart';
import '../../../Map/ui/views/loading.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Safe Road'),
      ),
      drawer: const SideMenuWidget(),
      body: const Loading(),
    );
  }
}
