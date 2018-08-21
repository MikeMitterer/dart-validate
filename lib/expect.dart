library expect;

import 'package:validate/validate.dart';

typedef String LazyMessage();

String _DEFAULT_IS_NULL_EX_MESSAGE() => Validate.DEFAULT_IS_NULL_EX_MESSAGE;
String _DEFAULT_IS_TRUE_EX_MESSAGE() => Validate.DEFAULT_IS_TRUE_EX_MESSAGE;

T notNull<T>(final T object,{ final LazyMessage message = _DEFAULT_IS_NULL_EX_MESSAGE }) {
    if (object == null) {
        throw new ArgumentError(message());
    }
    return object;
}

bool isTrue(final bool expression,{ final LazyMessage message = _DEFAULT_IS_TRUE_EX_MESSAGE }) {
    if (expression == null || expression == false) {
        throw new ArgumentError(message());
    }
    return expression;
}