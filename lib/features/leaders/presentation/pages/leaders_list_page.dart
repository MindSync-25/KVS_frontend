import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// ─── Simple leader model for display ─────────────────────────────────────────

class LeaderCard {
  final String id;
  final String name;
  final String role;
  final String area;
  final String district;
  final int issuesSolved;
  final int followers;
  final String? photoUrl;

  const LeaderCard({
    required this.id,
    required this.name,
    required this.role,
    required this.area,
    required this.district,
    required this.issuesSolved,
    required this.followers,
    this.photoUrl,
  });
}

// Stub data – will be replaced with Supabase query
final stubLeaders = [
  LeaderCard(id: '1', name: 'Ravi Kumar', role: 'District Lead', area: 'Bengaluru Urban', district: 'Bengaluru Urban', issuesSolved: 142, followers: 3200),
  LeaderCard(id: '2', name: 'Meena Shetty', role: 'Taluk Lead', area: 'Mangaluru Taluk', district: 'Dakshina Kannada', issuesSolved: 89, followers: 1400),
  LeaderCard(id: '3', name: 'Harish Gowda', role: 'Ward Lead', area: 'Ward 5, Mysuru', district: 'Mysuru', issuesSolved: 63, followers: 780),
  LeaderCard(id: '4', name: 'Savitha Naik', role: 'Booth Lead', area: 'Booth 12, Hubli', district: 'Dharwad', issuesSolved: 44, followers: 520),
];

class LeadersListPage extends ConsumerStatefulWidget {
  const LeadersListPage({super.key});

  @override
  ConsumerState<LeadersListPage> createState() => _LeadersListPageState();
}

class _LeadersListPageState extends ConsumerState<LeadersListPage> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final filtered = stubLeaders.where((l) =>
        l.name.toLowerCase().contains(_search.toLowerCase()) ||
        l.area.toLowerCase().contains(_search.toLowerCase())).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Our Leaders'),
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                hintText: 'Search leaders or area...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // My district highlight
          if (user != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSizes.sm),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: Text(
                  'Showing leaders for your district: ${user.district}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          const SizedBox(height: AppSizes.sm),
          // List
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('No leaders found'))
                : ListView.separated(
                    padding: const EdgeInsets.all(AppSizes.md),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSizes.sm),
                    itemBuilder: (_, i) => _LeaderTile(
                      leader: filtered[i],
                      onTap: () =>
                          context.push('/leaders/${filtered[i].id}'),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _LeaderTile extends StatelessWidget {
  final LeaderCard leader;
  final VoidCallback onTap;

  const _LeaderTile({required this.leader, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.primary.withOpacity(0.15),
              backgroundImage:
                  leader.photoUrl != null ? NetworkImage(leader.photoUrl!) : null,
              child: leader.photoUrl == null
                  ? Text(
                      leader.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(leader.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15)),
                  Text(leader.role,
                      style: const TextStyle(
                          color: AppColors.primary, fontSize: 13)),
                  Text(leader.area,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    const Icon(Icons.task_alt,
                        size: 14, color: AppColors.secondary),
                    const SizedBox(width: 2),
                    Text('${leader.issuesSolved}',
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondary)),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.people_outline,
                        size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 2),
                    Text('${leader.followers}',
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
            const SizedBox(width: AppSizes.sm),
            const Icon(Icons.chevron_right,
                color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
