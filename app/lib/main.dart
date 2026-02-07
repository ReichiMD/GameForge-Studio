import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const GameForgeApp());
}

class GameForgeApp extends StatelessWidget {
  const GameForgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GameForge Studio',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  bool _isAuthenticated = false;
  String? _username;
  String? _githubToken;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final githubToken = prefs.getString('githubToken');

    setState(() {
      _isAuthenticated = username != null && githubToken != null;
      _username = username;
      _githubToken = githubToken;
      _isLoading = false;
    });
  }

  Future<void> _handleLogin(String username, String githubToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('githubToken', githubToken);

    setState(() {
      _isAuthenticated = true;
      _username = username;
      _githubToken = githubToken;
    });
  }

  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('githubToken');

    setState(() {
      _isAuthenticated = false;
      _username = null;
      _githubToken = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_isAuthenticated) {
      return LoginScreen(onLogin: _handleLogin);
    }

    return HomeScreen(
      onCreateProject: () {
        // TODO: Navigate to CreateProjectScreen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Neues Projekt - Coming soon!'),
          ),
        );
      },
    );
  }
}
