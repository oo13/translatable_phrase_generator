--[[
   Phrase generator.
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

local phrase_data = require "phrase.data"
local phrase_parser = require "phrase.parser"

local phrase = {}
local phrase_mt = { __index = phrase }
phrase.utf8_is_required = true

local check_encoding_consistency

--[[
   Create an instance of the phrase generator.

   param: text_or_compiled  A text or a compiled data of the phrase syntax, or nil to request the empty instance.
          start_condition  A string that has the name of the nonterminal where is the start condition, or nil that means "main".

   return: The phrase generator if no errors are detected.
           An empty phrase generator if non fatal errors are detected.
           nil if a fatal error is detected.

   note: output_error() and output_compile_error() is called if some errors are detected.
--]]
function phrase.new(text_or_compiled, start_condition)
   if not check_encoding_consistency() then
      return nil
   end
   local instance = {}
   setmetatable(instance, phrase_mt)
   instance.data = phrase_data.new_phrase_data()
   instance.type_phrase = true
   if text_or_compiled then
      instance:add(text_or_compiled, start_condition)
   end
   return instance
end

--[[
   Add a phrase syntax into the instance.

   param: text_or_compiled  A text or a compiled data of the phrase syntax.
          start_condition  A string that has the name of the nonterminal where is the start condition, or nil that means "main".

   return: false if the phrase syntax fail to add into the phrase generator due to some errors.

   note: output_error() and output_compile_error() is if when some errors are detected.
--]]
function phrase:add(text_or_compiled, start_condition)
   local text, syntax, err_msg
   if type(text_or_compiled) == "string" then
      text = text_or_compiled
      syntax, err_msg = phrase_parser.parse(text)
   elseif type(text_or_compiled) == "table" and text_or_compiled.type_compiled_syntax then
      text = nil
      err_msg = ""
      syntax = text_or_compiled.data:clone()
   else
      phrase.output_error("Invalid parameter type.")
      return false
   end
   if err_msg == "" then
      if start_condition == nil then
         start_condition = "main"
      end
      err_msg = syntax:bind_syntax(start_condition)
      if err_msg == "" and not self.data:add(syntax) then
         err_msg = "Fail to add the syntax.\n"
      end
   end
   if err_msg ~= "" then
      self.output_compile_error(text, err_msg)
      return false
   else
      return true
   end
end

--[[
   Generate a phrase.

   param: ext_context  nil, or a table that has a set of the nonterminal and the value.
   return: A phrase text.

   note: 'ext_context' is used only for the unsolved nonterminals.
--]]
function phrase:generate(ext_context)
   return self.data:generate(ext_context)
end


local compiled_syntax_add

--[[
   Compile a phrase syntax to generate the compiled data.

   param: text  A string of a phrase syntax, or nil to request the empty instance.
   return: The compiled data if no errors are detected.
           nil if some errors are detected.

   note: output_error() and output_compile_error() is if when some errors are detected.
--]]
function phrase.compile(text)
   if not check_encoding_consistency() then
      return nil
   end
   local syntax, err_msg
   if text ~= nil then
      syntax, err_msg = phrase_parser.parse(text)
      if err_msg ~= "" then
         phrase.output_compile_error(text, err_msg)
         return nil
      end
   else
      syntax = phrase_data.new_syntax()
   end

   local compiled = {}
   compiled.data = syntax
   compiled.type_compiled_syntax = true
   compiled.add = compiled_syntax_add
   return compiled
end

--[[
   A instance method of the compiled data that adds a phrase syntax into "self" after compiling the syntax if needed.

   param: text_or_compiled  A text or a compiled data of the phrase syntax.

   return: false if the phrase syntax fail to add into the instance due to some errors.

   note: output_error() and output_compile_error() is if when some errors are detected.
   note: The production rules for the existing nonterminals is overwritten if "text_or_compiled" has the assignment for the same nonterminal.
--]]
function compiled_syntax_add(self, text_or_compiled)
   local compiled_to_add = nil
   if type(text_or_compiled) == "string" then
      compiled_to_add = phrase.compile(text_or_compiled)
   elseif type(text_or_compiled) == "table" and text_or_compiled.type_compiled_syntax then
      compiled_to_add = {}
      compiled_to_add.data = text_or_compiled.data:clone()
   else
      phrase.output_error("Invalid parameter type.")
   end
   if compiled_to_add then
      self.data:add(compiled_to_add.data)
      return true
   else
      return false
   end
end

--[[
   Equalize the chance to select each phrase syntax.

   param: enable  It equalizes the chance to select each phrase syntax if "enable" is true or nil. If 'enable' is false, the chance depends on the weight of the phrase syntax.
--]]
function phrase:equalize_chance(enable)
   self.data:equalize_chance(enable)
end

--[[
   Get the number of the syntaxes in the instance..

   return: The number of the phrase syntaxes in the instance.
--]]
function phrase:get_number_of_syntax()
   return self.data:get_number_of_syntax()
end

--[[
   Get the sum of the weight of the syntaxes in the instance.

   return: The sum of the weight of the syntaxes in the instance.
--]]
function phrase:get_weight()
   return self.data:get_weight()
end

--[[
   Get the number of the possible phrases generated by the instance.

   return: The number of the possible phrases generated by the instance.
--]]
function phrase:get_combination_number()
   return self.data:get_combination_number()
end

--[[
   Set a random function to generate a phrase text.

   param: f The function that is compatible with math.random() and math.random(n).
--]]
function phrase.set_random_function(f)
   phrase_data.rand = f
end

--[[
   Configure the requirement for the character encoding, and try to enable it.

   param: enable if it's true or nil, UTF-8 support is required and tried to enable. (default)
                 if it's false, The plain 8 bit encoding support is required and tried to enable.

   return: false if fail to set the required encoding.
--]]
function phrase.require_utf8(enable)
   if enable == nil then
      enable = true
   end
   phrase.utf8_is_required = enable
   return phrase_parser.set_encoding_utf8(enable)
end

-- Check the character encoding is consistent.
function check_encoding_consistency()
   if phrase.utf8_is_required then
      if not phrase_parser.check_encoding_utf8() then
         phrase.output_error('The module "phrase" requires the character encoding UTF-8.\n')
         return false
      end
   else
      if phrase_parser.check_encoding_utf8() then
         phrase.output_error('The module "phrase" requires the plain 8 bit character encoding.\n')
         return false
      end
   end
   return true
end

--[[
   Default function to output the error messages.
--]]
function phrase.output_error(err_msg)
   io.stderr:write(err_msg)
end

--[[
   Truncate a program text of a phrase syntax to output it in the error message.
--]]
local function trunc_syntax(text)
   local target_len = 40

   text = text:gsub("^%s+(.+)%s$", "%1")
   local s = ""
   local count = 0
   local len = text:len()
   while count < len do
      local c = string.char(text:byte(count, count))
      if c == "\n" then
         break
      end

      s = s .. c
      count = count + 1

      if count >= target_len and string.find(" \t=|~", c, 1, true) then
         break
      end
   end
   if count < len then
      s = s .. "..."
   else
      s = text
   end
   return s
end

--[[
   Default function to output the compile error messages.
   This function uses output_error() to output.
--]]
function phrase.output_compile_error(text, err_msg)
   if text ~= nil then
      phrase.output_error('Error in the phrase "' .. trunc_syntax(text) .. '":\n' .. err_msg)
   else
      phrase.output_error('Error at compiling:\n' .. err_msg)
   end
end

return phrase
