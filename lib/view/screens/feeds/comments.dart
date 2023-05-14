import 'package:flutter/material.dart';
class CommentsScreen extends StatelessWidget {
  const CommentsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CommentsScreen'),
      ),
      body: const Center(
        child: Text('Comments Screen'),
      ),
    );
  }
}
