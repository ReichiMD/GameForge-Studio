import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/project.dart';

/// Service for managing projects using SharedPreferences
class ProjectService {
  static const String _projectsKey = 'gameforge_projects';

  /// Get all projects
  Future<List<Project>> getProjects() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final projectsJson = prefs.getString(_projectsKey);

      if (projectsJson == null || projectsJson.isEmpty) {
        return [];
      }

      final List<dynamic> projectsList = json.decode(projectsJson);
      return projectsList
          .map((json) => Project.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading projects: $e');
      return [];
    }
  }

  /// Save a new project
  Future<bool> saveProject(Project project) async {
    try {
      final projects = await getProjects();

      // Check if project already exists (by ID)
      final existingIndex = projects.indexWhere((p) => p.id == project.id);
      if (existingIndex != -1) {
        // Update existing project
        projects[existingIndex] = project;
      } else {
        // Add new project
        projects.add(project);
      }

      return await _saveProjects(projects);
    } catch (e) {
      print('Error saving project: $e');
      return false;
    }
  }

  /// Update an existing project
  Future<bool> updateProject(Project project) async {
    try {
      final projects = await getProjects();
      final index = projects.indexWhere((p) => p.id == project.id);

      if (index == -1) {
        return false; // Project not found
      }

      projects[index] = project.copyWith(updatedAt: DateTime.now());
      return await _saveProjects(projects);
    } catch (e) {
      print('Error updating project: $e');
      return false;
    }
  }

  /// Delete a project by ID
  Future<bool> deleteProject(String projectId) async {
    try {
      final projects = await getProjects();
      projects.removeWhere((p) => p.id == projectId);
      return await _saveProjects(projects);
    } catch (e) {
      print('Error deleting project: $e');
      return false;
    }
  }

  /// Get a single project by ID
  Future<Project?> getProjectById(String projectId) async {
    try {
      final projects = await getProjects();
      return projects.firstWhere(
        (p) => p.id == projectId,
        orElse: () => throw Exception('Project not found'),
      );
    } catch (e) {
      print('Error getting project: $e');
      return null;
    }
  }

  /// Get projects by category
  Future<List<Project>> getProjectsByCategory(String category) async {
    final projects = await getProjects();
    return projects.where((p) => p.category == category).toList();
  }

  /// Clear all projects (for testing/reset)
  Future<bool> clearAllProjects() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_projectsKey);
    } catch (e) {
      print('Error clearing projects: $e');
      return false;
    }
  }

  /// Private method to save projects list to SharedPreferences
  Future<bool> _saveProjects(List<Project> projects) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final projectsJson = json.encode(
        projects.map((p) => p.toJson()).toList(),
      );
      return await prefs.setString(_projectsKey, projectsJson);
    } catch (e) {
      print('Error saving projects to storage: $e');
      return false;
    }
  }
}
