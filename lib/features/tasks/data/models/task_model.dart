import "package:cloud_firestore/cloud_firestore.dart";
import "package:hive/hive.dart";
import "package:taski/features/tasks/domain/entities/task.dart";

@HiveType(typeId: 1)
class TaskModel extends Task {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String projectId;

  @HiveField(2)
  @override
  final String title;

  @HiveField(3)
  @override
  final String description;

  @HiveField(4)
  @override
  final TaskStatus status;

  @HiveField(5)
  @override
  final DateTime dueDate;

  @HiveField(6)
  @override
  final String assignedTo;

  @HiveField(7)
  @override
  final DateTime createdAt;

  const TaskModel({
    required this.id,
    required this.projectId,
    required this.title,
    required this.description,
    required this.status,
    required this.dueDate,
    required this.assignedTo,
    required this.createdAt,
  }) : super(
          id: id,
          projectId: projectId,
          title: title,
          description: description,
          status: status,
          dueDate: dueDate,
          assignedTo: assignedTo,
          createdAt: createdAt,
        );

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      projectId: data["projectId"] ?? '',
      title: data["title"] ?? '',
      description: data["description"] ?? '',
      status: TaskStatus.values.firstWhere(
        (e) => e.toString().split(".").last == data["status"],
        orElse: () => TaskStatus.todo,
      ),
      dueDate: (data["dueDate"] is Timestamp)
          ? (data["dueDate"] as Timestamp).toDate()
          : (data["dueDate"] != null ? DateTime.parse(data["dueDate"]) : DateTime.now()),
      assignedTo: data["assignedTo"] ?? '',
      createdAt: (data["createdAt"] is Timestamp)
          ? (data["createdAt"] as Timestamp).toDate()
          : (data["createdAt"] != null ? DateTime.parse(data["createdAt"]) : DateTime.now()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "projectId": projectId,
      "title": title,
      "description": description,
      "status": status.toString().split(".").last,
      "dueDate": Timestamp.fromDate(dueDate),
      "assignedTo": assignedTo,
      "createdAt": Timestamp.fromDate(createdAt),
    };
  }
}

class TaskModelAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = 1;

  @override
  TaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskModel(
      id: fields[0] as String,
      projectId: fields[1] as String,
      title: fields[2] as String,
      description: fields[3] as String,
      status: TaskStatus.values[fields[4] as int],
      dueDate: DateTime.fromMillisecondsSinceEpoch(fields[5] as int),
      assignedTo: fields[6] as String,
      createdAt: fields.containsKey(7) ? DateTime.fromMillisecondsSinceEpoch(fields[7] as int) : DateTime.now(),
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.projectId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.status.index)
      ..writeByte(5)
      ..write(obj.dueDate.millisecondsSinceEpoch)
      ..writeByte(6)
      ..write(obj.assignedTo)
      ..writeByte(7)
      ..write(obj.createdAt.millisecondsSinceEpoch);
  }
}