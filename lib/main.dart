import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_project/new_design/homepage.dart';
import 'package:test_project/services/auth.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.bottom, //This line is used for showing the bottom bar
  ]);

  // initialiseStudyPlanDB();
  runApp(const MyApp());
  // FirebaseAuth.instance;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      title: 'School Planner',
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const HomePage();
            } else {
              return const AuthGate();
            }
          }),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _selectedIndex = 0;

//   void callback() {
//     setState(() {});
//   }

//   static const List<Widget> _mainPages = <Widget>[
//     SubjectsPage(),
//     ToDoPage(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   void _addSubjectTapped(context) {
//     Navigator.of(context).push(MaterialPageRoute(builder: (_) {
//       return const AddSubjectPage();
//     }));
//   }

//   void _addTaskTapped(context) {
//     Navigator.of(context).push(MaterialPageRoute(builder: (_) {
//       return const AddTaskPage();
//     }));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_selectedIndex == 0 ? 'Subjects' : 'To-Do List'),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: IconButton(
//                 onPressed: () => _selectedIndex == 0
//                     ? _addSubjectTapped(context)
//                     : _addTaskTapped(context),
//                 icon: const Icon(
//                   Icons.add,
//                   color: Colors.white,
//                   size: 28,
//                 )),
//           )
//         ],
//       ),
//       body: _mainPages.elementAt(_selectedIndex),
//       bottomNavigationBar: MyBottomNavBar(
//           selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
//     );
//   }
// }
