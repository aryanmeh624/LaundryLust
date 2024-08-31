import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cleanliness_page.dart';

class IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50], // Softer background color
      appBar: AppBar(
        title: Center(
          child: Text(
            'Welcome',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        backgroundColor: Colors.indigo, // Darker color for contrast
        elevation: 0, // Flat app bar for a modern look
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Animated laundry icon at the top
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
                'Stay Clean',
                style: TextStyle(
                  color: Colors.indigo,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Don’t let laundry spin you out!',
                style: TextStyle(
                  color: Colors.indigo[700],
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              GestureDetector(
                onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('hasSeenIntro', true);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => CleanlinessPage()),
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
                        'Get Started',
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
    );
  }
}
