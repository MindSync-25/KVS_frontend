import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../auth/domain/entities/app_user.dart';

class LeaderboardPage extends ConsumerWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: _LeaderboardScaffold(),
    );
  }
}

class _LeaderboardScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Leaderboard'),
        bottom: const TabBar(
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'State'),
            Tab(text: 'My District'),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          _Board(entries: _stub),
          _Board(
              entries: _stub
                  .where((e) => e.district == 'Bengaluru Urban')
                  .toList()),
        ],
      ),
    );
  }
}

class _LeaderboardEntry {
  final int rank;
  final String name;
  final String district;
  final int score;
  final int referrals;
  final int issuesSolved;
  final PartyPosition position;

  const _LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.district,
    required this.score,
    required this.referrals,
    required this.issuesSolved,
    required this.position,
  });
}

final _stub = [
  _LeaderboardEntry(rank: 1, name: 'Meena Shetty', district: 'Dakshina Kannada', score: 4820, referrals: 89, issuesSolved: 142, position: PartyPosition.districtPresident),
  _LeaderboardEntry(rank: 2, name: 'Ravi Kumar', district: 'Bengaluru Urban', score: 4110, referrals: 76, issuesSolved: 98, position: PartyPosition.districtPresident),
  _LeaderboardEntry(rank: 3, name: 'Harish Gowda', district: 'Mysuru', score: 3790, referrals: 64, issuesSolved: 87, position: PartyPosition.constituencyIncharge),
  _LeaderboardEntry(rank: 4, name: 'Savitha Naik', district: 'Dharwad', score: 3210, referrals: 52, issuesSolved: 63, position: PartyPosition.boothPresident),
  _LeaderboardEntry(rank: 5, name: 'Manjunath P', district: 'Tumakuru', score: 2980, referrals: 48, issuesSolved: 55, position: PartyPosition.boothPresident),
  _LeaderboardEntry(rank: 6, name: 'Priya Hegde', district: 'Uttara Kannada', score: 2640, referrals: 41, issuesSolved: 47, position: PartyPosition.boothCommitteeMember),
  _LeaderboardEntry(rank: 7, name: 'Suresh B N', district: 'Hassan', score: 2310, referrals: 35, issuesSolved: 39, position: PartyPosition.member),
  _LeaderboardEntry(rank: 8, name: 'Kavitha R', district: 'Mandya', score: 1980, referrals: 29, issuesSolved: 30, position: PartyPosition.member),
];



class _Board extends StatelessWidget {
  final List<_LeaderboardEntry> entries;
  const _Board({required this.entries});

  Color _positionColor(PartyPosition p) => switch (p) {
        PartyPosition.member                  => AppColors.rankVolunteer,
        PartyPosition.boothCommitteeMember    => AppColors.rankBoothLead,
        PartyPosition.boothPresident          => AppColors.rankWardLead,
        PartyPosition.mandalPresident         => AppColors.rankTalukLead,
        PartyPosition.blockTalukPresident     => AppColors.rankTalukLead,
        PartyPosition.constituencyIncharge    => AppColors.rankDistLead,
        PartyPosition.districtMorchaHead      => AppColors.rankDistLead,
        PartyPosition.districtSecretary       => AppColors.rankDistLead,
        PartyPosition.districtGeneralSecretary => AppColors.rankDistLead,
        PartyPosition.districtPresident       => AppColors.rankDistLead,
        _                                     => AppColors.rankState,
      };

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const Center(
        child: Text('No data for your district yet',
            style: TextStyle(color: AppColors.textSecondary)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.md),
      itemCount: entries.length,
      itemBuilder: (_, i) {
        final e = entries[i];
        final isTop3 = e.rank <= 3;
        return Container(
          margin: const EdgeInsets.only(bottom: AppSizes.sm),
          padding: const EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            color: isTop3
                ? AppColors.accent.withOpacity(0.08)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: isTop3
                ? Border.all(
                    color: AppColors.accent.withOpacity(0.4))
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              // Rank number
              SizedBox(
                width: 36,
                child: Text(
                  isTop3
                      ? ['🥇', '🥈', '🥉'][e.rank - 1]
                      : '#${e.rank}',
                  style: TextStyle(
                    fontSize: isTop3 ? 22 : 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              // Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: _positionColor(e.position).withOpacity(0.2),
                child: Text(
                  e.name[0],
                  style: TextStyle(
                    color: _positionColor(e.position),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              // Name + district
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14)),
                    Text(e.district,
                        style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11)),
                  ],
                ),
              ),
              // Score
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${e.score}',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: isTop3 ? AppColors.primary : AppColors.textPrimary,
                      )),
                  const Text('pts',
                      style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
