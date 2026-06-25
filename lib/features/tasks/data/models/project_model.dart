import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:taski/features/tasks/domain/entities/project.dart';

@HiveType(typeId: 0)
class ProjectModel extends Project {
  const ProjectModel({
    required super.id,
    required super.name,
    required super.createdBy,
    required super.members,
  });

  factory ProjectModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProjectModel(
      id: doc.id,
      name: data["name"] ?? '',
      createdBy: data["createdBy"] ?? '',
      members: List<String>.from(data["members"] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "createdBy": createdBy,
      "members": members,
    };
  }
}

class ProjectModelAdapter extends TypeAdapter<ProjectModel> {
  @override
  final int typeId = 0;

  @override
  ProjectModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProjectModel(
      id: fields[0] as String,
      name: fields[1] as String,
      createdBy: fields[2] as String,
      members: (fields[3] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProjectModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.createdBy)
      ..writeByte(3)
      ..write(obj.members);
  }
}