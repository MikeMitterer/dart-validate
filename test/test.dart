// ----------------------------------------------------------------------------
// Start der Tests mit:
//      pub run test test/test.dart
//
library test;

import 'package:test/test.dart';

//-----------------------------------------------------------------------------
// Logging

import 'package:logging/logging.dart';
import 'package:logging_handlers/logging_handlers_shared.dart';

import 'package:validate/validate.dart';

part 'src/validate_test.dart';

main() {
  configLogging();
  testValidate();
}

void configLogging() {
  hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

  // now control the logging.
  // Turn off all logging first
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen(new LogPrintHandler());
}