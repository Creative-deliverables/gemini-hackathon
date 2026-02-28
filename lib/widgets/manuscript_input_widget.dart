import 'package:flutter/material.dart';
import '../config/theme.dart';

class ManuscriptInputWidget extends StatelessWidget {
  const ManuscriptInputWidget({
    super.key,
    required this.controller,
    this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '원고 입력',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (_, value, _) {
                return Text(
                  '${value.text.length}자',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            decoration: InputDecoration(
              hintText: '원고 내용을 입력해주세요...\n\n책의 핵심 내용, 목차, 주요 메시지 등을 자유롭게 작성하세요.',
              hintMaxLines: 5,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }
}
