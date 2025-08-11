import 'package:flutter/material.dart';
import 'todo_list_screen.dart';

class CategoryScreen extends StatelessWidget {
  final String userName;
  CategoryScreen({required this.userName});

  final List<Map<String, dynamic>> categories = [
    {"name": "Work", "icon": Icons.work, "color": Colors.blue},
    {"name": "Study", "icon": Icons.school, "color": Colors.green},
    {"name": "Shopping", "icon": Icons.shopping_cart, "color": Colors.orange},
    {"name": "Fitness", "icon": Icons.fitness_center, "color": Colors.red},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello, $userName 👋"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(20),
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        children: categories.map((category) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 500),
                  pageBuilder: (_, __, ___) => TodoListScreen(
                    userName: userName,
                    category: category["name"],
                  ),
                  transitionsBuilder: (_, animation, __, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: category["color"].withOpacity(0.8),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(2, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(category["icon"], size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    category["name"],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
