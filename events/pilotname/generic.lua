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
local phrase = require "phrase"

return function ()
   local syntax = phrase.compile()

   syntax:add(_([[
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
   ]]))

   -- "1" to "99"  The rational person counts from zero.😆
   syntax:add(_([[
    _N19 = 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
    NUM = {_N19}{_N19} | {_N19} | {_N19}0
   ]]))

   syntax:add(_([[
    _I = I | II | III | IV | V | VI | VII | VIII | IX
    _X = X | XX | XXX | XL | L | LX | LXX | LXXX | XC
    ROMAN_NUM = {_X}{_I} | {_I} | {_X}
   ]]))

   -- I doubt _NUMBER is intentional, but Naev does so.
   syntax:add(_([[
    _GREEK = α | β | γ | δ | ε | ζ | Δ | Σ | Ψ | Ω
    _NUMBER = "1" 0.4 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | "11" 0.5
    SUFFIX = "{_GREEK}" 0.5 | "{_GREEK}-{_NUMBER}" 0.5
   ]]))

   -- The weight of "main" is to normalize to 1.
   syntax:add(_([[
    main 1 =
     "{NAME} {NUM}" 0.5 |
     "{NAME} {ROMAN_NUM}" 0.35 |
     "{NAME} {SUFFIX}" 0.15
   ]]))

   local ph = static_phrase_generator.get("pilotname_generic")
   ph:add(syntax)
end
