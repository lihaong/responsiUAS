import 'package:flutter/material.dart';
import 'package:responsi/list_category.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Responsi TPM',
      theme: ThemeData.light(),
      home: CategoryListScreen(),
    );
  }

  const MyApp({super.key});
}
