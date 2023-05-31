import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MealDetailPage extends StatefulWidget {
  final String mealId;

  const MealDetailPage({Key? key, required this.mealId}) : super(key: key);

  @override
  _MealDetailPageState createState() => _MealDetailPageState();
}

class _MealDetailPageState extends State<MealDetailPage> {
  late Future<Map<String, dynamic>> _mealDetailsFuture;

  @override
  void initState() {
    super.initState();
    _mealDetailsFuture = fetchMealDetails();
  }

  Future<Map<String, dynamic>> fetchMealDetails() async {
    final url = 'http://www.themealdb.com/api/json/v1/1/lookup.php?i=${widget.mealId}';
    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    return data['meals'][0];
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _mealDetailsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Meal Detail'),
              centerTitle: true,
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Meal Detail'),
              centerTitle: true,
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          final mealData = snapshot.data as Map<String, dynamic>;

          return Scaffold(
            appBar: AppBar(
              title: Text(mealData['strMeal'] ?? 'Meal Detail'),
              centerTitle: true,
            ),
            body: Container(
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  Image.network(
                    mealData['strMealThumb'] ?? '',
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Category: ${mealData['strCategory'] ?? ''}',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Area: ${mealData['strArea'] ?? ''}',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    color: Colors.white54,
                    child: Text(
                      mealData['strInstructions'] ?? '',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    child: Text('Watch Video'),
                    onPressed: () {
                      launch(mealData['strYoutube']);
                    },
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
