import 'dart:ui';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_icons.dart';

class GlassContainer extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? radius;
  final double blur;
  final Border? border;

  // ✅ Menu related
  final bool showMenu;
  final VoidCallback? onRename;
  final VoidCallback? onDelete;

  const GlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.radius,
    this.blur = 12,
    this.border,
    this.showMenu = false,
    this.onRename,
    this.onDelete,
  });

  @override
  State<GlassContainer> createState() => _GlassContainerState();
}

class _GlassContainerState extends State<GlassContainer> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        if (widget.showMenu) {
          setState(() => _hovering = true);
        }
      },
      onExit: (_) {
        if (widget.showMenu) {
          setState(() => _hovering = false);
        }
      },
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(widget.radius ?? AppSpacing.radiusLg),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: widget.blur,
            sigmaY: widget.blur,
          ),
          child: Container(
            padding: widget.padding ?? const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.surfaceGlass.withOpacity(0.85),
                  AppColors.surfaceGlass.withOpacity(0.65),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius:
                  BorderRadius.circular(widget.radius ?? AppSpacing.radiusLg),
              border: widget.border ??
                  Border.all(
                    color: AppColors.border,
                  ),
            ),
            child: Stack(
              children: [
                widget.child,

                // --------------------------------------------------
                // THREE DOT MENU (HOVER ONLY — FUNCTIONAL)
                // --------------------------------------------------
                if (widget.showMenu)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: AnimatedOpacity(
                      opacity: _hovering ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOut,
                      child: PopupMenuButton<_MenuAction>(
                        icon: AppIcons.svg(
                          AppIcons.more,
                          color: AppColors.textMuted,
                          size: AppSpacing.iconSm,
                        ),
                        color: AppColors.surface,
                        onSelected: (value) {
                          if (value == _MenuAction.rename) {
                            widget.onRename?.call();
                          } else if (value == _MenuAction.delete) {
                            widget.onDelete?.call();
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: _MenuAction.rename,
                            child: Row(
                              children: [
                                AppIcons.svg(
                                  AppIcons.edit,
                                  size: AppSpacing.iconSm,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                const Text('Rename'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: _MenuAction.delete,
                            child: Row(
                              children: [
                                AppIcons.svg(
                                  AppIcons.delete,
                                  size: AppSpacing.iconSm,
                                  color: AppColors.danger,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                const Text('Delete'),
                              ],
                            ),
                          ),
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
  }
}

enum _MenuAction { rename, delete }