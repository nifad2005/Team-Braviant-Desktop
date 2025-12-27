import 'package:flutter/material.dart';
import 'package:team_braviant_desktop/screens/add_team_member_screen.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Braviant', style: TextStyle(color: Color(0xFFFFD700), fontSize: 20, fontWeight: FontWeight.bold),),
      ),
      body: const AddTeamMemberScreen(),
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
                // Handle navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Theme.of(context).colorScheme.primary), // Gold icon
              title: Text('Settings', style: Theme.of(context).textTheme.bodyLarge), // White text
              onTap: () {
                // Handle navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.person_add, color: Theme.of(context).colorScheme.primary), // Gold icon
              title: Text('Add Team Member', style: Theme.of(context).textTheme.bodyLarge), // White text
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AddTeamMemberScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
