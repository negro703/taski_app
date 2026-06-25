import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taski/core/common_widgets/shimmer_loading.dart';
import 'package:taski/features/tasks/domain/entities/project.dart';
import 'package:taski/features/tasks/domain/entities/task.dart';
import 'package:taski/features/tasks/presentation/bloc/tasks_bloc.dart';
import 'package:taski/features/tasks/presentation/bloc/tasks_event.dart';
import 'package:taski/features/tasks/presentation/bloc/tasks_state.dart';
import 'package:taski/features/tasks/presentation/widgets/add_task_modal.dart';
import 'package:taski/features/tasks/presentation/widgets/task_card.dart';

class ProjectDetailsPage extends StatefulWidget {
  final Project project;

  const ProjectDetailsPage({super.key, required this.project});

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<TasksBloc>().add(GetTasksEvent(projectId: widget.project.id));
  }

  void _showAddTaskSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AddTaskModalContent(projectId: widget.project.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF475569)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.project.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
          ),
        ),
        centerTitle: false,
      ),
      body: BlocConsumer<TasksBloc, TasksState>(
        listener: (context, state) {
          if (state is TasksError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TasksLoading) {
            return const Padding(
              padding: EdgeInsets.all(20),
              child: ShimmerLoadingSkeleton(),
            );
          } else if (state is TasksLoaded) {
            if (state.tasks.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.inbox_rounded,
                        size: 56, color: const Color(0xFFE2E8F0)),
                    const SizedBox(height: 16),
                    const Text(
                      'No tasks found',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tap + to add your first task',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFCBD5E1),
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 80),
              itemCount: state.tasks.length,
              separatorBuilder: (_, _) => const SizedBox(height: 0),
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                return _AnimatedTaskCard(
                  index: index,
                  task: task,
                  onStatusChanged: (newStatus) {
                    context.read<TasksBloc>().add(
                      UpdateTaskStatusEvent(
                        taskId: task.id,
                        projectId: widget.project.id,
                        status: newStatus,
                      ),
                    );
                  },
                  onDelete: () {
                    context.read<TasksBloc>().add(
                      DeleteTaskEvent(
                        taskId: task.id,
                        projectId: widget.project.id,
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is TasksError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        size: 56, color: Color(0xFFE2E8F0)),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.tonal(
                      onPressed: () => context
                          .read<TasksBloc>()
                          .add(GetTasksEvent(projectId: widget.project.id)),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskSheet,
        backgroundColor: const Color(0xFF6366F1),
        elevation: 4,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }
}

/// Animated wrapper that fades + slides each task card into view.
class _AnimatedTaskCard extends StatefulWidget {
  final int index;
  final Task task;
  final ValueChanged<TaskStatus> onStatusChanged;
  final VoidCallback onDelete;

  const _AnimatedTaskCard({
    required this.index,
    required this.task,
    required this.onStatusChanged,
    required this.onDelete,
  });

  @override
  State<_AnimatedTaskCard> createState() => _AnimatedTaskCardState();
}

class _AnimatedTaskCardState extends State<_AnimatedTaskCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: TaskCard(
          task: widget.task,
          onStatusChanged: widget.onStatusChanged,
          onDelete: widget.onDelete,
        ),
      ),
    );
  }
}