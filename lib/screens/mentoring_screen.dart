import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/providers/mentoring_provider.dart';
import '../l10n/app_localizations.dart';
import '../data/models/mentoring_module_model.dart';
import 'module_detail_screen.dart';

class MentoringScreen extends ConsumerWidget {
  const MentoringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modulesAsync = ref.watch(mentoringModulesProvider);
    final progressAsync = ref.watch(mentoringProgressStateProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.mentoringTitle),
        elevation: 0,
      ),
      body: modulesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text(
            l10n.mentoringError(error.toString()),
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ),
        data: (modules) {
          return progressAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => Center(
              child: Text(
                l10n.mentoringError(error.toString()),
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
            data: (progress) {
              final percentage = progress.progressPercentage;

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Progress Header Card
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.secondary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(alpha: 0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.mentoringProgressLabel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: percentage / 100.0,
                                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                                    valueColor: const AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                    minHeight: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                '$percentage%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Modules List
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: modules.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final module = modules[index];
                        final isCompleted = progress.completedModules.contains(module.id);

                        return _buildModuleCard(context, module, isCompleted, l10n);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildModuleCard(
    BuildContext context,
    MentoringModule module,
    bool isCompleted,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ModuleDetailScreen(
              module: module,
              isCompleted: isCompleted,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isCompleted
                ? theme.colorScheme.secondary.withValues(alpha: 0.5)
                : theme.colorScheme.outline.withValues(alpha: 0.35),
            width: isCompleted ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Icon/Badge
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isCompleted
                    ? theme.colorScheme.secondary.withValues(alpha: 0.1)
                    : theme.colorScheme.primary.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isCompleted ? theme.colorScheme.secondary : theme.colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    module.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    module.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.mentoringDurationMinutes(module.duration),
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? theme.colorScheme.secondary.withValues(alpha: 0.1)
                              : theme.colorScheme.onSurface.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isCompleted
                              ? l10n.mentoringModuleCompleted
                              : l10n.mentoringModulePending,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isCompleted
                                ? theme.colorScheme.secondary
                                : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
