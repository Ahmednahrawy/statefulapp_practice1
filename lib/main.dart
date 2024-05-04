import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ApiProvider(api: Api(), child: const HomePage()),
    ),
  );
}

class ApiProvider extends InheritedWidget {
  ApiProvider({
    super.key,
    required this.api,
    required this.child,
  })  : uuid = const Uuid().v4(),
        super(child: child);

  final Widget child;
  final Api api;
  final String uuid;

  static ApiProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ApiProvider>();
  }

  @override
  bool updateShouldNotify(ApiProvider oldWidget) {
    return uuid != oldWidget.uuid;
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueKey _textKey = const ValueKey<String?>(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ApiProvider.of(context)?.api.dateAndTime ?? 'Tap down'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: GestureDetector(
        onTap: () async {
          final api = ApiProvider.of(context)?.api;
          final dateAndTime = await api?.getDateAndTime();
          setState(() {
            _textKey = ValueKey(dateAndTime);
          });
        },
        child: SizedBox.expand(
          child: Container(
            color: Colors.white,
            child: DateTimeWidget(
              key: _textKey,
            ),
          ),
        ),
      ),
    );
  }
}

class DateTimeWidget extends StatelessWidget {
  const DateTimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final api = ApiProvider.of(context)!.api;
    return Text(api.dateAndTime ?? 'Tap on screen to fetch the date and time');
  }
}

class Api {
  String? dateAndTime;

  Future<String> getDateAndTime() {
    return Future.delayed(
      const Duration(seconds: 1),
      () => DateTime.now().toIso8601String(),
    ).then((value) {
      dateAndTime = value;
      return value;
    });
  }
}
