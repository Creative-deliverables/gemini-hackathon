import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:gemini_hackathon/core/extensions/color.dart';

class PreviewPanel extends StatelessWidget {
  final String? htmlContent;

  const PreviewPanel({super.key, this.htmlContent});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(bottom: BorderSide(color: theme.dividerColor)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Manuscript Preview', style: theme.textTheme.titleLarge),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Upload PDF'),
                ),
              ],
            ),
          ),

          // Content Area
          Expanded(
            child: htmlContent != null && htmlContent!.isNotEmpty
                ? SingleChildScrollView(
                    padding: const EdgeInsets.all(32.0),
                    child: HtmlWidget(
                      htmlContent!,
                      textStyle: theme.textTheme.bodyLarge,
                      customStylesBuilder: (element) {
                        // Inherit color from theme for headers instead of forcing dark color
                        if (element.localName?.startsWith('h') == true) {
                          return {
                            'color':
                                '#${theme.colorScheme.onSurface.value.toRadixString(16).substring(2)}',
                          };
                        }
                        return null;
                      },
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.description_outlined,
                          size: 64,
                          color: theme.colorScheme.onSurface.withAlphaOpacity(
                            0.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No manuscript uploaded yet',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withAlphaOpacity(
                              0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Upload a PDF to view contents and extract information',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
