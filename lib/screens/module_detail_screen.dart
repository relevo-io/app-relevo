import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/mentoring_module_model.dart';
import '../data/providers/mentoring_provider.dart';
import '../l10n/app_localizations.dart';

class ModuleDetailScreen extends ConsumerStatefulWidget {
  final MentoringModule module;
  final bool isCompleted;

  const ModuleDetailScreen({
    super.key,
    required this.module,
    required this.isCompleted,
  });

  @override
  ConsumerState<ModuleDetailScreen> createState() => _ModuleDetailScreenState();
}

class _ModuleDetailScreenState extends ConsumerState<ModuleDetailScreen> {
  bool _isCompleting = false;

  Future<void> _completeModule() async {
    setState(() {
      _isCompleting = true;
    });

    try {
      await ref.read(mentoringProgressStateProvider.notifier).completeModule(widget.module.id);
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.mentoringCompletedAlert),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCompleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.mentoringDetailTitle),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Module Header
                  Text(
                    widget.module.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.module.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Module Items List
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.module.items.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = widget.module.items[index];
                      return _buildItemWidget(context, item, l10n);
                    },
                  ),
                ],
              ),
            ),
          ),
          // Complete Action Button Section
          if (!widget.isCompleted)
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isCompleting ? null : _completeModule,
                  child: _isCompleting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(l10n.mentoringMarkAsCompleted),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildItemWidget(
    BuildContext context,
    MentoringItem item,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);
    IconData icon;
    Color color;
    String typeLabel;

    switch (item.type) {
      case 'tip':
        icon = Icons.lightbulb_outline_rounded;
        color = Colors.amber.shade700;
        typeLabel = l10n.mentoringItemTip;
        break;
      case 'question':
        icon = Icons.help_outline_rounded;
        color = theme.colorScheme.primary;
        typeLabel = l10n.mentoringItemQuestion;
        break;
      case 'task':
        icon = Icons.assignment_turned_in_outlined;
        color = theme.colorScheme.secondary;
        typeLabel = l10n.mentoringItemTask;
        break;
      default:
        icon = Icons.info_outline;
        color = theme.colorScheme.primary;
        typeLabel = '';
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                typeLabel,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item.title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.text,
            style: TextStyle(
              fontSize: 13,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              height: 1.4,
            ),
          ),
          if (item.options != null && item.options!.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...item.options!.map((option) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.radio_button_off_outlined,
                        size: 16,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          option,
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }
}
