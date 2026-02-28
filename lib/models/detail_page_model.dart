/// AI 생성 결과 — 상세페이지 데이터 모델
class DetailPage {
  DetailPage({
    required this.title,
    this.subtitle,
    this.description,
    this.targetAudience = const [],
    this.benefits = const [],
    this.tableOfContents = const [],
    this.rawHtml = '',
  });

  final String title;
  final String? subtitle;
  final String? description;
  final List<String> targetAudience;
  final List<String> benefits;
  final List<String> tableOfContents;
  final String rawHtml;

  factory DetailPage.fromJson(Map<String, dynamic> json) {
    return DetailPage(
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String?,
      description: json['description'] as String?,
      targetAudience: (json['targetAudience'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      benefits: (json['benefits'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      tableOfContents: (json['tableOfContents'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      rawHtml: json['rawHtml'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'targetAudience': targetAudience,
      'benefits': benefits,
      'tableOfContents': tableOfContents,
      'rawHtml': rawHtml,
    };
  }
}
