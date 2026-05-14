import 'dart:io';

void main() {
  final dir = Directory('lib');
  final pattern = RegExp(r'AppStyles\.style([A-Za-z0-9_]+)\b(?!\()');
  int count = 0;

  for (final entity in dir.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final content = entity.readAsStringSync();
      if (pattern.hasMatch(content)) {
        final newContent = content.replaceAllMapped(pattern, (match) {
          return 'AppStyles.style${match.group(1)}(context)';
        });
        entity.writeAsStringSync(newContent);
        print('Updated ${entity.path}');
        count++;
      }
    }
  }
  print('Total files updated: $count');
}
