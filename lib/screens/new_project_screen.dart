import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/theme.dart';
import '../models/platform_model.dart';
import '../services/gemini_service.dart';
import '../widgets/app_header.dart';
import '../widgets/file_upload_widget.dart';
import '../widgets/manuscript_input_widget.dart';
import '../widgets/platform_selector.dart';
import '../widgets/tone_selector.dart';

class NewProjectScreen extends StatefulWidget {
  const NewProjectScreen({super.key});

  @override
  State<NewProjectScreen> createState() => _NewProjectScreenState();
}

class _NewProjectScreenState extends State<NewProjectScreen>
    with SingleTickerProviderStateMixin {
  int _step = 1;
  bool _isGenerating = false;
  String _errorMsg = '';

  // Step 1 state
  final _nameController = TextEditingController();
  final _manuscriptController = TextEditingController();
  late final TabController _tabController;
  Uint8List? _pdfBytes;
  String? _pdfFileName;
  int? _pdfFileSize;

  // Step 2 state
  BookPlatform? _selectedPlatform;
  PlatformFormat? _selectedFormat;
  String _selectedTone = '전문적인';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _manuscriptController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  bool get _isTextMode => _tabController.index == 0;

  void _goToStep2() {
    if (_nameController.text.trim().isEmpty) {
      setState(() => _errorMsg = '프로젝트 이름을 입력해주세요.');
      return;
    }

    if (_isTextMode) {
      if (_manuscriptController.text.trim().length < 10) {
        setState(() => _errorMsg = '원고 내용이 너무 짧습니다. 충분한 내용을 작성해주세요.');
        return;
      }
    } else {
      if (_pdfBytes == null) {
        setState(() => _errorMsg = '업로드할 파일을 선택해주세요.');
        return;
      }
    }

    setState(() {
      _errorMsg = '';
      _step = 2;
    });
  }

  Future<void> _handleGenerate() async {
    setState(() {
      _errorMsg = '';
      _isGenerating = true;
    });

    try {
      final platformInfo = _selectedFormat != null
          ? '${_selectedPlatform?.label ?? ''} ${_selectedFormat!.name} (${_selectedFormat!.dimensionLabel})'
          : '일반 온라인 서점';

      String resultHtml;

      if (_isTextMode) {
        resultHtml = await GeminiService.instance.generateFromText(
          text: _manuscriptController.text,
          platform: platformInfo,
          tone: _selectedTone,
        );
      } else {
        resultHtml = await GeminiService.instance.generateFromPdf(
          pdfBytes: _pdfBytes!,
          platform: platformInfo,
          tone: _selectedTone,
        );
      }
      if (kDebugMode) {
        print(resultHtml);
      }

      if (!mounted) {
        return;
      }
      context.go('/project/result', extra: resultHtml);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('생성 완료! (${resultHtml.length}자)'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorMsg = '$e');
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(),
                const SizedBox(height: 8),
                _buildProjectNameField(),
                if (_errorMsg.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildError(),
                ],
                const SizedBox(height: 24),
                if (_step == 1) _buildStep1() else _buildStep2(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '새 프로젝트 만들기',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          _step == 1
              ? '프로젝트 이름을 지정하고 원고를 작성하거나 업로드해주세요.'
              : '서식과 템플릿을 설정하고 AI가 판매페이지를 생성하게 하세요.',
          style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildProjectNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        RichText(
          text: const TextSpan(
            text: '프로젝트 이름 ',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            children: [
              TextSpan(
                text: '*',
                style: TextStyle(color: AppColors.error),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: TextField(
            controller: _nameController,
            enabled: _step == 1,
            decoration: const InputDecoration(hintText: '예: 신규 건강기능식품 런칭 페이지'),
          ),
        ),
      ],
    );
  }

  Widget _buildError() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withAlpha(26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _errorMsg,
        style: const TextStyle(
          color: AppColors.error,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                onTap: (_) => setState(() {}),
                indicatorColor: AppColors.primary,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                tabs: const [
                  Tab(text: '직접 작성하기'),
                  Tab(text: '문서 기획안 업로드'),
                ],
              ),
              SizedBox(
                height: 400,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _isTextMode
                      ? ManuscriptInputWidget(controller: _manuscriptController)
                      : FileUploadWidget(
                          selectedFileName: _pdfFileName,
                          selectedFileSize: _pdfFileSize,
                          onFileSelected: (bytes, name) {
                            setState(() {
                              _pdfBytes = bytes;
                              _pdfFileName = name;
                              _pdfFileSize = bytes.length;
                              _errorMsg = '';
                            });
                          },
                          onClear: () {
                            setState(() {
                              _pdfBytes = null;
                              _pdfFileName = null;
                              _pdfFileSize = null;
                            });
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: _goToStep2,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('다음: 서식 및 템플릿 설정하기'),
          ),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(26),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.dashboard,
                  size: 24,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '템플릿 상세 설정',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '이 설정을 바탕으로 AI가 최적화된 서식을 구성합니다.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: PlatformSelector(
                        selectedPlatform: _selectedPlatform,
                        selectedFormat: _selectedFormat,
                        onPlatformChanged: (p) =>
                            setState(() => _selectedPlatform = p),
                        onFormatChanged: (f) =>
                            setState(() => _selectedFormat = f),
                      ),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: ToneSelector(
                        selectedTone: _selectedTone,
                        onChanged: (t) => setState(() => _selectedTone = t),
                      ),
                    ),
                  ],
                );
              }
              return Column(
                children: [
                  PlatformSelector(
                    selectedPlatform: _selectedPlatform,
                    selectedFormat: _selectedFormat,
                    onPlatformChanged: (p) =>
                        setState(() => _selectedPlatform = p),
                    onFormatChanged: (f) => setState(() => _selectedFormat = f),
                  ),
                  const SizedBox(height: 24),
                  ToneSelector(
                    selectedTone: _selectedTone,
                    onChanged: (t) => setState(() => _selectedTone = t),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: _isGenerating
                    ? null
                    : () => setState(() => _step = 1),
                icon: const Icon(Icons.arrow_back, size: 16),
                label: const Text('이전 (원고 편집)'),
              ),
              ElevatedButton(
                onPressed: _isGenerating || _selectedFormat == null
                    ? null
                    : _handleGenerate,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  disabledBackgroundColor: AppColors.primary.withAlpha(77),
                ),
                child: _isGenerating
                    ? const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('AI가 판매페이지를 구성하는 중...'),
                        ],
                      )
                    : const Text('AI로 일괄 구성 시작하기'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
