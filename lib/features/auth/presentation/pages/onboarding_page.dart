import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/locale_extensions.dart';
import '../providers/auth_provider.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  Future<void> _proceed(bool isMember) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppStrings.prefOnboarded, true);
    ref.read(pendingMemberProvider.notifier).state = isMember;
    if (mounted) context.go(AppStrings.routePhone);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentPage == 2;
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _currentPage = i),
              children: [
                _SlideOne(),
                _SlideTwo(),
                _SlideThree(
                  onCitizen: () => _proceed(false),
                  onMember: () => _proceed(true),
                ),
              ],
            ),
          ),
          // Dots
          _DotsIndicator(count: 3, current: _currentPage),
          const SizedBox(height: 16),
          if (!isLast)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => _proceed(false),
                    child: Text(
                      context.isKn ? 'ಬಿಡಿ' : 'Skip',
                      style: const TextStyle(color: Colors.white54, fontSize: 15),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 36, vertical: 14),
                      elevation: 0,
                    ),
                    onPressed: () => _pageController.nextPage(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                    ),
                    child: Text(
                      context.isKn ? 'ಮುಂದೆ  →' : 'Next  →',
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 15),
                    ),
                  ),
                ],
              ),
            )
          else
            const SizedBox(height: 8),
          const SizedBox(height: 28),
        ],
      ),
    );
  }
}

// ─── Slide 1: Rise for Karnataka ────────────────────────────────────────────

class _SlideOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            const Spacer(),
            Text(
              '01',
              style: TextStyle(
                fontSize: 96,
                fontWeight: FontWeight.w900,
                color: Colors.white.withOpacity(0.05),
                height: 1,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withOpacity(0.12),
                border: Border.all(
                    color: AppColors.accent.withOpacity(0.4), width: 2),
              ),
              child: const Icon(Icons.shield,
                  size: 64, color: AppColors.accent),
            ),
            const SizedBox(height: 32),
            Text(
              context.isKn ? 'ಕರ್ನಾಟಕಕ್ಕಾಗಿ\nಏಳಿ' : 'RISE FOR\nKARNATAKA',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 2,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              context.isKn ? 'RISE FOR KARNATAKA' : 'ಕರ್ನಾಟಕಕ್ಕಾಗಿ ಏಳಿ',
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              context.isKn
                  ? 'ಪ್ರತಿ ಬೂತ್‌ನಿಂದ ರಾಜ್ಯ ರಾಜಧಾನಿಯವರೆಗೆ — ಒಂದೊಂದು ಧ್ವನಿಯಿಂದ ಪ್ರಾಮಾಣಿಕ ನಾಯಕತ್ವ ನಿರ್ಮಿಸೋಣ.'
                  : 'Building honest leadership from every booth to the state capital — one voice at a time.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white.withOpacity(0.70),
                height: 1.7,
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

// ─── Slide 2: Your Voice. Their Action. ─────────────────────────────────────

class _SlideTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            const Spacer(),
            Text(
              '02',
              style: TextStyle(
                fontSize: 96,
                fontWeight: FontWeight.w900,
                color: Colors.white.withOpacity(0.05),
                height: 1,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.gold.withOpacity(0.12),
                border: Border.all(
                    color: AppColors.gold.withOpacity(0.4), width: 2),
              ),
              child: const Icon(Icons.campaign,
                  size: 64, color: AppColors.gold),
            ),
            const SizedBox(height: 32),
            Text(
              context.isKn ? 'ನಿಮ್ಮ ಧ್ವನಿ.\nಅವರ ಕ್ರಿಯೆ.' : 'YOUR VOICE.\nTHEIR ACTION.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1.5,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              context.isKn ? 'YOUR VOICE. THEIR ACTION.' : 'ನಿಮ್ಮ ಧ್ವನಿ. ಅವರ ಕ್ರಿಯೆ.',
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.gold,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              context.isKn
                  ? 'ರಸ್ತೆ, ನೀರು, ಆಸ್ಪತ್ರೆ ಮತ್ತು ಶಾಲೆ ಸಮಸ್ಯೆಗಳನ್ನು ಫೋಟೋಗಳೊಂದಿಗೆ ವರದಿ ಮಾಡಿ. ನಿಮ್ಮ ಸ್ಥಳೀಯ ನಾಯಕರು ತ್ವರಿತವಾಗಿ ಸ್ಪಂದಿಸುತ್ತಾರೆ.'
                  : 'Report road, water, hospital and school problems with photos. Your local leaders respond fast.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white.withOpacity(0.70),
                height: 1.7,
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

// ─── Slide 3: Choose Your Role ───────────────────────────────────────────────

class _SlideThree extends StatelessWidget {
  final VoidCallback onCitizen;
  final VoidCallback onMember;

  const _SlideThree({required this.onCitizen, required this.onMember});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const Spacer(),
            Text(
              '03',
              style: TextStyle(
                fontSize: 96,
                fontWeight: FontWeight.w900,
                color: Colors.white.withOpacity(0.05),
                height: 1,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent,
              ),
              child: const Icon(Icons.diversity_3,
                  size: 48, color: Colors.white),
            ),
            const SizedBox(height: 24),
            Text(
              context.isKn ? 'ಕರ್ನಾಟಕಕ್ಕೆ ಹೇಗೆ\nಸೇವೆ ಸಲ್ಲಿಸುತ್ತೀರಿ?' : 'HOW WILL YOU\nSERVE KARNATAKA?',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1.5,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              context.isKn ? 'HOW WILL YOU SERVE KARNATAKA?' : 'ಕರ್ನಾಟಕಕ್ಕೆ ಹೇಗೆ ಸೇವೆ ಸಲ್ಲಿಸುತ್ತೀರಿ?',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.accent,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            // Citizen card
            _ChoiceCard(
              icon: Icons.record_voice_over_outlined,
              title: "I'm a Citizen",
              titleKn: 'ನಾಗರಿಕ',
              subtitle: 'Report issues & hold leaders accountable',
              subtitleKn: 'ಸಮಸ್ಯೆ ವರದಿ · ನಾಯಕರ ಜವಾಬ್ದಾರಿ',
              isPrimary: false,
              onTap: onCitizen,
            ),
            const SizedBox(height: 14),
            // Member card
            _ChoiceCard(
              icon: Icons.military_tech,
              title: "I'm a Party Member",
              titleKn: 'ಪಕ್ಷದ ಸದಸ್ಯ',
              subtitle: 'Join the cadre · Build the movement · Rise in rank',
              subtitleKn: 'ದಳ ಸೇರಿ · ಚಳವಳಿ ಕಟ್ಟಿ · ಮೇಲೇರಿ',
              isPrimary: true,
              onTap: onMember,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ─── Choice Card ─────────────────────────────────────────────────────────────

class _ChoiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String titleKn;
  final String subtitle;
  final String subtitleKn;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ChoiceCard({
    required this.icon,
    required this.title,
    required this.titleKn,
    required this.subtitle,
    required this.subtitleKn,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isKn = context.isKn;
    final primaryTitle = isKn ? titleKn : title;
    final secondaryTitle = isKn ? title : titleKn;
    final displaySubtitle = isKn ? subtitleKn : subtitle;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.accent : Colors.transparent,
          border: Border.all(
            color: isPrimary
                ? AppColors.accent
                : Colors.white.withOpacity(0.35),
            width: isPrimary ? 0 : 1.5,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.15),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        primaryTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '· $secondaryTitle',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.65),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    displaySubtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.80),
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }
}

// ─── Dots Indicator ──────────────────────────────────────────────────────────

class _DotsIndicator extends StatelessWidget {
  final int count;
  final int current;

  const _DotsIndicator({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: current == i ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: current == i
                ? AppColors.accent
                : Colors.white.withOpacity(0.30),
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    );
  }
}
