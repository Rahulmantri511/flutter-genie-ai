import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodeDisplay extends StatelessWidget {
  final Map<String, dynamic> jsonData = {
    "type": "Scaffold",
    "body": {
      "type": "Container",
      "padding": {"all": 24},
      "child": {
        "type": "Column",
        "children": [
          {
            "type": "TextField",
            "decoration": {
              "hintText": "Search...",
              "filled": true,
              "fillColor": "#F5F5F5",
              "border": {
                "type": "OutlineInputBorder",
                "borderRadius": 12,
                "borderSide": "none"
              },
              "contentPadding": {
                "vertical": 16,
                "horizontal": 20
              }
            }
          },
          {
            "type": "SizedBox",
            "height": 24
          },
          {
            "type": "ElevatedButton",
            "text": "Continue",
            "backgroundColor": "#46A695",
            "textColor": "#FFFFFF",
            "style": {
              "borderRadius": 12,
              "elevation": 0
            }
          }
        ]
      }
    }
  };

  void _copyCode(BuildContext context, String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Code copied to clipboard!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dartCode = '''
import 'package:flutter/material.dart';

class UIExample extends StatelessWidget {
  const UIExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF46A695),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
''';

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: const [
              Tab(text: 'JSON Format'),
              Tab(text: 'Dart Code'),
            ],
            labelColor: Theme.of(context).primaryColor,
            indicatorColor: Theme.of(context).primaryColor,
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildCodeCard(
                  context,
                  const JsonEncoder.withIndent('  ').convert(jsonData),
                  'JSON',
                ),
                _buildCodeCard(context, dartCode, 'Dart'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeCard(BuildContext context, String code, String type) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton.icon(
            onPressed: () => _copyCode(context, code),
            icon: const Icon(Icons.copy),
            label: Text('Copy $type Code'),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: SelectableText(
              code,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}