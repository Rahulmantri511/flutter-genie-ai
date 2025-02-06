// ui_builder.dart
import 'package:flutter/material.dart';

class FlutterUIBuilder {
  final Color primaryColor;
  final BuildContext context;


  FlutterUIBuilder({required this.primaryColor,required this.context,
  });
  Color _hexToColor(String hex) {
    try {
      // Remove # and spaces
      hex = hex.replaceAll('#', '').replaceAll(' ', '');

      // Basic validation for hex format
      if (!RegExp(r'^[0-9A-Fa-f]{6,8}$').hasMatch(hex)) {
        throw FormatException('Invalid hex color format');
      }

      // Add FF prefix for alpha if needed
      if (hex.length == 6) {
        hex = 'FF' + hex;
      }

      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      print('Error parsing color: $e');
      return primaryColor;
    }
  }

  Color _parseColor(dynamic colorStr) {
    if (colorStr == null) return primaryColor;

    if (colorStr is String) {
      final String cleanColorStr = colorStr.toLowerCase().trim();

      // Handle named colors first
      final Map<String, Color> colorMap = {
        'blue': Colors.blue,
        'red': Colors.red,
        'green': Colors.green,
        'yellow': Colors.yellow,
        'purple': Colors.purple,
        'orange': Colors.orange,
        'black': Colors.black,
        'white': Colors.white,
        'grey': Colors.grey,
        'gray': Colors.grey,
        // Add material shades
        'blue.100': Colors.blue[100]!,
        'blue.200': Colors.blue[200]!,
        'blue.300': Colors.blue[300]!,
        'blue.400': Colors.blue[400]!,
        'blue.500': Colors.blue[500]!,
        'blue.600': Colors.blue[600]!,
        'blue.700': Colors.blue[700]!,
        'blue.800': Colors.blue[800]!,
        'blue.900': Colors.blue[900]!,
      };

      // Check for named color first
      if (colorMap.containsKey(cleanColorStr)) {
        return colorMap[cleanColorStr]!;
      }

      // Then try hex color if it looks like a hex value
      if (cleanColorStr.startsWith('#')) {
        return _hexToColor(cleanColorStr);
      }
    }

    // Return primary color if no valid color found
    return primaryColor;
  }

  Widget buildUIFromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'Scaffold':
        return _buildScaffold(json);
      case 'AppBar':
        return _buildAppBar(json);
      case 'SingleChildScrollView':
        return _buildSingleChildScrollView(json);
        case 'Center':
        return _Center(json);
      case 'Column':
        return _buildColumn(json);
      case 'Row':
        return _buildRow(json);
      case 'Container':
        return _buildContainer(json);
      case 'TextField':
        return _buildTextField(json);
      case 'ElevatedButton':
        return _buildElevatedButton(json);
      case 'Text':
        return _buildText(json);
      case 'Card':
        return _buildCard(json);
      case 'Image':
        return _buildImage(json);
      case 'Icon':
        return _buildIcon(json);
      case 'Divider':
        return _buildDivider(json);
      case 'Stack':
        return _buildStack(json);
      case 'Padding':
        return _buildPadding(json);
      case 'Center':
        return _buildCenter(json);
      case 'ListView':
        return _buildListView(json);
      case 'CircleAvatar':
        return _buildCircleAvatar(json);
      case 'ListTile':
        return _buildListTile(json);
      case 'SafeArea':
        return _buildSafeArea(json);
      case 'Checkbox':
        return _buildCheckbox(json);
      case 'TextButton':
        return _buildTextButton(json);
      case 'IconButton':
        return _buildIconButton(json);
      default:
        return Container();
    }
  }

  Widget _buildScaffold(Map<String, dynamic> json) {
    PreferredSizeWidget? appBar;
    if (json['appBar'] != null) {
      if (json['appBar']['type'] == 'AppBar') {
        appBar = _buildAppBar(json['appBar']);
      } else {
        print('Warning: appBar must be of type "AppBar"');
      }
    }

    return Scaffold(
      appBar: appBar,
      body: json['body'] != null
          ? buildUIFromJson(json['body'])
          : null,
      backgroundColor: json['backgroundColor'] != null
          ? _parseColor(json['backgroundColor'])
          : null,
      floatingActionButton: json['floatingActionButton'] != null
          ? buildUIFromJson(json['floatingActionButton'])
          : null,
    );
  }

  PreferredSizeWidget _buildAppBar(Map<String, dynamic> json) {
    return AppBar(
      title: json['title'] != null
          ? buildUIFromJson(json['title'])
          : null,
      backgroundColor: json['backgroundColor'] != null
          ? _parseColor(json['backgroundColor'])
          : null,
      actions: json['actions'] != null
          ? List<Widget>.from(_buildChildren(json['actions']))
          : null,
      leading: json['leading'] != null
          ? buildUIFromJson(json['leading'])
          : null,
      centerTitle: json['centerTitle'] ?? false,
      elevation: json['elevation']?.toDouble(),
    );
  }


  Widget _buildSingleChildScrollView(Map<String, dynamic> json) {
    return SingleChildScrollView(
      scrollDirection: _getAxis(json['scrollDirection']),
      child: Container(
        width: double.infinity,  // This ensures full width
        child: json['child'] != null ? buildUIFromJson(json['child']) : Container(),
      ),
    );
  }

  Widget _Center(Map<String, dynamic> json) {
    return Center(
      child: json['child'] != null ? buildUIFromJson(json['child']) : null,
    );
  }

  Widget _buildListTile(Map<String, dynamic> json) {
    Widget? leadingWidget;
    if (json['leading'] != null) {
      if (json['leading'] is Map<String, dynamic>) {
        final leadingMap = json['leading'] as Map<String, dynamic>;
        if (leadingMap['type'] == 'Icon') {
          leadingWidget = Icon(
            _getIconData(leadingMap['icon']),
            color: leadingMap['color'] != null ?
            _parseColor(leadingMap['color']) :
            primaryColor,
            size: leadingMap['size']?.toDouble() ?? 24.0,
          );
        } else {
          leadingWidget = buildUIFromJson(leadingMap);
        }
      }
    }

    Widget? titleWidget;
    if (json['title'] != null) {
      if (json['title'] is Map<String, dynamic>) {
        titleWidget = buildUIFromJson(json['title']);
      } else if (json['title'] is String) {
        titleWidget = Text(json['title']);
      }
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1.0,
          ),
        ),
      ),
      child: ListTile(
        leading: leadingWidget,
        title: titleWidget,
        subtitle: json['subtitle'] != null ?
        buildUIFromJson(json['subtitle']) :
        null,
        trailing: json['trailing'] != null ?
        buildUIFromJson(json['trailing']) :
        null,
        onTap: () {},
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0
        ),
        dense: json['dense'] ?? false,
        enabled: json['enabled'] ?? true,
      ),
    );
  }

  Widget _buildColumn(Map<String, dynamic> json) {
    // Create the base column widget
    Widget column = Column(
      crossAxisAlignment: _getCrossAxisAlignment(json['crossAxisAlignment']),
      mainAxisAlignment: _getMainAxisAlignment(json['mainAxisAlignment']),
      mainAxisSize: _getMainAxisSize(json['mainAxisSize']),
      children: _buildChildren(json['children']),
    );

    // Check if we need to make the column scrollable
    bool shouldScroll = json['scroll'] == true || json['scrollable'] == true;

    // Parse height using _parseSize helper
    final height = _parseSize(json['height'], isWidth: false);
    final hasHeight = height != null;

    // If a specific height is provided, wrap in SizedBox
    if (hasHeight) {
      column = SizedBox(
        height: height,
        child: column,
      );
    }

    // If margin is specified, wrap in Container
    if (json['margin'] != null) {
      column = Container(
        margin: _getEdgeInsets(json['margin']),
        child: column,
      );
    }

    // If scrollable is specified or no height constraint is given, wrap in SingleChildScrollView
    if (shouldScroll || (!hasHeight && json['parent'] != 'ListView')) {
      return SingleChildScrollView(
        child: column,
      );
    }

    // If this column is inside a flex container and should expand
    if (json['expand'] == true || json['flex'] != null) {
      return Expanded(
        flex: json['flex']?.toInt() ?? 1,
        child: column,
      );
    }

    return column;
  }

// Helper method for parsing sizes
  double? _parseSize(dynamic value, {bool isWidth = true}) {
    if (value == null) return null;

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      if (value.endsWith('%')) {
        final percentage = double.tryParse(value.replaceAll('%', '')) ?? 100;
        final screenSize = MediaQuery.of(context).size;
        return (isWidth ? screenSize.width : screenSize.height) * (percentage / 100);
      }
      return double.tryParse(value);
    }

    if (value is Map) {
      // Handle cases where height/width is specified as a map with units
      if (value['value'] != null) {
        return _parseSize(value['value'], isWidth: isWidth);
      }
    }

    return null;
  }
  List<Widget> _buildChildren(List? children) {
    if (children == null) return [];

    return children.map((child) {
      if (child is Map<String, dynamic>) {
        // Add parent context to child
        child['parent'] = child['type'];

        // Handle flexible sizing for children
        if (child['expand'] == true || child['flex'] != null) {
          return Expanded(
            flex: child['flex']?.toInt() ?? 1,
            child: buildUIFromJson(child),
          );
        }

        // Add padding if specified
        if (child['padding'] != null) {
          return Padding(
            padding: _getEdgeInsets(child['padding']),
            child: buildUIFromJson(child),
          );
        }
      }

      return buildUIFromJson(child);
    }).toList();
  }


  Widget _buildRow(Map<String, dynamic> json) {
    return Row(
      crossAxisAlignment: _getCrossAxisAlignment(json['crossAxisAlignment']),
      mainAxisAlignment: _getMainAxisAlignment(json['mainAxisAlignment']),
      mainAxisSize: _getMainAxisSize(json['mainAxisSize']),
      children: _buildChildren(json['children']),
    );
  }

// Add these methods to your FlutterUIBuilder class

  Gradient? _parseGradient(Map<String, dynamic>? gradientData) {
    if (gradientData == null) return null;

    List<Color> colors = (gradientData['colors'] as List?)
        ?.map((c) => _parseColor(c))
        ?.toList() ??
        [Colors.transparent, Colors.transparent];

    Alignment begin = _parseAlignment(gradientData['begin']) ?? Alignment.topCenter;
    Alignment end = _parseAlignment(gradientData['end']) ?? Alignment.bottomCenter;

    return LinearGradient(
      colors: colors,
      begin: begin,
      end: end,
    );
  }

  List<BoxShadow>? _parseShadows(List? shadows) {
    if (shadows == null) return null;

    return shadows.map((shadow) {
      if (shadow is Map<String, dynamic>) {
        Color color = _parseColor(shadow['color'] ?? '#00000020');
        double blurRadius = (shadow['blurRadius'] ?? 10).toDouble();
        double spreadRadius = (shadow['spreadRadius'] ?? 0).toDouble();
        Map<String, dynamic>? offset = shadow['offset'] as Map<String, dynamic>?;

        return BoxShadow(
          color: color,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
          offset: offset != null
              ? Offset(
            (offset['dx'] ?? 0).toDouble(),
            (offset['dy'] ?? 0).toDouble(),
          )
              : const Offset(0, 2),
        );
      }
      return const BoxShadow(
        color: Colors.black12,
        blurRadius: 10,
        offset: Offset(0, 2),
      );
    }).toList();
  }

// Update _buildContainer to use these new methods
  double? _getSizeValue(dynamic value) {
    if (value == null) return null;

    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value);
    }
    if (value is Map<String, dynamic>) {
      if (value.containsKey('value')) {
        return _getSizeValue(value['value']);
      }
    }
    return null;
  }

  Widget _buildContainer(Map<String, dynamic> json) {
    final decoration = json['decoration'] as Map<String, dynamic>?;

    // Get color or gradient
    Color? containerColor;
    Gradient? gradient;

    if (decoration != null) {
      if (decoration['gradient'] != null) {
        gradient = _parseGradient(decoration['gradient']);
      } else if (decoration['color'] != null) {
        containerColor = _hexToColor(decoration['color']);
      }
    } else if (json['backgroundColor'] != null) {
      containerColor = _hexToColor(json['backgroundColor']);
    } else if (json['color'] != null) {
      containerColor = _hexToColor(json['color']);
    }

    // Parse other decoration properties
    BorderRadius? borderRadius = decoration?['borderRadius'] != null
        ? _getBorderRadius(decoration!['borderRadius'])
        : null;

    List<BoxShadow>? shadows = decoration?['boxShadow'] != null
        ? _parseShadows(decoration!['boxShadow'] as List?)
        : null;

    // Handle dimensions that could be numbers, strings, or maps
    double? width = _getSizeValue(json['width']);
    double? height = _getSizeValue(json['height']);

    // Handle percentage-based dimensions
    if (json['width'] is String && json['width'].toString().endsWith('%')) {
      final percentage = double.tryParse(json['width'].toString().replaceAll('%', '')) ?? 100;
      width = MediaQuery.of(context).size.width * (percentage / 100);
    }
    if (json['height'] is String && json['height'].toString().endsWith('%')) {
      final percentage = double.tryParse(json['height'].toString().replaceAll('%', '')) ?? 100;
      height = MediaQuery.of(context).size.height * (percentage / 100);
    }

    return Container(
      width: width,
      height: height,
      padding: _getEdgeInsets(json['padding']),
      margin: _getEdgeInsets(json['margin']),
      decoration: BoxDecoration(
        color: containerColor,
        gradient: gradient,
        borderRadius: borderRadius,
        boxShadow: shadows,
      ),
      child: json['child'] != null ? buildUIFromJson(json['child']) : null,
    );
  }

  BorderRadius _getBorderRadius(dynamic value) {
    if (value == null) return BorderRadius.zero;

    if (value is num) {
      return BorderRadius.circular(value.toDouble());
    }

    if (value is Map<String, dynamic>) {
      return BorderRadius.only(
        topLeft: Radius.circular(value['topLeft']?.toDouble() ?? 0),
        topRight: Radius.circular(value['topRight']?.toDouble() ?? 0),
        bottomLeft: Radius.circular(value['bottomLeft']?.toDouble() ?? 0),
        bottomRight: Radius.circular(value['bottomRight']?.toDouble() ?? 0),
      );
    }

    return BorderRadius.zero;
  }

// Update the _buildTextField method's decoration handling
  Widget _buildTextField(Map<String, dynamic> json) {
    InputDecoration inputDecoration = InputDecoration();

    try {
      if (json.containsKey('decoration')) {
        final decoration = json['decoration'];
        if (decoration is Map<String, dynamic>) {
          // Handle border
          InputBorder? border;
          if (decoration['border'] is Map<String, dynamic>) {
            final borderData = decoration['border'];
            if (borderData['type'] == 'OutlineInputBorder') {
              border = OutlineInputBorder(
                borderRadius: _getBorderRadius(borderData['borderRadius']),
                borderSide: borderData['borderSide'] == 'none'
                    ? BorderSide.none
                    : const BorderSide(),
              );
            }
          } else if (decoration['border'] == 'underline') {
            border = const UnderlineInputBorder();
          }

          // Handle content padding
          EdgeInsets? contentPadding;
          if (decoration['contentPadding'] is Map<String, dynamic>) {
            contentPadding = _getEdgeInsets(decoration['contentPadding']);
          }

          inputDecoration = InputDecoration(
            labelText: decoration['labelText']?.toString(),
            hintText: decoration['hintText']?.toString(),
            hintStyle: TextStyle(
              color: _parseColor(decoration['hintStyle']?['color']),
              fontSize: decoration['hintStyle']?['fontSize']?.toDouble(),
            ),
            border: border,
            enabledBorder: border,
            focusedBorder: border,
            filled: decoration['filled'] == true,
            fillColor: decoration['fillColor'] != null
                ? _hexToColor(decoration['fillColor'])
                : null,
            contentPadding: contentPadding,
          );
        }
      }

      // Create the text field
      Widget textField = TextField(
        decoration: inputDecoration,
        obscureText: json['obscureText'] == true,
        style: TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      );

      // If margin is specified, wrap in a container
      if (json['margin'] != null) {
        return Container(
          margin: _getEdgeInsets(json['margin']),
          child: textField,
        );
      }

      // If there's no margin specified but we want consistent spacing
      return Container(
        margin: const EdgeInsets.only(bottom: 16), // Default bottom margin
        child: textField,
      );

    } catch (e) {
      print('Error building TextField: $e');
      return TextField(
        decoration: InputDecoration(
          labelText: 'Error in TextField',
          errorText: e.toString(),
        ),
      );
    }
  }
  Widget _buildElevatedButton(Map<String, dynamic> json) {
    final style = json['style'] as Map<String, dynamic>?;

    return SizedBox(
      width: double.infinity,
      height: json['height']?.toDouble(),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: json['backgroundColor'] != null
              ? _hexToColor(json['backgroundColor'])
              : primaryColor,
          foregroundColor: json['textColor'] != null
              ? _hexToColor(json['textColor'])
              : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: style != null
                ? _getBorderRadius(style['borderRadius'])
                : BorderRadius.circular(8),
          ),
        ),
        child: Text(
          json['text'] ?? 'Button',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }


  Widget _buildText(Map<String, dynamic> json) {
    final style = json['style'] as Map<String, dynamic>?;

    // Get the text content, checking both 'text' and 'data' fields
    final String textContent = json['text']?.toString() ??
        json['data']?.toString() ?? '';

    return Text(
      textContent,
      style: TextStyle(
        color: style?['color'] != null ?
        _parseColor(style!['color']) :
        (json['color'] != null ? _parseColor(json['color']) : null),
        fontSize: style?['fontSize']?.toDouble(),
        fontWeight: _getFontWeight(style?['fontWeight']?.toString()),
        letterSpacing: style?['letterSpacing']?.toDouble(),
        height: style?['height']?.toDouble(),
        decoration: _getTextDecoration(style?['decoration']),
      ),
      textAlign: _getTextAlign(json['textAlign']),
      maxLines: json['maxLines'],
      overflow: _getTextOverflow(json['overflow']),
    );
  }

  Widget _buildCard(Map<String, dynamic> json) {
    // Parse border properties
    final borderWidth = json['borderWidth']?.toDouble() ?? 0.0;
    final borderRadius = json['borderRadius']?.toDouble() ?? 8.0;
    final borderColor = _parseColor(json['borderColor'] as String?);

    return Card(
      elevation: json['elevation']?.toDouble() ?? 1.0,
      color: _parseColor(json['color'] as String?),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: borderWidth > 0
            ? BorderSide(
          color: borderColor,
          width: borderWidth,
        )
            : BorderSide.none,
      ),
      margin: json['margin'] is Map
          ? EdgeInsets.only(
        top: (json['margin']['top'] ?? 0.0).toDouble(),
        bottom: (json['margin']['bottom'] ?? 0.0).toDouble(),
        left: (json['margin']['left'] ?? 0.0).toDouble(),
        right: (json['margin']['right'] ?? 0.0).toDouble(),
      )
          : null,
      child: json['child'] != null ? buildUIFromJson(json['child']) : null,
    );
  }
  Widget _buildImage(Map<String, dynamic> json) {
    return json['url'] != null
        ? Image.network(
      json['url'],
      width: json['width']?.toDouble(),
      height: json['height']?.toDouble(),
      fit: _getBoxFit(json['fit']),
    )
        : const Placeholder();
  }

  Widget _buildIcon(Map<String, dynamic> json) {
    return Icon(
      _getIconData(json['icon']),
      color: json['color'] != null ? _hexToColor(json['color']) : primaryColor,
      size: json['size']?.toDouble(),
    );
  }

  Widget _buildDivider(Map<String, dynamic> json) {
    return Divider(
      height: json['height']?.toDouble() ?? 1.0,
      thickness: json['thickness']?.toDouble() ?? 1.0,
      color: json['color'] != null ? _hexToColor(json['color']) : Colors.grey,
    );
  }

  Widget _buildStack(Map<String, dynamic> json) {
    return Stack(
      alignment: _getAlignment(json['alignment']),
      children: _buildChildren(json['children']),
    );
  }

  Widget _buildPadding(Map<String, dynamic> json) {
    return Padding(
      padding: _getEdgeInsets(json['padding']),
      child: json['child'] != null ? buildUIFromJson(json['child']) : null,
    );
  }

  Widget _buildCenter(Map<String, dynamic> json) {
    return Center(
      child: json['child'] != null ? buildUIFromJson(json['child']) : null,
    );
  }

  Widget _buildListView(Map<String, dynamic> json) {
    return ListView(
      scrollDirection: _getAxis(json['scrollDirection']),
      children: _buildChildren(json['children']),
    );
  }

  Widget _buildCircleAvatar(Map<String, dynamic> json) {
    return CircleAvatar(
      radius: json['radius']?.toDouble() ?? 20.0,
      backgroundColor: json['backgroundColor'] != null ?
      _hexToColor(json['backgroundColor']) : primaryColor,
      child: json['child'] != null ? buildUIFromJson(json['child']) : null,
    );
  }



  // Helper methods for converting string values to Flutter enums
  CrossAxisAlignment _getCrossAxisAlignment(String? value) {
    switch (value) {
      case 'start': return CrossAxisAlignment.start;
      case 'end': return CrossAxisAlignment.end;
      case 'center': return CrossAxisAlignment.center;
      case 'stretch': return CrossAxisAlignment.stretch;
      case 'baseline': return CrossAxisAlignment.baseline;
      default: return CrossAxisAlignment.center;
    }
  }

  MainAxisAlignment _getMainAxisAlignment(String? value) {
    switch (value) {
      case 'start': return MainAxisAlignment.start;
      case 'end': return MainAxisAlignment.end;
      case 'center': return MainAxisAlignment.center;
      case 'spaceBetween': return MainAxisAlignment.spaceBetween;
      case 'spaceAround': return MainAxisAlignment.spaceAround;
      case 'spaceEvenly': return MainAxisAlignment.spaceEvenly;
      default: return MainAxisAlignment.start;
    }
  }

  MainAxisSize _getMainAxisSize(String? value) {
    switch (value) {
      case 'min': return MainAxisSize.min;
      case 'max': return MainAxisSize.max;
      default: return MainAxisSize.max;
    }
  }

  EdgeInsets _getEdgeInsets(dynamic value) {
    if (value == null) return EdgeInsets.zero;
    if (value is num) return EdgeInsets.all(value.toDouble());
    if (value is Map<String, dynamic>) {
      return EdgeInsets.only(
        left: value['left']?.toDouble() ?? 0.0,
        right: value['right']?.toDouble() ?? 0.0,
        top: value['top']?.toDouble() ?? 0.0,
        bottom: value['bottom']?.toDouble() ?? 0.0,
      );
    }
    return EdgeInsets.zero;
  }

  IconData _getIconData(String? value) {
    switch (value?.toLowerCase()) {
    // Currently used icons in the response
      case 'settings': return Icons.settings;
      case 'arrow_forward_ios': return Icons.arrow_forward_ios;
      case 'fingerprint': return Icons.fingerprint;
      case 'brightness_3': return Icons.brightness_3;
      case 'info': return Icons.info;
      case 'chat_bubble': return Icons.chat_bubble;
      case 'logout': return Icons.logout;
      case 'email': return Icons.email;

    // Other common icons
      case 'lock': return Icons.lock;
      case 'person': return Icons.person;
      case 'home': return Icons.home;
      case 'visibility': return Icons.visibility;
      case 'bookmark': return Icons.bookmark;
      case 'notifications': return Icons.notifications;
      case 'favorite': return Icons.favorite;
      case 'star': return Icons.star;
      case 'search': return Icons.search;
      case 'account_circle': return Icons.account_circle;
      case 'menu': return Icons.menu;
      case 'more_vert': return Icons.more_vert;
      case 'share': return Icons.share;
      case 'delete': return Icons.delete;
      case 'edit': return Icons.edit;
      case 'add': return Icons.add;
      case 'remove': return Icons.remove;
      case 'done': return Icons.done;
      case 'close': return Icons.close;
      case 'arrow_back': return Icons.arrow_back;
      case 'download': return Icons.download;
      default: return Icons.circle;
    }
  }
  Widget _buildSafeArea(Map<String, dynamic> json) {
    return SafeArea(
      child: json['child'] != null ? buildUIFromJson(json['child']) : Container(),
    );
  }

  Widget _buildCheckbox(Map<String, dynamic> json) {
    return Checkbox(
      value: json['value'] ?? false,
      onChanged: (bool? value) {},
      activeColor: _parseColor(json['activeColor'] ?? '#46A695'),
    );
  }

  Widget _buildTextButton(Map<String, dynamic> json) {
    return TextButton(
      onPressed: () {},
      child: json['child'] != null ? buildUIFromJson(json['child']) : Container(),
      style: TextButton.styleFrom(
        foregroundColor: _parseColor(json['textColor'] ?? '#666666'),
        padding: _getEdgeInsets(json['padding']),
      ),
    );
  }

  Widget _buildIconButton(Map<String, dynamic> json) {
    // Handle icon property that can be either a string or a map
    Widget iconWidget;

    if (json['icon'] is String) {
      // Direct icon name
      iconWidget = Icon(
        _getIconData(json['icon']),
        color: json['color'] != null ? _hexToColor(json['color']) : primaryColor,
        size: json['size']?.toDouble() ?? 24.0,
      );
    } else if (json['icon'] is Map<String, dynamic>) {
      // Icon with specific properties
      final iconData = json['icon'] as Map<String, dynamic>;
      iconWidget = Icon(
        _getIconData(iconData['icon']),
        color: iconData['color'] != null ? _hexToColor(iconData['color']) : primaryColor,
        size: iconData['size']?.toDouble() ?? 24.0,
      );
    } else {
      // Fallback icon
      iconWidget = Icon(
        Icons.circle,
        color: primaryColor,
        size: 24.0,
      );
    }

    // Get button style if provided
    final style = json['style'] as Map<String, dynamic>?;

    // Create the IconButton
    return Container(
      decoration: style != null && style['border'] != null
          ? BoxDecoration(
        border: _buildBorder(style['border']),
        borderRadius: style['border'] is Map<String, dynamic>
            ? _getBorderRadius(style['border']['borderRadius'])
            : null,
      )
          : null,
      child: IconButton(
        icon: iconWidget,
        onPressed: () {},
        padding: _getEdgeInsets(json['padding']) ?? const EdgeInsets.all(8.0),
        constraints: json['size'] != null
            ? BoxConstraints.tightFor(
          width: json['size'].toDouble(),
          height: json['size'].toDouble(),
        )
            : null,
      ),
    );
  }

// Helper method to build border
  Border? _buildBorder(dynamic borderData) {
    if (borderData == null) return null;

    if (borderData is Map<String, dynamic>) {
      if (borderData['borderSide'] is Map<String, dynamic>) {
        final side = borderData['borderSide'];
        return Border.all(
          color: _parseColor(side['color'] ?? '#CCCCCC'),
          width: (side['width'] ?? 1.0).toDouble(),
        );
      }
    }

    return Border.all(
      color: Colors.grey.shade300,
      width: 1.0,
    );
  }
  TextInputType _getTextInputType(String? value) {
    switch (value) {
      case 'text': return TextInputType.text;
      case 'number': return TextInputType.number;
      case 'email': return TextInputType.emailAddress;
      case 'phone': return TextInputType.phone;
      case 'multiline': return TextInputType.multiline;
      default: return TextInputType.text;
    }
  }

  FontWeight _getFontWeight(String? value) {
    switch (value) {
      case 'bold': return FontWeight.bold;
      case 'normal': return FontWeight.normal;
      case 'w100': return FontWeight.w100;
      case 'w200': return FontWeight.w200;
      case 'w300': return FontWeight.w300;
      case 'w400': return FontWeight.w400;
      case 'w500': return FontWeight.w500;
      case 'w600': return FontWeight.w600;
      case 'w700': return FontWeight.w700;
      case 'w800': return FontWeight.w800;
      case 'w900': return FontWeight.w900;
      default: return FontWeight.normal;
    }
  }

  TextDecoration _getTextDecoration(String? value) {
    switch (value) {
      case 'underline': return TextDecoration.underline;
      case 'lineThrough': return TextDecoration.lineThrough;
      case 'overline': return TextDecoration.overline;
      default: return TextDecoration.none;
    }
  }

  TextAlign _getTextAlign(String? value) {
    switch (value) {
      case 'left': return TextAlign.left;
      case 'right': return TextAlign.right;
      case 'center': return TextAlign.center;
      case 'justify': return TextAlign.justify;
      default: return TextAlign.left;
    }
  }

  TextOverflow _getTextOverflow(String? value) {
    switch (value) {
      case 'ellipsis': return TextOverflow.ellipsis;
      case 'clip': return TextOverflow.clip;
      case 'fade': return TextOverflow.fade;
      default: return TextOverflow.clip;
    }
  }

  BoxFit _getBoxFit(String? value) {
    switch (value) {
      case 'cover': return BoxFit.cover;
      case 'contain': return BoxFit.contain;
      case 'fill': return BoxFit.fill;
      case 'fitWidth': return BoxFit.fitWidth;
      case 'fitHeight': return BoxFit.fitHeight;
      case 'none': return BoxFit.none;
      default: return BoxFit.cover;
    }
  }

  Alignment _getAlignment(String? value) {
    switch (value) {
      case 'topLeft': return Alignment.topLeft;
      case 'topCenter': return Alignment.topCenter;
      case 'topRight': return Alignment.topRight;
      case 'centerLeft': return Alignment.centerLeft;
      case 'center': return Alignment.center;
      case 'centerRight': return Alignment.centerRight;
      case 'bottomLeft': return Alignment.bottomLeft;
      case 'bottomCenter': return Alignment.bottomCenter;
      case 'bottomRight': return Alignment.bottomRight;
      default: return Alignment.center;
    }
  }

  // Add this method to your FlutterUIBuilder class

  Alignment? _parseAlignment(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      switch (value.toLowerCase()) {
        case 'topleft':
        case 'top_left':
        case 'top-left':
          return Alignment.topLeft;
        case 'topcenter':
        case 'top_center':
        case 'top-center':
        case 'top':
          return Alignment.topCenter;
        case 'topright':
        case 'top_right':
        case 'top-right':
          return Alignment.topRight;
        case 'centerleft':
        case 'center_left':
        case 'center-left':
        case 'left':
          return Alignment.centerLeft;
        case 'center':
          return Alignment.center;
        case 'centerright':
        case 'center_right':
        case 'center-right':
        case 'right':
          return Alignment.centerRight;
        case 'bottomleft':
        case 'bottom_left':
        case 'bottom-left':
          return Alignment.bottomLeft;
        case 'bottomcenter':
        case 'bottom_center':
        case 'bottom-center':
        case 'bottom':
          return Alignment.bottomCenter;
        case 'bottomright':
        case 'bottom_right':
        case 'bottom-right':
          return Alignment.bottomRight;
        default:
          return Alignment.center;
      }
    }

    // Handle cases where alignment is specified as x, y coordinates
    if (value is Map<String, dynamic>) {
      double x = (value['x'] ?? 0.0).toDouble();
      double y = (value['y'] ?? 0.0).toDouble();
      return Alignment(x, y);
    }

    return null;
  }

  Axis _getAxis(String? value) {
    switch (value) {
      case 'horizontal': return Axis.horizontal;
      case 'vertical': return Axis.vertical;
      default: return Axis.vertical;
    }
  }
}