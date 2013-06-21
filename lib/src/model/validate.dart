part of validate;

/**
 * <p>This class assists in validating arguments. The validation methods are
 * based along the following principles:
 * <ul>
 *   <li>An invalid {@code null} argument causes a {@link NullPointerError}.</li>
 *   <li>A non-{@code null} argument causes an {@link IllegalArgumentException}.</li>
 *   <li>An invalid index into an array/collection/map/string causes an {@link IndexOutOfBoundsException}.</li>
 * </ul>
 *
 * <p>All exceptions messages are
 * <a href="http://java.sun.com/j2se/1.5.0/docs/api/java/util/Formatter.html#syntax">format strings</a>
 * as defined by the Java platform. For example:</p>
 *
 * <pre>
 * Validate.isTrue(i > 0, "The value must be greater than zero");
 * Validate.notNull(surname, "The surname must not be null");
 * </pre>
 */

/**
 * Constructor. This class should not normally be instantiated.
 */
abstract class Validate {
    static const String PATTERN_EMAIL         = "^([0-9a-zA-Z]([-.\\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\\w]*[0-9a-zA-Z]\\.)+[a-zA-Z]{2,9})\$";
    static const String PATTERN_PW            = "((?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#\$%]).{8,15})";  // http://www.mkyong.com/regular-expressions/how-to-validate-password-with-regular-expression/
    static const String PATTERN_ALPHANUMERIC  = "^[a-zA-Z0-9öäüÖÄÜß]+\$";
    static const String PATTERN_HEX           = "^(0x[a-fA-F0-9]+)|([a-fA-F0-9])+\$";

    static const String _DEFAULT_IS_TRUE_EX_MESSAGE = "The validated expression is false";
    static const String _DEFAULT_IS_NULL_EX_MESSAGE = "The validated object is null";
    static const String _DEFAULT_NOT_EMPTY_MESSAGE = "The validated value is empty";
    static const String _DEFAULT_NOT_BLANK_EX_MESSAGE = "The validated string is blank";
    static const String _DEFAULT_NO_NULL_ELEMENTS_ARRAY_EX_MESSAGE = "The validated array contains null element";
    static const String _DEFAULT_VALID_INDEX_ARRAY_EX_MESSAGE = "The validated array index is invalid";
    static const String _DEFAULT_VALID_STATE_EX_MESSAGE = "The validated state is false";
    static const String _DEFAULT_MATCHES_PATTERN_EX = "The string does not match the pattern";
    static const String _DEFAULT_INCLUSIVE_BETWEEN_EX_MESSAGE = "The value is not in the specified inclusive range";
    static const String _DEFAULT_EXCLUSIVE_BETWEEN_EX_MESSAGE = "The value is not in the specified exclusive range";

    /*
    static const String _DEFAULT_NO_NULL_ELEMENTS_COLLECTION_EX_MESSAGE = "The validated collection contains null element at specified index";
    static const String _DEFAULT_VALID_INDEX_CHAR_SEQUENCE_EX_MESSAGE = "The validated character sequence index is invalid";
    static const String _DEFAULT_VALID_INDEX_COLLECTION_EX_MESSAGE ="The validated collection index is invalid";
    static const String _DEFAULT_IS_INSTANCE_OF_EX_MESSAGE = "The instance of the validated object is invalid";
    */

    // isTrue
    //---------------------------------------------------------------------------------

    /**
     * <p>Validate that the argument condition is {@code true}; otherwise
     * throwing an exception with the specified message. This method is useful when
     * validating according to an arbitrary boolean expression, such as validating a
     * primitive number or using your own custom validation expression.</p>
     *
     * <pre>Validate.isTrue(i > 0.0, "The value must be greater than zero: $value");</pre>
     *
     * @param expression  the boolean expression to check
     * @param message  the {@link String#format(String, Object...)} exception message if invalid, not null
     * @throws ArgumentError if expression is {@code false}
     */
    static void isTrue(bool expression, [String message = _DEFAULT_IS_TRUE_EX_MESSAGE]) {
        if (expression == false) {
            throw new ArgumentError(message);
        }
    }

    // notNull
    //---------------------------------------------------------------------------------

    /**
     * <p>Validate that the specified argument is not {@code null};
     * otherwise throwing an exception.
     *
     * <pre>Validate.notNull(myObject, "The object must not be null");</pre>
     *
     * <p>The message of the exception is &quot;The validated object is
     * null&quot;.</p>
     *
     * @param object  the object to check
     * @return the validated object (never {@code null} for method chaining)
     * @throws NullPointerError if the object is {@code null}
     */
    static notNull(var object,[String message = _DEFAULT_IS_NULL_EX_MESSAGE]) {
      if (object == null) {
        throw new NullPointerError(message);
      }
      return object;      
    }


    // notEmpty array
    //---------------------------------------------------------------------------------

    /**
     * <p>Validate that the specified argument is neither {@code null}
     * nor is empty (object must have isEmpty implemented); otherwise throwing an exception
     * with the specified message.
     *
     * <pre>Validate.notEmpty(myArray, "The array must not be empty");</pre>
     *
     * @param value  the value to check, validated not null by this method
     * @param message  the exception message if invalid, not null
     * @return the validated value (never {@code null} method for chaining)
     * @throws NullPointerError if the array is {@code null}
     * @throws ArgumentError if the array is empty
     */
    static notEmpty(var value, [String message = _DEFAULT_NOT_EMPTY_MESSAGE]) {
        Validate.notNull(value,message);
        /*
        if ((value is List || value is Map || value is String) && value.length == 0) {
            throw new ArgumentError(message);
        }
        */
        if (value.isEmpty) {
            throw new ArgumentError(message);
        }
        
        return value;
    }

 
    // notBlank string
    //---------------------------------------------------------------------------------

    /**
     * <p>Validate that the specified string is
     * neither {@code null}, a length of zero (no characters), empty
     * nor whitespace; otherwise throwing an exception with the specified
     * message.
     *
     * <pre>Validate.notBlank(myString, "The string must not be blank");</pre>
     *
     * @param value  the string to check, validated not null by this method
     * @param message  the exception message if invalid, not null
     * @return the validated string
     * @throws NullPointerError if the character sequence is {@code null}
     * @throws ArgumentError if the character sequence is blank
     */
    static String notBlank(String value, [String message = _DEFAULT_NOT_BLANK_EX_MESSAGE]) {
        Validate.notNull(value,message);
        if ((value is String) == false || value.trim().isEmpty) {
            throw new ArgumentError(message);
        }
        return value;
    }

    // noNullElements array
    //---------------------------------------------------------------------------------

    /**
     * <p>Validate that the specified argument array is neither
     * {@code null} nor contains any elements that are {@code null};
     * otherwise throwing an exception with the specified message.
     *
     * <pre>Validate.noNullElements(myArray, "The validated array contains null element");</pre>
     *
     * <p>If the array is {@code null}, then the message in the exception
     * is &quot;The validated object is null&quot;.</p>
     *
     * @param iterable  the Iterable to check, validated not null by this method
     * @param message  the exception message if invalid, not null
     * @return the validated iterable (never {@code null} method for chaining)
     * @throws NullPointerError if the iterable is {@code null}
     * @throws ArgumentError if an element is {@code null}
     */
    static Iterable noNullElements(Iterable iterable, [String message = _DEFAULT_NO_NULL_ELEMENTS_ARRAY_EX_MESSAGE]) {
        Validate.notNull(iterable);
        for(var x in iterable) {
          if(x == null) {
            throw new ArgumentError(message);
          }
        }
  
        return iterable;
    }




    // validIndex array
    //---------------------------------------------------------------------------------

    /**
     * <p>Validates that the index is within the bounds of the argument
     * iterable; otherwise throwing an exception with the specified message.</p>
     *
     * <pre>Validate.validIndex(iterable, 2, "The validated array index is invalid");</pre>
     *
     * <p>If the array is {@code null}, then the message of the exception
     * is &quot;The validated object is null&quot;.</p>
     *
     * @param iterable  the iterable to check, validated not null by this method
     * @param index  the index to check
     * @param message  the exception message if invalid, not null
     * @return the validated iterable (never {@code null} for method chaining)
     * @throws NullPointerError if the array is {@code null}
     * @throws RangeError if the index is invalid
     */
    static Iterable validIndex(Iterable iterable, int index, [String message = _DEFAULT_VALID_INDEX_ARRAY_EX_MESSAGE]) {
        Validate.notNull(iterable);
        if (index < 0 || index >= iterable.length) {
            throw new RangeError(message);
        }
        return iterable;
    }



    // validState
    //---------------------------------------------------------------------------------

    /**
     * <p>Validate that the stateful condition is {@code true}; otherwise
     * throwing an exception. This method is useful when validating according
     * to an arbitrary boolean expression, such as validating a
     * primitive number or using your own custom validation expression.</p>
     *
     * <pre>
     * Validate.validState(field > 0);
     * Validate.validState(this.isOk());</pre>
     *
     * <p>The message of the exception is &quot;The validated state is
     * false&quot;.</p>
     *
     * @param expression  the boolean expression to check
     * @throws IllegalStateException if expression is {@code false}
     */
    static void validState(bool expression,[String message = _DEFAULT_VALID_STATE_EX_MESSAGE]) {
        if (expression == false) {
            throw new IllegalStateError(message);
        }
    }



    // matchesPattern
    //---------------------------------------------------------------------------------

    /**
     * <p>Validate that the specified argument character sequence matches the specified regular
     * expression pattern; otherwise throwing an exception.</p>
     *
     * <pre>Validate.matchesPattern("hi", new RegExp("^test\$"));</pre>
     *
     * <p>The syntax of the pattern is the one used in the {@link RegExp} class.</p>
     *
     * @param input  the character sequence to validate, not null
     * @param pattern  the regular expression pattern, not null
     * @throws ArgumentError if the character sequence does not match the pattern
     */
    static void matchesPattern(String input, RegExp pattern,[String message = _DEFAULT_MATCHES_PATTERN_EX]) {
        if (pattern.hasMatch(input) == false) {
            throw new ArgumentError(message);
        }
    }

    static void isEmail(String input,[String message = _DEFAULT_MATCHES_PATTERN_EX]) {
      matchesPattern(input,new RegExp(PATTERN_EMAIL),message);  
    }

    static void isPassword(String input,[String message = _DEFAULT_MATCHES_PATTERN_EX]) {
      matchesPattern(input,new RegExp(PATTERN_PW),message);  
    }    
    
    static void isAlphaNumeric(String input,[String message = _DEFAULT_MATCHES_PATTERN_EX]) {
      matchesPattern(input,new RegExp(PATTERN_ALPHANUMERIC),message);  
    } 
    
    static void isHex(String input,[String message = _DEFAULT_MATCHES_PATTERN_EX]) {
      matchesPattern(input,new RegExp(PATTERN_HEX),message);  
    }  
    
    // inclusiveBetween
    //---------------------------------------------------------------------------------

    /**
     * <p>Validate that the specified argument object fall between the two
     * inclusive values specified; otherwise, throws an exception.</p>
     *
     * <pre>Validate.inclusiveBetween(0, 2, 1);</pre>
     *
     * @param start  the inclusive start value, not null
     * @param end  the inclusive end value, not null
     * @param value  the object to validate, not null
     * @throws ArgumentError if the value falls out of the boundaries
     */
    static void inclusiveBetween(Comparable start, Comparable end, Comparable value,[String message = _DEFAULT_INCLUSIVE_BETWEEN_EX_MESSAGE]) {
        if (value.compareTo(start) < 0 || value.compareTo(end) > 0) {
            throw new ArgumentError(message);
        }
    }

    // exclusiveBetween
    //---------------------------------------------------------------------------------

    /**
     * <p>Validate that the specified argument object fall between the two
     * exclusive values specified; otherwise, throws an exception.</p>
     *
     * <pre>Validate.inclusiveBetween(0, 2, 1);</pre>
     *
     * @param start  the exclusive start value, not null
     * @param end  the exclusive end value, not null
     * @param value  the object to validate, not null
     * @throws ArgumentError if the value falls out of the boundaries
     */
    static void exclusiveBetween(Comparable start, Comparable end, Comparable value,[String message = _DEFAULT_EXCLUSIVE_BETWEEN_EX_MESSAGE]) {
        if (value.compareTo(start) <= 0 || value.compareTo(end) >= 0) {
            throw new ArgumentError(message);
        }
    }

    // isInstanceOf
    //---------------------------------------------------------------------------------

    /**
     * <p>Validate that the argument is an instance of the specified class; otherwise
     * throwing an exception. This method is useful when validating according to an arbitrary
     * class</p>
     *
     * <pre>Validate.isInstanceOf(OkClass.class, object);</pre>
     *
     * <p>The message of the exception is &quot;The validated object is not an instance of&quot;
     * followed by the name of the class</p>
     *
     * @param type  the class the object must be validated against, not null
     * @param obj  the object to check, null throws an exception
     * @throws ArgumentError if argument is not of specified class
     * @see #isInstanceOf(Class, Object, String, Object...)
     *
     * @since 3.0
     */
    /*  
     static void isInstanceOf(Type type, var obj,[String message = _DEFAULT_IS_INSTANCE_OF_EX_MESSAGE]) {
        final Type tocheck = obj.runtimeType;
        if (type.runtimeType.hashCode != tocheck.runtimeType.hashCode) {
            throw new ArgumentError(message);
        }
    }
    */
}