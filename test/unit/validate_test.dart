import 'package:test/test.dart';
import 'package:validate/validate.dart';

class _NotAJsonObject {
    final String message = "I am not the right one";
}

class _IAmAJsonObject extends _NotAJsonObject {
    dynamic toJson() {
        return [ message];
    }
}

/// A matcher for [IllegalStateError].
const isIllegalStateError = const TypeMatcher<IllegalStateError>();

/// A matcher for functions that throw IllegalStateError.
// ignore: deprecated_member_use
const Matcher throwsIllegalStateError = const Throws(isIllegalStateError);


main() {
    // final _logger = new Logger('validate.testValidate');
    // configLogging();

    group('Validator-Test', () {
        test('isTrue', () {
            expect(() => (Validate.isTrue(true)), returnsNormally);
            expect(() => (Validate.isTrue(false)), throwsArgumentError);
        });

        test('> notNull', () {
            expect(() => (Validate.notNull("Test")), returnsNormally);
            expect(() => (Validate.notNull(null)), throwsArgumentError);
        });

        test('> notEmpty', () {
            expect(() => (Validate.notEmpty("Test")), returnsNormally);
            expect(() => (Validate.notEmpty([10, 20])), returnsNormally);

            final Map<String, Object> map = new Map<String, Object>();
            expect(() => (Validate.notEmpty(map)), throwsArgumentError);

            map["Hallo"] = "Test";
            expect(() => (Validate.notEmpty(map)), returnsNormally);

            // int has not Method "isEmpty"
            expect(() => (Validate.notEmpty(0)), throwsNoSuchMethodError);

            expect(() => (Validate.notEmpty("")), throwsArgumentError);
        });

        test('> notBlank', () {
            expect(() => (Validate.notBlank("Test")), returnsNormally);
            expect(() => (Validate.notBlank(null)), throwsArgumentError);
            expect(() => (Validate.notBlank("")), throwsArgumentError);

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
            expect(() => (Validate.noNullElements(list)), throwsArgumentError);

            expect(() => (Validate.noNullElements(new List<String>())), returnsNormally);
        });

        test('> validIndex', () {
            expect(() => (Validate.validIndex([1, 2], 1)), returnsNormally);
            expect(() => (Validate.validIndex([1, 2], 3)), throwsRangeError);

            final List<String> list = new List<String>()
                ..addAll(["one", "two", "three"]);

            expect(() => (Validate.validIndex(list, 1)), returnsNormally);
        });

        test('> validState', () {
            expect(() => (Validate.validState(true)), returnsNormally);
            expect(() => (Validate.validState(false)), throwsIllegalStateError);
        });

        test('> matchesPattern', () {
            expect(() => (Validate.matchesPattern("Test", new RegExp("^\\we\\w{2}\$"))), returnsNormally);
            expect(() => (Validate.matchesPattern("Te_st", new RegExp("^\\we\\w{2}\$"))),
                throwsA(new isInstanceOf<ArgumentError>()));

            expect(() => (Validate.isEmail("urbi@orbi.it")), returnsNormally);
            expect(() => (Validate.isEmail("urbi@orbit")), throwsArgumentError);

            expect(() => (Validate.isAlphaNumeric("123abcdö")), returnsNormally);
            expect(() => (Validate.isAlphaNumeric("123a#bcd")), throwsArgumentError);

            expect(() => (Validate.isHex("1234567890abcdef")), returnsNormally);
            expect(() => (Validate.isHex("0x1234567890abcdef")), returnsNormally);
            expect(() => (Validate.isHex("1234567890abcdefg")), throwsArgumentError);
        });

        test('> password', () {
            expect(() => (Validate.isPassword("1abcdefGH#")), returnsNormally);
            expect(() => (Validate.isPassword("1abcdefGH?")), returnsNormally);

            expect(() => (Validate.isPassword("urbi@orbi.it")), throwsArgumentError);
            expect(() => (Validate.isPassword("1234567890abcdefGH#")), throwsArgumentError);
            expect(() => (Validate.isPassword("12345678aA# ")), throwsArgumentError);
            expect(() => (Validate.isPassword("12345678aA'")), throwsArgumentError);
            expect(() => (Validate.isPassword("")), throwsArgumentError);
            expect(() => (Validate.isPassword("1abcdefGH;")), throwsArgumentError);
        });

        test('> inclusive', () {
            expect(() => (Validate.inclusiveBetween(0, 2, 2)), returnsNormally);
            expect(() => (Validate.inclusiveBetween(0, 2, 3)), throwsArgumentError);

            expect(() => (Validate.exclusiveBetween(0, 2, 2)), throwsArgumentError);
            expect(() => (Validate.exclusiveBetween(0, 2, 1)), returnsNormally);
        });

        test('> json', () {
            expect(() => (Validate.isJson("Test")), returnsNormally);
            expect(() => (Validate.isJson(1)), returnsNormally);
            expect(() => (Validate.isJson(["3", "4"])), returnsNormally);

            expect(() => (Validate.isJson(new _NotAJsonObject())), throwsArgumentError);
            expect(() => (Validate.isJson(new _IAmAJsonObject())), returnsNormally);
        });

        test('> key in Map', () {
            final Map<String, dynamic> map1ToTest = new Map<String, dynamic>();
            map1ToTest.putIfAbsent("name", () => "Mike");
            map1ToTest.putIfAbsent("number", () => 42);

            expect(() => (Validate.isKeyInMap("name", map1ToTest)), returnsNormally);
            expect(() => (Validate.isKeyInMap("number", map1ToTest)), returnsNormally);

            //expect(() => (Validate.isKeyInMap("email",map1ToTest)),returnsNormally);
            expect(() => (Validate.isKeyInMap("email", map1ToTest)), throwsArgumentError);

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
            expect(() => (Validate.isInstance(new instanceCheck<List<String>>(), new List())),
                throwsArgumentError);

            expect(() => (Validate.isInstance(new instanceCheck<List<String>>(strict: false), new List<String>())),
                returnsNormally);

            expect(() => (Validate.isInstance(new instanceCheck<String>(), "Test")), returnsNormally);
            expect(() => (Validate.isInstance(new instanceCheck<String>(), 1)), throwsArgumentError);
            expect(() => (Validate.isInstance(new instanceCheck<String>(strict: false), 1)),throwsArgumentError);

            expect(() => (Validate.isInstance(new instanceCheck<int>(), 29)), returnsNormally);
            expect(() => (Validate.isInstance(new instanceCheck<String>(), 1)),throwsArgumentError);

            expect(() => (Validate.isInstance(new instanceCheck<num>(strict: false), 29.0)), returnsNormally);
            expect(() => (Validate.isInstance(new instanceCheck<num>(), 29.0)),throwsArgumentError);
            expect(() => (Validate.isInstance(new instanceCheck<num>(strict: false), 29)), returnsNormally);

            expect(() => (Validate.isInstance(null, 29.0)), throwsArgumentError);
        });
    });
}

