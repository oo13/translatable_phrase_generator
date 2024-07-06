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

return function ()
   local ph = static_phrase_generator.get("pilotname_generic")

   -- The weight of "main" is to normalize to 1.
   ph:add(_([[
    NAME =
     Aurochs |
     Axis |
     Bear |
     Beetle |
     Black Hole |
     Blizzard |
     Blood |
     Blue |
     Boa |
     Boulder |
     Bullet |
     Chainsaw |
     Claw |
     Cluster |
     Cougar |
     Crisis |
     Crow |
     Dart |
     Death |
     Deity |
     Demon |
     Diamond |
     Dire Wolf |
     Dragon |
     Eagle |
     Earthquake |
     Electron |
     Falcon |
     Fang |
     Fire |
     Fox |
     Glory |
     Hammer |
     Hawk |
     Hornet |
     Hunter |
     Hurricane |
     Ice |
     Ion |
     Lantern |
     Leopard |
     Light |
     Lion |
     Lizard |
     Mammoth |
     Mantis |
     Mech |
     Mosquito |
     Neutron |
     Nova |
     Orca |
     Panther |
     Peril |
     Photon |
     Pride |
     Proton |
     Python |
     Raven |
     Rebirth |
     Red |
     Raptor |
     Rex |
     Rocket |
     Rogue |
     Saber |
     Scorpion |
     Scythe |
     Serpent |
     Shadow |
     Shark |
     Star Killer |
     Spade |
     Spider |
     Talon |
     Thunder |
     Tiger |
     Torch |
     Tsunami |
     Turtle |
     Typhoon |
     Velocity |
     Vengeance |
     Void |
     Wasp |
     Wind |
     Wing |
     Wolf |
     Wraith |
     Zombie

    main = "{NAME} {LETTER}{SUFFIX}" 1
   ]]))
end
