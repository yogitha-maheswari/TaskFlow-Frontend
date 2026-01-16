import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/search_field.dart';
import '../../data/services/task_service.dart';
import '../dashboard/widgets/overdue_badge.dart';
import '../models/create_task_model.dart';
import '../models/task_model.dart';
import 'widgets/task_tile.dart';

class CategoryPage extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const CategoryPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  Future<Map<String, dynamic>>? _taskFuture;

  final TextEditingController _searchController = TextEditingController();
  String _search = '';

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --------------------------------------------------
  // Fetch tasks from backend
  // --------------------------------------------------
  void _loadTasks() {
    _taskFuture = TaskService.fetchTasksByCategory(
      categoryId: widget.categoryId,
      search: _search,
    );
    setState(() {});
  }

  void _onSearchPressed() {
    _search = _searchController.text.trim();
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _taskFuture,
        builder: (context, snapshot) {
          // LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ERROR
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
              child: Text('Failed to load tasks'),
            );
          }

          // DATA
          final data = snapshot.data!;
          final int totalTasks = data['totalTasks'] ?? 0;
          final int overdueCount = data['overdueTasks'] ?? 0;

          final List<Task> tasks = (data['tasks'] as List)
              .map((e) => Task.fromJson(e))
              .toList();

          final overdueTasks = tasks.where((t) => t.isOverdue).toList();
          final normalTasks = tasks.where((t) => !t.isOverdue).toList();

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),

                      // --------------------------------------------------
                      // HEADER
                      // --------------------------------------------------
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: AppSpacing.md),
                              child: AppIcons.svg(
                                AppIcons.back,
                                size: AppSpacing.iconMd,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.categoryName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$totalTasks tasks',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall,
                                ),
                              ],
                            ),
                          ),
                          if (overdueCount > 0)
                            OverdueBadge(count: overdueCount),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // --------------------------------------------------
                      // SEARCH (CLICK ONLY)
                      // --------------------------------------------------
                      SearchField(
                        controller: _searchController,
                        onSearchPressed: _onSearchPressed,
                      ),

                      // --------------------------------------------------
                      // OVERDUE TASKS
                      // --------------------------------------------------
                      if (overdueTasks.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xxl),
                        Text(
                          AppStrings.overdue,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(color: AppColors.danger),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        ...overdueTasks.map(
                          (task) => Padding(
                            padding: const EdgeInsets.only(
                                bottom: AppSpacing.sm),
                            child: TaskTile(
                              task: task,
                              onRefresh: _loadTasks,
                            ),
                          ),
                        ),
                      ],

                      // --------------------------------------------------
                      // NORMAL TASKS
                      // --------------------------------------------------
                      if (normalTasks.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xxl),
                        Text(
                          AppStrings.tasks,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        ...normalTasks.map(
                          (task) => Padding(
                            padding: const EdgeInsets.only(
                                bottom: AppSpacing.sm),
                            child: TaskTile(
                              task: task,
                              onRefresh: _loadTasks,
                            ),
                          ),
                        ),
                      ],

                      // EMPTY STATE
                    if (tasks.isEmpty)
                      const Center(
                        child: Padding(
                          
                          padding: EdgeInsets.only(top: AppSpacing.xxl),
                          
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.playlist_add_check_rounded, size: 48),
                              SizedBox(height: AppSpacing.sm),
                              Text('No tasks found'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),

      // --------------------------------------------------
      // CREATE TASK
      // --------------------------------------------------
      
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final bool? created = await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (_) => CreateTaskModal(
              categoryId: widget.categoryId, // ✅ REQUIRED
            ),
          );

          if (created == true) {
            _loadTasks(); // 🔄 reload from DB
          }
        },
        child: AppIcons.svg(AppIcons.add, color: Colors.white),
      ),
    );
  }
}
