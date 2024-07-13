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

This file derives from "dat/scripts/pilotname/generic.lua" in Naev.
Copyright © 2021 bobbens@github
--]]

local static_phrase_generator = require "static_phrase_generator"

--[[
-- @brief Generates generic pilot names
--]]
local function generic ()
   local pilotname_generic = static_phrase_generator.get("pilotname_generic")
   return pilotname_generic:generate()
end

return generic
