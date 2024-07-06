--[[
   Endless names plugin for Naev.
--]]
--[[
This plugin is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This plugin is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this plugin.  If not, see <http://www.gnu.org/licenses/>.

Copyright © 2024 OOTA, Masato
--]]

local static_phrase_generator = {}

-- The phrase generator with the "static" lifetime.
-- The translatable phrase generator is not too heavy, but it should have static lifetime, because an event can add a new phrase into a phrase generator.

-- Reset the static phrase generator.
-- key: the key name of the generator, or nil means all generators.
function static_phrase_generator.reset(key)
   local g = naev.cache()
   if g.static_phrase_generator then
      if not key then
         g.static_phrase_generator = nil
      elseif g.static_phrase_generator[key] then
         g.static_phrase_generator[key] = nil
      end
   end
end

-- Get the static phrase generator
function static_phrase_generator.get(key)
   local g = naev.cache()
   if not g.static_phrase_generator then
      g.static_phrase_generator = {}
   end
   if not g.static_phrase_generator[key] then
      local phrase = require "phrase"
      local naev_rnd = require "phrase.naev_rnd_wrapper"

      phrase.output_error = warn
      phrase.set_random_function(naev_rnd.f)

      g.static_phrase_generator[key] = phrase.new()
   end
   return g.static_phrase_generator[key]
end

return static_phrase_generator

