import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/locale_extensions.dart';
import '../providers/auth_provider.dart';

// SharedPreferences key for the user's home state
const _kPrefState = 'ybs_selected_state';

// All Indian states and union territories
const _kIndianStates = [
  'Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar',
  'Chhattisgarh', 'Goa', 'Gujarat', 'Haryana',
  'Himachal Pradesh', 'Jharkhand', 'Karnataka', 'Kerala',
  'Madhya Pradesh', 'Maharashtra', 'Manipur', 'Meghalaya',
  'Mizoram', 'Nagaland', 'Odisha', 'Punjab',
  'Rajasthan', 'Sikkim', 'Tamil Nadu', 'Telangana',
  'Tripura', 'Uttar Pradesh', 'Uttarakhand', 'West Bengal',
  'Andaman & Nicobar', 'Chandigarh', 'Dadra & Nagar Haveli',
  'Daman & Diu', 'Delhi', 'Jammu & Kashmir', 'Ladakh',
  'Lakshadweep', 'Puducherry',
];

// State name in each region's native script — shows personalised pride
const _kStateNativeNames = <String, String>{
  'Andhra Pradesh': 'ఆంధ్ర ప్రదేశ్',
  'Arunachal Pradesh': 'अरुणाचल प्रदेश',
  'Assam': 'অসম',
  'Bihar': 'बिहार',
  'Chhattisgarh': 'छत्तीसगढ़',
  'Goa': 'Goa',
  'Gujarat': 'ગુજરાત',
  'Haryana': 'हरियाणा',
  'Himachal Pradesh': 'हिमाचल प्रदेश',
  'Jharkhand': 'झारखंड',
  'Karnataka': 'ಕರ್ನಾಟಕ',
  'Kerala': 'കേരളം',
  'Madhya Pradesh': 'मध्य प्रदेश',
  'Maharashtra': 'महाराष्ट्र',
  'Manipur': 'মণিপুর',
  'Meghalaya': 'Meghalaya',
  'Mizoram': 'Mizoram',
  'Nagaland': 'Nagaland',
  'Odisha': 'ଓଡ଼ିଶା',
  'Punjab': 'ਪੰਜਾਬ',
  'Rajasthan': 'राजस्थान',
  'Sikkim': 'Sikkim',
  'Tamil Nadu': 'தமிழ்நாடு',
  'Telangana': 'తెలంగాణ',
  'Tripura': 'ত্রিপুরা',
  'Uttar Pradesh': 'उत्तर प्रदेश',
  'Uttarakhand': 'उत्तराखंड',
  'West Bengal': 'পশ্চিমবঙ্গ',
  'Andaman & Nicobar': 'अंडमान',
  'Chandigarh': 'ਚੰਡੀਗੜ੍ਹ',
  'Dadra & Nagar Haveli': 'दादरा',
  'Daman & Diu': 'Daman',
  'Delhi': 'दिल्ली',
  'Jammu & Kashmir': 'जम्मू-कश्मीर',
  'Ladakh': 'लद्दाख़',
  'Lakshadweep': 'Lakshadweep',
  'Puducherry': 'புதுச்சேரி',
};

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String _selectedState = '';

  Future<void> _proceed(bool isMember) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppStrings.prefOnboarded, true);
    if (_selectedState.isNotEmpty) {
      await prefs.setString(_kPrefState, _selectedState);
    }
    ref.read(pendingMemberProvider.notifier).state = isMember;
    if (mounted) context.go(AppStrings.routePhone);
  }

  void _onStateSelected(String state) {
    setState(() => _selectedState = state);
    _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentPage == 3;
    final displayState =
        _selectedState.isEmpty ? 'Your State' : _selectedState;
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _currentPage = i),
              children: [
                _SlideZero(
                  onStateSelected: _onStateSelected,
                  selectedState: _selectedState,
                ),
                _SlideOne(state: displayState),
                _SlideTwo(),
                _SlideThree(
                  state: displayState,
                  onCitizen: () => _proceed(false),
                  onMember: () => _proceed(true),
                ),
              ],
            ),
          ),
          // Dots
          _DotsIndicator(count: 4, current: _currentPage),
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
                      style: const TextStyle(
                          color: Colors.white54, fontSize: 15),
                    ),
                  ),
                  // Slide 0 auto-advances on state tap; no manual Next button
                  if (_currentPage > 0)
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
                    )
                  else
                    const SizedBox.shrink(),
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

// ─── Slide 0: Pick Your State ────────────────────────────────────────────────

class _SlideZero extends StatelessWidget {
  final ValueChanged<String> onStateSelected;
  final String selectedState;

  const _SlideZero(
      {required this.onStateSelected, required this.selectedState});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.isKn ? 'ನಿಮ್ಮ\nರಾಜ್ಯ.' : 'YOUR\nSTATE.',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1.5,
                height: 1.05,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              context.isKn
                  ? 'ನಿಮ್ಮ ರಾಜ್ಯವನ್ನು ಆಯ್ಕೆ ಮಾಡಿ — ನಿಮ್ಮ ಚಳವಳಿ ಪ್ರಾರಂಭವಾಗುತ್ತದೆ'
                  : 'Select your home state — your movement starts here',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.55),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 9,
                  crossAxisSpacing: 9,
                  childAspectRatio: 3.4,
                ),
                itemCount: _kIndianStates.length,
                itemBuilder: (_, i) {
                  final state = _kIndianStates[i];
                  final isSelected = state == selectedState;
                  return GestureDetector(
                    onTap: () => onStateSelected(state),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.accent
                            : Colors.white.withOpacity(0.07),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.accent
                              : Colors.white.withOpacity(0.18),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Center(
                        child: Text(
                          state,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withOpacity(0.80),
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Slide 1: Rise for [State] ───────────────────────────────────────────────

class _SlideOne extends StatelessWidget {
  final String state;

  const _SlideOne({required this.state});

  bool get _isKarnataka => state == 'Karnataka';

  @override
  Widget build(BuildContext context) {
    final nativeName = _kStateNativeNames[state] ?? state.toUpperCase();

    // For Karnataka (Kannada locale): show Kannada headline, English accent
    // For all others: show English headline, native script accent
    final headline = (context.isKn && _isKarnataka)
        ? 'ಕರ್ನಾಟಕಕ್ಕಾಗಿ\nಏಳಿ'
        : 'RISE FOR\n${state.toUpperCase()}';
    final accentLine = (context.isKn && _isKarnataka)
        ? 'RISE FOR KARNATAKA'
        : nativeName;
    final body = (context.isKn && _isKarnataka)
        ? 'ಪ್ರತಿ ಬೂತ್‌ನಿಂದ ರಾಜ್ಯ ರಾಜಧಾನಿಯವರೆಗೆ — ಒಂದೊಂದು ಧ್ವನಿಯಿಂದ ಪ್ರಾಮಾಣಿಕ ನಾಯಕತ್ವ ನಿರ್ಮಿಸೋಣ.'
        : 'Building honest leadership from every booth to the state capital — one voice at a time.';

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
              child:
                  const Icon(Icons.shield, size: 64, color: AppColors.accent),
            ),
            const SizedBox(height: 32),
            Text(
              headline,
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
              accentLine,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                color: AppColors.accent,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              body,
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
  final String state;
  final VoidCallback onCitizen;
  final VoidCallback onMember;

  const _SlideThree(
      {required this.state,
      required this.onCitizen,
      required this.onMember});

  bool get _isKarnataka => state == 'Karnataka';

  @override
  Widget build(BuildContext context) {
    final headlineKn = _isKarnataka
        ? 'ಕರ್ನಾಟಕಕ್ಕೆ ಹೇಗೆ\nಸೇವೆ ಸಲ್ಲಿಸುತ್ತೀರಿ?'
        : 'HOW WILL YOU\nSERVE $state?';
    final subKn = _isKarnataka
        ? 'HOW WILL YOU SERVE KARNATAKA?'
        : 'HOW WILL YOU SERVE ${state.toUpperCase()}?';
    final headlineEn = 'HOW WILL YOU\nSERVE ${state.toUpperCase()}?';
    final subEn = _isKarnataka ? 'ಕರ್ನಾಟಕಕ್ಕೆ ಹೇಗೆ ಸೇವೆ ಸಲ್ಲಿಸುತ್ತೀರಿ?' : '';

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
              context.isKn ? headlineKn : headlineEn,
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
            if ((context.isKn ? subKn : subEn).isNotEmpty)
              Text(
                context.isKn ? subKn : subEn,
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
