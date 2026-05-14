import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/kvs_button.dart';
import 'leaders_list_page.dart';

class LeaderProfilePage extends ConsumerWidget {
  final String leaderId;
  const LeaderProfilePage({super.key, required this.leaderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Find stub data
    final leader = stubLeaders.firstWhere(
      (l) => l.id == leaderId,
      orElse: () => const LeaderCard(
        id: '', name: 'Unknown', role: '', area: '', district: '',
        issuesSolved: 0, followers: 0,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: Text(
                        leader.name.isNotEmpty
                            ? leader.name[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      leader.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      leader.role,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats row
                  Row(
                    children: [
                      _StatBadge(
                        label: 'Issues Solved',
                        value: '${leader.issuesSolved}',
                        icon: Icons.task_alt,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: AppSizes.md),
                      _StatBadge(
                        label: 'Followers',
                        value: '${leader.followers}',
                        icon: Icons.people_outline,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.lg),

                  // Area info
                  _InfoRow(
                    icon: Icons.location_on_outlined,
                    label: 'Area',
                    value: leader.area,
                  ),
                  const SizedBox(height: AppSizes.sm),
                  _InfoRow(
                    icon: Icons.location_city_outlined,
                    label: 'District',
                    value: leader.district,
                  ),
                  const SizedBox(height: AppSizes.lg),

                  const Divider(),
                  const SizedBox(height: AppSizes.md),

                  const Text(
                    'Recent Activity',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSizes.md),

                  // Placeholder activity items
                  ...List.generate(
                    3,
                    (i) => _ActivityItem(
                      text: 'Resolved issue: ${["Road pothole fixed", "Water supply restored", "Street light repaired"][i]}',
                      time: '${i + 1} day${i > 0 ? "s" : ""} ago',
                    ),
                  ),

                  const SizedBox(height: AppSizes.xl),

                  KvsButton(
                    label: 'Report Issue to This Leader',
                    icon: Icons.report_problem_outlined,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatBadge({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: color)),
            Text(label,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: AppSizes.sm),
        Text('$label: ',
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 13)),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 13)),
      ],
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String text;
  final String time;

  const _ActivityItem({required this.text, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 5),
            decoration: const BoxDecoration(
              color: AppColors.secondary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text,
                    style: const TextStyle(fontSize: 13)),
                Text(time,
                    style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

