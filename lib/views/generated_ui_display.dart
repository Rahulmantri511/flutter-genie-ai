import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ui_builder.dart';

class GeneratedUIDisplay extends StatelessWidget {
  final Map<String, dynamic> uiData;
  final VoidCallback onModify;
  final Color primaryColor;

  const GeneratedUIDisplay({
    Key? key,
    required this.uiData,
    required this.onModify,
    this.primaryColor = Colors.blue,
  }) : super(key: key);

  void _copyCode(BuildContext context) {
    final jsonString = const JsonEncoder.withIndent('  ').convert(uiData);
    Clipboard.setData(ClipboardData(text: jsonString));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Code copied to clipboard!'),
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uiBuilder = FlutterUIBuilder(
      primaryColor: primaryColor,
      context: context,
    );

    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              border: Border(
                bottom: BorderSide(color: primaryColor.withOpacity(0.2)),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _copyCode(context),
                          icon: const Icon(Icons.code),
                          label: const Text('Copy Code'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: primaryColor,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: primaryColor),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: onModify,
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('Modify'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    tabs: const [
                      Tab(text: 'Preview'),
                      Tab(text: 'Code'),
                    ],
                    labelColor: primaryColor,
                    indicatorColor: primaryColor,
                    dividerColor: Colors.transparent,
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        SingleChildScrollView(
                          child: uiBuilder.buildUIFromJson(uiData),
                        ),
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: SelectableText(
                                const JsonEncoder.withIndent('  ').convert(uiData),
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 14,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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