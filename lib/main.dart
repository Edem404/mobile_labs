import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _textFromUser = '';
  final List<String> _savedItems = [];
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
    setState(() {
      _counter = 0;
      _textFromUser = '';
      _textController.clear();
    });
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
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
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
// class InputField extends StatelessWidget {
//   final TextEditingController controller;
//   final Function(String) onTextChanged;
//
//   const InputField({required this.controller,
//     required this.onTextChanged, super.key,});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: TextField(
//         controller: controller,
//         onChanged: onTextChanged,
//         decoration: const InputDecoration(
//           labelText: 'Find ',
//           border: OutlineInputBorder(),
//         ),
//       ),
//     );
//   }
// }
