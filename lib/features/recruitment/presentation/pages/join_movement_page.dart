import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/kvs_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class JoinMovementPage extends ConsumerWidget {
  const JoinMovementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final referralCode = user?.referralCode ?? 'KVS-----';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Join the Movement'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.xl),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              ),
              child: Column(
                children: [
                  const Icon(Icons.volunteer_activism,
                      color: Colors.white, size: 48),
                  const SizedBox(height: AppSizes.md),
                  const Text(
                    'Grow the Movement',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  const Text(
                    'Invite friends & earn karma points for every verified member you bring!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.xl),

            // Referral code card
            const Text(
              'Your Referral Code',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Container(
              padding: const EdgeInsets.all(AppSizes.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      referralCode,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 4,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy_outlined,
                        color: AppColors.primary),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: referralCode));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Referral code copied!')),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.md),

            KvsButton(
              label: 'Share Referral Link',
              icon: Icons.share,
              variant: KvsButtonVariant.secondary,
              onPressed: () {
                // TODO: Share plugin
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Sharing: Join KVS with code $referralCode'),
                  ),
                );
              },
            ),

            const SizedBox(height: AppSizes.xl),

            // Stats
            const Text(
              'Your Recruitment Stats',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Row(
              children: [
                _RecruitCard(
                  label: 'Total Referrals',
                  value: '${user?.referralCount ?? 0}',
                  icon: Icons.group_add_outlined,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSizes.md),
                const _RecruitCard(
                  label: 'Points Earned',
                  value: '—',
                  icon: Icons.star_outline,
                  color: AppColors.accent,
                ),
              ],
            ),

            const SizedBox(height: AppSizes.xl),

            // How it works
            const Text(
              'How It Works',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            ...[
              ('Share your referral code with friends', Icons.share_outlined),
              ('They register with your code', Icons.app_registration_outlined),
              ('You earn 50 karma points per verified member', Icons.emoji_events_outlined),
            ].mapIndexed((i, item) => _StepRow(
                  step: i + 1,
                  text: item.$1,
                  icon: item.$2,
                )),
          ],
        ),
      ),
    );
  }
}

class _RecruitCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _RecruitCard({
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
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: color)),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final int step;
  final String text;
  final IconData icon;

  const _StepRow({
    required this.step,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('$step',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }
}

// Simple indexed map helper
extension _IndexedMapExt<T> on List<T> {
  List<R> mapIndexed<R>(R Function(int i, T e) f) {
    return [for (var i = 0; i < length; i++) f(i, this[i])];
  }
}
