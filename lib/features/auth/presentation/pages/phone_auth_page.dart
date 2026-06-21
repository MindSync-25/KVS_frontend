import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/locale_extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/kvs_button.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../providers/auth_provider.dart';

class PhoneAuthPage extends ConsumerStatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  ConsumerState<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends ConsumerState<PhoneAuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _agreed = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.isKn
              ? 'ಸೇವಾ ನಿಯಮಗಳಿಗೆ ಒಪ್ಪಿಗೆ ನೀಡಿ'
              : 'Please agree to Terms & Privacy Policy'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    await ref.read(authProvider.notifier).sendOtp(_phoneController.text.trim());
    if (mounted) {
      final error = ref.read(authProvider).error;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: AppColors.error),
        );
      } else {
        context.push(AppStrings.routeOtp);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).status == AuthStatus.loading;
    final isMember = ref.watch(pendingMemberProvider);

    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: SafeArea(
          child: Column(
            children: [
              // ── Top half: dark navy branding ──────────────────────────────
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // KVS Shield
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.accent.withOpacity(0.15),
                          border: Border.all(
                              color: AppColors.accent.withOpacity(0.5),
                              width: 2),
                        ),
                        child: const Icon(Icons.shield,
                            size: 40, color: AppColors.accent),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Yuva Bharata Sena',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Role badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: isMember
                              ? AppColors.accent
                              : Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isMember
                                  ? Icons.military_tech
                                  : Icons.record_voice_over_outlined,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isMember
                                  ? (context.isKn ? 'ಪಕ್ಷ ಸದಸ್ಯ' : 'Party Member')
                                  : (context.isKn ? 'ನಾಗರಿಕ' : 'Citizen'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () {
                          ref.read(pendingMemberProvider.notifier).state =
                              !isMember;
                        },
                        child: Text(
                          isMember
                              ? (context.isKn ? 'ನಾಗರಿಕನಾಗಿ ಬದಲಿಸಿ' : 'Switch to Citizen instead')
                              : (context.isKn ? 'ಪಕ್ಷ ಸದಸ್ಯನಾಗಿ ಬದಲಿಸಿ' : 'Switch to Party Member instead'),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.55),
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Bottom half: white card with phone form ───────────────────
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(28)),
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isMember
                                ? (context.isKn ? 'ಪಕ್ಷಕ್ಕೆ ಸೇರಲು ಮೋಬೈಲ್ ಸಂಖ್ಯೆ ನಮೂದಿಸಿ' : 'Enter Mobile Number to Join')
                                : (context.isKn ? 'ನಿಮ್ಮ ಮೋಬೈಲ್ ಸಂಖ್ಯೆ ನಮೂದಿಸಿ' : 'Enter Your Mobile Number'),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isMember
                                ? (context.isKn ? 'Enter Mobile Number to Join' : 'ಪಕ್ಷಕ್ಕೆ ಸೇರಲು ಮೋಬೈಲ್ ಸಂಖ್ಯೆ ನಮೂದಿಸಿ')
                                : (context.isKn ? 'Enter Your Mobile Number' : 'ನಿಮ್ಮ ಮೋಬೈಲ್ ಸಂಖ್ಯೆ ನಮೂದಿಸಿ'),
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            validator: Validators.phone,
                            decoration: InputDecoration(
                              hintText: '10-digit mobile number',
                              prefixIcon: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 14),
                                child: const Text(
                                  '+91',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              prefixIconConstraints:
                                  const BoxConstraints(minWidth: 56),
                              filled: true,
                              fillColor: AppColors.surfaceVariant,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: AppColors.primary, width: 1.5),
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 18,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: _agreed,
                                onChanged: (v) =>
                                    setState(() => _agreed = v ?? false),
                                activeColor: AppColors.primary,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      setState(() => _agreed = !_agreed),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: Text(
                                        context.isKn
                                            ? 'ಯುವ ಭಾರತ ಸೇನಾದ ಸೇವಾ ನಿಯಮಗಳು ಮತ್ತು ಗೌಪ್ಯತಾ ನೀತಿಗೆ ನಾನು ಒಪ್ಪುತ್ತೇನೆ'
                                            : 'I agree to the Terms of Service and Privacy Policy of Yuva Bharata Sena',
                                        style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 12,
                                          height: 1.4),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Send OTP
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                              ),
                              onPressed: isLoading ? null : _sendOtp,
                              icon: const Icon(Icons.send, size: 18),
                              label: Text(
                                context.isKn ? 'OTP ಕಳುಹಿಸಿ' : 'Send OTP',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Demo mode
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.textSecondary,
                                side: BorderSide(
                                    color: AppColors.textHint
                                        .withOpacity(0.5)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () => ref
                                  .read(authProvider.notifier)
                                  .enterDemoMode(),
                              icon: const Icon(Icons.science_outlined,
                                  size: 16),
                              label: const Text('Demo Mode (UI Test)',
                                  style: TextStyle(fontSize: 13)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
