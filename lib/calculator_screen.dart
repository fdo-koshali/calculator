//IM 2021 070 K H K L S FERNANDO

import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

// Main Calculator Stateful Widget
class Calculator extends StatefulWidget {
  @override
  State<Calculator> createState() => _CalculatorState();
}

// State of the Calculator widget
class _CalculatorState extends State<Calculator> {
  String userInput = ""; // Stores user input
  String result = "0"; // Stores the calculation result
  bool isAnswerDisplayed = false; // Tracks if the result is currently displayed

  List<String> history = []; // Stores calculation history
  List<String> buttonList = [
    // List of button labels for the calculator
    'AC', '(', ')', '÷',
    '7', '8', '9', '×',
    '4', '5', '6', '+',
    '1', '2', '3', '-',
    '0', '.', '%', '='
  ];

  // Clears the calculation history
  void clearHistory() {
    setState(() {
      history.clear();
    });
  }

  // Deletes the last character of user input
  void deleteLastCharacter() {
    setState(() {
      if (userInput.isNotEmpty) {
        userInput = userInput.substring(0, userInput.length - 1);
      }
    });
  }

  // Main UI build method
  @override
  Widget build(BuildContext context) {
    double fontSize = userInput.length > 15
        ? 24
        : 32; // Adjusts font size based on input length

    return Scaffold(
      backgroundColor:
          const Color(0xFF000000), // Sets background color to black
      appBar: AppBar(
        title: const Text(
          'Calculator',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFF36A13), // AppBar background color
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Button to navigate to the history screen
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryScreen(
                    history: history,
                    onClearHistory: clearHistory,
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Display area for input and result
          SizedBox(
            height: 240,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Displays user input
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.centerRight,
                        child: Text(
                          userInput,
                          style: TextStyle(
                            fontSize: fontSize,
                            color: Colors.white, // Input text color
                          ),
                        ),
                      ),
                    ),
                    // Backspace button
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Material(
                          color: Colors.black, // Backspace button color
                          child: InkWell(
                            onTap: deleteLastCharacter,
                            child: SizedBox(
                              height: 48,
                              width: 48,
                              child: const Icon(
                                Icons.backspace, // Backspace icon
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Displays result
                Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.centerRight,
                  child: Text(
                    result,
                    style: const TextStyle(
                      fontSize: 48,
                      color: Colors.white, // Result text color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Button grid
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: buttonList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // Number of buttons in a row
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return customButton(buttonList[index]);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  // Creates a custom button for the calculator
  Widget customButton(String text) {
    return InkWell(
      splashColor: (text == "AC" || text == "=") // Button press effect
          ? Colors.transparent
          : const Color(0xFF1d2630),
      onTap: () {
        setState(() {
          handleButtons(text); // Handles button press logic
        });
      },
      child: Ink(
        decoration: BoxDecoration(
          color: getBgColor(text), // Sets background color based on button type
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              blurRadius: 4,
              spreadRadius: 0.5,
              offset: const Offset(-3, -3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: getColor(text), // Sets text color based on button type
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // Determines text color for buttons
  getColor(String text) {
    if ("÷×+-C()".contains(text)) {
      return const Color(0xFFF36A13); // Orange color for operators
    }
    return Colors.white; // Default color
  }

  // Determines background color for buttons
  getBgColor(String text) {
    if (text == "AC" || text == "=") {
      return const Color(0xFFF36A13); // Orange background for AC and =
    }
    return const Color(0xFF1d2630); // Default background color
  }

  // Handles button press logic
  handleButtons(String text) {
    if (text == "AC") {
      userInput = "";
      result = "0";
      isAnswerDisplayed = false;
      return;
    }

    if (text == "%") {
      if (userInput.isNotEmpty) {
        double value = double.tryParse(userInput) ?? 0;
        userInput = (value / 100).toString();
      }
      return;
    }

    if (text == "=") {
      String expression = userInput.replaceAll('×', '*').replaceAll('÷', '/');
      result = calculate(expression); // Performs calculation
      history.add("$userInput = $result"); // Adds to history
      userInput = result;
      isAnswerDisplayed = true;
    } else {
      if (userInput.isNotEmpty &&
          "+-×÷".contains(userInput[userInput.length - 1]) &&
          "+-×÷".contains(text)) {
        return; // Prevents consecutive operators
      }

      if (isAnswerDisplayed && "0123456789".contains(text)) {
        userInput = text; // Resets input after result is displayed
        isAnswerDisplayed = false;
      } else {
        userInput += text;
      }
    }
  }

  // Performs the calculation
  String calculate(String expression) {
    try {
      String processedExpression =
          expression.replaceAll('×', '*').replaceAll('÷', '/');

      // Handles division by zero
      if (processedExpression.contains("/0")) {
        List<String> parts = processedExpression.split("/");
        if (parts.length == 2 && parts[0].trim() == "0") {
          return "Undefined"; // 0/0
        }
        return "Infinity"; // Any number divided by 0
      }

      var exp = Parser().parse(processedExpression);
      var evaluation = exp.evaluate(EvaluationType.REAL, ContextModel());

      if (evaluation == evaluation.toInt()) {
        return evaluation.toInt().toString(); // Returns integer if applicable
      }

      return evaluation.toString(); // Returns double result
    } catch (e) {
      return "Error"; // Error handling for invalid expressions
    }
  }
}

// History screen widget
class HistoryScreen extends StatelessWidget {
  final List<String> history; // Passed history list
  final VoidCallback onClearHistory; // Callback to clear history

  const HistoryScreen({
    super.key,
    required this.history,
    required this.onClearHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: const Color(0xFFF36A13), // History screen AppBar color
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: onClearHistory, // Clears history when pressed
          )
        ],
      ),
      body: history.isEmpty
          ? const Center(
              child: Text(
                'No history yet!',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: history.length, // Displays history list
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(history[index]), // Displays each history item
                );
              },
            ),
    );
  }
}
