import 'dart:typed_data';
import 'platform_model.dart';

/// 프로젝트 데이터 모델
class Project {
  Project({
    required this.name,
    this.manuscriptText,
    this.pdfBytes,
    this.pdfFileName,
    this.platform,
    this.format,
    this.tone = '전문적인',
  });

  final String name;
  final String? manuscriptText;
  final Uint8List? pdfBytes;
  final String? pdfFileName;
  final BookPlatform? platform;
  final PlatformFormat? format;
  final String tone;

  /// 유효성 검증: 이름 필수, 텍스트 10자 이상 또는 PDF 필수
  String? validate({required bool isTextMode}) {
    if (name.trim().isEmpty) {
      return '프로젝트 이름을 입력해주세요.';
    }
    if (isTextMode) {
      if (manuscriptText == null || manuscriptText!.trim().length < 10) {
        return '원고 내용이 너무 짧습니다. 충분한 내용을 작성해주세요.';
      }
    } else {
      if (pdfBytes == null) {
        return '업로드할 파일을 선택해주세요.';
      }
    }
    return null;
  }
}
