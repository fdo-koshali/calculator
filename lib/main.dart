//IM 2021 070 K H K L S FERNANDO

import 'package:calculator/calculator_screen.dart'; // Importing the custom Calculator widget
import 'package:flutter/material.dart'; // Importing Flutter material package for UI design

// Main function, the entry point of the application
void main() {
  runApp(const MyApp()); // Runs the app and initializes the root widget
}

// Root widget of the application
class MyApp extends StatelessWidget {
  const MyApp(
      {super.key}); // Constructor with an optional key for widget identification

  // This method builds the UI for the application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, // Hides the debug banner in the top-right corner
      home:
          Calculator(), // Sets the Calculator widget as the home screen of the app
    );
  }
}
