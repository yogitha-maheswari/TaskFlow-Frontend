import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/glass_container.dart';

class DeadlinePicker extends StatefulWidget {
  final DateTime? initialDateTime;
  final ValueChanged<DateTime?>? onChanged;

  const DeadlinePicker({
    super.key,
    this.initialDateTime,
    this.onChanged,
  });

  @override
  State<DeadlinePicker> createState() => _DeadlinePickerState();
}

class _DeadlinePickerState extends State<DeadlinePicker> {
  DateTime? _date;
  TimeOfDay? _time;

  late final TextEditingController _dateCtrl;
  late final TextEditingController _timeCtrl;

  bool _didInit = false;

  @override
  void initState() {
    super.initState();

    if (widget.initialDateTime != null) {
      _date = widget.initialDateTime;
      _time = TimeOfDay.fromDateTime(widget.initialDateTime!);
    }

    _dateCtrl = TextEditingController();
    _timeCtrl = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_didInit) {
      if (_date != null) {
        _dateCtrl.text =
            '${_date!.day.toString().padLeft(2, '0')}-'
            '${_date!.month.toString().padLeft(2, '0')}-'
            '${_date!.year}';
      }

      if (_time != null) {
        _timeCtrl.text = _time!.format(context);
      }

      _didInit = true;
    }
  }

  void _emit() {
    if (_date != null && _time != null) {
      widget.onChanged?.call(
        DateTime(
          _date!.year,
          _date!.month,
          _date!.day,
          _time!.hour,
          _time!.minute,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // 🔥 FIX: allow overdue dates
    final DateTime safeInitialDate = _date ?? now;
    final DateTime safeFirstDate =
        safeInitialDate.isBefore(now) ? safeInitialDate : now;

    return GlassContainer(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          // ------------------ Date ------------------
          Expanded(
            child: TextField(
              controller: _dateCtrl,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'dd-mm-yyyy',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: AppIcons.svg(
                    AppIcons.calendar,
                    size: AppSpacing.iconSm,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: safeInitialDate,
                  firstDate: safeFirstDate,
                  lastDate: DateTime(now.year + 5),
                );

                if (picked != null) {
                  setState(() => _date = picked);
                  _dateCtrl.text =
                      '${picked.day.toString().padLeft(2, '0')}-'
                      '${picked.month.toString().padLeft(2, '0')}-'
                      '${picked.year}';
                  _emit();
                }
              },
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          // ------------------ Time ------------------
          Expanded(
            child: TextField(
              controller: _timeCtrl,
              readOnly: true,
              decoration: InputDecoration(
                hintText: '--:--',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: AppIcons.svg(
                    AppIcons.clock,
                    size: AppSpacing.iconSm,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: _time ?? TimeOfDay.now(),
                );

                if (picked != null) {
                  setState(() => _time = picked);
                  _timeCtrl.text = picked.format(context);
                  _emit();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _dateCtrl.dispose();
    _timeCtrl.dispose();
    super.dispose();
  }
}