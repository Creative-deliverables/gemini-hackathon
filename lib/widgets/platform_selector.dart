import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/platform_model.dart';

class PlatformSelector extends StatelessWidget {
  const PlatformSelector({
    super.key,
    required this.selectedPlatform,
    required this.selectedFormat,
    required this.onPlatformChanged,
    required this.onFormatChanged,
  });

  final BookPlatform? selectedPlatform;
  final PlatformFormat? selectedFormat;
  final ValueChanged<BookPlatform?> onPlatformChanged;
  final ValueChanged<PlatformFormat?> onFormatChanged;

  @override
  Widget build(BuildContext context) {
    final formats = selectedPlatform != null
        ? getFormatsForPlatform(selectedPlatform!)
        : <PlatformFormat>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '출판사 플랫폼',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: BookPlatform.values.map((platform) {
            final isSelected = selectedPlatform == platform;
            return ChoiceChip(
              label: Text(platform.label),
              selected: isSelected,
              onSelected: (selected) {
                onPlatformChanged(selected ? platform : null);
                onFormatChanged(null);
              },
              selectedColor: AppColors.primary.withAlpha(51),
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
            );
          }).toList(),
        ),
        if (selectedPlatform != null) ...[
          const SizedBox(height: 20),
          Text(
            '출판 규격',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '나중에 에디터 화면에서도 언제든 다른 판형으로 변경할 수 있습니다.',
            style: TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<PlatformFormat>(
            initialValue: selectedFormat,
            decoration: InputDecoration(
              hintText: '원하시는 출판 규격을 선택하세요',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            dropdownColor: AppColors.surface,
            items: formats.map((f) {
              return DropdownMenuItem(
                value: f,
                child: Text('${f.name} (${f.dimensionLabel})'),
              );
            }).toList(),
            onChanged: onFormatChanged,
          ),
        ],
      ],
    );
  }
}
