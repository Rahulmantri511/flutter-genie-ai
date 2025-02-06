import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/image_service.dart';
import 'generated_ui_display.dart';
import 'ui_builder.dart';
import 'dart:developer';
class DesignHistory {
  final String prompt;
  final Map<String, dynamic> uiData;
  final String? color;

  DesignHistory({
    required this.prompt,
    required this.uiData,
    this.color,
  });
}

class GeneratedUIScreen extends StatefulWidget {
  const GeneratedUIScreen({super.key});

  @override
  State<GeneratedUIScreen> createState() => _GeneratedUIScreenState();
}

class _GeneratedUIScreenState extends State<GeneratedUIScreen> {
  List<DesignHistory> designHistory = [];
  final TextEditingController _promptController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  bool _isLoading = false;
  Color _primaryColor = Colors.blue;
  late FlutterUIBuilder _uiBuilder;
  String? _selectedImagePath;
  Uint8List? _imageBytes;
  Color primaryColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    _uiBuilder = FlutterUIBuilder(primaryColor: _primaryColor,context: context);
  }

  @override
  void dispose() {
    _promptController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  Color _hexToColor(String hex) {
    try {
      hex = hex.replaceAll('#', '');
      if (hex.length == 6) {
        hex = 'FF' + hex;
      }
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      print('Error parsing color: $e');
      return Colors.blue;
    }
  }

  Future<void> _pickImage() async {
    try {
      final result = await ImagePickerService.pickImage();

      if (result != null) {
        setState(() {
          _selectedImagePath = result.fileName;
          _imageBytes = result.bytes;
        });

        // Pre-fill prompt with image description
        _promptController.text = "Create a UI based on this uploaded image. ";
      }
    } catch (e) {
      print('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error selecting image: $e')),
        );
      }
    }
  }

  void _showPromptBottomSheet({String? previousPrompt}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 24,
            right: 24,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  previousPrompt != null ? 'Modify Design' : 'Create New Design',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (previousPrompt != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Previous prompt: $previousPrompt',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image_outlined),
                  label: Text(_selectedImagePath ?? 'Upload Reference Image'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: primaryColor,
                    elevation: 0,
                    side: BorderSide(color: primaryColor),
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                if (_imageBytes != null) ...[
                  const SizedBox(height: 16),
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(
                          _imageBytes!,
                          fit: BoxFit.cover,
                          height: 150,
                          width: double.infinity,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              _selectedImagePath = null;
                              _imageBytes = null;
                            });
                          },
                          icon: const Icon(Icons.close),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.all(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 24),
                TextField(
                  controller: _promptController,
                  decoration: InputDecoration(
                    hintText: previousPrompt != null
                        ? 'Describe your design modifications...'
                        : 'Describe the UI you want to create...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _colorController,
                  decoration: InputDecoration(
                    hintText: 'Theme color (e.g., #FF0000)',
                    prefixIcon: const Icon(Icons.color_lens_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    if (previousPrompt != null)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _selectedImagePath = null;
                            _imageBytes = null;
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                    if (previousPrompt != null)
                      const SizedBox(width: 16),
                    Expanded(
                      flex: previousPrompt != null ? 2 : 1,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_promptController.text.isNotEmpty) {
                            if (_colorController.text.isNotEmpty) {
                              _primaryColor = _hexToColor(_colorController.text);
                              _uiBuilder = FlutterUIBuilder(
                                primaryColor: _primaryColor,
                                context: context,
                              );
                            }
                            Navigator.pop(context);
                            await _generateUI(_promptController.text);
                            _promptController.clear();
                            _colorController.clear();
                            _selectedImagePath = null;
                            _imageBytes = null;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          previousPrompt != null ? 'Update Design' : 'Generate UI',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _generateUI(String prompt) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await fetchGeneratedUI(prompt);
      setState(() {
        designHistory.add(DesignHistory(
          prompt: prompt,
          uiData: response,
          color: _colorController.text.isNotEmpty ? _colorController.text : null,
        ));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating UI: $e')),
        );
      }
    }
  }

  Future<Map<String, dynamic>> fetchGeneratedUI(String prompt) async {
    const String apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-lite-preview-02-05:generateContent?key=AIzaSyAn7GwRev5sEBANdbbsrfD05sI2v3BcJKM";

    final enhancedPrompt = '''
    You are a modern Flutter UI generator specializing in creating beautiful, production-ready user interfaces. ${_imageBytes != null ? "I've uploaded an image as reference. Create a pixel-perfect UI that precisely matches the style, layout, and aesthetics of the uploaded image." : ""} Generate a complete Flutter widget tree as JSON that can be parsed into Flutter widgets.

    Available Components and Styling Options:

    1. Container Styling:
    - Basic: {type: "Container", width, height, padding, margin}
    - Advanced Decoration: {
    decoration: {
      color: "#HEXCODE",
      borderRadius: number or {topLeft, topRight, bottomLeft, bottomRight},
      border: {color: "#HEXCODE", width: number},
      gradient: {colors: ["#HEXCODE", "#HEXCODE"], begin, end}
    }
  }

2. Modern Text Fields:
- Basic: {type: "TextField"}
- Styled: {
    decoration: {
      hintText: "string",
      filled: true,
      fillColor: "#HEXCODE",
      border: {
        type: "OutlineInputBorder",
        borderRadius: number,
        borderSide: "none"
      },
      contentPadding: {vertical: number, horizontal: number}
    }
  }

3. Buttons and Interactive Elements:
- Modern Button: {
    type: "ElevatedButton",
    text: "string",
    backgroundColor: "#HEXCODE",
    textColor: "#HEXCODE",
    style: {
      borderRadius: number,
      elevation: number
    }
  }

4. Layout and Spacing:
- Professional Container Spacing: {
    padding: {top, left, right, bottom},
    margin: {top, left, right, bottom}
  }
- Responsive Sizing: Use relative units (percentage of screen width)
- Card Layout: Add elevation and rounded corners

5. Typography and Text Styling:
- Modern Text: {
    type: "Text",
    text: "string",
    style: {
      color: "#HEXCODE",
      fontSize: number,
      fontWeight: "bold/w500/etc",
      letterSpacing: number
    }
  }

Style Guidelines:
1. Material Design 3 Colors:
   - Primary: "#46A695" (Modern teal)
   - Surface: "#FFFFFF" (Clean white)
   - Background: "#F5F5F5" (Light gray)
   - Text: Primary "#000000", Secondary "#666666"

2. Spacing and Sizing:
   - Border Radius: 8-25px for containers
   - Padding: 16-24px for content areas
   - Button Height: 48-56px
   - Text Field Height: 48-56px

3. Typography:
   - Headings: 24-32px, Bold
   - Body Text: 14-16px, Regular
   - Button Text: 16px, Medium
   - Field Labels: 14px, Medium

4. Interactive Elements:
   - Buttons: Full width, rounded corners
   - Text Fields: Filled style with rounded corners
   - Icons: Consistent size (24px)

Consider these modern UI patterns:
- Use ample white space
- Implement consistent padding
- Apply subtle shadows for depth
- Use rounded corners for containers
- Ensure proper contrast ratios
- Maintain visual hierarchy

Universal Spacing Rules:

1. Layout Structure:
   - Screen Edges: 24-32px padding
   - Major Sections: 48px separation
   - Component Groups: 32px separation
   - Related Elements: 16-24px separation
   - Micro Elements: 8px separation

2. Component Spacing:
   Containers:
   {
     "type": "Container",
     "margin": {
       "vertical": 24,    // Between components
       "horizontal": 16   // Side spacing
     },
     "padding": {
       "vertical": 20,    // Inner top/bottom
       "horizontal": 16   // Inner left/right
     }
   }

   Forms:
   - Fields: 24px bottom margin
   - Labels to Fields: 8px spacing
   - Between Fields: 16-24px
   - Form Sections: 32px spacing

   Lists:
   - List Items: 16px separation
   - Section Headers: 24px top margin
   - Group Spacing: 32px between groups

   Cards:
   - Between Cards: 16-24px
   - Card Padding: 16-20px
   - Card Content Spacing: 12-16px

3. Interactive Elements:
   Buttons:
   {
     "margin": {
       "vertical": 24,
       "horizontal": 16
     },
     "padding": {
       "vertical": 16-20,
       "horizontal": 24-32
     }
   }

   Input Fields:
   {
     "margin": {"bottom": 20},
     "contentPadding": {
       "vertical": 16,
       "horizontal": 20
     }
   }

4. Typography Spacing:
   - Headings: 32px bottom margin
   - Subheadings: 16px bottom margin
   - Paragraphs: 16px bottom margin
   - Line Height: 1.5 for readability
   - Letter Spacing: 0.2-0.5px

5. Spacing Scale:
   Base-8 System:
   - 8px: Minimum spacing
   - 16px: Default spacing
   - 24px: Medium spacing
   - 32px: Large spacing
   - 48px: Section spacing
   - 64px: Major section spacing

6. Component Hierarchy:
   Primary Content:
   - Largest padding (24-32px)
   - Clear separation (32-48px)

   Secondary Content:
   - Medium padding (16-24px)
   - Standard separation (24px)

   Supporting Elements:
   - Minimal padding (8-16px)
   - Closer grouping (8-16px)

7. Responsive Adjustments:
   Mobile:
   - Edge padding: 16-24px
   - Component spacing: 16-24px
   - Button padding: 16px vertical

   Tablet/Desktop:
   - Edge padding: 24-32px
   - Component spacing: 24-32px
   - Button padding: 20px vertical

Important Rules:
1. Always use consistent spacing multiples of 8
2. Maintain proper hierarchy with spacing
3. Include margins for ALL components
4. Use padding for internal spacing
5. Consider responsive behavior
6. Group related items with consistent spacing

Response Requirements:
- Every component must include explicit margin/padding
- Use the spacing scale consistently
- Maintain vertical rhythm
- Consider component hierarchy
- Follow responsive guidelines

User request: ${prompt}

Respond only with complete, valid JSON. Ensure proper nesting and include all necessary styling properties for a polished, modern UI.
''';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [{
            "parts": [
              if (_imageBytes != null)
                {
                  "inlineData": {
                    "mimeType": "image/jpeg",
                    "data": base64Encode(_imageBytes!)
                  }
                },
              {
                "text": enhancedPrompt
              }
            ]
          }],
          "generationConfig": {
            "temperature": 0.9,
            "topK": 32,
            "topP": 0.8,
            "maxOutputTokens": 10000
          }
        }),
      );

      print('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return _parseGeminiResponse(response.body);
      } else {
        throw Exception("Failed to load AI UI: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
      return _generateErrorUI("Error: $e");
    }
  }

  Map<String, dynamic> _parseGeminiResponse(String response) {
    try {
      // Parse the outer response structure
      final parsedResponse = jsonDecode(response);
      String text = parsedResponse['candidates'][0]['content']['parts'][0]['text'];

      // Remove code block markers if present
      text = text.replaceAll('```json\n', '')
          .replaceAll('```\n', '')
          .replaceAll('```', '')
          .trim();

      // Try to extract and complete valid JSON
      text = _reconstructJson(text);

      try {
        final uiJson = jsonDecode(text);
        return _validateAndFixUIJson(uiJson);
      } catch (e) {
        print('Error parsing cleaned JSON: $e');
        log('Attempted to parse JSON: $text');
        return _generateErrorUI("Error parsing JSON response");
      }
    } catch (e) {
      print('Error in Gemini response: $e');
      return _generateErrorUI("Error: Invalid response format");
    }
  }

  String _reconstructJson(String text) {
    try {
      // Stack to track nested structures
      List<String> stack = [];
      // Track if we're inside a string
      bool inString = false;
      // Track if we've hit truncation
      bool isTruncated = false;

      // Process each character
      for (int i = 0; i < text.length; i++) {
        String char = text[i];

        // Handle string boundaries
        if (char == '"' && (i == 0 || text[i - 1] != '\\')) {
          inString = !inString;
          continue;
        }

        // Skip if we're inside a string
        if (inString) continue;

        // Track opening structures
        if (char == '{' || char == '[') {
          stack.add(char);
        }
        // Track closing structures
        else if (char == '}' || char == ']') {
          if (stack.isEmpty) {
            // More closing than opening - malformed JSON
            return text;
          }
          String last = stack.removeLast();
          if ((char == '}' && last != '{') || (char == ']' && last != '[')) {
            // Mismatched brackets - malformed JSON
            return text;
          }
        }
      }

      // If we have unclosed structures, the JSON is truncated
      if (stack.isNotEmpty) {
        isTruncated = true;
      }

      if (isTruncated) {
        // Complete the truncated JSON based on stack
        String completedJson = text;

        // Close any open structures
        while (stack.isNotEmpty) {
          String structure = stack.removeLast();
          if (structure == '{') {
            // For objects, add minimal valid completion
            completedJson += '}';
          } else if (structure == '[') {
            // For arrays, add minimal valid completion
            completedJson += ']';
          }
        }

        return completedJson;
      }

      return text;
    } catch (e) {
      print('Error reconstructing JSON: $e');
      return text;
    }
  }

  Map<String, dynamic> _validateAndFixUIJson(Map<String, dynamic> json) {
    json = Map<String, dynamic>.from(json);

    // Ensure required fields
    json.putIfAbsent('type', () => 'Container');

    // Handle special cases for text fields
    _sanitizeTextFields(json);

    // Recursively validate nested structures
    json.forEach((key, value) {
      if (value is Map) {
        json[key] = _validateAndFixUIJson(Map<String, dynamic>.from(value));
      } else if (value is List) {
        json[key] = value.map((item) {
          if (item is Map) {
            return _validateAndFixUIJson(Map<String, dynamic>.from(item));
          }
          return item;
        }).toList();
      } else if (value == null) {
        json[key] = _getDefaultValueForKey(key);
      }
    });

    return json;
  }

  void _sanitizeTextFields(Map<String, dynamic> json) {
    if (json.containsKey('text')) {
      var text = json['text'];
      if (text is String) {
        // Remove any unexpected quote characters
        text = text.replaceAll('"', '');
        // Handle escaped quotes
        text = text.replaceAll('\\"', '"');
        json['text'] = text;
      }
    }
  }

  dynamic _getDefaultValueForKey(String key) {
    switch (key) {
      case 'children':
        return [];
      case 'text':
        return '';
      case 'type':
        return 'Container';
      case 'mainAxisSize':
        return 'min';
      case 'padding':
        return 16.0;
      default:
        if (key.toLowerCase().contains('alignment')) {
          return 'center';
        }
        return null;
    }
  }

  Map<String, dynamic> _generateErrorUI(String errorMessage) {
    return {
      "type": "Scaffold",
      "backgroundColor": "#FFFFFF",
      "body": {
        "type": "Center",
        "child": {
          "type": "Column",
          "mainAxisAlignment": "center",
          "crossAxisAlignment": "center",
          "mainAxisSize": "min",
          "children": [
            {
              "type": "Icon",
              "icon": "error",
              "color": "#FF0000",
              "size": 48
            },
            {
              "type": "Padding",
              "padding": 16,
              "child": {
                "type": "Text",
                "text": errorMessage,
                "style": {
                  "fontSize": 20,
                  "color": "#FF0000"
                }
              }
            }
          ]
        }
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Generated UI"),
        actions: [
          if (designHistory.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Design History'),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: designHistory.asMap().entries.map((entry) {
                          int idx = entry.key;
                          DesignHistory design = entry.value;
                          return ListTile(
                            title: Text('Design ${idx + 1}'),
                            subtitle: Text(design.prompt),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.pop(context);
                                _showPromptBottomSheet(previousPrompt: design.prompt);
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : designHistory.isEmpty
          ? const Center(
        child: Text('Click the + button below to generate UI'),
      )
          : Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              body: GeneratedUIDisplay(
                uiData: designHistory.last.uiData,
                onModify: () => _showPromptBottomSheet(
                  previousPrompt: designHistory.last.prompt,
                ),
                primaryColor: _primaryColor,
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => _navigateBack(context),
                child: const Icon(Icons.arrow_back),
              ),
            ),
          );
        },
      ),
      floatingActionButton: designHistory.isEmpty
          ? FloatingActionButton(
        onPressed: () => _showPromptBottomSheet(),
        child: const Icon(Icons.add),
      )
          : null,
    );
  }


  void _navigateBack(BuildContext context) {
    Navigator.of(context).pop();
    setState(() {
      designHistory.clear();
    });
  }

}
extension StringExtension on String {
  String repeat(int times) => List.filled(times, this).join();
}