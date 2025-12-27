import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For RawKeyboardKey
import 'package:team_braviant_desktop/screens/add_team_member_screen.dart';
import 'package:team_braviant_desktop/screens/team_member_list_screen.dart';
import 'package:team_braviant_desktop/services/database_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // NEW IMPORT

// Define Custom Intents
class AddMemberIntent extends Intent {
  const AddMemberIntent();
}

class SaveMemberIntent extends Intent {
  const SaveMemberIntent();
}

class CancelIntent extends Intent {
  const CancelIntent();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit(); // NEW LINE: Initialize FFI
  databaseFactory = databaseFactoryFfi; // NEW LINE: Set the database factory
  await DatabaseHelper().database; // Initialize the database
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyN): const AddMemberIntent(), // Ctrl+N to add
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS): const SaveMemberIntent(), // Ctrl+S to save
        LogicalKeySet(LogicalKeyboardKey.escape): const CancelIntent(), // Escape to cancel
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          AddMemberIntent: CallbackAction<AddMemberIntent>(
            onInvoke: (intent) {
              final NavigatorState navigator = Navigator.of(context);
              // Only navigate if not already on the add screen or a dialog
              if (!navigator.canPop() || ModalRoute.of(context)?.settings.name != '/addMember') {
                navigator.push(
                  MaterialPageRoute(
                    builder: (context) => const AddTeamMemberScreen(),
                    settings: const RouteSettings(name: '/addMember'),
                  ),
                );
              }
              return null;
            },
          ),
          SaveMemberIntent: CallbackAction<SaveMemberIntent>(
            onInvoke: (intent) {
              // This action will be handled at a lower level (screen-specific)
              // For now, if current route is addMember, pop.
              if (ModalRoute.of(context)?.settings.name == '/addMember') {
                 Navigator.of(context).pop(); // Simulate saving by closing the add screen
              } else if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
              return null;
            },
          ),
          CancelIntent: CallbackAction<CancelIntent>(
            onInvoke: (intent) {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
              return null;
            },
          ),
        },
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: MaterialColor(
                0xFFFFD700, // Gold color
                <int, Color>{
                  50: Color(0xFFFFF8E1),
                  100: Color(0xFFFFECB3),
                  200: Color(0xFFFFE082),
                  300: Color(0xFFFFD54F),
                  400: Color(0xFFFFCA28),
                  500: Color(0xFFFFC107),
                  600: Color(0xFFFFB300),
                  700: Color(0xFFFFA000),
                  800: Color(0xFFFF8F00),
                  900: Color(0xFFFF6F00),
                },
              ),
              brightness: Brightness.dark, // Explicitly set brightness to dark
              backgroundColor: Colors.grey[800],
              cardColor: Colors.grey[700],
            ).copyWith(
              secondary: Colors.amber, // Use colorScheme.secondary for accent
              // Also define other colors in the ColorScheme if needed
              surface: Colors.grey[700], // A common background for cards, dialogs, etc.
              onSurface: Colors.white, // Text/icons on surface
              primary: Color(0xFFFFD700), // Explicitly define primary color here
              onPrimary: Colors.black, // Text/icons on primary color
            ),
            scaffoldBackgroundColor: Colors.grey[800],
            appBarTheme: AppBarTheme(
              color: Colors.grey[900],
              foregroundColor: Color(0xFFFFD700), // Gold text on black app bar
              titleTextStyle: TextStyle(
                color: Color(0xFFFFD700),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            textTheme: TextTheme(
              displayLarge: TextStyle(color: Color(0xFFFFD700)),
              displayMedium: TextStyle(color: Color(0xFFFFD700)),
              displaySmall: TextStyle(color: Color(0xFFFFD700)),
              headlineLarge: TextStyle(color: Color(0xFFFFD700)),
              headlineMedium: TextStyle(color: Color(0xFFFFD700)),
              headlineSmall: TextStyle(color: Color(0xFFFFD700)),
              titleLarge: TextStyle(color: Color(0xFFFFD700)),
              titleMedium: TextStyle(color: Color(0xFFFFD700)),
              titleSmall: TextStyle(color: Color(0xFFFFD700)),
              bodyLarge: TextStyle(color: Colors.white), // White for body text on black background
              bodyMedium: TextStyle(color: Colors.white),
              bodySmall: TextStyle(color: Colors.white),
              labelLarge: TextStyle(color: Color(0xFFFFD700)),
              labelMedium: TextStyle(color: Color(0xFFFFD700)),
              labelSmall: TextStyle(color: Color(0xFFFFD700)),
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Color(0xFFFFD700), // Gold FAB
              foregroundColor: Colors.black, // Black icon on gold FAB
            ),
          ),
          home: const MyHomePage(title: 'Team Braviant'),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget _currentScreen = const TeamMemberListScreen(); // Default to list screen

  void _navigateTo(Widget screen) {
    setState(() {
      _currentScreen = screen;
    });
    Navigator.of(context).pop(); // Close the drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Braviant', style: TextStyle(color: Color(0xFFFFD700), fontSize: 20, fontWeight: FontWeight.bold),),
      ),
      body: _currentScreen,
      endDrawer: Drawer(
        backgroundColor: Colors.grey[900], // Dark background for the drawer
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary, // Gold header
              ),
              child: Text(
                'Team Braviant',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.black), // Black text on gold
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Theme.of(context).colorScheme.primary), // Gold icon
              title: Text('Home', style: Theme.of(context).textTheme.bodyLarge), // White text
              onTap: () {
                _navigateTo(const TeamMemberListScreen()); // Assuming home is the list screen
              },
            ),
            ListTile(
              leading: Icon(Icons.group, color: Theme.of(context).colorScheme.primary), // Gold icon
              title: Text('View Team Members', style: Theme.of(context).textTheme.bodyLarge), // White text
              onTap: () {
                _navigateTo(const TeamMemberListScreen());
              },
            ),
            ListTile(
              leading: Icon(Icons.person_add, color: Theme.of(context).colorScheme.primary), // Gold icon
              title: Text('Add Team Member', style: Theme.of(context).textTheme.bodyLarge), // White text
              onTap: () {
                _navigateTo(const AddTeamMemberScreen());
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Theme.of(context).colorScheme.primary), // Gold icon
              title: Text('Settings', style: Theme.of(context).textTheme.bodyLarge), // White text
              onTap: () {
                // Handle navigation to settings or implement a settings screen
                Navigator.of(context).pop(); // Close the drawer
              },
            ),
          ],
        ),
      ),
    );
  }
}
