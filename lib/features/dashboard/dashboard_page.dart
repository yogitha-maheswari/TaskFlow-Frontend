import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/desktop_toast.dart';
import '../../core/widgets/search_field.dart';
import '../../data/services/dashboard_service.dart';
import '../../data/services/secure_storage_service.dart';
import '../../data/providers/notification_provider.dart';
import '../../data/services/api_guard.dart';
import '../../data/services/http_exceptions.dart';
import '../auth/login_page.dart';
import 'widgets/category_card.dart';
import 'widgets/add_category_card.dart';
import 'widgets/overdue_badge.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Future<Map<String, dynamic>>? _dashboardFuture;
  final TextEditingController _searchController = TextEditingController();
  String _search = '';

  @override
  void initState() {
    super.initState();
    debugPrint('🚀 DashboardPage initState called');
    _loadDashboard();

    // 🔔 IN-APP NOTIFICATION LISTENER (WINDOWS)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<NotificationProvider>();

      provider.stream.listen((event) {
        if (!mounted) return;

        DesktopToast.show(
          context,
          title: event.title,
          message: event.message,
        );
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadDashboard() {
    setState(() {
      _dashboardFuture =
          DashboardService.fetchDashboard(search: _search);
    });
  }

  void _onSearchPressed() {
    _search = _searchController.text.trim();
    _loadDashboard();
  }

  Future<void> _logout() async {
    await SecureStorage.clearSession();
    context.read<NotificationProvider>().stop();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  int _crossAxisCount(double width) {
    if (width < 600) return 1;
    if (width < 900) return 2;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dashboardFuture,
        builder: (context, snapshot) {
          // ⏳ LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // ❌ ERROR HANDLING
          if (snapshot.hasError) {
            final err = snapshot.error;

            // 🔐 SESSION EXPIRED → FORCE LOGOUT
            if (err is UnauthorizedException) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                ApiGuard.handle401(context);
              });

              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // ❌ OTHER ERRORS (network, parsing, etc.)
            return Center(
              child: Text(
                'Something went wrong. Please try again.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }

          // ✅ SUCCESS
          final data = snapshot.data!;
          final List categories = (data['categories'] as List?) ?? [];
          final int totalCategories = data['totalCategories'] ?? 0;
          final int totalTasks = data['totalTasks'] ?? 0;
          final int overdueTasks = data['overdueTasks'] ?? 0;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 30),

                    // HEADER
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.myTasks,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              '$totalCategories categories · $totalTasks tasks',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            if (overdueTasks > 0)
                              OverdueBadge(count: overdueTasks),
                            const SizedBox(width: AppSpacing.md),
                            IconButton(
                              tooltip: 'Logout',
                              onPressed: _logout,
                              icon: AppIcons.svg(
                                AppIcons.logout,
                                size: AppSpacing.iconMd,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    SearchField(
                      controller: _searchController,
                      onSearchPressed: _onSearchPressed,
                    ),

                    const SizedBox(height: AppSpacing.xxl),

                    Expanded(
                      child: GridView.count(
                        crossAxisCount:
                            _crossAxisCount(screenWidth),
                        crossAxisSpacing: AppSpacing.lg,
                        mainAxisSpacing: AppSpacing.lg,
                        children: [
                          ...categories.map(
                            (cat) => CategoryCard(
                              categoryId: cat['_id'],
                              title: cat['name'],
                              taskCount: cat['taskCount'],
                              progress:
                                  (cat['progress'] as num).toDouble(),
                              icon: cat['icon'],
                              overdueCount:
                                  cat['overdueCount'] ?? 0,
                              onDelete: _loadDashboard,
                              onRename: _loadDashboard,
                            ),
                          ),
                          AddCategoryCard(
                            onCreated: _loadDashboard,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}