import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:giaicswift/services/checkresults.dart';
import 'package:googleapis/calendar/v3.dart' hide Colors;
import 'package:url_launcher/url_launcher.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _controller = TextEditingController();
  String _result = '';
  String _status = '';
  bool _isPassed = false;

  void _checkRollNumber() async {
    if (_controller.text.isEmpty) {
      setState(() {
        _result = 'Please enter a roll number';
        _status = 'Error';
      });
      return;
    }
    // Check if the input value is an integer
    final rollNumber = int.tryParse(_controller.text);
    if (rollNumber == null) {
      setState(() {
        _result = 'Roll number must be an integer';
        _status = 'Error';
      });
      return;
    }

    try {
      final checker = RollNumberChecker();
      final result = await checker.getResult(_controller.text);
      setState(() {
        _result = result.toString(); // Assuming result is a String
        _isPassed = _result.toLowerCase() == 'pass';
        _status = _isPassed ? 'Congratulations!' : 'Keep pushing forward!';
        log(_controller.text);
        debugPrint('Result: $_result');
      });
    } catch (e) {
      debugPrint('Error: $e');
      setState(() {
        _result = 'Error occurred';
        _status = 'Error';
      });
    }
  }

  void _launchURL() async {
    const url = 'https://www.linkedin.com/in/mehdinathani/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'GIAIC Q1 Result Checker',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  textAlign: TextAlign.center,
                  'Check your GIAIC Result',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  textAlign: TextAlign.center,
                  'Enter your roll number to see your Quarter 1 result',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Roll Number',
                    fillColor: Colors.amber,
                    icon: Icon(Icons.numbers),
                    labelStyle: TextStyle(fontSize: 20),
                  ),
                  onSubmitted: (value) {
                    _controller.text = value;
                    _checkRollNumber();
                  },
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _checkRollNumber,
                  child: const Text(
                    "Check Result",
                    style: TextStyle(
                        fontSize: 24,
                        wordSpacing: 1,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 30),
                if (_result.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_isPassed)
                        Column(
                          children: [
                            const Icon(Icons.emoji_events,
                                color: Colors.green, size: 50),
                            const Text(
                              'Congratulations!',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Roll Number: ${_controller.text}',
                              style: const TextStyle(
                                  fontSize: 24,
                                  wordSpacing: 1,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Status: $_result',
                              style: const TextStyle(
                                  fontSize: 24,
                                  wordSpacing: 1,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Your hard work has paid off, keep pushing forward!',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        )
                      else
                        Column(
                          children: [
                            const Icon(Icons.error,
                                color: Colors.red, size: 50),
                            const Text(
                              'Keep pushing forward!',
                              style: TextStyle(fontSize: 22, color: Colors.red),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Roll Number: ${_controller.text}',
                              style: const TextStyle(
                                  fontSize: 24,
                                  wordSpacing: 1,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Status: $_result',
                              style: const TextStyle(
                                  fontSize: 24,
                                  wordSpacing: 1,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'The only true failure is giving up.\nYou\'ve got this, keep pushing forward!',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          debugPrint("Tap");
          _launchURL();
        },
        child: Container(
          color: Colors.green,
          child: RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Made with ❤ by ',
                  style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: 'Mehdi Nathani',
                  style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 20,
                      color: Colors.black, // Blue color for the name
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold // Underline
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
