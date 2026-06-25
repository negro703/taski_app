import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taski/features/tasks/data/models/project_model.dart';
import 'package:taski/features/tasks/data/models/task_model.dart';
import 'package:taski/features/tasks/domain/entities/task.dart';

class TasksRemoteDataSource {
  final FirebaseFirestore firestore;

  TasksRemoteDataSource({required this.firestore});

  /// Projects stream
  Stream<List<ProjectModel>> getProjects() {
    return firestore.collection('projects').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => ProjectModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// Create a project document, returns the generated ID
  Future<String> createProject(ProjectModel project) async {
    final docRef = await firestore.collection('projects').add(project.toMap());
    return docRef.id;
  }

  /// Delete a project document
  Future<void> deleteProject(String projectId) async {
    await firestore.collection('projects').doc(projectId).delete();
  }

  /// Tasks stream for a given project
  Stream<List<TaskModel>> getTasks(String projectId) {
    return firestore
        .collection('tasks')
        .where('projectId', isEqualTo: projectId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TaskModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// Create a task document, returns the generated ID
  Future<String> createTask(TaskModel task) async {
    final docRef = await firestore.collection('tasks').add(task.toMap());
    return docRef.id;
  }

  /// Delete a task document
  Future<void> deleteTask(String taskId) async {
    await firestore.collection('tasks').doc(taskId).delete();
  }

  /// Update a task's status
  Future<void> updateTaskStatus(String taskId, TaskStatus newStatus) async {
    await firestore.collection('tasks').doc(taskId).update({
      'status': newStatus.toString().split('.').last,
      'lastUpdated': Timestamp.now(),
    });
  }
}