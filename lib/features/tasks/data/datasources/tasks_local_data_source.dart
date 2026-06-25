import 'package:hive_flutter/hive_flutter.dart';
import '../models/project_model.dart';
import '../models/task_model.dart';

abstract class TasksLocalDataSource {
  Future<void> cacheProjects(List<ProjectModel> projects);
  Future<List<ProjectModel>> getCachedProjects();
  Future<void> removeCachedProject(String projectId);
  Future<void> cacheTasks(List<TaskModel> tasks);
  Future<List<TaskModel>> getCachedTasks(String projectId);
  Future<void> removeCachedTask(String taskId);
}

class TasksLocalDataSourceImpl implements TasksLocalDataSource {
  static const String _projectsBoxName = 'projects_box';
  static const String _tasksBoxName = 'tasks_box';

  Future<Box<ProjectModel>> get _projectsBox async =>
      Hive.openBox<ProjectModel>(_projectsBoxName);

  Future<Box<TaskModel>> get _tasksBox async =>
      Hive.openBox<TaskModel>(_tasksBoxName);

  @override
  Future<void> cacheProjects(List<ProjectModel> projects) async {
    final box = await _projectsBox;
    await box.clear();
    final Map<String, ProjectModel> map = {
      for (var project in projects) project.id: project
    };
    await box.putAll(map);
  }

  @override
  Future<List<ProjectModel>> getCachedProjects() async {
    final box = await _projectsBox;
    return box.values.toList();
  }

  @override
  Future<void> removeCachedProject(String projectId) async {
    final box = await _projectsBox;
    await box.delete(projectId);
  }

  @override
  Future<void> cacheTasks(List<TaskModel> tasks) async {
    final box = await _tasksBox;
    if (tasks.isNotEmpty) {
      final projectId = tasks.first.projectId;
      final keysToDelete = box.keys.where((key) {
        final task = box.get(key);
        return task?.projectId == projectId;
      }).toList();
      await box.deleteAll(keysToDelete);

      final Map<String, TaskModel> map = {
        for (var task in tasks) task.id: task
      };
      await box.putAll(map);
    }
  }

  @override
  Future<List<TaskModel>> getCachedTasks(String projectId) async {
    final box = await _tasksBox;
    return box.values.where((task) => task.projectId == projectId).toList();
  }

  @override
  Future<void> removeCachedTask(String taskId) async {
    final box = await _tasksBox;
    await box.delete(taskId);
  }
}