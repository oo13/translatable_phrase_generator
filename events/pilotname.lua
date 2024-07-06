--[[
<?xml version='1.0' encoding='utf8'?>
<event name="Configure pilot names">
 <location>load</location>
 <chance>100</chance>
</event>
--]]
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

This file derive from "dat/events/news.lua" in Naev.
Copyright © 2022, 2023 bobbens@github
--]]

local lf = require "love.filesystem"
local static_phrase_generator = require "static_phrase_generator"

function create ()
   -- Reset the pilotname
   static_phrase_generator.reset()

   -- Check the subdirectory "events/pilotname" as it's the Naev manner.
   for k, v in ipairs(lf.getDirectoryItems("events/pilotname")) do
      require("events.pilotname." .. string.gsub(v, ".lua", ""))()
   end

   -- You can add a phrase syntax into the static phrase generator at any time.
end
