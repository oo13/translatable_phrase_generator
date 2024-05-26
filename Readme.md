# Translatable phrase generator for Lua 5.1, or Endless names plugin for Naev

This Lua module is one of the translatable phrase generators. See [the manual](manual.md) for details. The module consists of ["scripts/phrase.lua"](scripts/phrase.lua), ["scripts/phrase/data.lua"](scripts/phrase/data.lua), and ["scripts/phrase/parser.lua"](scripts/phrase/parser.lua). Endless names plugin for Naev is a simple example of use. The user codes are ["scripts/pilotname/*.lua"](scripts/pilotname/), and the Japanese translation is ["po/ja.po"](po/ja.po).

## Manual
[The manual](manual.md)

## What's the translatable phrase generator

1. The generator can generate a phrase (like a word, a name, a sentence, and a paragraph) with a syntax rule expressed by a text that can be replaced (=translated) in the run-time.
1. The syntax rule can express the phrase in many languages other than English.

For instance, [Context-free grammar of Wesnoth](https://wiki.wesnoth.org/Context-free_grammar) is a translatable phrase generator. [The phrase node in Endless Sky](https://github.com/endless-sky/endless-sky/wiki/CreatingPhrases) might be, except that it cannot replace the text of the syntax rule.

## Motive for Creating Another One
[Context-free grammar of Wesnoth](https://wiki.wesnoth.org/Context-free_grammar) can theoretically describe a phrase syntax rule in many languages, but a syntax rule that can be simply expressed a combination of words in English might not be expressed by a combination in other languages because they have inflection and so on; a syntax rule with three production rules have ten options in English may be translated into a syntax rule with one production rule have a thousand options in a language. It's hard to maintain a "combination explosion" like this. (In other hand, the expandable to all options in a single production rule means translatable. If a method doesn't allow the translator to specify all options, it may be impossible to translate potentially.)

Also a word in English cannot always translate into the same word of a language in the different sentence, and it should be translated a various word depended on the context. It causes a trouble similar to inflection.

As far as I had experienced about translating the phrase node in my translatable version of Endless Sky, the substitution is effective to handle the inflection and the like depended on the context, and the sophisticated substitution may make easy to handle the changing word order.

[Context-free grammar of Wesnoth](https://wiki.wesnoth.org/Context-free_grammar)  has no substituting functions. That's why I would create another phrase generator that wasn't compatible with it.

## Features (in comparison with Context-free grammar of Wesnoth)
- gsub (global substitution) function.
- Generator with a parameter to restrict the context.
- Equal chance to generate all possible texts by default, and the creator can change it.
- The comment blocks to maintain the translation easily.
- Don't care some white spaces for readability.

## Example of Phrase Syntax
Japanese translation of Arach ship's name in Endless Sky (excerpt):
```
ARACH_START= マg | グラb | ブロg | ブロp | ブラb | モg | モb {* | ... }
ARACH_MIDDLE = aラg | aバg | グラg | グロp | aロp | プルーt {* | ... }
ARACH_NEXT = ・{ARACH_START}
ARACH_EMPTY = ""
main = {ARACH_START}{ARACH_MIDDLE}{=
         {ARACH_MIDDLE} | {ARACH_EMPTY} | {ARACH_NEXT}
       }{=
         {ARACH_MIDDLE} | {ARACH_EMPTY}
       } ~
       /ga/ガ/g ~
       /ba/バ/g ~
       /pa/パ/g ~
       /ta/タ/g ~
       /g/グ/g ~
       /b/ブ/g ~
       /p/プ/g ~
       /t/トゥ/g
```
Gsubs handle the characters that must be replaced by the combination with preceding and succeeding words.

Inflection:
```
ARTICLES = a | the | that | its
NOUNS = @apple | banana | @orange | @avocado | watermelon
main = {ARTICLES} {NOUNS} ~
       /a @/an / ~
       /@//
```

An example that an English word cannot translates into the same word in Japanese.
English version:
```
ECONOMICAL_SITUATION = poor | rich
main = You are {ECONOMICAL_SITUATION}. |
       You purchased a {ECONOMICAL_SITUATION} ship.
```

Japanese version:
```
ECONOMICAL_SITUATION = 貧乏 | 裕福
main = あなたは{ECONOMICAL_SITUATION}です。 |
       あなたは{ECONOMICAL_SITUATION}な船を購入しました。 ~
       /貧乏な船/粗末な船/ ~
       /裕福な船/豪華な船/
```

# Requirement

This module supports Lua 5.1, and requires [lua-utf8](https://github.com/starwing/luautf8) unless you stick to the plain 8-bit character encoding.

This module has not tested in Lua 5.2 and higher.

# License
This module is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This module is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this module.  If not, see <http://www.gnu.org/licenses/>.

Copyright © 2024 OOTA, Masato
