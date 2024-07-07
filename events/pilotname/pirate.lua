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

This file derive from "dat/scripts/pilotname/pirate.lua" in Naev.
Copyright © 2021 bobbens@github
--]]

local static_phrase_generator = require "static_phrase_generator"

return function ()
   local ph = static_phrase_generator.get("pilotname_pirate")

   -- The weight of "main" is to normalize to 1.
   ph:add(_([[
    ARTICLE =
     Das |
     Der |
     Kono |
     La |
     Le |
     The |
     Ye

    DESCRIPTOR =
     Aerobic |
     Aku No |
     Amai |
     Ancient |
     Astro |
     Baggy |
     Bakana |
     Bald |
     Beautiful |
     Benevolent |
     Bedrohliche |
     Big |
     Big Bad |
     Bloody |
     Bright |
     Brooding |
     BT |
     Bureina |
     Caped |
     Citrus |
     Clustered |
     Cocky |
     Creamy |
     Crisis |
     Crusty |
     Dark |
     Deadly |
     Deathly |
     Defiant |
     Delicious |
     Despicable |
     Destructive |
     Diligent |
     Drunk |
     Egotistical |
     Electromagnetic |
     Erroneous |
     Escaped |
     Eternal |
     Evil |
     Fallen |
     Fearless |
     Fearsome |
     Filthy |
     Flightless |
     Flying |
     Foreboding |
     Fuketeru |
     Full-Motion |
     Furchtlose |
     General |
     Gigantic |
     Glittery |
     Glorious |
     Great |
     Groß |
     Grumpy |
     Hairy |
     Hammy |
     Handsome |
     Happy |
     Hashitteru |
     Hellen |
     Hen'na |
     Hidoi |
     Hilarious |
     Hitori No |
     Horrible |
     IDS |
     Imperial |
     Impressive |
     Insatiable |
     Ionic |
     Iron |
     Justice |
     Kakkowarui |
     Koronderu |
     Kowai |
     Lesser |
     Lightspeed |
     Lone |
     Loud |
     Lovely |
     Lustful |
     Mächtige |
     Malodorous |
     Messy |
     Mighty |
     Mijikai |
     Morbid |
     Mukashi No |
     Murderous |
     Nai |
     Naïve |
     Neutron-Accelerated |
     New |
     Night's |
     Nimble |
     Ninkyōna |
     No Good |
     Numb |
     Oishī |
     Ōkina |
     Old |
     Oshirisu No |
     Oyoideru |
     Pale |
     Perilous |
     Pirate's |
     Pocket |
     Princeless |
     Psychic |
     Raging |
     Reclusive |
     Relentless |
     Rostige |
     Rough |
     Ruthless |
     Saccharin |
     Salty |
     Samui |
     Satanic |
     Secluded |
     Seltsame |
     Serial |
     Sharing |
     Silly |
     Single |
     Sleepy |
     Slimy |
     Smelly |
     Solar |
     Space |
     Stained |
     Static |
     Steel |
     Strange |
     Strawhat |
     Sukina |
     Super |
     Sweaty |
     Sweet |
     Tall |
     Takai |
     Terrible |
     Tired |
     Toothless |
     Tropical |
     Tsukareteru |
     Typical |
     Ultimate |
     Umai |
     Uncombed |
     Undead |
     Unersättliche |
     Unhealthy |
     Unreal |
     Unsightly |
     Urusai |
     Utsukushī |
     Vengeful |
     Very Bad |
     Violent |
     Warui |
     Weeping |
     Wild |
     Winged |
     Wretched |
     Yaseteru |
     Yasui |
     Yasashī |
     Yummy

    COLOUR =
     Akai |
     Amarillo |
     Aoi |
     Azul |
     Blau |
     Bleu |
     Blue |
     Chairo No |
     Crimson |
     Cyan |
     Gelb |
     Gin'iro No |
     Golden |
     Gray |
     Green |
     Grün |
     Haiiro No |
     Kiiroi |
     Kin'iro No |
     Kuroi |
     Mauve |
     Midori No |
     Murasaki No |
     Pink |
     Purple |
     Red |
     Roho |
     Schwarz |
     Shiroi |
     Silver |
     Violet |
     Yellow

    ACTOR =
     1024 |
     Aku |
     Akuma |
     Alphabet Soup |
     Amigo |
     Angel |
     Angle Grinder |
     Anvil |
     Ari |
     Arrow |
     Ass |
     Atama |
     Aunt |
     Auster |
     Avenger |
     Axis |
     Baka |
     Bakemono |
     Band Saw |
     Bat |
     Beard |
     Belt Sander |
     Bench Grinder |
     Bengoshi |
     Black Hole |
     Blarg |
     Blitzschneider |
     Blizzard |
     Blood |
     Blunder |
     Boot |
     Bobber |
     Bolt Cutter |
     Bōshi |
     Brain |
     Breeze |
     Bride |
     Brigand |
     Bulk |
     Burglar |
     Cane |
     Chainsaw |
     Cheese |
     Cheese Grater |
     Chi |
     Chicken |
     Circle |
     Claw |
     Claw Hammer |
     Club |
     Coconut |
     Coot |
     Corsair |
     Cougar |
     Crisis |
     Crow |
     Crowbar |
     Crusader |
     Curse |
     Cyborg |
     Darkness |
     Death |
     Deity |
     Demon |
     Destruction |
     Devil |
     Dictator |
     Disaster |
     Discord |
     Donkey |
     Doom |
     Drache |
     Dragon |
     Dread |
     Drifter |
     Drill Press |
     Duckling |
     Eagle |
     Eggplant |
     Ego |
     Electricity |
     Emperor |
     Energy-Volt |
     Engine |
     Fang |
     Flare |
     Flash |
     Fox |
     Friend |
     Fugitive |
     Gaki |
     Geschützturmdrehbank |
     Giant |
     Gift |
     Gohan |
     Goose |
     Gorilla |
     Gun |
     Hae |
     Hamburger |
     Hammer |
     Headache |
     Hex |
     Hikari |
     Horobi |
     Horror |
     Hunter |
     Husband |
     Ichigo |
     Id |
     Impact Wrench |
     Inazuma |
     Ionizer |
     Ishi |
     Itoyōji |
     Jalapeño |
     Jigsaw |
     Jishin |
     Jinx |
     Ka |
     Kailan |
     Kaji |
     Kamakiri |
     Kame |
     Kami |
     Kamikaze |
     Kappa |
     Karaoke |
     Katana |
     Kaze |
     Keel |
     Ketchup |
     Killer |
     Kirin |
     Kitchen Knife |
     Kitsune |
     Kitten |
     Knave |
     Knife |
     Knight |
     Kōmori |
     Kumo |
     Lance |
     Lanze |
     Lantern |
     Lawyer |
     League |
     Lust |
     Madōshi |
     Magician |
     Mahō |
     Maize |
     Mangaka |
     Mangekyō |
     Mango |
     Mech |
     Melon |
     Mind |
     Model |
     Monster |
     Mosquito |
     Moustache |
     Mugi |
     Nanika |
     Neckbeard |
     Necromancer |
     Neko |
     Nezumi |
     Night |
     Niku |
     Ninja |
     Niwatori |
     Nova |
     Ogre |
     Oni |
     Onion |
     Osiris |
     Outlaw |
     Oyster |
     Panther |
     Paste |
     Pea |
     Peapod |
     Peril |
     Pickaxe |
     Pipe Wrench |
     Pitchfork |
     Politician |
     Potato |
     Potter |
     Pride |
     Princess |
     Pulse |
     Puppy |
     Python |
     Raigeki |
     Ramen |
     Rat |
     Ratte |
     Ravager |
     Raven |
     Reaver |
     Recluse |
     Rice |
     Ring |
     River |
     Roba |
     Rōjin |
     Rubber Mallet |
     Ryū |
     Sakura |
     Salad |
     Samurai |
     Sasori |
     Scythe |
     Sea |
     Seaweed |
     Seijika |
     Sentinel |
     Serpent |
     Shepherd |
     Shinigami |
     Shinobi |
     Shock |
     Shovel |
     Shujin |
     Siren |
     Slayer |
     Space Dog |
     Spade |
     Spaghetti |
     Spaghetti Monster |
     Spider |
     Squeegee |
     Staple Gun |
     Stern |
     Stir-fry |
     Storm |
     Supernova |
     Surströmming |
     Table Saw |
     Tallman |
     Tanoshimi |
     Tatsumaki |
     Tegami |
     Teineigo |
     Tenkūryū |
     Terror |
     Thunder |
     Tomodachi |
     Tooth |
     Tora |
     Tori |
     Treasure Hunter |
     Tree |
     Tsuchi |
     Tumbler |
     Turret Lathe |
     Twilight |
     Tyrant |
     Umi |
     Urchin |
     Velocity |
     Vengeance |
     Void |
     Vomit |
     Wache |
     Watcher |
     Wedge |
     Widget |
     Widow |
     Wight |
     Willow |
     Wind |
     Wizard |
     Wolf |
     Yakuza |
     Yama |
     Yami |
     Yarou |
     Yasai |
     Yatsu |
     Youma |
     Zombie

    main 1 =
     {ARTICLE} {ACTOR} |
     {COLOUR} {ACTOR} |
     {DESCRIPTOR} {ACTOR} |
     {ARTICLE} {DESCRIPTOR} {ACTOR} |
     {ARTICLE} {COLOUR} {ACTOR} |
     {ARTICLE} {DESCRIPTOR} {COLOUR} {ACTOR}
   ]]))
end
