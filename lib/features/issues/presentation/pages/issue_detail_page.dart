import 'package:flutter/material.dart';

class IssueDetailPage extends StatelessWidget {
  final String issueId;
  const IssueDetailPage({super.key, required this.issueId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Issue Detail')),
      body: Center(child: Text('Issue: $issueId')),
    );
  }
}
