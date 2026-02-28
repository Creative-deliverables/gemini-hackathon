import 'package:flutter/material.dart';
import '../config/theme.dart';

class ToneOption {
  const ToneOption({required this.value, required this.label});
  final String value;
  final String label;
}

const List<ToneOption> toneOptions = [
  ToneOption(value: '전문적인', label: '전문적이고 신뢰감 있는'),
  ToneOption(value: '설득력있는', label: '강력하고 설득력 있는 (세일즈 지향)'),
  ToneOption(value: '감동적인', label: '감성적이고 따뜻한 스토리텔링'),
  ToneOption(value: '명확한', label: '간단명료하고 핵심만 짚는'),
];

class ToneSelector extends StatelessWidget {
  const ToneSelector({
    super.key,
    required this.selectedTone,
    required this.onChanged,
  });

  final String selectedTone;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '문체 (Tone & Manner)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          '선택하신 글투에 맞춰 홍보 문구가 작성됩니다.',
          style: TextStyle(fontSize: 13, color: AppColors.textMuted),
        ),
        const SizedBox(height: 12),
        ...toneOptions.map((option) {
          final isSelected = selectedTone == option.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => onChanged(option.value),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withAlpha(26)
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      size: 20,
                      color:
                          isSelected ? AppColors.primary : AppColors.textMuted,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        option.label,
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
