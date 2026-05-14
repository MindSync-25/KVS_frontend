import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/kvs_button.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../providers/auth_provider.dart';

// Karnataka districts
const _kDistricts = [
  'Bagalkot','Ballari','Belagavi','Bengaluru Rural','Bengaluru Urban',
  'Bidar','Chamarajanagara','Chikkaballapur','Chikkamagaluru','Chitradurga',
  'Dakshina Kannada','Davanagere','Dharwad','Gadag','Hassan','Haveri',
  'Kalaburagi','Kodagu','Kolar','Koppal','Mandya','Mysuru','Raichur',
  'Ramanagara','Shivamogga','Tumakuru','Udupi','Uttara Kannada',
  'Vijayapura','Yadgir',
];

class ProfileSetupPage extends ConsumerStatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  ConsumerState<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends ConsumerState<ProfileSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _wardController = TextEditingController();
  final _referralController = TextEditingController();

  String? _selectedDistrict;
  String _selectedLanguage = 'en';
  int _step = 0; // 0 = name+lang, 1 = location, 2 = referral

  @override
  void dispose() {
    _nameController.dispose();
    _wardController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authProvider.notifier).createProfile(
          name: _nameController.text.trim(),
          district: _selectedDistrict ?? '',
          taluk: '',
          ward: _wardController.text.trim(),
          constituencyId: '',
          language: _selectedLanguage,
          referredBy: _referralController.text.trim().isEmpty
              ? null
              : _referralController.text.trim().toUpperCase(),
        );
    if (mounted) {
      final error = ref.read(authProvider).error;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: AppColors.error,
          ),
        );
      }
      // GoRouter redirect handles navigation on success
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        ref.watch(authProvider).status == AuthStatus.loading;

    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              // Progress bar
              LinearProgressIndicator(
                value: (_step + 1) / 3,
                backgroundColor: AppColors.surfaceVariant,
                color: AppColors.primary,
                minHeight: 4,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSizes.lg),
                        Text(
                          'Step ${_step + 1} of 3',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: AppSizes.sm),
                        ..._buildStep(),
                      ],
                    ),
                  ),
                ),
              ),
              // Navigation buttons
              Padding(
                padding: const EdgeInsets.all(AppSizes.lg),
                child: Row(
                  children: [
                    if (_step > 0)
                      Expanded(
                        child: KvsButton(
                          label: 'Back',
                          variant: KvsButtonVariant.outlined,
                          onPressed: () =>
                              setState(() => _step--),
                        ),
                      ),
                    if (_step > 0) const SizedBox(width: AppSizes.md),
                    Expanded(
                      flex: 2,
                      child: KvsButton(
                        label: _step == 2 ? 'Join Movement' : 'Next',
                        isLoading: isLoading,
                        icon: _step == 2
                            ? Icons.celebration
                            : Icons.arrow_forward,
                        onPressed: () {
                          if (_step < 2) {
                            if (_formKey.currentState!.validate()) {
                              setState(() => _step++);
                            }
                          } else {
                            _submit();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildStep() {
    switch (_step) {
      case 0:
        return [
          const Text(
            'What\'s your name?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          const Text(
            'ನಿಮ್ಮ ಹೆಸರು ಏನು?',
            style: TextStyle(color: AppColors.primary, fontSize: 14),
          ),
          const SizedBox(height: AppSizes.xl),
          TextFormField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            validator: Validators.name,
            decoration: const InputDecoration(
              hintText: 'Your full name',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: AppSizes.xl),
          const Text(
            'Preferred Language',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          Row(
            children: [
              _LanguageTile(
                label: 'English',
                sublabel: 'English',
                selected: _selectedLanguage == 'en',
                onTap: () => setState(() => _selectedLanguage = 'en'),
              ),
              const SizedBox(width: AppSizes.md),
              _LanguageTile(
                label: 'ಕನ್ನಡ',
                sublabel: 'Kannada',
                selected: _selectedLanguage == 'kn',
                onTap: () => setState(() => _selectedLanguage = 'kn'),
              ),
            ],
          ),
        ];

      case 1:
        return [
          const Text(
            'Where are you from?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          const Text(
            'ನಿಮ್ಮ ಸ್ಥಳ ಯಾವುದು?',
            style: TextStyle(color: AppColors.primary, fontSize: 14),
          ),
          const SizedBox(height: AppSizes.xl),
          DropdownButtonFormField<String>(
            value: _selectedDistrict,
            decoration: const InputDecoration(
              hintText: 'Select District',
              prefixIcon: Icon(Icons.location_city_outlined),
            ),
            items: _kDistricts
                .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                .toList(),
            onChanged: (v) => setState(() => _selectedDistrict = v),
            validator: (v) =>
                v == null ? 'Please select your district' : null,
          ),
          const SizedBox(height: AppSizes.md),
          TextFormField(
            controller: _wardController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              hintText: 'Ward / Village / Area (optional)',
              prefixIcon: Icon(Icons.home_outlined),
            ),
          ),
        ];

      case 2:
        return [
          const Text(
            'Do you have a referral code?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          const Text(
            'ರೆಫರಲ್ ಕೋಡ್ ಹೊಂದಿದ್ದೀರಾ?',
            style: TextStyle(color: AppColors.primary, fontSize: 14),
          ),
          const SizedBox(height: AppSizes.xl),
          TextFormField(
            controller: _referralController,
            textCapitalization: TextCapitalization.characters,
            validator: Validators.referralCode,
            decoration: const InputDecoration(
              hintText: 'Referral code (optional)',
              prefixIcon: Icon(Icons.card_giftcard_outlined),
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline,
                    color: AppColors.primary, size: 18),
                SizedBox(width: AppSizes.sm),
                Expanded(
                  child: Text(
                    'If someone referred you, enter their code to give them credit and earn bonus points!',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ];

      default:
        return [];
    }
  }
}

class _LanguageTile extends StatelessWidget {
  final String label;
  final String sublabel;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.label,
    required this.sublabel,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withOpacity(0.1)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: Border.all(
              color: selected ? AppColors.primary : const Color(0xFFDDDDDD),
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: selected
                      ? AppColors.primary
                      : AppColors.textPrimary,
                ),
              ),
              Text(
                sublabel,
                style: TextStyle(
                  fontSize: 12,
                  color: selected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
