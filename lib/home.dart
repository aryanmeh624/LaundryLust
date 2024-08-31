import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cleanliness_page.dart';
import 'global.dart' as globals;
import 'add_clothes.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  Future<void> _getCleanlinessLevel() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      globals.cleanlinessLevel = prefs.getInt('cleanlinessLevel') ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCleanlinessLevel();

    // Initialize the animation controller and animation
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CleanlinessPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Your cleanliness level is: ${globals.cleanlinessLevel}',
          style: TextStyle(fontSize: 24),
        ),
      ),
      floatingActionButton: _AnimatedFloatingActionButton(
        animation: _animation,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddClothes()),
          );
        },
      ),
    );
  }
}

class _AnimatedFloatingActionButton extends StatelessWidget {
  final Animation<double> animation;
  final VoidCallback onPressed;

  _AnimatedFloatingActionButton({
    required this.animation,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: FloatingActionButton(
            onPressed: onPressed,
            backgroundColor: Colors.blue,
            child: Icon(Icons.add),
            tooltip: 'Add Clothes',
          ),
        );
      },
    );
  }
}
