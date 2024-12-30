import 'package:flutter/material.dart';

void main() {
  runApp(MoodTrackerApp());
}

class MoodTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mood Tracker',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Map<String, String> _users = {'testuser': 'password123'};
  String? _error;

  void _login() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (_users[username] == password) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(username: username),
        ),
      );
    } else {
      setState(() {
        _error = 'Invalid username or password';
      });
    }
  }

  void _signup() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isNotEmpty && password.isNotEmpty && !_users.containsKey(username)) {
      setState(() {
        _users[username] = password;
        _error = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup successful! Please login.')),
      );
    } else {
      setState(() {
        _error = 'Signup failed. Username might already exist.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade400, Colors.teal.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Mood Tracker',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _error!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Login'),
                    ),
                    TextButton(
                      onPressed: _signup,
                      child: Text('Sign Up'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String username;

  HomePage({required this.username});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> moods = [
    {'mood': 'Happy', 'emoji': '😊'},
    {'mood': 'Sad', 'emoji': '😢'},
    {'mood': 'Excited', 'emoji': '🤩'},
    {'mood': 'Anxious', 'emoji': '😟'},
    {'mood': 'Calm', 'emoji': '😌'},
    {'mood': 'Angry', 'emoji': '😡'},
  ];
  String? selectedMood;
  String? note;
  List<Map<String, String>> moodLog = [];

  void _logMood() {
    if (selectedMood != null) {
      setState(() {
        moodLog.add({
          'mood': selectedMood!,
          'note': note ?? '',
          'date': DateTime.now().toLocal().toString().split(' ')[0],
        });
        selectedMood = null;
        note = null;
      });
    }
  }

  void _viewGraph() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GraphPage(moodLog: moodLog)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mood Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.bar_chart),
            onPressed: _viewGraph,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade100, Colors.teal.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi ${widget.username}, how is your mood today?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal.shade900),
              ),
              SizedBox(height: 20),
              Wrap(
                spacing: 10,
                children: moods.map((mood) {
                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(mood['emoji']!, style: TextStyle(fontSize: 18)),
                        SizedBox(width: 5),
                        Text(mood['mood']!),
                      ],
                    ),
                    selected: selectedMood == mood['mood'],
                    onSelected: (bool selected) {
                      setState(() {
                        selectedMood = selected ? mood['mood'] : null;
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Add a note (optional)',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (value) {
                  note = value;
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _logMood,
                  child: Text('Log Mood'),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Mood Log:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal.shade900),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: moodLog.length,
                  itemBuilder: (context, index) {
                    final log = moodLog[index];
                    final mood = moods.firstWhere((m) => m['mood'] == log['mood']);
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.teal.shade200,
                          child: Text(mood['emoji']!, style: TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                        title: Text(log['mood']!, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (log['note']!.isNotEmpty) Text('Note: ${log['note']}'),
                            Text('Date: ${log['date']}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GraphPage extends StatelessWidget {
  final List<Map<String, String>> moodLog;

  GraphPage({required this.moodLog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mood Graphs'),
      ),
      body: Center(
        child: Text('Graphs for weekly, monthly, and yearly data will be displayed here.'),
      ),
    );
  }
}
