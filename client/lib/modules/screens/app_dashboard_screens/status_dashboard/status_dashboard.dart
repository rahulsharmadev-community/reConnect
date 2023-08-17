import 'package:flutter/material.dart';

class StatusDashBoardScreen extends StatelessWidget {
  const StatusDashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) => listTile(),
    );
  }

  ListTile listTile() {
    return const ListTile(
      leading: CircleAvatar(
        radius: 26,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 12),
      title: Row(children: [
        Expanded(
          child: Text('Rohit(GITAM)'),
        ),
      ]),
      subtitle: Text(
        'Yestaday, 2:50 pm',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
