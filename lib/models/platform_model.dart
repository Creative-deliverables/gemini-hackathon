/// 지원하는 출판 플랫폼
enum BookPlatform {
  yes24('예스24'),
  bookk('부크크'),
  aladin('알라딘'),
  kyobo('교보문고');

  const BookPlatform(this.label);
  final String label;
}

/// 플랫폼별 출판 규격
class PlatformFormat {
  const PlatformFormat({
    required this.name,
    required this.widthMm,
    required this.heightMm,
    required this.platform,
  });

  final String name;
  final double widthMm;
  final double heightMm;
  final BookPlatform platform;

  String get dimensionLabel => '${widthMm.toInt()}x${heightMm.toInt()}mm';
}

/// 모든 플랫폼의 사용 가능한 규격 목록
const List<PlatformFormat> availableFormats = [
  // 예스24
  PlatformFormat(name: 'A4 (국배판)', widthMm: 210, heightMm: 297, platform: BookPlatform.yes24),
  PlatformFormat(name: 'A5 (국판)', widthMm: 148, heightMm: 210, platform: BookPlatform.yes24),
  PlatformFormat(name: 'B5 (46배판)', widthMm: 188, heightMm: 254, platform: BookPlatform.yes24),
  PlatformFormat(name: '신국판', widthMm: 152, heightMm: 225, platform: BookPlatform.yes24),

  // 부크크
  PlatformFormat(name: 'A4 (국배판)', widthMm: 210, heightMm: 297, platform: BookPlatform.bookk),
  PlatformFormat(name: 'A5 (국판)', widthMm: 148, heightMm: 210, platform: BookPlatform.bookk),
  PlatformFormat(name: 'B5 (46배판)', widthMm: 188, heightMm: 254, platform: BookPlatform.bookk),
  PlatformFormat(name: 'B6 (46판)', widthMm: 128, heightMm: 188, platform: BookPlatform.bookk),
  PlatformFormat(name: '크라운판', widthMm: 176, heightMm: 248, platform: BookPlatform.bookk),

  // 알라딘
  PlatformFormat(name: 'A5 (국판)', widthMm: 148, heightMm: 210, platform: BookPlatform.aladin),
  PlatformFormat(name: 'B5 (46배판)', widthMm: 188, heightMm: 254, platform: BookPlatform.aladin),
  PlatformFormat(name: '신국판', widthMm: 152, heightMm: 225, platform: BookPlatform.aladin),

  // 교보문고
  PlatformFormat(name: 'A4 (국배판)', widthMm: 210, heightMm: 297, platform: BookPlatform.kyobo),
  PlatformFormat(name: 'A5 (국판)', widthMm: 148, heightMm: 210, platform: BookPlatform.kyobo),
  PlatformFormat(name: 'B5 (46배판)', widthMm: 188, heightMm: 254, platform: BookPlatform.kyobo),
  PlatformFormat(name: '크라운판', widthMm: 176, heightMm: 248, platform: BookPlatform.kyobo),
  PlatformFormat(name: '신국판', widthMm: 152, heightMm: 225, platform: BookPlatform.kyobo),
];

/// 플랫폼별 규격 목록 필터
List<PlatformFormat> getFormatsForPlatform(BookPlatform platform) {
  return availableFormats.where((f) => f.platform == platform).toList();
}
