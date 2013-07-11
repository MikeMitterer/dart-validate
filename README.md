## Validate ##
Lightweight library for validating function arguments in Dart.

This library is mainly a port of Apaches org.apache.commons.lang3.Validate class

Validation is necessary on most public-facing APIs. Parameter validation 
on non-public methods is not as important - it is often desirable to have validation occur only once, 
at the public 'entry point' - but if you can live with the potential performance hit, I recommend 
to validate parameters everywhere, as it makes code maintenance and refactoring a bit easier.

For further documentation please refere to the Unit-Tests.

###API###
[Dart Documentation][1] on GitHub

###History###
* 1.2.0 - isKeyInMap check added
* 1.1.0 - isJson check added
* 1.0.5 - Changed GitHub-Repository to dart-validate
* 1.0.4 - Replaced NullPointerException with ArgumentError - makes more sense

###License###

    Copyright 2013 Michael Mitterer, IT-Consulting and Development Limited,
    Austrian Branch

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, 
    software distributed under the License is distributed on an 
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
    either express or implied. See the License for the specific language 
    governing permissions and limitations under the License.
    
If this plugin is helpful for you - please [(Circle)](http://gplus.mikemitterer.at/) me.

[1] http://htmlpreview.github.io/?https://raw.github.com/MikeMitterer/dart-validate/master/docs/index.html