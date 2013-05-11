## Validate ##
Lightweight library for validating function arguments.

This library is mainly a port of Apaches org.apache.commons.lang3.Validate class

Validation is necessary on most public-facing APIs. Parameter validation 
on non-public methods is not as important - it is often desirable to have validation occur only once, 
at the public 'entry point' - but if you can live with the potential performance hit, I recommend 
to validate parameters everywhere, as it makes code maintenance and refactoring a bit easier.

For further documentation please refere to the Unit-Tests.