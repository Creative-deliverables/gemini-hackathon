import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../config/theme.dart';

class FileUploadWidget extends StatelessWidget {
  const FileUploadWidget({
    super.key,
    required this.onFileSelected,
    this.selectedFileName,
    this.selectedFileSize,
    this.onClear,
    this.maxSizeMB = 20,
  });

  final void Function(Uint8List bytes, String fileName) onFileSelected;
  final String? selectedFileName;
  final int? selectedFileSize;
  final VoidCallback? onClear;
  final int maxSizeMB;

  Future<void> _pickFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    if (file.bytes == null) return;

    final sizeMB = file.size / (1024 * 1024);
    if (sizeMB > maxSizeMB) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('파일 크기가 ${maxSizeMB}MB를 초과합니다.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    onFileSelected(file.bytes!, file.name);
  }

  @override
  Widget build(BuildContext context) {
    final hasFile = selectedFileName != null;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 300),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.border,
              width: 2,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: hasFile ? _buildFileInfo(context) : _buildUploadPrompt(context),
        ),
      ),
    );
  }

  Widget _buildFileInfo(BuildContext context) {
    final sizeMB = (selectedFileSize ?? 0) / (1024 * 1024);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(26),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary.withAlpha(51)),
          ),
          child: const Icon(Icons.description, size: 32, color: AppColors.primary),
        ),
        const SizedBox(height: 16),
        Text(
          selectedFileName!,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          '${sizeMB.toStringAsFixed(2)} MB',
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: onClear,
          icon: const Icon(Icons.close, size: 16),
          label: const Text('다른 파일 선택하기'),
        ),
      ],
    );
  }

  Widget _buildUploadPrompt(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.cloud_upload_outlined, size: 48, color: AppColors.textMuted),
        const SizedBox(height: 16),
        const Text(
          '업로드할 파일을 선택하세요',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'PDF 포맷을 지원합니다. (최대 ${maxSizeMB}MB)',
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => _pickFile(context),
          child: const Text('파일 찾아보기'),
        ),
      ],
    );
  }
}
