import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/kvs_button.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../providers/auth_provider.dart';

class OtpVerifyPage extends ConsumerStatefulWidget {
  const OtpVerifyPage({super.key});

  @override
  ConsumerState<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends ConsumerState<OtpVerifyPage> {
  final _otpController = TextEditingController();
  String _otp = '';
  int _resendSeconds = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    _timer?.cancel();
    setState(() => _resendSeconds = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendSeconds == 0) {
        t.cancel();
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _verify() async {
    if (_otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the 6-digit OTP'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    await ref.read(authProvider.notifier).verifyOtp(_otp);
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
      // Navigation handled by GoRouter redirect based on AuthStatus
    }
  }

  Future<void> _resend() async {
    final phone = ref.read(authProvider).pendingPhone;
    if (phone == null) return;
    await ref.read(authProvider.notifier).sendOtp(phone);
    _startResendTimer();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP resent successfully'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.status == AuthStatus.loading;
    final phone = authState.pendingPhone ?? '';

    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: AppColors.textPrimary,
          title: const Text('Verify OTP'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSizes.lg),
                // Header
                const Text(
                  'Enter the OTP',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        fontSize: 14, color: AppColors.textSecondary),
                    children: [
                      const TextSpan(text: 'OTP sent to '),
                      TextSpan(
                        text: '+91 $phone',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.xxl),
                // PIN code input
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.scale,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    fieldHeight: 56,
                    fieldWidth: 46,
                    activeColor: AppColors.primary,
                    selectedColor: AppColors.primary,
                    inactiveColor: const Color(0xFFDDDDDD),
                    activeFillColor: AppColors.surface,
                    selectedFillColor: AppColors.surfaceVariant,
                    inactiveFillColor: AppColors.surface,
                  ),
                  enableActiveFill: true,
                  onChanged: (v) => setState(() => _otp = v),
                  onCompleted: (v) {
                    setState(() => _otp = v);
                    _verify();
                  },
                ),
                const SizedBox(height: AppSizes.xl),
                // Verify button
                KvsButton(
                  label: 'Verify & Continue',
                  onPressed: _otp.length == 6 ? _verify : null,
                  isLoading: isLoading,
                  icon: Icons.verified_user,
                ),
                const SizedBox(height: AppSizes.lg),
                // Resend
                Center(
                  child: _resendSeconds > 0
                      ? Text(
                          'Resend OTP in ${_resendSeconds}s',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        )
                      : TextButton(
                          onPressed: _resend,
                          child: const Text(
                            'Resend OTP',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
