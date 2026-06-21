import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/locale_extensions.dart';
import '../../../auth/domain/entities/app_user.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final isPublic = user == null || user.role == UserRole.public;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(isPublic, user),
      body: isPublic ? _PublicBody(user: user) : _MemberBody(user: user!),
      bottomNavigationBar: _buildNav(isPublic),
    );
  }

  AppBar _buildAppBar(bool isPublic, AppUser? user) {
    return AppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accent.withOpacity(0.2),
              border: Border.all(
                  color: AppColors.accent.withOpacity(0.5), width: 1.5),
            ),
            child: const Icon(Icons.shield, size: 20, color: AppColors.accent),
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Yuva Bharata Sena',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3),
              ),
              Text(
                'ಯುವ ಭಾರತ ಸೇನಾ',
                style: TextStyle(
                    fontSize: 10,
                    color: AppColors.accent,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
            icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
      ],
    );
  }

  NavigationBar _buildNav(bool isPublic) {
    if (isPublic) {
      return NavigationBar(
        selectedIndex: _navIndex,
        backgroundColor: Colors.white,
        indicatorColor: AppColors.primary.withOpacity(0.12),
        onDestinationSelected: (i) {
          setState(() => _navIndex = i);
          switch (i) {
            case 1:
              context.push(AppStrings.routeIssuesList);
            case 2:
              context.push(AppStrings.routeLeaders);
            case 3:
              context.push(AppStrings.routeProfile);
          }
        },
        destinations: [
          NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: context.isKn ? 'ಮನೆ' : 'Home'),
          NavigationDestination(
              icon: const Icon(Icons.campaign_outlined),
              selectedIcon: const Icon(Icons.campaign),
              label: context.isKn ? 'ನನ್ನ ಸಮಸ್ಯೆ' : 'My Issues'),
          NavigationDestination(
              icon: const Icon(Icons.people_outlined),
              selectedIcon: const Icon(Icons.people),
              label: context.isKn ? 'ನಾಯಕರು' : 'Leaders'),
          NavigationDestination(
              icon: const Icon(Icons.person_outlined),
              selectedIcon: const Icon(Icons.person),
              label: context.isKn ? 'ಪ್ರೊಫೈಲ್' : 'Profile'),
        ],
      );
    }
    return NavigationBar(
      selectedIndex: _navIndex,
      backgroundColor: Colors.white,
      indicatorColor: AppColors.primary.withOpacity(0.12),
      onDestinationSelected: (i) {
        setState(() => _navIndex = i);
        switch (i) {
          case 1:
            context.push(AppStrings.routeFeed);
          case 2:
            context.push(AppStrings.routeLeaderboard);
          case 3:
            context.push(AppStrings.routeProfile);
        }
      },
      destinations: [
        NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: context.isKn ? 'ಮನೆ' : 'Home'),
        NavigationDestination(
            icon: const Icon(Icons.article_outlined),
            selectedIcon: const Icon(Icons.article),
            label: context.isKn ? 'ಫೀಡ್' : 'Feed'),
        NavigationDestination(
            icon: const Icon(Icons.leaderboard_outlined),
            selectedIcon: const Icon(Icons.leaderboard),
            label: context.isKn ? 'ಪಕ್ಷ' : 'Cadre'),
        NavigationDestination(
            icon: const Icon(Icons.person_outlined),
            selectedIcon: const Icon(Icons.person),
            label: context.isKn ? 'ಪ್ರೊಫೈಲ್' : 'Profile'),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  PUBLIC / CITIZEN HOME
// ═══════════════════════════════════════════════════════════════════════════

class _PublicBody extends StatelessWidget {
  final AppUser? user;
  const _PublicBody({this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero banner
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.isKn
                      ? 'ಸ್ವಾಗತ, ${user?.name ?? 'ನಾಗರಿಕ'}'
                      : 'Welcome, ${user?.name ?? 'Citizen'}',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.80), fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  context.isKn ? 'ನಿಮ್ಮ ಧ್ವನಿ\nಮುಖ್ಯ.' : 'Your Voice\nMatters.',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.isKn ? 'Your Voice Matters.' : 'ನಿಮ್ಮ ಧ್ವನಿ ಮುಖ್ಯ.',
                  style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                if (user?.district != null)
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.white54, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${user!.district} · ${user!.ward}',
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          // BIG Report Button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: GestureDetector(
              onTap: () => context.push(AppStrings.routeReportIssue),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.accent, Color(0xFFFF9500)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.40),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 28, vertical: 22),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.campaign,
                          color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.isKn ? 'ಸಮಸ್ಯೆ ವರದಿ ಮಾಡಿ' : 'REPORT AN ISSUE',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            context.isKn
                                ? 'REPORT AN ISSUE — Leaders will act'
                                : 'ಸಮಸ್ಯೆ ವರದಿ ಮಾಡಿ — ನಾಯಕರು ಕ್ರಮ ತೆಗೆದುಕೊಳ್ಳುತ್ತಾರೆ',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios,
                        color: Colors.white70, size: 18),
                  ],
                ),
              ),
            ),
          ),

          // Quick actions row
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              children: [
                Expanded(
                  child: _PublicActionCard(
                    icon: Icons.track_changes_outlined,
                    label: 'Track My Issues',
                    labelKn: 'ನನ್ನ ಸಮಸ್ಯೆ',
                    color: AppColors.primary,
                    onTap: () =>
                        context.push(AppStrings.routeIssuesList),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PublicActionCard(
                    icon: Icons.people_alt_outlined,
                    label: 'My Leaders',
                    labelKn: 'ನನ್ನ ನಾಯಕರು',
                    color: const Color(0xFF5B4FCF),
                    onTap: () =>
                        context.push(AppStrings.routeLeaders),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PublicActionCard(
                    icon: Icons.event_outlined,
                    label: 'Events',
                    labelKn: 'ಕಾರ್ಯಕ್ರಮ',
                    color: AppColors.success,
                    onTap: () =>
                        context.push(AppStrings.routeEvents),
                  ),
                ),
              ],
            ),
          ),

          // Issue stats
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Row(
              children: [
                _MiniStat(
                  value: '${user?.issuesReported ?? 0}',
                  label: context.isKn ? 'ಸಮಸ್ಯೆ\nದಾಖಲು' : 'Issues Filed',
                  icon: Icons.task_alt_outlined,
                  color: AppColors.accent,
                ),
                const SizedBox(width: 12),
                _MiniStat(
                  value: '${user?.issuesResolved ?? 0}',
                  label: context.isKn ? 'ಪರಿಹೃತ' : 'Resolved',
                  icon: Icons.check_circle_outline,
                  color: AppColors.success,
                ),
                const SizedBox(width: 12),
                _MiniStat(
                  value: '${user?.eventsAttended ?? 0}',
                  label: context.isKn ? 'ಕಾರ್ಯ' : 'Events',
                  icon: Icons.event_outlined,
                  color: AppColors.gold,
                ),
              ],
            ),
          ),

          // Join movement banner
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            child: GestureDetector(
              onTap: () => context.push(AppStrings.routeJoin),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: const NetworkImage(
                        'https://placehold.co/600x120/0F2167/1B3A8C/png'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        AppColors.primary.withOpacity(0.88),
                        BlendMode.srcOver),
                    onError: (_, __) {},
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(Icons.military_tech,
                        color: AppColors.gold, size: 36),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.isKn
                                ? 'ಹೆಚ್ಚಿನ ಪ್ರಭಾವ ಬಯಸುತ್ತೀರಾ?'
                                : 'Want a bigger impact?',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            context.isKn
                                ? 'ಪಕ್ಷ ಸದಸ್ಯನಾಗಿ ಸೇರಿ · ಮೇಲೇರಿ'
                                : 'Join as a Party Member · Rise through ranks',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        context.isKn ? 'ಸೇರಿ →' : 'Join →',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  MEMBER / CADRE HOME
// ═══════════════════════════════════════════════════════════════════════════

/// Qualification thresholds: minimum recruits to apply for the next position.
const _kBoothPresidentThreshold   = 20;
const _kMandalPresidentThreshold   = 50;
const _kTalukPresidentThreshold    = 100;

class _MemberBody extends StatelessWidget {
  final AppUser user;
  const _MemberBody({required this.user});

  String get _positionLabel {
    switch (user.position) {
      case PartyPosition.member:
        return 'Party Member';
      case PartyPosition.boothCommitteeMember:
        return 'Booth Committee Member';
      case PartyPosition.boothPresident:
        return 'Booth President';
      case PartyPosition.mandalPresident:
        return 'Mandal President';
      case PartyPosition.blockTalukPresident:
        return 'Block / Taluk President';
      case PartyPosition.constituencyIncharge:
        return 'Constituency In-charge';
      case PartyPosition.districtMorchaHead:
        return 'District Morcha Head';
      case PartyPosition.districtSecretary:
        return 'District Secretary';
      case PartyPosition.districtGeneralSecretary:
        return 'District General Secretary';
      case PartyPosition.districtPresident:
        return 'District President';
      case PartyPosition.stateSecretary:
        return 'State Secretary';
      case PartyPosition.stateTreasurer:
        return 'State Treasurer';
      case PartyPosition.stateGeneralSecretary:
        return 'General Secretary';
      case PartyPosition.stateOrgGeneralSecretary:
        return 'Gen. Secretary (Org.)';
      case PartyPosition.stateVicePresident:
        return 'State Vice President';
      case PartyPosition.statePresident:
        return 'State President';
    }
  }

  Color get _positionColor {
    switch (user.position) {
      case PartyPosition.member:
        return const Color(0xFF64B5F6); // light blue — base member
      case PartyPosition.boothCommitteeMember:
      case PartyPosition.boothPresident:
      case PartyPosition.mandalPresident:
        return const Color(0xFFCD7F32); // bronze — grassroots
      case PartyPosition.blockTalukPresident:
      case PartyPosition.constituencyIncharge:
        return const Color(0xFF00BCD4); // teal — taluk/constituency
      case PartyPosition.districtMorchaHead:
      case PartyPosition.districtSecretary:
      case PartyPosition.districtGeneralSecretary:
      case PartyPosition.districtPresident:
        return const Color(0xFF9B59B6); // purple — district
      case PartyPosition.stateSecretary:
      case PartyPosition.stateTreasurer:
      case PartyPosition.stateGeneralSecretary:
      case PartyPosition.stateOrgGeneralSecretary:
      case PartyPosition.stateVicePresident:
      case PartyPosition.statePresident:
        return AppColors.gold; // gold — state level
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // ── Hero card ─────────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryDark, AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name row
                Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _positionColor.withOpacity(0.2),
                        border: Border.all(color: _positionColor, width: 2.5),
                      ),
                      child: Center(
                        child: Text(
                          user.name.isNotEmpty
                              ? user.name[0].toUpperCase()
                              : 'K',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: _positionColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined,
                                  color: Colors.white54, size: 13),
                              const SizedBox(width: 3),
                              Flexible(
                                child: Text(
                                  '${user.ward} · ${user.district}',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white54, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accent.withOpacity(0.15),
                        border: Border.all(
                            color: AppColors.accent.withOpacity(0.5)),
                      ),
                      child: const Center(
                        child: Icon(Icons.shield_outlined,
                            color: AppColors.accent, size: 22),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Position / progression card
                user.position == PartyPosition.member
                    ? _MemberProgressCard(user: user)
                    : _AssignedPositionCard(
                        positionLabel: _positionLabel,
                        positionColor: _positionColor,
                        taluk: user.taluk,
                        ward: user.ward,
                        district: user.district,
                        status: user.positionStatus,
                      ),
              ],
            ),
          ),

          // ── Stats panel ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _StripStat(
                    value: '${user.referralCount}',
                    label: context.isKn ? 'ಸದಸ್ಯರ\nನೇಮಕ' : 'Members\nRecruited',
                    icon: Icons.group_add_outlined,
                    valueColor: AppColors.accent,
                  ),
                  _Divider(),
                  _StripStat(
                    value: '${user.issuesReported}',
                    label: context.isKn ? 'ಸಮಸ್ಯೆ\nವರದಿ' : 'Issues\nRaised',
                    icon: Icons.campaign_outlined,
                    valueColor: AppColors.primary,
                  ),
                  _Divider(),
                  _StripStat(
                    value: '${user.eventsAttended}',
                    label: context.isKn ? 'ಕಾರ್ಯ\nಭಾಗ' : 'Events\nAttended',
                    icon: Icons.event_outlined,
                    valueColor: AppColors.success,
                  ),
                  _Divider(),
                  _StripStat(
                    value: '${user.badges.length}',
                    label: context.isKn ? 'ಬ್ಯಾಡ್ಜ್\nಗಳಿಸಿ' : 'Badges\nEarned',
                    icon: Icons.badge_outlined,
                    valueColor: AppColors.gold,
                  ),
                ],
              ),
            ),
          ),

          // ── Mission tiles ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      context.isKn ? 'ನಿಮ್ಮ ಸೇವೆ' : 'YOUR MISSION',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.9,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _MissionListItem(
                        icon: Icons.person_add_alt_1_rounded,
                        iconColor: AppColors.accent,
                        title: context.isKn ? 'ಸದಸ್ಯ ಸೇರಿಸಿ' : 'Recruit Member',
                        subtitle: context.isKn
                            ? 'ನಿಮ್ಮ ವಾರ್ಡ್ ತಂಡವನ್ನು ಬೆಳೆಸಿ'
                            : 'Grow your ward team',
                        isFirst: true,
                        onTap: () => context.push(AppStrings.routeJoin),
                      ),
                      _MissionListItem(
                        icon: Icons.campaign_rounded,
                        iconColor: AppColors.primary,
                        title: context.isKn ? 'ಸಮಸ್ಯೆ ವರದಿ' : 'Report Issue',
                        subtitle: context.isKn
                            ? 'ಸ್ಥಳೀಯ ಸಮಸ್ಯೆಗಳನ್ನು ಶೀಘ್ರ ವರದಿ ಮಾಡಿ'
                            : 'Raise local problems fast',
                        onTap: () => context.push(AppStrings.routeReportIssue),
                      ),
                      _MissionListItem(
                        icon: Icons.event_rounded,
                        iconColor: const Color(0xFF5B4FCF),
                        title: context.isKn ? 'ಕಾರ್ಯಕ್ರಮಗಳು' : 'Party Events',
                        subtitle: context.isKn
                            ? 'ಸಭೆ, ರ್ಯಾಲಿ ಮತ್ತು ಕಾರ್ಯಕ್ರಮ ವೀಕ್ಷಿಸಿ'
                            : 'See meetings, rallies and upcoming events',
                        onTap: () => context.push(AppStrings.routeEvents),
                      ),
                      _MissionListItem(
                        icon: Icons.people_rounded,
                        iconColor: AppColors.success,
                        title: context.isKn ? 'ನಾಯಕರು' : 'View Leaders',
                        subtitle: context.isKn
                            ? 'ನಿಮ್ಮ ಪಕ್ಷದ ನಾಯಕರನ್ನು ನೋಡಿ'
                            : 'Know your party heads',
                        isLast: true,
                        onTap: () => context.push(AppStrings.routeLeaders),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Party Updates header ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      context.isKn ? 'ಪಕ್ಷ ಸುದ್ದಿ' : 'PARTY UPDATES',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.9,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => context.push(AppStrings.routeFeed),
                  child: Text(
                    context.isKn ? 'ಎಲ್ಲ ನೋಡಿ →' : 'See All →',
                    style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            child: Column(
              children: [
                _UpdateCard(
                  tag: 'Announcement',
                  tagColor: AppColors.accent,
                  title: 'Ward meeting in Hebbal — Sunday 10AM',
                  time: '2 hours ago',
                ),
                const SizedBox(height: 10),
                _UpdateCard(
                  tag: 'Achievement',
                  tagColor: AppColors.success,
                  title: '500 issues resolved this month across Karnataka',
                  time: 'Yesterday',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  Sub-widgets
// ═══════════════════════════════════════════════════════════════════════════

class _PublicActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String labelKn;
  final Color color;
  final VoidCallback onTap;

  const _PublicActionCard({
    required this.icon,
    required this.label,
    required this.labelKn,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.09),
          borderRadius: BorderRadius.circular(14),
          border:
              Border.all(color: color.withOpacity(0.18)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(
              context.isKn ? labelKn : label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 11),
            ),
            Text(
              context.isKn ? label : labelKn,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: color.withOpacity(0.65), fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _MiniStat({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w900,
                  fontSize: 20),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Position widgets ────────────────────────────────────────────────────────

/// Shown for [PartyPosition.member]: progress bar toward first nomination.
class _MemberProgressCard extends StatelessWidget {
  final AppUser user;
  const _MemberProgressCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final recruited = user.referralCount;
    final threshold = _kBoothPresidentThreshold;
    final progress = (recruited / threshold).clamp(0.0, 1.0);
    final eligible = recruited >= threshold;
    final nominationPending =
        user.positionStatus == PositionStatus.pendingAssignment;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: nominationPending
          // ── Nomination submitted view ──────────────────────────────
          ? Row(
              children: [
                const Icon(Icons.hourglass_top_rounded,
                    color: Color(0xFFFFD54F), size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.isKn ? 'ನಾಮಿನೇಷನ್ ಸಲ್ಲಿಸಲಾಗಿದೆ' : 'NOMINATION SUBMITTED',
                        style: const TextStyle(
                          color: Color(0xFFFFD54F),
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        context.isKn
                            ? 'ನಿಮ್ಮ ಬೂತ್ ಅಧ್ಯಕ್ಷ ನಾಮಿನೇಷನ್ ಪಕ್ಷದಲ್ಲಿದೆ. ಪರಿಶೀಲಿಸಿದ ನಂತರ ತಿಳಿಸಲಾಗುವುದು.'
                            : 'Your Booth President nomination is with the party. You will be notified once reviewed.',
                        style: const TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            )
          // ── Progress view ──────────────────────────────────────────
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Member badge row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF64B5F6).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: const Color(0xFF64B5F6).withOpacity(0.5)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.verified_user_outlined,
                              color: Color(0xFF64B5F6), size: 13),
                          const SizedBox(width: 5),
                          Text(
                            context.isKn ? 'ಪಕ್ಷ ಸದಸ್ಯ' : 'PARTY MEMBER',
                            style: const TextStyle(
                              color: Color(0xFF64B5F6),
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Yuva Bharata Sena',
                      style: TextStyle(
                          color: Colors.white38, fontSize: 10),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                const Divider(color: Colors.white12, height: 1),
                const SizedBox(height: 14),

                // Path header
                Text(
                  context.isKn ? 'ನಾಯಕತ್ವದ ಹಾದಿ' : 'YOUR PATH TO LEADERSHIP',
                  style: const TextStyle(
                    color: Colors.white38,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 10),

                // Next position
                Row(
                  children: [
                    const Icon(Icons.emoji_events_outlined,
                        color: Color(0xFFCD7F32), size: 18),
                    const SizedBox(width: 8),
                    Text(
                      context.isKn ? 'ಬೂತ್ ಅಧ್ಯಕ್ಷ' : 'Booth President',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      context.isKn
                          ? '$recruited / $threshold ಸದಸ್ಯರು'
                          : '$recruited / $threshold members',
                      style: const TextStyle(
                          color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: Colors.white.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      eligible
                          ? const Color(0xFFCD7F32)
                          : const Color(0xFF64B5F6),
                    ),
                  ),
                ),

                const SizedBox(height: 6),
                Text(
                  eligible
                      ? (context.isKn ? 'ಅರ್ಹರಿದ್ದೀರಿ! ನಾಮಿನೇಷನ್ ಸಲ್ಲಿಸಿ.' : 'You qualify! Submit your nomination below.')
                      : (context.isKn
                          ? 'ಅರ್ಹತೆಗಾಗಿ ಇನ್ನಂ ${threshold - recruited} ಸದಸ್ಯರನ್ನು ಸೇರಿಸಿ.'
                          : 'Recruit ${threshold - recruited} more members from your ward to qualify.'),
                  style: TextStyle(
                    color: eligible
                        ? const Color(0xFFCD7F32)
                        : Colors.white38,
                    fontSize: 11,
                  ),
                ),

                const SizedBox(height: 14),

                // Apply button
                GestureDetector(
                  onTap: eligible ? () {} : null,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: eligible
                          ? const Color(0xFFCD7F32)
                          : Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: eligible
                          ? null
                          : Border.all(color: Colors.white12),
                    ),
                    child: Text(
                      eligible
                          ? (context.isKn ? 'ನಾಮಿನೇಷನ್ ಸಲ್ಲಿಸಿ →' : 'Apply for Nomination →')
                          : (context.isKn ? 'ನಾಮಿನೇಷನ್ (ಲಾಕ್)' : 'Apply for Nomination (locked)'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: eligible
                            ? Colors.white
                            : Colors.white30,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _AssignedPositionCard extends StatelessWidget {
  final String positionLabel;
  final Color positionColor;
  final String taluk;
  final String ward;
  final String district;
  final PositionStatus status;

  const _AssignedPositionCard({
    required this.positionLabel,
    required this.positionColor,
    required this.taluk,
    required this.ward,
    required this.district,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: positionColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: positionColor.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.military_tech, color: positionColor, size: 20),
              const SizedBox(width: 8),
              Text(
                positionLabel.toUpperCase(),
                style: TextStyle(
                  color: positionColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  letterSpacing: 0.6,
                ),
              ),
              const Spacer(),
              if (status == PositionStatus.active)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: AppColors.success.withOpacity(0.5)),
                  ),
                  child: Builder(builder: (ctx) => Text(
                    ctx.isKn ? 'ಸಕ್ರಿಯ' : 'ACTIVE',
                    style: const TextStyle(
                      color: AppColors.success,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                      letterSpacing: 0.8,
                    ),
                  )),
                ),
            ],
          ),
          if (ward.isNotEmpty || taluk.isNotEmpty || district.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Divider(color: Colors.white12, height: 1),
            const SizedBox(height: 10),
            _GeoRow(icon: Icons.location_city_outlined, label: ward),
            if (taluk.isNotEmpty) _GeoRow(icon: Icons.map_outlined, label: '$taluk Taluk'),
            if (district.isNotEmpty)
              _GeoRow(icon: Icons.domain_outlined, label: '$district District'),
          ],
        ],
      ),
    );
  }
}

class _GeoRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _GeoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Icon(icon, color: Colors.white38, size: 13),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _StripStat extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color valueColor;

  const _StripStat(
      {required this.value,
      required this.label,
      required this.icon,
      required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: valueColor.withOpacity(0.75), size: 18),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
                color: valueColor,
                fontWeight: FontWeight.w900,
                fontSize: 20),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 9),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1,
        height: 40,
        color: AppColors.surfaceVariant);
  }
}

class _MissionListItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;

  const _MissionListItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.isFirst = false,
    this.isLast = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.vertical(
            top: isFirst ? const Radius.circular(16) : Radius.zero,
            bottom: isLast ? const Radius.circular(16) : Radius.zero,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 21),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textHint, size: 20),
              ],
            ),
          ),
        ),
        if (!isLast)
          const Divider(height: 1, indent: 70, endIndent: 16),
      ],
    );
  }
}

class _UpdateCard extends StatelessWidget {
  final String tag;
  final Color tagColor;
  final String title;
  final String time;

  const _UpdateCard({
    required this.tag,
    required this.tagColor,
    required this.title,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: tagColor.withOpacity(0.14)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: tagColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: tagColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                        color: tagColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: const TextStyle(
                      color: AppColors.textHint, fontSize: 11),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right,
              color: AppColors.textHint, size: 18),
        ],
      ),
    );
  }
}
