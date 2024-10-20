import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart' as quill;

// take datetime and return local date and time
String timeFormat(DateTime time) {
  return time.toLocal().toString().split('.')[0];
}

enum OperationFilter {
  isEqualTo,
  isLessThan,
  isLessThanOrEqualTo,
  isGreaterThan,
  isGreaterThanOrEqualTo,
  whereIn,
  arrayContains,
  arrayContainsAny,
  isNull,
  isNotEqualTo,
  whereNotIn,
}

String encodeQuillContent(quill.QuillController controller) {
  final doc = controller.document.toDelta();
  return jsonEncode(doc.toJson());
}

/// Decodes a given JSON string into a [quill.Document] object.
/// The JSON string should be a serialized [quill.Delta] object.
///
quill.Document decodeQuillContent(String jsonString) {
  final List<dynamic> decodedJson = jsonDecode(jsonString);
  return quill.Document.fromJson(decodedJson);
}

// String convertJsonToPlainText(String jsonString) {
//   try {
//     final List<dynamic> decodedJson = jsonDecode(jsonString);
//     final quill.Document doc = quill.Document.fromJson(decodedJson);
//     return doc.toPlainText(); // Extract plain text from the document
//   } catch (e) {
//     debugPrint('Error in convertJsonToPlainText: $e');
//     return '';
//   }
// }

String convertJsonToPlainText(String jsonString) {
  // Decode the JSON string into a list of maps
  List<dynamic> delta;
  try {
    delta = json.decode(jsonString);
  } catch (e) {
    print('Failed to decode JSON: $e');
    return '';
  }

  StringBuffer plainText = StringBuffer();
  int bulletPointIndex = 1; // For numbering bullet points if needed

  for (var item in delta) {
    if (item.containsKey('insert')) {
      // Add the insert text
      String insertText = item['insert'];

      // Append the insert text to plainText
      plainText.write(insertText);
    }

    if (item.containsKey('attributes')) {
      // Check for list attributes
      if (item['attributes'].containsKey('list')) {
        String listType = item['attributes']['list'];

        if (listType == 'bullet') {
          // If it's a bullet point, append a newline and a bullet symbol
          plainText
              .write('\n* '); // You can change "* " to any bullet character
        } else if (listType == 'ordered') {
          // If it's an ordered list, append the current index as a number
          plainText.write(
              '\n${bulletPointIndex++}. '); // Increment for each numbered list item
        }
      }

      // Handle other text formatting (like bold, italic, underline, etc.)
      // You can modify how these formats appear in the plain text if desired
      if (item['attributes'].containsKey('bold')) {
        // Add a marker for bold (you can use "*" for Markdown style)
        plainText.write('**'); // Start of bold
      }
      if (item['attributes'].containsKey('italic')) {
        // Add a marker for italic
        plainText.write('_'); // Start of italic
      }
      if (item['attributes'].containsKey('underline')) {
        // Add a marker for underline (optional)
        plainText.write('~'); // Start of underline
      }

      // At the end of the attributes, add end markers
      if (item['attributes'].containsKey('bold')) {
        plainText.write('**'); // End of bold
      }
      if (item['attributes'].containsKey('italic')) {
        plainText.write('_'); // End of italic
      }
      if (item['attributes'].containsKey('underline')) {
        plainText.write('~'); // End of underline
      }
    }
  }

  return plainText
      .toString()
      .trim(); // Remove any leading or trailing whitespace
}
