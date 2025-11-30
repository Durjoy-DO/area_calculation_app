import 'package:flutter/material.dart';
import 'dart:math' as math; // Used for pi constant

void main() {
  runApp(const AreaApp());
}

class AreaApp extends StatelessWidget {
  const AreaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define a modern color scheme
        primarySwatch: Colors.teal,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[400]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.teal, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const AreaHome(),
    );
  }
}

class AreaHome extends StatefulWidget {
  const AreaHome({super.key});

  @override
  State<AreaHome> createState() => _AreaHomeState();
}

class _AreaHomeState extends State<AreaHome> {
  String? selectedShape;
  final controller1 = TextEditingController();
  final controller2 = TextEditingController();
  final controller3 = TextEditingController();
  String result = '';

  // Key for the animated result text
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    super.dispose();
  }

  void calculate() {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    double a = double.tryParse(controller1.text) ?? 0;
    double b = double.tryParse(controller2.text) ?? 0;
    double c = double.tryParse(controller3.text) ?? 0;

    double area = 0;

    switch (selectedShape) {
      case 'Square':
        area = a * a;
        break;
      case 'Rectangle':
        area = a * b;
        break;
      case 'Triangle':
        area = (a * b) / 2;
        break;
      case 'Trapezium':
        area = ((a + b) * c) / 2;
        break;
      case 'Circle':
        area = math.pi * a * a; // Use the more precise math.pi
        break;
      case 'Rhombus':
        area = (a * b) / 2;
        break;
    }

    setState(() {
      // Format to 2 decimal places for a cleaner look
      result = "Area: ${area.toStringAsFixed(2)}";
    });
  }

  List<Widget> inputFields() {
    if (selectedShape == null) return [];

    List<Widget> fields;
    switch (selectedShape) {
      case 'Square':
        fields = [field(controller1, "Side Length", Icons.square_foot)];
        break;
      case 'Rectangle':
        fields = [
          field(controller1, "Length", Icons.height),
          field(controller2, "Width", Icons.width_normal),
        ];
        break;
      case 'Triangle':
        fields = [
          field(controller1, "Base", Icons.height),
          field(controller2, "Height", Icons.width_normal),
        ];
        break;
      case 'Trapezium':
        fields = [
          field(controller1, "Base 1", Icons.linear_scale),
          field(controller2, "Base 2", Icons.linear_scale),
          field(controller3, "Height", Icons.height),
        ];
        break;
      case 'Circle':
        fields = [field(controller1, "Radius", Icons.circle_outlined)];
        break;
      case 'Rhombus':
        fields = [
          field(controller1, "Diagonal 1", Icons.width_full),
          field(controller2, "Diagonal 2", Icons.height),
        ];
        break;
      default:
        fields = [];
    }

    // Wrap each field in an AnimatedSwitcher for a smooth fade transition
    return fields.map((f) => AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: f,
    )).toList();
  }

  Widget field(TextEditingController controller, String label, IconData icon) {
    return Padding(
      // Add a key to help Flutter identify the widget during animations
      key: ValueKey(label),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.teal),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Area Calculator"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Select Shape",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedShape,
                        hint: const Text("Choose a shape to calculate"),
                        isExpanded: true,
                        decoration: const InputDecoration(),
                        items: [
                          'Square',
                          'Rectangle',
                          'Triangle',
                          'Trapezium',
                          'Circle',
                          'Rhombus'
                        ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            selectedShape = value;
                            // Clear fields and result for a fresh start
                            controller1.clear();
                            controller2.clear();
                            controller3.clear();
                            result = '';
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Animated container for input fields
              if (selectedShape != null)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ...inputFields(),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: calculate,
                          child: const Text("Calculate Area"),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 30),

              // Animated result text
              Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: result.isEmpty
                      ? const SizedBox.shrink() // Don't show anything if no result
                      : Text(
                    result,
                    // Add a key to ensure the widget is replaced, triggering the animation
                    key: ValueKey<String>(result),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
