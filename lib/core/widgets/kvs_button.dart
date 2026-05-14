import 'package:flutter/material.dart';
import '../../core/constants/app_sizes.dart';

enum KvsButtonVariant { primary, secondary, outlined, ghost }

class KvsButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final KvsButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final double? width;

  const KvsButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = KvsButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget child = isLoading
        ? SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: variant == KvsButtonVariant.outlined
                  ? theme.colorScheme.primary
                  : Colors.white,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: AppSizes.iconSm),
                const SizedBox(width: AppSizes.sm),
              ],
              Text(label),
            ],
          );

    final minSize = Size(width ?? double.infinity, AppSizes.btnHeight);

    switch (variant) {
      case KvsButtonVariant.primary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(minimumSize: minSize),
          child: child,
        );
      case KvsButtonVariant.secondary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: minSize,
            backgroundColor: theme.colorScheme.secondary,
          ),
          child: child,
        );
      case KvsButtonVariant.outlined:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(minimumSize: minSize),
          child: child,
        );
      case KvsButtonVariant.ghost:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(minimumSize: minSize),
          child: child,
        );
    }
  }
}
