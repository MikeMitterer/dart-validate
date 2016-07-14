import 'package:test/test.dart';

import 'package:logging/logging.dart';
import 'package:logging_handlers/logging_handlers_shared.dart';
import 'package:validate/validate.dart';

class _NotAJsonObject {
    final String message = "I am not the right one";
}

class _IAmAJsonObject extends _NotAJsonObject {
    dynamic toJson() {
        return [ message];
    }
}

main() {
    // final _logger = new Logger('validate.testValidate');
    configLogging();

    group('Validator-Test', () {
        test('isTrue', () {
            expect(() => (Validate.isTrue(true)), returnsNormally);
            expect(() => (Validate.isTrue(false)), throwsA(new isInstanceOf<ArgumentError>()));
        });

        test('> notNull', () {
            expect(() => (Validate.notNull("Test")), returnsNormally);
            expect(() => (Validate.notNull(null)), throwsA(new isInstanceOf<ArgumentError>()));
        });

        test('> notEmpty', () {
            expect(() => (Validate.notEmpty("Test")), returnsNormally);
            expect(() => (Validate.notEmpty([10, 20])), returnsNormally);

            final Map<String, Object> map = new Map<String, Object>();
            expect(() => (Validate.notEmpty(map)), throwsA(new isInstanceOf<ArgumentError>()));

            map["Hallo"] = "Test";
            expect(() => (Validate.notEmpty(map)), returnsNormally);

            // int has not Method "isEmpty"
            expect(() => (Validate.notEmpty(0)), throwsA(new isInstanceOf<NoSuchMethodError>()));

            expect(() => (Validate.notEmpty("")), throwsA(new isInstanceOf<ArgumentError>()));
        });

        test('> notBlank', () {
            expect(() => (Validate.notBlank("Test")), returnsNormally);
            expect(() => (Validate.notBlank(null)), throwsA(new isInstanceOf<ArgumentError>()));
            expect(() => (Validate.notBlank("")), throwsA(new isInstanceOf<ArgumentError>()));

            // Dart should point out at least a warning!!!!
            //expect(() => (Validate.notBlank(10)),throwsA(new isInstanceOf<ArgumentError>()));
        });

        test('> noNullElements', () {
            expect(() => (Validate.noNullElements([1, 2, 3, 4])), returnsNormally);

            final List<String> list = new List<String>()
                ..addAll(["one", "two", "three"]);

            expect(() => (Validate.noNullElements(list)), returnsNormally);

            list.add(null);
            expect(4, list.length);
            expect(() => (Validate.noNullElements(list)), throwsA(new isInstanceOf<ArgumentError>()));

            expect(() => (Validate.noNullElements(new List<String>())), returnsNormally);
        });

        test('> validIndex', () {
            expect(() => (Validate.validIndex([1, 2], 1)), returnsNormally);
            expect(() => (Validate.validIndex([1, 2], 3)), throwsA(new isInstanceOf<RangeError>()));

            final List<String> list = new List<String>()
                ..addAll(["one", "two", "three"]);

            expect(() => (Validate.validIndex(list, 1)), returnsNormally);
        });

        test('> validState', () {
            expect(() => (Validate.validState(true)), returnsNormally);
            expect(() => (Validate.validState(false)), throwsA(new isInstanceOf<IllegalStateError>()));
        });

        test('> matchesPattern', () {
            expect(() => (Validate.matchesPattern("Test", new RegExp("^\\we\\w{2}\$"))), returnsNormally);
            expect(() => (Validate.matchesPattern("Te_st", new RegExp("^\\we\\w{2}\$"))),
                throwsA(new isInstanceOf<ArgumentError>()));

            expect(() => (Validate.isEmail("urbi@orbi.it")), returnsNormally);
            expect(() => (Validate.isEmail("urbi@orbit")), throwsA(new isInstanceOf<ArgumentError>()));

            expect(() => (Validate.isAlphaNumeric("123abcdö")), returnsNormally);
            expect(() => (Validate.isAlphaNumeric("123a#bcd")), throwsA(new isInstanceOf<ArgumentError>()));

            expect(() => (Validate.isHex("1234567890abcdef")), returnsNormally);
            expect(() => (Validate.isHex("0x1234567890abcdef")), returnsNormally);
            expect(() => (Validate.isHex("1234567890abcdefg")), throwsA(new isInstanceOf<ArgumentError>()));
        });

        test('> password', () {
            expect(() => (Validate.isPassword("1abcdefGH#")), returnsNormally);
            expect(() => (Validate.isPassword("1abcdefGH?")), returnsNormally);

            expect(() => (Validate.isPassword("urbi@orbi.it")), throwsA(new isInstanceOf<ArgumentError>()));
            expect(() => (Validate.isPassword("1234567890abcdefGH#")), throwsA(new isInstanceOf<ArgumentError>()));
            expect(() => (Validate.isPassword("12345678aA# ")), throwsA(new isInstanceOf<ArgumentError>()));
            expect(() => (Validate.isPassword("12345678aA'")), throwsA(new isInstanceOf<ArgumentError>()));
            expect(() => (Validate.isPassword("")), throwsA(new isInstanceOf<ArgumentError>()));
            expect(() => (Validate.isPassword("1abcdefGH;")), throwsA(new isInstanceOf<ArgumentError>()));
        });

        test('> inclusive', () {
            expect(() => (Validate.inclusiveBetween(0, 2, 2)), returnsNormally);
            expect(() => (Validate.inclusiveBetween(0, 2, 3)), throwsA(new isInstanceOf<ArgumentError>()));

            expect(() => (Validate.exclusiveBetween(0, 2, 2)), throwsA(new isInstanceOf<ArgumentError>()));
            expect(() => (Validate.exclusiveBetween(0, 2, 1)), returnsNormally);
        });

        test('> json', () {
            expect(() => (Validate.isJson("Test")), returnsNormally);
            expect(() => (Validate.isJson(1)), returnsNormally);
            expect(() => (Validate.isJson(["3", "4"])), returnsNormally);

            expect(() => (Validate.isJson(new _NotAJsonObject())), throwsA(new isInstanceOf<ArgumentError>()));
            expect(() => (Validate.isJson(new _IAmAJsonObject())), returnsNormally);
        });

        test('> key in Map', () {
            final Map<String, dynamic> map1ToTest = new Map<String, dynamic>();
            map1ToTest.putIfAbsent("name", () => "Mike");
            map1ToTest.putIfAbsent("number", () => 42);

            expect(() => (Validate.isKeyInMap("name", map1ToTest)), returnsNormally);
            expect(() => (Validate.isKeyInMap("number", map1ToTest)), returnsNormally);

            //expect(() => (Validate.isKeyInMap("email",map1ToTest)),returnsNormally);
            expect(() => (Validate.isKeyInMap("email", map1ToTest)), throwsA(new isInstanceOf<ArgumentError>()));

            try {
                Validate.isKeyInMap("email", map1ToTest);
                expect(false,isTrue);

            } on ArgumentError catch(e) {
                // Strip out all whitespaces
                expect(e.message.replaceAll(new RegExp("\\s+")," "),
                    "The key 'email' is not available for this structure: { \"name\": \"Mike\", \"number\": 42 }");
            }
        });

        test('> isInstanceOf', () {
            //void test(final instanceCheck instanceCheck,final obj) {
            //    bool match = instanceCheck.check(obj);
            //    _logger.info("Type: ${instanceCheck.runtimeType}, M $match T: ${instanceCheck.type}");
            //}

            // test(new instanceCheck<List<String>>(),new List<String>());
            // test(new instanceCheck<List>(),new List());
            // test(new instanceCheck<String>(),"Test");

            //Validate.isInstance(new instanceCheck<String>(),"Hallo");
            //Validate.isInstance(new instanceCheck<String>(),1);

            expect(() => (Validate.isInstance(new instanceCheck<List<String>>(), new List())),
                throwsA(new isInstanceOf<ArgumentError>()));
            expect(() => (Validate.isInstance(new instanceCheck<List<String>>(strict: false), new List())),
                returnsNormally);

            expect(() => (Validate.isInstance(new instanceCheck<String>(), "Test")), returnsNormally);
            expect(() => (Validate.isInstance(new instanceCheck<String>(), 1)),
                throwsA(new isInstanceOf<ArgumentError>()));
            expect(() => (Validate.isInstance(new instanceCheck<String>(strict: false), 1)),
                throwsA(new isInstanceOf<ArgumentError>()));

            expect(() => (Validate.isInstance(new instanceCheck<int>(), 29)), returnsNormally);
            expect(() => (Validate.isInstance(new instanceCheck<String>(), 1)),
                throwsA(new isInstanceOf<ArgumentError>()));

            expect(() => (Validate.isInstance(new instanceCheck<double>(), 29.0)), returnsNormally);
            expect(() => (Validate.isInstance(new instanceCheck<double>(), 29)),
                throwsA(new isInstanceOf<ArgumentError>()));

            expect(() => (Validate.isInstance(new instanceCheck<num>(strict: false), 29.0)), returnsNormally);
            expect(() => (Validate.isInstance(new instanceCheck<num>(), 29.0)),
                throwsA(new isInstanceOf<ArgumentError>()));
            expect(() => (Validate.isInstance(new instanceCheck<num>(strict: false), 29)), returnsNormally);

            expect(() => (Validate.isInstance(null, 29.0)), throwsA(new isInstanceOf<ArgumentError>()));
        });
    });
}

void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogPrintHandler());
}