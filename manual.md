# Introduction
This module can generate various phrases with a syntax expressed by a text, which can be translated to generate a phrase in other languages. (The way to translate is such as gettext, but it's outside the scope of this module.)

# Example
`_()` is a function to translate.

## A simple example

Lua code:
```lua
local greetings = phrase.new(_([[
main = {HELLO}, {WORLD}!

HELLO = Hi | Greetings | Hello | Good morning
WORLD = world | guys | folks
]]))

print(greetings:generate())
print(greetings:get_number_of_syntax())
print(greetings:get_combination_number())
print(greetings:get_weight())
```

The result:
```
Good morning, folks!
1
12
12
```

## Text Substitution, and Generation with a Parameter

Lua code:
```lua
local greetings = phrase.new(_([[
HELLO = Hi | Greetings | Hello | Good morning
WORLD = world | "{GENDER}-siblings" 2 | folks ~
  /female%-siblings/sisters/ ~
  /male%-siblings/brothers/

main = {HELLO}, {WORLD}!
]]))

print(greetings:generate({ GENDER = "male" }))
print(greetings:get_number_of_syntax())
print(greetings:get_combination_number())
print(greetings:get_weight())
```

The result:
```
Good morning, folks!
1
12
16
```

"-" must be escaped by "%" in the gsub patterns because "-" is a special character in the Lua patterns.

"{GENDER}-siblings" is followed by 2 so the weight of "{GENDER}-siblings" is 2. The quotation is necessary if it's followed by a weight.

If you will make it translatable, the parameters should be the range in the predefined variations and use in order to restrict the context, instead of to introduce extensibility, that is, you should tell the translator the possible combinations before translating.

## Multiple Phrase Syntaxes

Lua code:
```lua
local greetings = phrase.new(_([[
main = I hope this modules is useful!
]]))

greetings:add(_([[
main = This module is a libre software. You can help out by contributing {BUGS}.

BUGS= bug reports | typo fixes | "revisions of the documents" 2
]]))

print(greetings:generate())
print(greetings:get_number_of_syntax())
print(greetings:get_combination_number())
print(greetings:get_weight())
```

The result:
```
This module is a libre software. You can help out by contributing revisions of the documents.
2
4
5
```

A phrase generator can have completely independent phrase syntaxes.

The chance to generate "I hope..." is 20%, "This module..." is 80% because latter has 4 weights. It equalizes the chance to select each phrase syntax if `greetings:equalize_chance()` is called.

## Separate Compilation

Lua code:
```lua
local greet_syntax = phrase.compile(_([[
HELLO = Hi | Greetings | Hello | Good morning
]]))

greet_syntax:add(_([[
WORLD = world | guys | folks
]]))

greet_syntax:add(_([[
main = {HELLO}, {WORLD}!
]]))

local greetings = phrase.new(greet_syntax)

print(greetings:generate())
print(greetings:get_number_of_syntax())
print(greetings:get_combination_number())
print(greetings:get_weight())
```

The result:
```
Good morning, folks!
1
12
12
```

The multiple compilation may make easy to understand the parse error message and edit the translation file. If the syntax has more than a few decades lines, you should consider dividing into the multiple syntaxes (In above example, it's too short to divide).

It can use to create a common library with some assignments, but the number of the combinations should be low enough for the translators to accept them.

# Syntax of the Phrase Syntax
## Overview
The phrase syntax consists of assignments. The order of the assignments doesn't affect the generated text. The recursive reference is not allowed.

It needs a definition of the nonterminal "main" as the start condition to generate the phrase.

## Spaces
The spaces can consist of U+0020 SPACE, U+0009 TAB, and the comment blocks "{* ... }".

The operators "=", ":=", "|", and "~" can be preceded by the spaces, and succeeded by spaces and one newline. (If it allowed multiple newlines, some syntax errors cause puzzling error messages.)

## Assignment
The assignment defines a nonterminal assigned to a production rule.

`nonterminal = production_rule` or `nonterminal := production_rule`

The assignments must be separated by one newline at least. The last assignment doesn't need a following newline. There can be any number of the spaces and newlines between the assignments.

The assignment operator ":=" means the production rule equalizes the chance to select each text. "=" means the chance depends on the number of the possible texts to generate and the weight set by user.

If you don't use ":=" and the weight, the chance to generate all possible phrases is equal:
```
main = {A1} | {A2}
A1 = 0 | 1 | 2
A2 = {A21} | {A22}
A21 = 3 | 4
A22 = 5 | 6 | 7 | 8 | 9
```
The each chance to generate from "0" to "9" is 10%. The chance to select {A1} is 30%, {A2} is 70%, {A21} is 20%, {A22} is 50%.

If you use ":=":
```
main = {A1} | {A2}
A1 = 0 | 1 | 2
A2 := {A21} | {A22}
A21 = 3 | 4
A22 = 5 | 6 | 7 | 8 | 9
```
The chance to select {A21} is 35%, {A22} is 35%. {A1} and {A2} aren't affected by ":=". (cf. The weight propagates the higher layers.)

The nonterminal starts with "_" is  a local nonterminal that is visible only from the same compile unit.

## Production rule

The production rule consist of options and gsubs. For example: `text1 | text2 | text3 ~ /pat1/repl1/ ~ /pat2/repl2/g`

## Options
The options are texts separated "|". For example: `text1 | text2 | text3`

## Text
The text is the candidate for the result of the production rule.

If a text enclose quotation ('"', "'", or "`"), the text can have any character except the quotation. If it's followed by a number, the number is the weight of the chance to select the text. There can be the spaces between the quoted text and the weight number.

```
A = text1 | "text2" 2
```
The chance of "text1" is 33%, "text2" is 67%.
```
A = text1 | {B}
B = text2 | "{C}" 2
C = 1 | 2 | 3
```
The chance of "text1" is 25%, "text2" is 25%, "{C}" is 50%. The chance of "{C}" is lower than no weight.

The text doesn't need to enclose quotations ('"', "'", or "`") if it meets these requirements:
   1. The text is not empty.
   1. The text has neither newline, "|", "~", nor "}" except for a part of an expansion.
   1. The beginning of the text is other than the spaces and quotations. (The spaces preceded by the text are not a part of the text.)
   1. The end of the text is not the spaces. (The spaces succeeded by the text are not a part of the text. The expansion is a part of the text even if the expansion results the spaces or the empty string.)
   1. The text is not followed by a weight number. (The number is a part of the text.)

The text may have expansions, which is a string enclosed by "{" and "}". The text can contain "{" only as the beginning of the expansion, and the expansion can include any character except "}". The rule is prior to the above rules, for example `" {"} "` is a valid text.

## Expansion
The string enclosed by "{" and "}" is the expansion, which will be expanded into a text. "{" and "}" can enclose any character except "}".

1. If the string enclosed "{" and "}" has only alphabet, numeric, and low line characters ("[A-Za-z0-9_]"), it's a nonterminal. If the nonterminal is assigned to a production rule or a parameter, the expansion will be expanded into the generated text.
1. "{(}" and "{)}" will be expanded into "{" and "}".
1. If the beginning of the expansion is "{*", the expansion will be expanded into the empty string. (Technically speaking, it's not a comment block.)
1. If the beginning of the expansion is "{=" or "{:=", the content (except the first "=" or ":=") is considered as a production rule. For example, "{= A|B|C}" will be expanded into the result of the production rule "A|B|C". The syntax of the content is expressed by EBNF: `content = space_nl_opt, production_rule, space_nl_opt ;` "{:=" is, of course, the equalized select version of "{=".
1. The global unsolved expansion will be expanded into itself removed outer "{" and "}". (I recommend that the nonterminal is noticeable to find it easily unless you will leave it unsolved.)
1. The local unsolved expansion occurs an error.

## Gsub (Global substitution)
Gsub is the function to substitute the resulting string selected from the options. You can specify any number (including zero) of gsubs that substitute the string. 1st gsub specifies the substitution of the selected text out of the options, and then the result of the preceding substitution is substituted by the next gsub's.

A gsub specification follows "~", the first character except spaces means the separator in the specification. The separator character can be any character except spaces, newline, and "{", and can differ from a separator in the other specification.

For example:
```
~ /A B/C D/g ~ !/!|!11 ~ $X Y$1 2$
```

The pattern parameter succeeds the first separator in the specification and can have any characters except the separator, but the pattern must not be the empty string.

The separator succeeds the pattern, and the replacement parameter follows the separator. The replacement can have any characters except the separator, and can be the empty string.

The separator succeeds the replacement, and the number parameter follows the separator. The number is the integer or "g" that means all. You can omit the number and it means "1".

The parameters "pattern", "replacement", "number" are passed on the [UTF-8 version](https://github.com/starwing/luautf8) of [Lua string.gsub()](https://www.lua.org/manual/5.1/manual.html#pdf-string.gsub). (You can choose string.gsub() instead of the UTF-8 version if you want.)

## EBNF

```EBNF
start = space_nl_opt, [ { assignment, space_nl_opt } ], $ ;
space = " " | "\t" | ( "{*", [ { ? [^}] ? } ], "}" ) ;
nl = "\n" ;
space_nl_opt = [ { space | nl } ] ;

assignment = nonterminal, space_opt, operator, space_one_nl_opt, production_rule, ( nl | $ ) ;
nonterminal = { ? [A-Za-z0-9_] ? } ;
operator = "=" | ":=" ;
space_opt = [ { space } ] ;
space_one_nl_opt = space_opt, [ nl, space_opt ] ;

production_rule = options, gsubs ;

options = text, space_opt, [ { "|", space_one_nl_opt, text, space_opt } ] ;
text = text_begin, [ text_body, [ text_postfix ] ] |
       '"', [ { ? [^"{] ? | expansion } ], '"', space_opt, [ number ] |
       "'", [ { ? [^'{] ? | expansion } ], "'", space_opt, [ number ] |
       "`", [ { ? [^`{] ? | expansion } ], "`", space_opt, [ number ] ;
text_begin = ? [^ \t\n"'`|~{}] ? | expansion ; (* "}" is the next to the text when it's in {= ...}. *)
text_body = { ? [^\n|~{}] ? | expansion } ;
text_postfix = space_opt, ( $ | '\n' | '|' | '~' | '}' ) ; (* This space_opt is greedy match. It isn't a part of the text. *)
expansion = "{", [ { ? [^}] ? } ], "}" ;
number = ( ( { ? [0-9] ? }, [ "." ] ) | ( ".", ? [0-9] ? ) ), [ { ? [0-9] ? } ] ;

gsubs = [ { "~", space_one_nl_opt, sep, { pat }, sep2, [ { pat } ], sep2, [ ( "g" | integer ) ], space_opt } ] ; (* 'sep2' is the same character of 'sep'. *)
sep = ? [^ \t\n{] ? ; (* '{' may be the beginning of the comment block. *)
pat = ? all characters ? - sep2 ; (* 'sep2' is the character precedes 'pat' in the parent 'gsubs'. *)
integer = { ? [0-9] ? } ;
```

# Phrase functions
## Public functions in the module "phrase"
### new(text_or_compiled)

It creates an instance of the phrase generator.

Parameter:
- "text_or_compiled" is a text or a compiled data of the phrase syntax, or nil to request the empty instance.

Return:
- The instance of the phrase generator if no errors are detected.
- The instance of the empty phrase generator if non fatal errors are detected.
- nil if a fatal error is detected.

Errors:
- The fatal error is detected if you require UTF-8 support (default) but it doesn't exist.
- Some parse errors.
- A compile error when the nonterminal "main" doesn't exist.

Note:
- output_error() and output_compile_error() is called if some errors are detected.
- instance:add() is called if "text_or_compiled" isn't nil.

### compile(text)

It compiles a phrase syntax to generate the compiled data.

Parameter:
- "text" is a string of a phrase syntax, or nil to request the empty instance.

Return:
- The compiled data if no errors are detected.
- nil if some errors are detected.

Errors:
- The fatal error is detected if you require UTF-8 support (default) but it doesn't exist.
- Some parse errors.

Note:
- "text" doesn't need to have the assignment for 'main'.
- output_error() and output_compile_error() is called if when some errors are detected.

### set_random_function(f)

It sets a random function to generate a phrase text.

Parameter:
- "f" is a function that is compatible with math.random() and math.random(n).

Note:
- The default random function is math.random().

### require_utf8(enable)

It configures the requirement for the character encoding, and try to enable it. Different character encodings have different semantics of the gsub.

Parameter:
- If "enable" is true or nil, UTF-8 support is required and tried to enable. (Default)
- If "enable" is false, The plain 8-bit encoding is required and enabled.

Return:
- false if it fails to set the required encoding.

Note:
- lua-utf8.gsub() is used when UTF-8 support is enabled.
- string.gsub() is used when the plain 8-bit encoding is enabled.
- The separator character for gsub is one character in each encoding, not a byte.
- Counting the column number in the error message depends on the encoding.

### output_error(err_msg)

The function to output the error messages. You can replace it if you wish.

Parameter:
- "err_msg" is the string to output.

Note:
- This function calls io.stderr:write().

### output_compile_error(text, err_msg)

The function to output the compile error messages. You can replace it if you wish.

Parameter:
- "text" is the string of the phrase syntax when it's usable, or nil.
- "err_msg" is the string of the error message.

Note:
- This function uses output_error() to output.

## Instance methods of the phrase generator
### add(self, text_or_compiled)

It adds a phrase syntax into the instance.

Parameter:
- "text_or_compiled" is a text or a compiled data of the phrase syntax.

Return:
- false if the phrase syntax fail to add into the instance due to some errors.

Errors:
- Invalid parameter error if the parameter is neither a string or a compiled data.
- Some parse errors.
- A compile error when the nonterminal "main" doesn't exist.

Note:
- output_error() and output_compile_error() is called if some errors are detected.

### generate(self, param)

It generates a phrase text.

Parameter:
- "param" is nil, or a table that has a set of the nonterminal and the value.

Return:
- A phrase text.
- "nil" if the instance is the empty phrase generator.

Note:
- "param" is used only for the global unsolved nonterminals.

### equalize_chance(self, enable)

It equalizes the chance to select each phrase syntax.

Parameter:
- It equalizes the chance to select each phrase syntax if "enable" is true or nil.
- If "enable" is false, the chance depends on the weight of the phrase syntax. (Default)

### get_number_of_syntax(self)

It returns the number of the syntaxes in the instance.

Return:
- The number of the syntaxes in the instance.

### get_weight(self)

It returns the sum of the weight of the syntaxes in the instance.

Return:
- The sum of the weight of the syntaxes in the instance.

### get_combination_number(self)

It returns the number of the possible phrases generated by the instance.

Return:
- The number of the possible phrases generated by the instance.

## Instance method of the compiled data
### add(self, text_or_compiled)

It adds a phrase syntax into the instance after compiling the syntax if needed.

Parameter:
- "text_or_compiled" is a text or a compiled data of the phrase syntax.

Return:
- false if the phrase syntax fail to add into the instance due to some errors.

Errors:
- The fatal error is detected if "text_or_compiled" is a string and you require UTF-8 support (default) but it doesn't exist.
- Some parse errors.

Note:
- "text_or_compiled" doesn't need to have the assignment for 'main'.
- output_error() and output_compile_error() is called if when some errors are detected.
- The production rules for the existing nonterminals is overwritten if "text_or_compiled" has the assignment for the same nonterminal.
- compile() is called if "text_or_compiled" is a string.

# Requirement

This module supports Lua 5.1 to 5.4, and requires [lua-utf8](https://github.com/starwing/luautf8) unless you stick to the plain 8-bit character encoding.

# License
This module is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This module is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this module.  If not, see <http://www.gnu.org/licenses/>.

Copyright © 2024 OOTA, Masato
