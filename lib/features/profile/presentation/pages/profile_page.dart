import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/locale_extensions.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/widgets/kvs_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/domain/entities/app_user.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final locale = ref.watch(localeProvider);
    final isKn = context.isKn;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App bar with gradient
          SliverAppBar(
            expandedHeight: 220,
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
                      backgroundColor: Colors.white.withOpacity(0.25),
                      backgroundImage: user.photoUrl != null
                          ? NetworkImage(user.photoUrl!)
                          : null,
                      child: user.photoUrl == null
                          ? Text(
                              user.name.isNotEmpty
                                  ? user.name[0].toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      isKn ? _positionLabelKn(user.position) : _positionLabel(user.position),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {},
              ),
            ],
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
                      _Stat(label: isKn ? 'ನೇಮಕ' : 'Referrals', value: '${user.referralCount}', color: AppColors.primary),
                      const SizedBox(width: AppSizes.sm),
                      _Stat(label: isKn ? 'ಸಮಸ್ಯೆ' : 'Issues', value: '${user.issuesReported}', color: AppColors.secondary),
                      const SizedBox(width: AppSizes.sm),
                      _Stat(label: isKn ? 'ಕಾರ್ಯ' : 'Events', value: '${user.eventsAttended}', color: AppColors.info),
                    ],
                  ),
                  const SizedBox(height: AppSizes.lg),

                  // Party position
                  _PositionBadge(user: user),
                  const SizedBox(height: AppSizes.lg),

                  // Info section
                  _SectionTitle(isKn ? 'ಪ್ರೊಫೈಲ್ ಮಾಹಿತಿ' : 'Profile Info'),
                  const SizedBox(height: AppSizes.sm),
                  _InfoCard(items: [
                    _InfoItem(Icons.phone_outlined, isKn ? 'ಮೊಬೈಲ್' : 'Phone', user.phone),
                    _InfoItem(Icons.location_city_outlined, isKn ? 'ಜಿಲ್ಲೆ' : 'District', user.district),
                    if (user.taluk.isNotEmpty)
                      _InfoItem(Icons.map_outlined, isKn ? 'ತಾಲ್ಲೂಕು' : 'Taluk', user.taluk),
                    if (user.ward.isNotEmpty)
                      _InfoItem(Icons.home_outlined, isKn ? 'ವಾರ್ಡ್' : 'Ward', user.ward),
                    _InfoItem(Icons.card_giftcard_outlined, isKn ? 'ರೆಫರಲ್ ಕೋಡ್' : 'Referral Code', user.referralCode),
                  ]),
                  const SizedBox(height: AppSizes.lg),

                  // Badges
                  _SectionTitle(isKn ? 'ಬ್ಯಾಡ್ಜ್ & ಸಾಧನೆ' : 'Badges & Achievements'),
                  const SizedBox(height: AppSizes.sm),
                  user.badges.isEmpty
                      ? Text(
                          isKn
                              ? 'ಇನ್ನೂ ಬ್ಯಾಡ್ಜ್ ಇಲ್ಲ. ಕೊಡುಗೆ ಮುಂದುವರಿಸಿ!'
                              : 'No badges yet. Keep contributing!',
                          style: const TextStyle(color: AppColors.textSecondary))
                      : Wrap(
                          spacing: AppSizes.sm,
                          runSpacing: AppSizes.sm,
                          children: user.badges
                              .map((b) => _BadgeChip(label: b))
                              .toList(),
                        ),
                  const SizedBox(height: AppSizes.lg),

                  // Language toggle
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.md, vertical: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.language,
                            color: AppColors.primary, size: 22),
                        const SizedBox(width: AppSizes.sm),
                        Text(
                          isKn ? 'ಭಾಷೆ / Language' : 'Language / ಭಾಷೆ',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                        const Spacer(),
                        SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(
                                value: 'kn', label: Text('ಕನ್ನಡ')),
                            ButtonSegment(
                                value: 'en', label: Text('En')),
                          ],
                          selected: {locale.languageCode},
                          onSelectionChanged: (values) {
                            ref.read(localeProvider.notifier).state =
                                Locale(values.first);
                          },
                          style: const ButtonStyle(
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.xl),

                  // Sign out
                  KvsButton(
                    label: isKn ? 'ಹೊರಗೆ ಹೋಗಿ' : 'Sign Out',
                    variant: KvsButtonVariant.outlined,
                    icon: Icons.logout,
                    onPressed: () =>
                        ref.read(authProvider.notifier).signOut(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _positionLabel(PartyPosition p) => switch (p) {
        PartyPosition.member                   => 'Party Member',
        PartyPosition.boothCommitteeMember     => 'Booth Committee Member',
        PartyPosition.boothPresident           => 'Booth President',
        PartyPosition.mandalPresident          => 'Mandal President',
        PartyPosition.blockTalukPresident      => 'Block / Taluk President',
        PartyPosition.constituencyIncharge     => 'Constituency In-charge',
        PartyPosition.districtMorchaHead       => 'District Morcha Head',
        PartyPosition.districtSecretary        => 'District Secretary',
        PartyPosition.districtGeneralSecretary => 'District General Secretary',
        PartyPosition.districtPresident        => 'District President',
        PartyPosition.stateSecretary           => 'State Secretary',
        PartyPosition.stateTreasurer           => 'State Treasurer',
        PartyPosition.stateGeneralSecretary    => 'General Secretary',
        PartyPosition.stateOrgGeneralSecretary => 'Gen. Secretary (Org.)',
        PartyPosition.stateVicePresident       => 'State Vice President',
        PartyPosition.statePresident           => 'State President',
      };

  String _positionLabelKn(PartyPosition p) => switch (p) {
        PartyPosition.member                   => 'ಪಕ್ಷ ಸದಸ್ಯ',
        PartyPosition.boothCommitteeMember     => 'ಬೂತ್ ಸಮಿತಿ ಸದಸ್ಯ',
        PartyPosition.boothPresident           => 'ಬೂತ್ ಅಧ್ಯಕ್ಷ',
        PartyPosition.mandalPresident          => 'ಮಂಡಲ ಅಧ್ಯಕ್ಷ',
        PartyPosition.blockTalukPresident      => 'ಬ್ಲಾಕ್ / ತಾಲ್ಲೂಕು ಅಧ್ಯಕ್ಷ',
        PartyPosition.constituencyIncharge     => 'ಕ್ಷೇತ್ರ ಉಸ್ತುವಾರಿ',
        PartyPosition.districtMorchaHead       => 'ಜಿಲ್ಲಾ ಮೋರ್ಚಾ ಮುಖ್ಯಸ್ಥ',
        PartyPosition.districtSecretary        => 'ಜಿಲ್ಲಾ ಕಾರ್ಯದರ್ಶಿ',
        PartyPosition.districtGeneralSecretary => 'ಜಿಲ್ಲಾ ಪ್ರಧಾನ ಕಾರ್ಯದರ್ಶಿ',
        PartyPosition.districtPresident        => 'ಜಿಲ್ಲಾ ಅಧ್ಯಕ್ಷ',
        PartyPosition.stateSecretary           => 'ರಾಜ್ಯ ಕಾರ್ಯದರ್ಶಿ',
        PartyPosition.stateTreasurer           => 'ರಾಜ್ಯ ಖಜಾಂಚಿ',
        PartyPosition.stateGeneralSecretary    => 'ಪ್ರಧಾನ ಕಾರ್ಯದರ್ಶಿ',
        PartyPosition.stateOrgGeneralSecretary => 'ಸಂಘಟನಾ ಪ್ರಧಾನ ಕಾರ್ಯದರ್ಶಿ',
        PartyPosition.stateVicePresident       => 'ರಾಜ್ಯ ಉಪಾಧ್ಯಕ್ಷ',
        PartyPosition.statePresident           => 'ರಾಜ್ಯ ಅಧ್ಯಕ್ಷ',
      };
}

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _Stat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          child: Column(
            children: [
              Text(value,
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w800, color: color)),
              Text(label,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textSecondary)),
            ],
          ),
        ),
      );
}

class _PositionBadge extends StatelessWidget {
  final AppUser user;
  const _PositionBadge({required this.user});

  String _positionLabel(PartyPosition p) => switch (p) {
        PartyPosition.member                   => 'Party Member',
        PartyPosition.boothCommitteeMember     => 'Booth Committee Member',
        PartyPosition.boothPresident           => 'Booth President',
        PartyPosition.mandalPresident          => 'Mandal President',
        PartyPosition.blockTalukPresident      => 'Block / Taluk President',
        PartyPosition.constituencyIncharge     => 'Constituency In-charge',
        PartyPosition.districtMorchaHead       => 'District Morcha Head',
        PartyPosition.districtSecretary        => 'District Secretary',
        PartyPosition.districtGeneralSecretary => 'District General Secretary',
        PartyPosition.districtPresident        => 'District President',
        PartyPosition.stateSecretary           => 'State Secretary',
        PartyPosition.stateTreasurer           => 'State Treasurer',
        PartyPosition.stateGeneralSecretary    => 'General Secretary',
        PartyPosition.stateOrgGeneralSecretary => 'Gen. Secretary (Org.)',
        PartyPosition.stateVicePresident       => 'State Vice President',
        PartyPosition.statePresident           => 'State President',
      };

  String _positionLabelKn(PartyPosition p) => switch (p) {
        PartyPosition.member                   => 'ಪಕ್ಷ ಸದಸ್ಯ',
        PartyPosition.boothCommitteeMember     => 'ಬೂತ್ ಸಮಿತಿ ಸದಸ್ಯ',
        PartyPosition.boothPresident           => 'ಬೂತ್ ಅಧ್ಯಕ್ಷ',
        PartyPosition.mandalPresident          => 'ಮಂಡಲ ಅಧ್ಯಕ್ಷ',
        PartyPosition.blockTalukPresident      => 'ಬ್ಲಾಕ್ / ತಾಲ್ಲೂಕು ಅಧ್ಯಕ್ಷ',
        PartyPosition.constituencyIncharge     => 'ಕ್ಷೇತ್ರ ಉಸ್ತುವಾರಿ',
        PartyPosition.districtMorchaHead       => 'ಜಿಲ್ಲಾ ಮೋರ್ಚಾ ಮುಖ್ಯಸ್ಥ',
        PartyPosition.districtSecretary        => 'ಜಿಲ್ಲಾ ಕಾರ್ಯದರ್ಶಿ',
        PartyPosition.districtGeneralSecretary => 'ಜಿಲ್ಲಾ ಪ್ರಧಾನ ಕಾರ್ಯದರ್ಶಿ',
        PartyPosition.districtPresident        => 'ಜಿಲ್ಲಾ ಅಧ್ಯಕ್ಷ',
        PartyPosition.stateSecretary           => 'ರಾಜ್ಯ ಕಾರ್ಯದರ್ಶಿ',
        PartyPosition.stateTreasurer           => 'ರಾಜ್ಯ ಖಜಾಂಚಿ',
        PartyPosition.stateGeneralSecretary    => 'ಪ್ರಧಾನ ಕಾರ್ಯದರ್ಶಿ',
        PartyPosition.stateOrgGeneralSecretary => 'ಸಂಘಟನಾ ಪ್ರಧಾನ ಕಾರ್ಯದರ್ಶಿ',
        PartyPosition.stateVicePresident       => 'ರಾಜ್ಯ ಉಪಾಧ್ಯಕ್ಷ',
        PartyPosition.statePresident           => 'ರಾಜ್ಯ ಅಧ್ಯಕ್ಷ',
      };

  @override
  Widget build(BuildContext context) {
    final isKn = context.isKn;
    final isPending = user.positionStatus == PositionStatus.pendingAssignment &&
        user.position != PartyPosition.member;
    final posLabel = isKn ? _positionLabelKn(user.position) : _positionLabel(user.position);

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(
            isPending ? Icons.hourglass_top_rounded : Icons.military_tech,
            color: isPending ? AppColors.textSecondary : AppColors.primary,
            size: 24,
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isPending
                      ? (isKn ? 'ಹುದ್ದೆ ನಿರೀಕ್ಷಿಸಲಾಗಿದೆ' : 'Awaiting Position Assignment')
                      : posLabel,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14),
                ),
                if (!isPending)
                  Text(
                    '${user.ward} · ${user.taluk} · ${user.district}',
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary),
                  )
                else
                  Text(
                    isKn
                        ? 'ಭೌಗೋಳಿಕ ಆಧಾರದ ಮೇಲೆ ಪಕ್ಷ ಹುದ್ದೆ ನೀಡುತ್ತದೆ'
                        : 'The party will assign your position based on geography',
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      );
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;
  const _InfoItem(this.icon, this.label, this.value);
}

class _InfoCard extends StatelessWidget {
  final List<_InfoItem> items;
  const _InfoCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Column(
        children: items.mapIndexed((i, item) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.md, vertical: 12),
              child: Row(
                children: [
                  Icon(item.icon,
                      size: 18, color: AppColors.textSecondary),
                  const SizedBox(width: AppSizes.sm),
                  Text('${item.label}: ',
                      style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13)),
                  Expanded(
                    child: Text(item.value,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                  ),
                ],
              ),
            ),
            if (i < items.length - 1)
              const Divider(height: 1, indent: 16),
          ],
        )).toList(),
      ),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  final String label;
  const _BadgeChip({required this.label});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.accent.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.accent.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.military_tech, size: 14, color: AppColors.accent),
            const SizedBox(width: 4),
            Text(label,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
          ],
        ),
      );
}

extension _IndexedMap<T> on List<T> {
  List<R> mapIndexed<R>(R Function(int i, T e) f) =>
      [for (var i = 0; i < length; i++) f(i, this[i])];
}
