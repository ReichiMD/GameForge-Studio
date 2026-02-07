import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/library_screen.dart';
import 'screens/workshop_screen.dart';
import 'screens/settings_screen.dart';
import 'theme/app_theme.dart';
import 'theme/app_colors.dart';
import 'theme/app_spacing.dart';

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

    return MainNavigation(
      onLogout: _handleLogout,
    );
  }
}

class MainNavigation extends StatefulWidget {
  final VoidCallback onLogout;

  const MainNavigation({
    super.key,
    required this.onLogout,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(
        onCreateProject: () {
          // TODO: Navigate to CreateProjectScreen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Neues Projekt - Coming soon!'),
            ),
          );
        },
      ),
      const LibraryScreen(),
      const WorkshopScreen(),
      SettingsScreen(onLogout: widget.onLogout),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
          fontSize: AppTypography.xs,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: AppTypography.xs,
          fontWeight: FontWeight.w500,
        ),
        items: [
          _buildNavigationItem(
            emoji: '🏠',
            label: 'Home',
            isSelected: _selectedIndex == 0,
          ),
          _buildNavigationItem(
            emoji: '📚',
            label: 'Bibliothek',
            isSelected: _selectedIndex == 1,
          ),
          _buildNavigationItem(
            emoji: '🔧',
            label: 'Workshop',
            isSelected: _selectedIndex == 2,
          ),
          _buildNavigationItem(
            emoji: '⚙️',
            label: 'Settings',
            isSelected: _selectedIndex == 3,
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavigationItem({
    required String emoji,
    required String label,
    required bool isSelected,
  }) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
        ),
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 24),
        ),
      ),
      label: label,
    );
  }
}
