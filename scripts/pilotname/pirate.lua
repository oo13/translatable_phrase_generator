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

The definitions of the Endless names derive from "data/names.txt" in Endless Sky 0.9.8.
Copyright (c) 2014 by Michael Zahniser
Copyright (c) 2015 eflyon@github
Copyright (c) 2015 akien-mga@github
Copyright (c) 2015-2017 Pointedstick@github
--]]

local phrase = require "phrase"
local naev_rnd = require "phrase.naev_rnd_wrapper"

phrase.output_error = warn
phrase.set_random_function(naev_rnd.f)

-- Naev names
local names = phrase.new(_([[
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

 main =
  {ARTICLE} {ACTOR} |
  {COLOUR} {ACTOR} |
  {DESCRIPTOR} {ACTOR} |
  {ARTICLE} {DESCRIPTOR} {ACTOR} |
  {ARTICLE} {COLOUR} {ACTOR} |
  {ARTICLE} {DESCRIPTOR} {COLOUR} {ACTOR}
]]))

-- Endless names
local endless_syntax = phrase.compile()

-- All of these should sound good when preceded by the word "of" or when "'s" is added onto the end
endless_syntax:add(_([[
 SINISTER_NAMES =
  Blackbeard |
  Bluebeard |
  Lilith |
  Horus |
  Baal |
  Chernabog |
  Abaddon |
  Satan |
  Mordecai |
  Jezebel |
  Pandora |
  Asmodan |
  Charon |
  Mordred |
  Baphomet |
  Haekati |
  Deava |
  Amon |
  Gehenna |
  Malik |
  Perdition |
  Vladimir |
  Nergal |
  Azazel |
  Lucifer |
  Vexan |
  Babi |
  Belial |
  Djinn |
  Nosferatu |
  Ravenna |
  Simon |
  Tarik |
  Agrona |
  Lorelei |
  Cassandra |
  Balthazar |
  Rasputin |
  Khan |
  Malachai
]]))

endless_syntax:add(_([[
 PIRATE_ADJECTIVES =
  Sea |
  Grey |
  Morning |
  Night |
  Evening |
  Midnight |
  Black |
  Dead |
  Golden |
  Silver |
  Flying |
  Dark |
  Sky |
  Sunset |
  Shadow |
  Red |
  Crimson |
  Thunder |
  Poisoned |
  Venomous |
  Towering |
  Ghoulish |
  Dreadful |
  Baleful |
  Sundered |
  Brutal |
  Chaos |
  Boiling |
  Shackled |
  Blinded |
  Savage |
  Bloody |
  Bleeding |
  Scorched |
  Gray |
  Moonlight |
  Terrible |
  Horrible |
  Devouring |
  Ruinous |
  Ruined |
  Nightmare |
  Deadly |
  Rotten |
  Tattered |
  Rusty |
  Screaming |
  Painful |
  Suffocating |
  Evil |
  Wicked |
  Trickster |
  Laughing |
  Lost |
  Damned |
  Fallen |
  Crumbling |
  Murderous |
  Sadistic |
  Crippled |
  Flayed |
  Greedy |
  Despairing
]]))

endless_syntax:add(_([[
 PIRATE_ADJECTIVES_THAT_DONT_WORK_BEFORE_SINGULAR_NOUNS =
  Flames of |
  Reign of |
  Death by |
  Screams of |
  Cackles of
]]))

endless_syntax:add(_([[
 PIRATE_NOUNS =
  Star |
  Spectre |
  Queen |
  Wolf |
  Rover |
  Rambler |
  King |
  Prince |
  Princess |
  Dragon |
  Galley |
  Hunter |
  Killer |
  Bandit |
  Thief |
  Chain |
  Falcon |
  Raptor |
  Hawk |
  Stag |
  Fog |
  Marauder |
  Dominator |
  Blade |
  Sword |
  Knife |
  Cutlass |
  Cannon |
  Slaughter |
  Devil |
  God |
  Inferno |
  Abyss |
  Tyrant |
  Usurper |
  Ravager |
  Massacre |
  Exile |
  Storm |
  Corsair |
  Demon |
  Intruder |
  Naga |
  Dungeon |
  Hook |
  Tattoo |
  Horns |
  Slash |
  Morningstar |
  Serpent |
  Hammer |
  Children |
  Thunderbolt |
  Tomb |
  Barrel |
  Tankard |
  Bolt |
  Ship |
  Barge |
  Brig |
  Hulk |
  Realm |
  Hands |
  Fate |
  Raider |
  Volcano |
  Revenge
]]))

endless_syntax:add(_([[
 BAD_OUTCOMES =
  Doom |
  Death |
  Ruin |
  Pain |
  Agony |
  Decay |
  Screams |
  Torment |
  Torture |
  Madness |
  Insanity |
  Misery |
  Anguish |
  Conquest |
  Domination |
  Darkness |
  Spite |
  Violation |
  Apocalypse |
  Nightmare |
  Ragnarok |
  Hell |
  Plunder |
  Malice |
  Destruction |
  Blood |
  Poison |
  Blight |
  Fury |
  Misfortune |
  Damnation |
  Contagion |
  Betrayal |
  Asphyxiation |
  Hatred |
  Vileness |
  Evil |
  Murder |
  Oppression
]]))

endless_syntax:add(_([[
 PIRATE_0 =
  Caleuche |
  Lady Lovibond |
  Flying Dutchman |
  Princess Augusta |
  Eliza Battle |
  Iron Mountain |
  Eurydice |
  Valencia |
  Octavius |
  Jenny |
  Ourang Medan |
  Sea Bird |
  Resolute |
  Mary Celeste |
  Resolven |
  Zebrina |
  Deering |
  Bavchimo |
  Governor Parr |
  Joyita |
  Teignmouth Electron |
  Ocean Wave |
  High Aim |
  Jian Seng |
  Bel Amica |
  Kaz II |
  Tai Ching |
  Lunatic |
  Ryou-Un Maru |
  T. T. Zion |
  Lyubov Orlova |
  Skeleton Key |
  Ampoliros |
  Demeter |
  William Kidd |
  Adventure Gallery |
  Adventure Prize |
  Blackbeard |
  Queen Anne's Revenge |
  Adventure |
  Good Fortune |
  Scowerer |
  Wyndham Galley |
  Speakwell |
  Sultana |
  Whydah |
  Ranger |
  Lark |
  Flying Dragon |
  Golden Fleece |
  Trompeuse |
  La Nouvelle Trompeuse |
  Sea Nymph |
  Rising Sun |
  Postillion |
  Indian Queen |
  Marianne |
  Revenge |
  Happy Return |
  Night Rambler |
  Flying King |
  Delight |
  Amity |
  Liberty |
  Royal James |
  Fancy Dutch |
  Pembroke |
  Margaret |
  Prosperous |
  Rose Pink |
  Squirrel |
  Merry Christmas |
  Roebuck |
  Katherine |
  Defiance |
  Rover |
  Diamond Grey |
  Barsheba |
  St. Marie |
  Grey Wolf |
  Sea Wolf |
  Morning Star |
  Antelope |
  Dead Dog |
  Jolly Roger |
  In the Flesh |
  Cheeki Breeki |
  Styx |
  Attila the Hun |
  Edward Teach |
  Anne Bonny |
  Calico Jack |
  Jeanne de Clisson |
  Lo Hon-cho |
  Hyperion |
  Samuel Axe |
  Vlad the Impaler |
  Elizabeth Bathory |
  Morgan le Fay |
  Charnel Ground |
  Gaping Wound |
  Festering Wounds |
  Horrible Flies |
  Death's Head
]]))

endless_syntax:add(_([[
 PIRATE_1 =
  {PIRATE_ADJECTIVES} {= {PIRATE_NOUNS} | {SINISTER_NAMES} | {BAD_OUTCOMES} }
]]))

endless_syntax:add(_([[
 PIRATE_2 = {SUB_20} {SUB_21}

 SUB_20 =
  {PIRATE_ADJECTIVES_THAT_DONT_WORK_BEFORE_SINGULAR_NOUNS} |
  {PIRATE_ADJECTIVES}

 SUB_21 =
  {SINISTER_NAMES} |
  {BAD_OUTCOMES}
]]))

endless_syntax:add(_([[
 PIRATE_3 = {SINISTER_NAMES}'s {= {PIRATE_NOUNS} | {BAD_OUTCOMES} }
]]))

endless_syntax:add(_([[
 PIRATE_4 = {PIRATE_NOUNS} of {BAD_OUTCOMES}
]]))

endless_syntax:add(_([[
 PIRATE_5 = {SUB_50}{SUB_51}

 SUB_50 =
  Blood |
  Night |
  Death |
  Dead |
  Doom |
  Dark |
  Hate |
  Mad |
  Mind |
  Gut |
  Grim |
  Dread |
  Bone |
  Brain |
  Chain |
  Foul |
  Evil |
  Black |
  Red |
  Pain |
  War |
  Horn |
  Murder |
  Poison

 SUB_51 =
  oath |
  fire |
  spit |
  fury |
  rot |
  bat |
  bath |
  blade |
  flame |
  curse |
  scowl |
  wrench |
  wrought |
  corpse |
  fear |
  stain |
  sludge |
  hunter |
  shark |
  -eater |
  cradle |
  pulse |
  fang |
  claw |
  grave |
  hammer |
  river |
  pit |
  scourge |
  plague |
  storm |
  rage |
  slag |
  fist |
  punch |
  slash |
  chop |
  wreck |
  stab |
  beast |
  monger |
  monster |
  slayer |
  snake |
  rat |
  sport |
  shard |
  spike |
  stump |
  snap |
  frag |
  bringer |
  flicker |
  boil |
  rider |
  raider |
  stalker |
  swarm |
  fiend
]]))

-- Endless names main
endless_syntax:add(_([[
 main =
  {PIRATE_0} |
  {PIRATE_1} |
  {PIRATE_2} |
  {PIRATE_3} |
  {PIRATE_4} |
  {PIRATE_5}
]]))
names:add(endless_syntax)
names:equalize_chance() -- Naev : Endless Names = 1 : 1

--[[
-- @brief Generates pirate names
--]]
local function pirate ()
   return names:generate()
end

return pirate
