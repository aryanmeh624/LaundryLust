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
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Center(
          child: Text(
            'How Clean Are You?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.indigoAccent.withOpacity(0.1),
                  ),
                  child: Icon(
                    Icons.local_laundry_service,
                    size: 100,
                    color: Colors.indigo,
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  'How clean are you?',
                  style: TextStyle(
                    color: Colors.indigo,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Slider(
                  value: _currentSliderValue,
                  min: 1,
                  max: 10,
                  divisions: 9,
                  activeColor: Colors.indigo,
                  inactiveColor: Colors.indigo[100],
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
                    color: Colors.indigo,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                GestureDetector(
                  onTap: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('hasSetCleanliness', true);

                    await _saveCleanlinessLevel();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [Colors.indigo, Colors.blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withOpacity(0.4),
                          offset: Offset(0, 5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Save & Continue',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
