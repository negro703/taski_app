import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String id;
  final String name;
  final String createdBy;
  final List<String> members;

  const Project({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.members,
  });

  @override
  List<Object?> get props => [id, name, createdBy, members];
}
