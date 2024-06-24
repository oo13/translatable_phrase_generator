--[[
   The parser function for the phrase generator.
--]]
--[[
This module is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This module is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this module.  If not, see <http://www.gnu.org/licenses/>.

Copyright © 2024 OOTA, Masato
--]]

local utf8_support, utf8 = pcall(require, "utf8") -- Naev provides lua-utf8 as "utf8".
if not utf8_support or not utf8.gsub then
   utf8_support, utf8 = pcall(require, "lua-utf8") -- luarocks --local install luautf8, or https://github.com/starwing/luautf8
end

-- 8-bit encoding version.
-- The differences are the column number in the error message if you use a valid UTF-8 sequence, and gsub() function.
-- An error is caused by require("string") in Naev.
local char8 = {}
char8.char = string.char
char8.gsub = string.gsub
char8.charpos = function (s, i)
if i <= s:len() then
      return i, s:byte(i, 1)
   else
      return nil, nil
   end
end
char8.next = function (s, i)
   if i < s:len() then
      i = i + 1
      return i, s:byte(i, i)
   else
      return nil, nil
   end
end

local data = require "phrase.data"


local parser = {}
parser.utf8_support = utf8_support

--[[
   Choose UTF-8 or 8 bit character encoding.

   return: false if fail to set it.
--]]
function parser.set_encoding_utf8(enable)
   if enable == nil or enable then
      if parser.utf8_support then
         parser.encoding = utf8
      else
         parser.encoding = char8
      end
      return parser.utf8_support
   else
      parser.encoding = char8
      return true
   end
end
parser.set_encoding_utf8(true) -- The default is UTF-8, if possible.

--[[
   Check the character encoding is UTF-8.
--]]
function parser.check_encoding_utf8()
   return parser.encoding == utf8
end


-- forward declarations
local new_input_iterator, skip_space_nl, parse_assignment

--[[
   Parser
   returns the data of the syntax and the error message ("" means no error is detected).

   start = space_nl_opt, [ { assignment, space_nl_opt } ], $ ;
--]]
function parser.parse(text)
   local syntax = data.new_syntax()
   local err_msg = ""
   local it = new_input_iterator(text)
   skip_space_nl(it)
   while not it:eot() do
      local result, retval = pcall(parse_assignment, it, syntax)
      if not result then
         err_msg = err_msg .. retval

         if not it:eot() then
            -- Recovering from the error.
            local cont_chars = "|~="
            local cont_line = string.find(cont_chars, it:getc(), 1, true)
            while it:next() do
               local c = it:getc()
               if c == "\n" then
                  if cont_line then
                     cont_line = false
                  else
                     break
                  end
               elseif c ~= " " and c ~= "\t" then
                  cont_line = string.find(cont_chars, it:getc(), 1, true)
               end
            end
         end
      end
      skip_space_nl(it)
   end

   err_msg = err_msg .. syntax:fix_local_nonterminal()
   return syntax, err_msg
end


--[[--
   Input iterator

   Private data
   .s : target text
   .pos : current position
   .c : current character
   .column : current column
   .line : current line

   Public functions
   .getc() : The current character.
   .get_nextc() : The next character.
   .next() : The function to make the interest position next
   .eot() : Is the current position the end of the text?

   .get_current_position() : The list of the current position. 1st value is the line number, 2nd value is the column number.
--]]
function new_input_iterator(text)
   local it = {}
   it.s = text
   it.column = 1
   it.line = 1
   if text == "" then
      it.pos = nil
      it.c = nil
   else
      it.pos, it.c = parser.encoding.charpos(text, 1)
      it.c = parser.encoding.char(it.c)
   end

   it.getc = function (self)
      return self.c
   end

   it.get_nextc = function (self)
      local pos, c = parser.encoding.next(self.s, self.pos)
      if pos then
         return parser.encoding.char(c)
      else
         return nil
      end
   end

   it.next = function (self)
      if not self.pos then
         return nil
      end
      if self.c == "\n" then
         self.column = 1
         self.line = self.line + 1
      else
         self.column = self.column + 1
      end

      self.pos, self.c = parser.encoding.next(self.s, self.pos)
      if self.pos then
         self.c = parser.encoding.char(self.c)
      else
         self.c = nil
      end
      return self.c
   end

   it.eot = function (self)
      return not self.c
   end

   it.get_current_position = function (self)
      return self.line, self.column
   end

   return it
end


-- Throw a parse error. (Catched by parser.parse())
local function throw_parse_error(it, msg)
   local line, column = it:get_current_position()
   error("Line#" .. line .. ", Column#" .. column .. ": " .. msg .. "\n", 0)
end


--[[
   Skip spaces.

   space_opt = [ { space } ] ;
   space = " " | "\t" | ( "{*", [ { ? [^}] ? } ], "}" ) ;
--]]
local function skip_space(it, en_nl)
   while not it:eot() do
      local c = it:getc()
      if c == "{" and it:get_nextc() == "*" then
         it:next()
         it:next()
         while not it:eot() and it:getc() ~= "}" do
            it:next()
         end
         if it:eot() then
            throw_parse_error(it, "The end of the comment is expected.")
         end
      elseif not (c == " " or c == "\t" or (en_nl and c == "\n")) then
         break
      end

      it:next()
   end
end


--[[
   Skip spaces and newlines.

   space_nl_opt = [ { space | nl } ] ;
   nl = "\n" ;
--]]
function skip_space_nl(it)
   skip_space(it, true)
end


--[[
   Skip spaces and a newline.

   space_one_nl_opt = space_opt, [ nl, space_opt ] ;
--]]
local function skip_space_one_nl(it)
   skip_space(it)
   if it:getc() == "\n" then
      it:next()
      skip_space(it)
   end
end


-- forward declarations
local parse_nonterminal, parse_operator, parse_production_rule

--[[
   Parse an assignment.

   assignment = nonterminal, space_opt, operator, space_one_nl_opt, production_rule, ( nl | $ ) ;
--]]
function parse_assignment(it, syntax)
   local nonterminal = parse_nonterminal(it)
   skip_space(it)
   local op_type = parse_operator(it)
   skip_space_one_nl(it)
   local rule = parse_production_rule(it)
   if it:eot() or it:getc() == "\n" then
      if op_type == ":" then
         rule:equalize_chance(true)
      end
      syntax:add(nonterminal, rule)
   else
      throw_parse_error(it, 'The end of the text or "\\n" is expected.')
   end
end


--[[
   Parse a nonterminal.

   nonterminal = { ? [A-Za-z0-9_] ? } ;
--]]
function parse_nonterminal(it)
   local nonterminal = ""
   while true do
      local c = it:getc()
      if c and string.find(c, "[A-Za-z0-9_]") then
         nonterminal = nonterminal .. c
         it:next()
      else
         break
      end
   end
   if nonterminal == "" then
      throw_parse_error(it, 'A nonterminal "/[A-Za-z0-9_]+/" is expected.')
   end
   return nonterminal
end


--[[
   Parse an operator.
   Returns ":" if the operator is ":=".

   operator = "=" | ":=" ;
--]]
function parse_operator(it)
   local c = it:getc()
   if c == "=" then
      it:next()
      return "="
   elseif c == ":" then
      it:next()
      if it:getc() == "=" then
         it:next()
         return ":"
      else
         throw_parse_error(it, '"=" is expected.')
      end
   else
      throw_parse_error(it, '"=" or ":=" is expected.')
   end
end


-- forward declarations
local parse_options, parse_gsubs

--[[
   Parse a production rule.

   production_rule = options, gsubs ;
--]]
function parse_production_rule(it, term_char)
   local options = parse_options(it)
   local gsubs = parse_gsubs(it)
   local rule = data.new_production_rule()
   rule:set_options(options)
   rule:set_gsubs(gsubs)
   if term_char ~= nil then
      skip_space_nl(it)
      if it:getc() == term_char then
         it:next()
      else
         throw_parse_error(it, '"' .. term_char .. '" is expected.')
      end
   end
   return rule
end


-- forward declaration
local parse_text

--[[
   Parse an "options".

   options = text, space_opt, [ { "|", space_one_nl_opt, text, space_opt } ] ;
--]]
function parse_options(it)
   local options = data.new_options()
   options:add_text(parse_text(it))
   skip_space(it)
   while it:getc() == "|" do
      it:next()
      skip_space_one_nl(it)
      options:add_text(parse_text(it))
      skip_space(it)
   end
   return options
end


-- forward declarations
local parse_quoted_text, parse_non_quoted_text, parse_expansion

--[[
   Parse a text.

   text = text_begin, [ text_body, [ text_postfix ] ] |
          '"', [ { ? [^"{] ? | expansion } ], '"', space_opt, [ number ] |
          "'", [ { ? [^'{] ? | expansion } ], "'", space_opt, [ number ] |
          "`", [ { ? [^`{] ? | expansion } ], "`", space_opt, [ number ] ;
   text_begin = ? [^ \t\n"'`|~{}] ? | expansion ; (* "}" is the next to the text when it's in {= ...}. *)
   expansion = "{", [ { ? [^}] ? } ], "}" ;
   number = ( ( { ? [0-9] ? }, [ "." ] ) | ( ".", ? [0-9] ? ) ), [ { ? [0-9] ? } ] ;
--]]
function parse_text(it)
   local c = it:getc()
   if it:eot() or string.find(" \t\n|~}", c, 1, true) then
      throw_parse_error(it, "A text is expected.")
      return data.new_text()
   elseif c == '"' or c == "'" or c == "`" then
      return parse_quoted_text(it)
   else
      return parse_non_quoted_text(it)
   end
end


-- forward declaration
local parse_number

--[[
   Parse a quoted text.

   text = ...
          '"', [ { ? [^"{] ? | expansion } ], '"', space_opt, [ number ] |
          "'", [ { ? [^'{] ? | expansion } ], "'", space_opt, [ number ] |
          "`", [ { ? [^`{] ? | expansion } ], "`", space_opt, [ number ] ;
--]]
function parse_quoted_text(it)
   local text = data.new_text()
   local s = ""
   local quote = it:getc()
   it:next()
   while not it:eot() and it:getc() ~= quote do
      if it:getc() == "{" then
         s = parse_expansion(it, text, s)
      else
         s = s .. it:getc()
         it:next()
      end
   end
   if it:eot() then
      throw_parse_error(it, "The end of the " .. quote .. "quoted text" .. quote .. " is expected.")
   end
   if s ~= "" then
      text:add_string(s)
   end
   it:next()
   skip_space(it)
   text:set_weight(parse_number(it))
   return text
end


--[[
   Parse a non quoted text.

   text = ...
          text_begin, [ text_body, [ text_postfix ] ] |
          ... ;
   text_body = { ? [^\n|~{}] ? | expansion } ;
   text_postfix = space_opt, ( $ | '\n' | '|' | '~' | '}' ) ; (* This space_opt is greedy match. It isn't a part of the text. *)
--]]
function parse_non_quoted_text(it)
   -- The caller ensures it:getc() == text_begin or EOT.
   local text = data.new_text()
   local s = ""
   local spaces = "" -- The candidate for "text_postfix" (trailing spaces)
   while true do
      local c = it:getc()
      if it:eot() or string.find("\n|~}", c, 1, true) then
         if s ~= "" then
            text:add_string(s)
         end
         return text
      elseif string.find(" \t", c, 1, true) then
         spaces = spaces .. c
         it:next()
      else
         if c == "{" then
            if it:get_nextc() == "*" then
               -- The comment block can match "text_postfix" rule, so don't clear "spaces" if it's a comment block.
               it:next()
               it:next()
               while not it:eot() and it:getc() ~= "}" do
                  it:next()
               end
               it:next()
               if it:eot() then
                  throw_parse_error(it, "The end of the comment is expected.")
               end
            else
               s = s .. spaces
               spaces = ""
               s = parse_expansion(it, text, s)
            end
         else
            s = s .. spaces .. c
            spaces = ""
            it:next()
         end
      end
   end
end


--[[
   Parse an expansion.

   Accomplish the definitive conversions here.
   If the string enclosed by "{" and "}" may be a nonterminal, it's a non-definitive conversion.

   expansion = "{", [ { ? [^}] ? } ], "}" ;
--]]
function parse_expansion(it, text, pre_s)
   it:next()
   local c = it:getc()
   if it:get_nextc() == "}" then
      -- "{(}" and "{)}"
      if c == ")" then
         it:next()
         it:next()
         return pre_s .. "}"
      elseif c == "(" then
         it:next()
         it:next()
         return pre_s .. "{"
      end
   end

   if c == "=" or (c == ":" and it:get_nextc() == "=") then
      -- Anonymous production rule
      if c == ":" then
         it:next()
      end
      it:next()
      skip_space_nl(it)
      text:add_string(pre_s)
      local rule = parse_production_rule(it, "}")
      if c == ":" then
         rule:equalize_chance()
      end
      text:add_anon_rule(rule)
      return ""
   else
      local is_comment = c == "*"
      local is_nonterminal = c ~= "}" and not is_comment
      local name = ""
      while not it:eot() do
         c = it:getc()
         it:next()
         if c == "}" then
            if is_nonterminal then
               if pre_s ~= "" then
                  text:add_string(pre_s)
               end
               text:add_expansion(name)
               return ""
            elseif is_comment then
               return pre_s
            else
               return pre_s .. name
            end
         else
            is_nonterminal = is_nonterminal and string.find(c, "[A-Za-z0-9_]")
            if not is_comment then
               name = name .. c
            end
         end
      end
   end
   throw_parse_error(it, "The end of the brace expansion is expected.")
end


-- Is the current position a decimal number character?
local function is_decimal_number_char(c)
   if c and string.find("0123456789", c, 1, true) then
      return true
   else
      return false
   end
end


--[[
   Parse a number.

   number = ( ( { ? [0-9] ? }, [ "." ] ) | ( ".", ? [0-9] ? ) ), [ { ? [0-9] ? } ] ;
--]]
function parse_number(it)
   local s = ""
   local c = it:getc()
   if c == "." then
      it:next()
      c = it:getc()
      if is_decimal_number_char(c) then
         s = "." .. c
         it:next()
         c = it:getc()
      else
         throw_parse_error(it, 'A number is expected. ("." is not a number.)')
      end
   elseif is_decimal_number_char(c) then
      repeat
         s = s .. c
         it:next()
         c = it:getc()
      until not is_decimal_number_char(c)
      if c == "." then
         s = s .. c
         it:next()
         c = it:getc()
      end
   else
      return nil
   end
   while is_decimal_number_char(c) do
      s = s .. c
      it:next()
      c = it:getc()
   end
   return tonumber(s)
end


-- forward declaration
local parse_pattern, parse_integer

--[[
   Parse an gsubs.

   gsubs = [ { "~", space_one_nl_opt, sep, { pat }, sep2, [ { pat } ], sep2, [ ( "g" | integer ) ], space_opt } ] ; (* 'sep2' is the same character of 'sep'. *)
   sep = ? [^ \t\n{] ? ; (* '{' may be the beginning of the comment block. *)
--]]
function parse_gsubs(it)
   local gsubs = data.new_gsubs(parser.encoding.gsub)
   while not it:eot() and it:getc() == "~" do
      it:next()
      skip_space_one_nl(it)
      local sep = it:getc()
      if it:eot() then
         throw_parse_error(it, "Unexpected EOT.")
      elseif sep == "{" then
         throw_parse_error(it, '"{" isn\'t allowable as a separator.')
      end
      it:next()

      local pat = parse_pattern(it, sep, false)
      local repl = parse_pattern(it, sep, true)
      local n = parse_integer(it)
      if n == nil then
         if it:getc() == "g" then
            it:next()
         else
            n = 1
         end
      end
      gsubs:add_parameter(pat, repl, n)
      skip_space(it)
   end
   return gsubs
end


--[[
   Parse an integer.

   integer = { ? [0-9] ? } ;
--]]
function parse_integer(it)
   local c = it:getc()
   if is_decimal_number_char(c) then
      local s = ""
      repeat
         s = s .. c
         it:next()
         c = it:getc()
      until not is_decimal_number_char(c)
      return tonumber(s)
   else
      return nil
   end
end


--[[
   Parse an pattern.

   pat = ? all characters ? - sep2 ; (* 'sep2' is the character precedes 'pat' in the parent 'gsubs'. *)
--]]
function parse_pattern(it, sep, allow_empty)
   local pat = ""
   while not it:eot() and it:getc() ~= sep do
      pat = pat .. it:getc()
      it:next()
   end
   if not allow_empty and pat == "" then
      throw_parse_error(it, "The non-empty pattern is expected.")
   end
   if it:eot() then
      throw_parse_error(it, "Unexpected EOT.")
   end
   it:next()
   return pat
end

return parser
