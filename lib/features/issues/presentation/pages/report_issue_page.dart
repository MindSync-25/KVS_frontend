import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/kvs_button.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/issues_provider.dart';
import '../../domain/entities/issue.dart';

// Issue-type colours
const _typeColors = {
  IssueType.bribery:     AppColors.issueBribe,
  IssueType.road:        AppColors.issueRoad,
  IssueType.water:       AppColors.issueWater,
  IssueType.hospital:    AppColors.issueHospital,
  IssueType.school:      AppColors.issueSchool,
  IssueType.electricity: AppColors.issueElectricity,
  IssueType.farmer:      AppColors.issueFarmer,
  IssueType.other:       AppColors.issueOther,
};

// Issue-type icons
const _typeIcons = {
  IssueType.bribery:     Icons.gavel_outlined,
  IssueType.road:        Icons.construction_outlined,
  IssueType.water:       Icons.water_drop_outlined,
  IssueType.hospital:    Icons.local_hospital_outlined,
  IssueType.school:      Icons.school_outlined,
  IssueType.electricity: Icons.bolt_outlined,
  IssueType.farmer:      Icons.agriculture_outlined,
  IssueType.other:       Icons.help_outline,
};

class ReportIssuePage extends ConsumerStatefulWidget {
  const ReportIssuePage({super.key});

  @override
  ConsumerState<ReportIssuePage> createState() => _ReportIssuePageState();
}

class _ReportIssuePageState extends ConsumerState<ReportIssuePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController  = TextEditingController();

  IssueType? _selectedType;
  int _step = 0; // 0-type 1-describe 2-media 3-confirm

  final List<File> _mediaFiles  = [];
  File? _voiceNote;
  bool _isRecording = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // ── Pick images ────────────────────────────────────────────────────────────
  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage(imageQuality: 70);
    if (picked.isNotEmpty) {
      setState(() {
        _mediaFiles.addAll(picked.map((x) => File(x.path)));
      });
    }
  }

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final video  = await picker.pickVideo(source: ImageSource.camera);
    if (video != null) {
      setState(() => _mediaFiles.add(File(video.path)));
    }
  }

  // ── Submit ─────────────────────────────────────────────────────────────────
  Future<void> _submit() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final ok = await ref.read(issuesProvider.notifier).submitIssue(
          reporterId:  user.uid,
          type:        _selectedType!,
          title:       _titleController.text.trim(),
          description: _descController.text.trim(),
          district:    user.district,
          taluk:       user.taluk,
          ward:        user.ward,
          mediaFiles:  _mediaFiles,
          voiceNote:   _voiceNote,
        );

    if (!mounted) return;
    if (ok) {
      _showSuccess();
    } else {
      final err = ref.read(issuesProvider).error ?? 'Submission failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err), backgroundColor: AppColors.error),
      );
    }
  }

  void _showSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSizes.md),
            const Icon(Icons.check_circle, color: AppColors.success, size: 64),
            const SizedBox(height: AppSizes.md),
            const Text(
              'Issue Reported!',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.sm),
            const Text(
              'ನಿಮ್ಮ ದೂರು ದಾಖಲಾಗಿದೆ.\nNamma team will look into it.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSizes.lg),
            KvsButton(
              label: 'Back to Home',
              onPressed: () {
                Navigator.pop(context);
                context.go(AppRoutes.home);
              },
            )
          ],
        ),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(issuesProvider).isSubmitting;

    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Report a Problem'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: Column(
          children: [
            // Step indicator
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.lg, vertical: AppSizes.sm),
              child: Row(
                children: List.generate(4, (i) {
                  final done   = i < _step;
                  final active = i == _step;
                  return Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: 4,
                      decoration: BoxDecoration(
                        color: done || active
                            ? AppColors.primary
                            : AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.lg),
                child: Form(
                  key: _formKey,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: KeyedSubtree(
                      key: ValueKey(_step),
                      child: _buildStep(),
                    ),
                  ),
                ),
              ),
            ),
            // Bottom nav
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSizes.lg, 0, AppSizes.lg, AppSizes.lg),
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
                  if (_step > 0)
                    const SizedBox(width: AppSizes.md),
                  Expanded(
                    flex: 2,
                    child: KvsButton(
                      label: _step == 3 ? 'Submit Report' : 'Next',
                      icon: _step == 3
                          ? Icons.send_outlined
                          : Icons.arrow_forward,
                      isLoading: isLoading,
                      onPressed: () {
                        if (_step == 0 && _selectedType == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Please select the issue type')),
                          );
                          return;
                        }
                        if (_step == 1) {
                          if (!_formKey.currentState!.validate()) return;
                        }
                        if (_step < 3) {
                          setState(() => _step++);
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
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _StepType(
          selected: _selectedType,
          onSelect: (t) => setState(() => _selectedType = t),
        );
      case 1:
        return _StepDescribe(
          titleCtrl: _titleController,
          descCtrl:  _descController,
          issueType: _selectedType!,
        );
      case 2:
        return _StepMedia(
          files:         _mediaFiles,
          voiceNote:     _voiceNote,
          isRecording:   _isRecording,
          onPickImages:  _pickImages,
          onPickVideo:   _pickVideo,
          onRemoveFile:  (i) => setState(() => _mediaFiles.removeAt(i)),
          onToggleVoice: () async {
            // TODO: wire up `record` package voice recording
            setState(() => _isRecording = !_isRecording);
          },
        );
      case 3:
        return _StepConfirm(
          type:      _selectedType!,
          title:     _titleController.text,
          desc:      _descController.text,
          fileCount: _mediaFiles.length,
          hasVoice:  _voiceNote != null,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

// ─── Step 1: Type selection ──────────────────────────────────────────────────

class _StepType extends StatelessWidget {
  final IssueType? selected;
  final ValueChanged<IssueType> onSelect;

  const _StepType({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What is the problem?',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary),
        ),
        const SizedBox(height: 4),
        const Text(
          'ಸಮಸ್ಯೆ ಯಾವ ವಿಧದ್ದು?',
          style: TextStyle(color: AppColors.primary, fontSize: 14),
        ),
        const SizedBox(height: AppSizes.xl),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: AppSizes.sm,
          mainAxisSpacing:  AppSizes.sm,
          childAspectRatio: 1.4,
          children: IssueType.values.map((t) {
            final isSelected = t == selected;
            final color = _typeColors[t]!;
            return GestureDetector(
              onTap: () => onSelect(t),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  color: isSelected ? color.withOpacity(0.15) : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(
                    color: isSelected ? color : const Color(0xFFE0E0E0),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                padding: const EdgeInsets.all(AppSizes.md),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_typeIcons[t], color: color, size: 28),
                    const SizedBox(height: 6),
                    Text(
                      t.label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? color : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      t.kannadaLabel,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        color: isSelected ? color : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ─── Step 2: Describe the issue ──────────────────────────────────────────────

class _StepDescribe extends StatelessWidget {
  final TextEditingController titleCtrl;
  final TextEditingController descCtrl;
  final IssueType issueType;

  const _StepDescribe({
    required this.titleCtrl,
    required this.descCtrl,
    required this.issueType,
  });

  @override
  Widget build(BuildContext context) {
    final color = _typeColors[issueType]!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(_typeIcons[issueType], color: color),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(issueType.label,
                      style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w700)),
                  Text(issueType.kannadaLabel,
                      style: TextStyle(
                          color: color.withOpacity(0.7),
                          fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.xl),
        const Text('Issue Title',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        const SizedBox(height: AppSizes.sm),
        TextFormField(
          controller: titleCtrl,
          maxLength:  80,
          textCapitalization: TextCapitalization.sentences,
          validator: (v) =>
              v == null || v.trim().length < 5 ? 'Enter a brief title' : null,
          decoration: const InputDecoration(
            hintText: 'e.g. Broken road near school',
            counterText: '',
          ),
        ),
        const SizedBox(height: AppSizes.md),
        const Text('Description',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        const SizedBox(height: AppSizes.sm),
        TextFormField(
          controller: descCtrl,
          maxLines: 5,
          maxLength: 500,
          textCapitalization: TextCapitalization.sentences,
          validator: (v) => v == null || v.trim().length < 10
              ? 'Please describe the issue (min 10 chars)'
              : null,
          decoration: const InputDecoration(
            hintText: 'Describe the problem in detail...',
            alignLabelWithHint: true,
          ),
        ),
      ],
    );
  }
}

// ─── Step 3: Media ───────────────────────────────────────────────────────────

class _StepMedia extends StatelessWidget {
  final List<File> files;
  final File? voiceNote;
  final bool isRecording;
  final VoidCallback onPickImages;
  final VoidCallback onPickVideo;
  final ValueChanged<int> onRemoveFile;
  final VoidCallback onToggleVoice;

  const _StepMedia({
    required this.files,
    required this.voiceNote,
    required this.isRecording,
    required this.onPickImages,
    required this.onPickVideo,
    required this.onRemoveFile,
    required this.onToggleVoice,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add Evidence (Optional)',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary),
        ),
        const SizedBox(height: 4),
        const Text(
          'ಫೋಟೋ ಅಥವಾ ವೀಡಿಯೋ ಸೇರಿಸಿ (ಐಚ್ಛಿಕ)',
          style: TextStyle(color: AppColors.primary, fontSize: 13),
        ),
        const SizedBox(height: AppSizes.xl),

        // Media buttons
        Row(
          children: [
            Expanded(
              child: _MediaButton(
                icon: Icons.photo_library_outlined,
                label: 'Photos',
                onTap: onPickImages,
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: _MediaButton(
                icon: Icons.videocam_outlined,
                label: 'Video',
                onTap: onPickVideo,
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: _MediaButton(
                icon: isRecording ? Icons.stop_circle : Icons.mic_outlined,
                label: isRecording ? 'Stop' : 'Voice',
                color: isRecording ? AppColors.error : AppColors.primary,
                onTap: onToggleVoice,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.lg),

        // Image thumbnails
        if (files.isNotEmpty) ...[
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: files.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppSizes.sm),
              itemBuilder: (_, i) => Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(AppSizes.radiusSm),
                    child: Image.file(files[i],
                        width: 80, height: 80, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: GestureDetector(
                      onTap: () => onRemoveFile(i),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close,
                            size: 12, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],

        if (voiceNote != null) ...[
          const SizedBox(height: AppSizes.md),
          Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.08),
              borderRadius:
                  BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: const Row(
              children: [
                Icon(Icons.audiotrack, color: AppColors.secondary),
                SizedBox(width: AppSizes.sm),
                Text('Voice note recorded',
                    style: TextStyle(color: AppColors.secondary)),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _MediaButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _MediaButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// ─── Step 4: Confirm ─────────────────────────────────────────────────────────

class _StepConfirm extends StatelessWidget {
  final IssueType type;
  final String title;
  final String desc;
  final int fileCount;
  final bool hasVoice;

  const _StepConfirm({
    required this.type,
    required this.title,
    required this.desc,
    required this.fileCount,
    required this.hasVoice,
  });

  @override
  Widget build(BuildContext context) {
    final color = _typeColors[type]!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Review & Submit',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary),
        ),
        const SizedBox(height: 4),
        const Text(
          'ಸಲ್ಲಿಕೆ ಮಾಡುವ ಮೊದಲು ಪರಿಶೀಲಿಸಿ',
          style: TextStyle(color: AppColors.primary, fontSize: 13),
        ),
        const SizedBox(height: AppSizes.xl),
        _ConfirmRow(label: 'Issue Type',
            value: '${type.label}  •  ${type.kannadaLabel}',
            icon: _typeIcons[type]!, color: color),
        const Divider(height: AppSizes.xl),
        _ConfirmRow(label: 'Title', value: title,
            icon: Icons.title, color: AppColors.textSecondary),
        const Divider(height: AppSizes.xl),
        _ConfirmRow(label: 'Description', value: desc,
            icon: Icons.description_outlined,
            color: AppColors.textSecondary),
        const Divider(height: AppSizes.xl),
        _ConfirmRow(
          label: 'Evidence',
          value: fileCount > 0 || hasVoice
              ? '${fileCount > 0 ? "$fileCount photo/video" : ""}${hasVoice ? (fileCount > 0 ? " + voice note" : "voice note") : ""}'
              : 'No media attached',
          icon: Icons.attach_file,
          color: AppColors.textSecondary,
        ),
        const SizedBox(height: AppSizes.xl),
        Container(
          padding: const EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.secondary, size: 18),
              SizedBox(width: AppSizes.sm),
              Expanded(
                child: Text(
                  'Your report will be visible to our leaders and will earn you karma points!',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _ConfirmRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: AppSizes.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
            ],
          ),
        ),
      ],
    );
  }
}
