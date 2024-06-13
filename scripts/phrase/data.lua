--[[
   Data structures for the phrase generator.
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

local data = {}


--[[
   Random function to use the selection.
   You may replace it if you want. (Use phrase.set_random_function(f))

   data.rand must be compatible with math.random() and math.random(n).
   This module never use two parameters form math.random(n, m).
--]]
data.rand = math.random

--[[
   An utility function
   Search a weight array for an index

   return: n when weights[n-1] <= target < weights[n]
           1 when target < weights[1]
           #weights when weights[#weights] <= target
--]]
local function search_index(target, weights)
   if #weights <= 32 then
      -- linear search
      for i = 1, #weights - 1 do
         if target < weights[i] then
            return i
         end
      end
      return #weights
   else
      -- binary search
      local b = 1
      local e = #weights
      local m = math.floor(#weights / 2)
      while true do
         if target < weights[m] then
            if m == 1 then
               return 1
            elseif weights[m - 1] <= target then
               return m
            else
               e = m - 1
            end
         else
            if m == e then
               return e
            elseif target < weights[m + 1] then
               return m + 1
            else
               b = m + 1
            end
         end
         m = math.floor((e - b) / 2) + b
      end
   end
end


--[[
   text structure
   It represents a text, including nonterminals and production rules to replace into some expressions.
   Note: It cannot be shared by multiple syntaxes.

   Private data:
   .parts[n]: The part of the text, the nonterminal, or the production rule.
   .f[n]: The function to generate the part of the text if .parts[n] is a nonterminal.
   .comb: The combination number of the possible expressions.
   .weight: The weight of the text as an option.
   .weight_by_user: The weight is set by user.

   Public functions:
   .get_combination_number(): The combination number of the possible expressions.
   .get_weight(): The weight of the text.
   .generate(): The generated text.

   .add_string(): used by the parser.
   .add_expansion(): used by the parser.
   .add_anon_rule(): used by the parser.
   .set_weight(): used by the parser.
   .bind_syntax(): bind the unsolved nonterminals.

   .clone(): clone this.

   Type ID:
   .type_text: the ID of the type
--]]
function data.new_text()
   local text = {}
   text.parts = {}
   text.f = {}
   text.comb = 1
   text.weight = 1
   text.weight_by_user = false
   text.type_text = true

   text.get_combination_number = function (self)
      return self.comb
   end

   text.get_weight = function (self)
      return self.weight
   end

   text.generate = function (self, param)
      local s = ""
      for i = 1, #self.parts do
         if self.f[i] then
            s = s .. self.f[i](param)
         else
            s = s .. self.parts[i]
         end
      end
      return s
   end

   text.add_string = function (self, part_of_text)
      self.parts[#self.parts + 1] = part_of_text
   end

   text.add_expansion = function (self, key)
      local new_idx = #self.parts + 1
      self.parts[new_idx] = key
      self.f[new_idx] = function (param)
         if type(param) == "table" and param[key] ~= nil then
            return tostring(param[key])
         else
            return key
         end
      end
   end

   text.add_anon_rule = function (self, rule)
      local new_idx = #self.parts + 1
      self.parts[new_idx] = rule
      self.f[new_idx] = function (param)
         return rule:generate(param)
      end
   end

   text.set_weight = function (self, w)
      self.weight_by_user = w ~= nil
      self.weight = w
   end

   text.bind_syntax = function (self, syntax, used_keys)
      local err_msg = ""
      self.comb = 1
      local weight = 1
      for i = 1, #self.parts do
         if self.f[i] then
            local key = self.parts[i]
            local is_anon_rule = type(key) == "table"
            if not is_anon_rule and used_keys[key] then
               err_msg = err_msg .. 'Recursive expansion of "' .. key .. '" is detected.\n'
            elseif is_anon_rule or syntax:has_nonterminal(key) then
               local rule
               if is_anon_rule then
                  rule = key
                  err_msg = err_msg .. rule:bind_syntax(syntax, used_keys)
               else
                  rule = syntax:get_production_rule(key)
                  used_keys[key] = true
                  err_msg = err_msg .. rule:bind_syntax(syntax, used_keys)
                  used_keys[key] = nil
                  self.f[i] = function (param)
                     return rule:generate(param)
                  end
               end
               self.comb = self.comb * rule:get_combination_number()
               weight = weight * rule:get_weight()
            end
         end
      end
      if not self.weight_by_user then
         self.weight = weight
      end
      return err_msg
   end

   text.clone = function (self)
      local new = data.new_text()
      new.weight_by_user = self.weight_by_user

      for i = 1, #self.parts do
         if self.parts[i].clone then
            new.parts[i] = self.parts[i]:clone()
            new.f[i] = function (param)
               return new.parts[i]:generate(param)
            end
         else
            new.parts[i] = self.parts[i]
            if self.f[i] then
               new.f[i] = function (param)
                  if type(param) == "table" and param[key] ~= nil then
                     return tostring(param[key])
                  else
                     return key
                  end
               end
             end
         end
      end
      return new
   end

   return text
end

--[[
   options structure
   It represents the options of the text.
   Note: It cannot be shared by multiple syntaxes.

   Private data:
   .texts[n]: An option of the text.
   .weights[n]: The sum of the weights of the texts[1] to [n].
   .equalized_chance: Does it equalize the chance to select each text option.

   Public functions:
   .generate(): The generated text.
   .get_weight(): The sum of the weights of the texts.
   .get_combination_number(): The combination number of the possible expressions.

   .add_text(): used by the parser.
   .equalize_chance(): used by the parser.
   .bind_syntax(): bind the unsolved nonterminals.

   .clone(): clone this.

   Type ID:
   .type_options: the ID of the type
--]]
function data.new_options()
   local options = {}
   options.texts = {}
   options.weights = {}
   options.equalized_chance = false
   options.type_options = true

   options.generate = function (self, param)
      local i = 1
      if #self.texts > 1 then
         if self.equalized_chance then
            i = data.rand(#self.texts)
         else
            local r = data.rand() * self:get_weight()
            i = search_index(r, self.weights)
         end
      end
      return self.texts[i]:generate(param)
   end

   options.get_weight = function (self)
      if #self.weights == 0 then
         return 0
      else
         return self.weights[#self.weights]
      end
   end

   options.get_combination_number = function (self)
      local sum = 0
      for _, t in ipairs(self.texts) do
         sum = sum + t:get_combination_number()
      end
      return sum
   end

   options.add_text = function (self, text)
      local new_idx = #self.texts + 1
      self.texts[new_idx] = text
      if new_idx > 1 then
         self.weights[new_idx] = self.weights[new_idx - 1] + 1
      else
         self.weights[new_idx] = 1
      end
   end

   options.equalize_chance = function (self, enable)
      if enable == nil then
         self.equalized_chance = true
      else
         self.equalized_chance = enable
      end
   end

   options.bind_syntax = function (self, syntax, used_keys)
      local sum = 0
      local err_msg = ""
      for i, text in ipairs(self.texts) do
         err_msg = err_msg .. text:bind_syntax(syntax, used_keys)
         sum = sum + text:get_weight()
         self.weights[i] = sum
      end
      return err_msg
   end

   options.clone = function (self)
      local new = data.new_options()
      new.equalized_chance = self.equalized_chance
      for i = 1, #self.texts do
         new.texts[i] = self.texts[i]:clone()
         new.weights[i] = i -- initial value
      end
      return new
   end

   return options
end

--[[
   gsubs structure
   It represents the gsub functions.

   Private data:
   .patterns[n]: pattern parameters for gsub
   .repls[n]: repl parameters for gsub
   .n[n]: n parameters for gsub
   .gsub_f: gsub function

   Public functions:
   .gsub(): apply the parameters.

   .add_parameter(): used by the parser.

   Type ID:
   .type_gsubs: the ID of the type
--]]
function data.new_gsubs(f)
   local gsubs = {}
   gsubs.patterns = {}
   gsubs.repls = {}
   gsubs.n = {}
   gsubs.gsub_f = f
   gsubs.type_gsubs = true

   gsubs.gsub = function (self, s)
      local r = s
      for i = 1, #self.patterns do
         r = self.gsub_f(r, self.patterns[i], self.repls[i], self.n[i])
      end
      return r
   end

   gsubs.add_parameter = function (self, pattern, repl, n)
      local i = #self.patterns + 1
      self.patterns[i] = pattern
      self.repls[i] = repl
      self.n[i] = n
   end

   return gsubs
end

--[[
   production_rule structure
   It represents the production rule.
   Note: It cannot be shared by multiple syntaxes.

   Private data:
   .options: options in the production rule.
   .gsubs: gsubs in the production rule.

   Public functions:
   .generate(): generate a text.
   .get_weight(): The sum of the weights of the texts.
   .get_combination_number(): The combination number of the possible texts.

   .set_options(): used by the parser.
   .set_gsubs(): used by the parser.
   .equalize_chance(): used by the parser.
   .bind_syntax(): bind the unsolved nonterminals.

   .clone(): clone this.

   Type ID:
   .type_production_rule: the ID of the type
--]]
function data.new_production_rule()
   local rule = {}
   rule.type_production_rule = true

   rule.generate = function (self, param)
      local s = ""
      if self.options then
         s = self.options:generate(param)
      end
      if self.gsubs then
         s = self.gsubs:gsub(s)
      end
      return s
   end

   rule.get_weight = function (self)
      if self.options then
         return self.options:get_weight()
      else
         return 0
      end
   end

   rule.get_combination_number = function (self)
      if self.options then
         return self.options:get_combination_number()
      else
         return 0
      end
   end

   rule.set_options = function (self, options)
      self.options = options
   end

   rule.set_gsubs = function (self, gsubs)
      self.gsubs = gsubs
   end

   rule.equalize_chance = function (self, enable)
      self.options:equalize_chance(enable)
   end

   rule.bind_syntax = function (self, syntax, used_keys)
      local err_msg = ""
      if self.options then
         err_msg = self.options:bind_syntax(syntax, used_keys)
      end
      return err_msg
   end

   rule.clone = function (self)
      local new = data.new_production_rule()
      new.gsubs = self.gsubs -- gsubs are harmless.
      if self.options then
         new.options = self.options:clone()
      end
      return new
   end

   return rule
end

--[[
   syntax structure
   It represents the syntax.

   Private data:
   .assignments: key: nonterminal, value: production_rule
   .binded: already executed bind_syntax().

   Public functions:
   .generate(): generate a text.
   .has_nonterminal(): does it have the nonterminal?
   .get_production_rule(): return the production rule.
   .get_weight(): the sum of the weight of the "main" production rule.
   .get_combination_number(): the combination number of the "main" production rule.
   .is_valid(): Is this a valid syntax?

   .add(): used by the parser.
   .bind_syntax(): bind the unsolved nonterminals.

   .clone(): clone this.

   Type ID:
   .type_syntax: the ID of the type
--]]
function data.new_syntax ()
   local syntax = {}
   syntax.assignments = {}
   syntax.binded = false
   syntax.type_syntax = true

   syntax.generate = function (self, param)
      if self:is_valid() then
         return self.assignments["main"]:generate(param)
      else
         return "nil"
      end
   end

   syntax.has_nonterminal = function (self, nonterminal)
      return self.assignments[nonterminal];
   end

   syntax.get_production_rule = function (self, nonterminal)
      return self.assignments[nonterminal];
   end

   syntax.get_weight = function (self)
      if self:is_valid() then
         return self.assignments["main"]:get_weight()
      else
         return 0
      end
   end

   syntax.get_combination_number = function (self)
      if self:is_valid() then
         return self.assignments["main"]:get_combination_number()
      else
         return 0
      end
   end

   syntax.add = function (self, nonterminal_or_syntax, production_rule)
      if nonterminal_or_syntax == nil then
         return
      elseif production_rule ~= nil then
         self.assignments[nonterminal_or_syntax] = production_rule
      else
         for n, p in pairs(nonterminal_or_syntax.assignments) do
            self.assignments[n] = p
         end
      end
      self.binded = false
   end

   syntax.is_valid = function (self)
      return self.binded and self.assignments["main"]
   end

   syntax.bind_syntax = function (self)
      local err_msg = ""
      if self.assignments["main"] then
         err_msg = self.assignments["main"]:bind_syntax(self, { main = true })
         self.binded = err_msg == ""
      end
      return err_msg
   end

   syntax.clone = function (self)
      local new = data.new_syntax()
      for k, v in pairs(self.assignments) do
         new.assignments[k] = v:clone()
      end
      return new
   end

   return syntax
end

--[[
   phrase data structure
   It represents the phrase.

   Private data:
   .syntaxes[n]: the syntaxes
   .weights[n]: the sum of the weights of the syntaxes[1] to [n].
   .equalized_chance: Does it equalize the chance to select each phrase syntax?

   Public functions:
   .generate(): generate a text.

   .add(): add a syntax into the phrase.
   .equalize_chance(): Equalize the chance to select each phrase syntax.
   .get_number_of_syntax(): The number of the syntaxes in the phrase.
   .get_weight(): The sum of the weight of the syntaxes.
   .get_combination_number(): The combination number of the phrase.

   Type ID:
   .type_phrase_data: the ID of the type
--]]
function data.new_phrase_data ()
   local phrase = {}
   phrase.syntaxes = {}
   phrase.weights = {}
   phrase.equalized_chance = false
   phrase.type_phrase_data = true

   phrase.generate = function (self, param)
      if #self.syntaxes >= 1 then
         local i = 1
         if #self.syntaxes > 1 then
            if self.equalized_chance then
               i = data.rand(#self.syntaxes)
            else
               local r = data.rand() * self:get_weight()
               i = search_index(r, self.weights)
            end
         end
         return self.syntaxes[i]:generate(param)
      else
         return "nil"
      end
   end

   phrase.add = function (self, syntax)
      if not syntax:is_valid() then
         return false
      end

      local sum = 0
      if #self.weights >= 1 then
         sum = self.weights[#self.weights]
      end

      local new_idx = #self.syntaxes + 1
      self.syntaxes[new_idx] = syntax
      self.weights[new_idx] = sum + syntax:get_weight()

      return true
   end

   phrase.equalize_chance = function (self, enable)
      if enable == nil then
         self.equalized_chance = true
      else
         self.equalized_chance = enable
      end
   end

   phrase.get_number_of_syntax = function (self)
      return #self.syntaxes
   end

   phrase.get_weight = function (self)
      if #self.weights > 0 then
         return self.weights[#self.weights]
      else
         return 0
      end
   end

   phrase.get_combination_number = function (self)
      local sum = 0
      for _, s in ipairs(self.syntaxes) do
         sum = sum + s:get_combination_number()
      end
      return sum
   end

   return phrase
end

return data
