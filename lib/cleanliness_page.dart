import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

class CleanlinessPage extends StatefulWidget {
  @override
  _CleanlinessPageState createState() => _CleanlinessPageState();
}

class _CleanlinessPageState extends State<CleanlinessPage> {
  double _currentSliderValue = 1.0;

  // List of descriptions for each slider value
  final List<String> cleanlinessDescriptions = [
    "Very dirty",  // 1
    "Dirty",       // 2
    "Quite Dirty", // 3
    "Messy",       // 4
    "Needs Improvement", // 5
    "Fairly Clean", // 6
    "Clean",       // 7
    "Very Clean",  // 8
    "Almost Spotless", // 9
    "Spotless",    // 10
  ];

  @override
  void initState() {
    super.initState();
    _loadCleanlinessLevel();
  }

  Future<void> _loadCleanlinessLevel() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentSliderValue = (prefs.getInt('cleanlinessLevel') ?? 1).toDouble();
    });
  }

  Future<void> _saveCleanlinessLevel() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cleanlinessLevel', _currentSliderValue.round());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'How Clean Are You?',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'How clean are you?',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 50),
            Slider(
              value: _currentSliderValue,
              min: 1,
              max: 10,
              divisions: 9,
              label: _currentSliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                });
              },
            ),
            SizedBox(height: 20),
            // Display the description corresponding to the slider value
            Text(
              cleanlinessDescriptions[_currentSliderValue.round() - 1],
              style: TextStyle(
                color: Colors.blue,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: () async {
                await _saveCleanlinessLevel();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                padding: EdgeInsets.all(16),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
