library test;

import 'package:unittest/unittest.dart';
//import 'package:unittest/html_enhanced_config.dart';

import 'package:validate/validate.dart';

part 'src/validate_test.dart';

//
// Mehr Infos: http://www.dartlang.org/articles/dart-unit-tests/
//
main() {
  //useHtmlEnhancedConfiguration();
  testValidate();
}