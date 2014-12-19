library test;

import 'package:unittest/unittest.dart';
//import 'package:unittest/html_enhanced_config.dart';

//-----------------------------------------------------------------------------
// Logging

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:validate/validate.dart';

part 'src/validate_test.dart';

//
// Mehr Infos: http://www.dartlang.org/articles/dart-unit-tests/
//
main() {
  //useHtmlEnhancedConfiguration();
  configLogging();

  testValidate();
}

void configLogging() {
  hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

  // now control the logging.
  // Turn off all logging first
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen(new LogConsoleHandler());
}