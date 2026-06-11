import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlusInfoIcon extends StatelessWidget {
  const PlusInfoIcon({
    super.key,
    required this.title,
    required this.message,
    this.iconColor,
  });

  final String title;
  final String message;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: MaterialLocalizations.of(context).moreButtonTooltip,
      constraints: BoxConstraints.tightFor(width: 36.r, height: 36.r),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      icon: Icon(Icons.info_outline, size: 20.r, color: iconColor),
      onPressed: () =>
          showPlusInfoDialog(context: context, title: title, message: message),
    );
  }
}

Future<void> showPlusInfoDialog({
  required BuildContext context,
  required String title,
  required String message,
}) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.workspace_premium_outlined),
          SizedBox(width: 8.w),
          Expanded(child: Text(title)),
        ],
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(MaterialLocalizations.of(ctx).closeButtonLabel),
        ),
      ],
    ),
  );
}
