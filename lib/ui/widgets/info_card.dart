import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    Key? key,
    required this.name,
    required this.bio,
  }) : super(key: key);

  final Widget name;
  final Widget bio;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.white24,
        child: Icon(
          CupertinoIcons.person,
          color: Colors.white,
        ),
      ),
      title: DefaultTextStyle(
        style: const TextStyle(color: Colors.white),
        child: name,
      ),
      subtitle: DefaultTextStyle(
        style: const TextStyle(color: Colors.white70),
        child: bio,
      ),
    );
  }
}
