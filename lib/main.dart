import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _textFromUser = '';
  final  _savedItems = <String>[];
  final TextEditingController _textController = TextEditingController();
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  void _resetUserActions() {
      _counter = 0;
      _textFromUser = '';
      _textController.clear();
  }

  void _setTextFromUser(String text) {
    setState(() {
      _textFromUser = text;
    });
  }

  void _saveText() {
    if (_textFromUser.isNotEmpty && _savedItems.length < 5) {
      setState(() {
        _savedItems.add('$_textFromUser: $_counter');
        _textFromUser = '';
        _counter = 0;
        _textController.clear();
      });
    }
  }

  void _deleteItem(int index) {
    setState(() {
      _savedItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          if (_savedItems.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.grey[200],
              child: ListView(
                shrinkWrap: true,
                children: _savedItems
                    .asMap()
                    .map((index, item) {
                  return MapEntry(
                    index,
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteItem(index),
                        ),
                        Expanded(
                          child: Text(
                            item,
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  );
                })
                    .values
                    .toList(),
              ),
            ),

          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InputField(
                    controller: _textController,
                    onTextChanged: _setTextFromUser,
                  ),
                  Text(
                    'Count of $_textFromUser: $_counter',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: _saveText,
            tooltip: 'Save',
            label: const Text('Save'),
            icon: const Icon(Icons.save),
          ),
          FloatingActionButton(
            onPressed: _decrementCounter,
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: _resetUserActions,
            tooltip: 'Reset',
            backgroundColor: Colors.red,
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String) onTextChanged;

  const InputField({required this.controller,
    required this.onTextChanged, super.key,});

  @override
  InputFieldState createState() => InputFieldState();
}

class InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: widget.controller,
        onChanged: (String text) {
          widget.onTextChanged(text);
        },
        decoration: const InputDecoration(
          labelText: 'Find ',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
