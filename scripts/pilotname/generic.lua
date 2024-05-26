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

The definitions of the Endless names derive from "data/names.txt" in Endless Sky 0.9.8.
Copyright (c) 2014 by Michael Zahniser
Copyright (c) 2015 lehgogh@github
Copyright (c) 2015-2017 Pointedstick@github
--]]

local phrase = require "phrase"
local naev_rnd = require "phrase.naev_rnd_wrapper"
local utility = require "pilotname.utility"

phrase.output_error = warn
phrase.set_random_function(naev_rnd.f)

-- Naev names
local names = phrase.new(_([[
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

 main = {NAME} {LETTER}{SUFFIX}
]]))

local greek = phrase.new(_([[
 main = α | β | γ | δ | ε | ζ | Δ | Σ | Ψ | Ω
]]))


-- Endless names
local endless_syntax = phrase.compile()

endless_syntax:add(_([[
 ADJECTIVES =
  Poor |
  Lonely |
  Glorious |
  Magnificent |
  Intrepid |
  Bold |
  Courageous |
  Generous |
  Brazen |
  Resolute |
  Reliable |
  Battered |
  Sensible |
  Defiant |
  Stoic |
  Bittersweet |
  Great |
  Cautious |
  Careful |
  Spicy |
  Lucky |
  Pious |
  Faithful |
  Adventurous |
  Merry |
  Joyous |
  Stalwart |
  Wealthy |
  Space |
  Favorite |
  Windswept |
  Forgotten |
  Unlucky |
  Radiant |
  Hopeful |
  Distant |
  Clever |
  Honorable |
  Radical |
  Slippery |
  Northern |
  Southern |
  Eastern |
  Western |
  Deepwater |
  Blessed |
  Valiant |
  Shimmering |
  Noble |
  Thoughtful |
  Steely |
  Sanguine |
  Sunny |
  Chiseled |
  Stormy |
  Endless |
  Infinite |
  Diligent |
  Patient |
  Wistful |
  Wise |
  Graceful |
  Subtle
]]))

endless_syntax:add(_([[
 COLORS =
  Green |
  Blue |
  White |
  Black |
  Violet |
  Indigo |
  Lilac |
  Azure |
  Gray |
  Golden |
  Silver |
  Copper |
  Bronze |
  Brass |
  Marigold |
  Lavender |
  Alabaster |
  Vermillion |
  Ivory |
  Shimmering |
  Rainbow |
  Emerald |
  Sapphire
]]))

endless_syntax:add(_([[
 CARDINAL_DIRECTIONS = North | South | East | West
]]))

endless_syntax:add(_([[
 SINGULAR_NOUNS =
  Star |
  Sun |
  Sky |
  Moon |
  Nova |
  Corona |
  Photon |
  Aurora |
  Snow |
  Void |
  Shockwave |
  Cloud |
  Nebula |
  Quasar |
  Pulsar |
  Horizon |
  Zenith |
  Comet |
  Flare |
  Energy |
  Galaxy |
  Ring |
  Blade |
  Sword |
  Light |
  Flash |
  Dance |
  Flood |
  Bounty |
  Castle |
  Temple |
  Spirit |
  Trail |
  Flight |
  Heart |
  Pennant |
  Harvest |
  Nymph |
  Mermaid |
  Siren |
  Anchor |
  Hammerhead |
  Lion |
  Lioness |
  Eagle |
  Silhouette |
  Guardian |
  God |
  Tower |
  Pillar |
  Hero |
  Quest |
  Journey |
  Matrix |
  Palace |
  Goblet |
  Sunset |
  Sunrise |
  Fish |
  Symbol |
  Mark |
  Realm |
  Tree |
  Crossing |
  Shadow |
  Swan |
  Forge |
  Banner |
  Voyage |
  Rose |
  Song |
  Raven |
  Point |
  Mountain |
  Island |
  Forest |
  Carnation |
  Gaze |
  Ship |
  Cave
]]))

endless_syntax:add(_([[
 PLURAL_NOUNS =
  Men |
  Stars |
  Dreams |
  Waves |
  Dragons |
  Secrets |
  Whispers |
  Storms |
  Eyes |
  Hands |
  Riches |
  Changes |
  Worlds |
  Words |
  Echoes |
  Winds |
  Leaves |
  Clouds |
  Legends |
  Sails |
  Beasts |
  Oceans |
  Idols |
  Faces |
  Names |
  Thoughts |
  Roses |
  Coins |
  Cups |
  Wands |
  Swords |
  Wings |
  Tears |
  Flags |
  Scars |
  Tongues |
  Deeds |
  Ways |
  Means |
  Mysteries |
  Wonders |
  Fools |
  Souls | {*
  Need to duplicate these because not all the words in the 'female titles' phrase could be pluralized by simply adding 's' to the end }
  Ladies |
  Princesses |
  Queens |
  Empresses |
  Duchesses |
  Mistresses | {*
  Need to duplicate these here as well to prevent the male titles from showing up way too often relative to the female ones }
  Lords |
  Princes |
  Kings |
  Emperors |
  Dukes |
  Masters
]]))

endless_syntax:add(_([[
 NOUNS_OF_INDETERMINATE_QUANTITY =
  Jade |
  Rain |
  Heart |
  Dominion |
  Leviathan |
  Salvation |
  Fate |
  Change |
  Ouroboros |
  Tiamat |
  Sorrow |
  Glass |
  Crystal |
  Heaven |
  Sand |
  Moonlight |
  Dawn |
  Dusk |
  Mystery |
  Magic |
  Fire |
  Ice |
  Water |
  Starlight |
  Lightning |
  Thunder |
  Steel |
  Glory |
  Stone |
  Old |
  Bravery |
  Poetry |
  Promise |
  Beauty |
  Mirth |
  Olympus |
  Light |
  Charity |
  Mercy |
  Hope |
  Virtue |
  Fortitude |
  Enlightenment |
  Might |
  Destiny |
  Grass |
  Clarity |
  Serenity |
  Tranquility |
  Paradise |
  Contentment |
  Strength |
  Power
]]))

endless_syntax:add(_([[
 THE_NOUNS = the {={SINGULAR_NOUNS} | {PLURAL_NOUNS} | {CARDINAL_DIRECTIONS}}
]]))

endless_syntax:add(_([[
 THINGS_YOU_CAN_BE_OF = of {=
  {PLURAL_NOUNS} |
  {THE_NOUNS} |
  {NOUNS_OF_INDETERMINATE_QUANTITY}
 }
]]))

-- Make sure to add any additions to the "plural nouns" list in plural form
endless_syntax:add(_([[
 MALE_TITLES =
  Lord |
  Prince |
  King |
  Emperor |
  Duke |
  Master
]]))

-- Make sure to add any additions to the "plural nouns" list in plural form
endless_syntax:add(_([[
 FEMALE_TITLES =
  Lady |
  Princess |
  Queen |
  Empress |
  Duchess |
  Mistress
]]))

endless_syntax:add(_([[
 GENDER_NEUTRAL_TITLES =
  Saint |
  Captain |
  Champion |
  Admiral |
  Sovereign
]]))

endless_syntax:add(_([[
 ALL_TITLES = {MALE_TITLES} | {FEMALE TITLES} | {GENDER_NEUTRAL_TITLES}
]]))

endless_syntax:add(_([[
 MALE_NAMES =
  Henry |
  Nelson |
  Randall |
  Ivan |
  James |
  Atanu |
  George |
  Arthur |
  Caspian |
  Canute |
  Enki |
  Richard |
  John |
  William |
  Donald |
  Samuel |
  Khufu |
  Edward |
  Sargon |
  Amon |
  Cyrus |
  Darius |
  Vipra |
  Raja |
  Shang |
  Wu |
  Xian |
  Alan |
  Logan |
  Eric |
  Malcolm |
  Monty |
  Dana |
  Philip |
  Isiah |
  Nasser |
  Rashid |
  Ahmed |
  Ari |
  Waleed |
  Mobutu |
  Osamu |
  Tarou |
  Partha |
  Salvador |
  Zuhair |
  Kenji |
  Takeshi |
  Hidekai |
  Chen |
  Mon Ping |
  Ruslan |
  Vladimir |
  Fyodor |
  Hammurabi |
  Denton |
  Xiang |
  Zhong |
  Bapu |
  Kouadio |
  Santiago |
  Rafael |
  Ignacio |
  Bruno |
  Martin |
  Starbuck |
  Xu
]]))

endless_syntax:add(_([[
 FEMALE_NAMES =
  Mary |
  Anne |
  Genevieve |
  Elizabeth |
  Shanshan |
  Yin |
  Lu |
  Maria |
  Isabella |
  Fiona |
  Caroline |
  Catherine |
  Victoria |
  Jane |
  Emily |
  Nefertiti |
  Fatima |
  Sophia |
  Katerina |
  Teresa |
  Etana |
  Awan |
  Xena |
  Zoe |
  Jane |
  River |
  Aletheia |
  Sara |
  Olympia |
  Layla |
  Surya |
  Shira |
  Anita |
  Sato |
  Mika |
  Mariko |
  Olga |
  Jing |
  Marianne |
  Natalie |
  Julia |
  Faye |
  Deirdre |
  Jaina |
  Isabel |
  Katerina |
  Pearl |
  Neela |
  Durga |
  Devi |
  Madhavi |
  Amwe |
  Nakoyan |
  Akua |
  Sofia |
  Catalina |
  Pilar |
  Elena |
  Athena |
  Calypso
]]))

endless_syntax:add(_([[
 ALL_POSSESSIVE_NAMES_AND_TITLES =
  {MALE_NAMES}'s |
  {FEMALE_NAMES}'s |
  {MALE_TITLES}'s |
  {FEMALE_TITLES}'s |
  {GENDER_NEUTRAL_TITLES}'s
]]))

endless_syntax:add(_([[
 PLURAL_QUANTITIES =
  Double |
  Twin |
  Two |
  Three |
  Triple |
  Four |
  Five |
  Six |
  Seven |
  Eight |
  Nine |
  Ten |
  Eleven |
  Twelve |
  Thirteen |
  Twenty |
  Fifty |
  One Hundred |
  One Thousand |
  Many |
  Too Many |
  No More
]]))

endless_syntax:add(_([[
 CLASSIC_SHIP_NAMES =
  Jumper |
  Rider |
  Chaser |
  Dancer |
  Seeker |
  Explorer |
  Lover |
  Hunter |
  Beater |
  Racer |
  Piercer |
  Charger |
  Speeder |
  Falcon |
  Paladin |
  Cavalier |
  Spear |
  Surfer |
  Strider |
  Genie |
  Caravan |
  Destiny |
  Goddess |
  Dreamer |
  Eagle |
  Folly |
  Baby |
  Money Pit |
  Beauty |
  Mule |
  Work Horse |
  Moneymaker |
  Wings |
  Starship |
  Hauler |
  Beater |
  Fortune |
  Dream |
  Pride |
  Gamble |
  Downfall |
  Regret |
  Savior |
  Glory |
  Miracle |
  Last Chance |
  Last Stand |
  Adventure |
  Hope |
  Jewel |
  Surprise |
  Star |
  Cutter |
  Cruiser
]]))

-- Final phrases that make ship names
endless_syntax:add(_([[
 MAIN_0 =
  Horizon |
  Enterprise |
  Rabbit |
  Napoleon |
  Khagan |
  Yokozuna |
  Ozeki |
  Black Bear |
  Indefatigable |
  Dauntless |
  Nautilus |
  Humboldt |
  Eagle |
  Endeavor |
  Slipstream |
  Stargazer |
  Venture |
  Union |
  Sunrise |
  Laotzu |
  Mencius |
  Hawk |
  Confucius |
  Megalith |
  Istanbul |
  Constantinople |
  Winchester |
  Magellan |
  Constellation |
  Orion |
  Oracle |
  Promised Land |
  Garden of Eden |
  George Washington |
  Kane |
  Loki |
  Polyphemus |
  Odysseus |
  Poseidon |
  Sinbad |
  Falling Snow |
  Quetzal |
  Quetzlcoatl |
  Icebreaker |
  Gorgon |
  Winston Churchill |
  Saint Felix |
  Orca |
  Snowy Owl |
  Bombay |
  Arethusa |
  Crown Point |
  Botany Bay |
  Medway |
  Allure |
  Neptune |
  Bazinje |
  Nomad |
  Redoubtable |
  Primarch |
  Great Egret |
  Jeanne d'Arc |
  Geronimo |
  Sitting Bull |
  Pocahontas |
  Crazy Horse |
  Toreador |
  Chelmsford |
  Argo |
  The Golden Fleece |
  Pequod |
  Beagle |
  Santa Maria |
  Bismark |
  Golden Hind |
  Mayflower |
  Monitor |
  Merrimack |
  Potemkin |
  Yamato |
  Fujiyama |
  Pretoria |
  Xiao Yi |
  Lou Chuan |
  Zheng He |
  Baychimo |
  Constitution |
  Excelsior |
  Renaissance |
  Yellowstone |
  Jim Jones |
  John Henry |
  Paul Bunyan |
  Robin Hood |
  Baba Yaga |
  Annie Oakley |
  Emiliano Zapata |
  North Star |
  Wanderer |
  Tears in Rain |
  Happy Returns |
  No Gods, No Masters |
  Majestic |
  Santa Fe |
  Hunk of Junk |
  Hammerhead |
  Heliopolis |
  Cornwall |
  Chichen Itza
]]))

-- e.g.:
-- Five Men
-- Twin Dragons
-- Ten Thousand Worlds
-- Too Many Scars
endless_syntax:add(_([[
 MAIN_1 = {PLURAL_QUANTITIES} {PLURAL_NOUNS}
]]))

-- e.g.
-- Honorable Guardian
-- Poor Richard
-- Golden Mary
-- Infinite Mystery
endless_syntax:add(_([[
 MAIN_2 = {SUB_20} {SUB_21}
 SUB_20 = {ADJECTIVES} | {COLORS}
 SUB_21 =
  {MALE_NAMES} |
  {FEMALE_NAMES} |
  {SINGULAR_NOUNS} |
  {PLURAL_NOUNS} |
  {NOUNS_OF_INDETERMINATE_QUANTITY}
]]))

-- e.g.:
-- King of the Mountain
-- Champion Ivan
endless_syntax:add(_([[
 MAIN_3 = {SUB_30} {SUB_31}
 SUB_30 = {MALE_TITLES} | {GENDER_NEUTRAL_TITLES}
 SUB_31 = {MALE_NAMES} | {THINGS_YOU_CAN_BE_OF}
]]))

-- e.g.:
-- Queen of Thoughts
-- Lady Caroline
endless_syntax:add(_([[
 MAIN_4 = {SUB_40} {SUB_41}
 SUB_40 = {FEMALE_TITLES} | {GENDER_NEUTRAL_TITLES}
 SUB_41 = {FEMALE_NAMES} | {THINGS_YOU_CAN_BE_OF}
]]))

-- e.g.:
-- Ivan the Bold
-- Wendy the White
endless_syntax:add(_([[
 MAIN_5 = {SUB_50} the {SUB_51}
 SUB_50 = {MALE_NAMES} | {FEMALE_NAMES}
 SUB_51 = {ADJECTIVES} | {COLORS}
]]))

-- e.g.:
-- Sword King
-- Dawn Empress
-- Lucky Princess
-- Green Admiral
endless_syntax:add(_([[
 MAIN_6 = {SUB_60} {ALL_TITLES}
 SUB_60 =
  {SINGULAR_NOUNS} |
  {NOUNS_OF_INDETERMINATE_QUANTITY} |
  {ADJECTIVES} |
  {COLORS}
]]))

-- e.g.:
-- Castle of Water
-- Oceans of the West
-- Sword of Destiny
-- Moonlight of Bravery
-- Rain of Riches
endless_syntax:add(_([[
 MAIN_7 = {SUB_70} {THINGS_YOU_CAN_BE_OF}
 SUB_70 =
  {SINGULAR_NOUNS} |
  {PLURAL_NOUNS} |
  {CLASSIC_SHIP_NAMES} |
  {NOUNS_OF_INDETERMINATE_QUANTITY}
]]))

-- e.g.:
-- Lord's Spear
-- Altheia's Money Pit
-- Xena's Fortune
endless_syntax:add(_([[
 MAIN_8 = {SUB_80} {CLASSIC_SHIP_NAMES}
 SUB_80 = {ADJECTIVES} | {COLORS} | {ALL_POSSESSIVE_NAMES_AND_TITLES}
]]))

-- e.g.:
-- Bittersweet Stone
-- Azure Nymph
-- Xu's Flags
-- Katerina's Silhouette
-- Lord's Whispers
endless_syntax:add(_([[
 MAIN_9 = {SUB_90} {SUB_91}
 SUB_90 = {ADJECTIVES} | {COLORS} | {ALL_POSSESSIVE_NAMES_AND_TITLES}
 SUB_91 =
  {PLURAL_NOUNS} |
  {SINGULAR_NOUNS} |
  {NOUNS_OF_INDETERMINATE_QUANTITY}
]]))

-- e.g.:
-- Jade Leviathan
-- Olympus Legends
-- Fire Words
endless_syntax:add(_([[
 MAIN_A = {NOUNS_OF_INDETERMINATE_QUANTITY} {SUB_A1}
 SUB_A1 = {SINGULAR_NOUNS} | {PLURAL_NOUNS}
]]))

-- e.g.:
-- Words and Changes
-- Beauty and Legends
-- Tears and Sorrow
endless_syntax:add(_([[
 MAIN_B = {SUB_B1} and {SUB_B1}
 SUB_B1 = {PLURAL_NOUNS} | {NOUNS_OF_INDETERMINATE_QUANTITY}
]]))

-- Endless names main
endless_syntax:add(_([[
 main =
  {MAIN_0} |
  {MAIN_1} |
  {MAIN_2} |
  {MAIN_3} |
  {MAIN_4} |
  {MAIN_5} |
  {MAIN_6} |
  {MAIN_7} |
  {MAIN_8} |
  {MAIN_9} |
  {MAIN_A} |
  {MAIN_B}
]]))
names:add(endless_syntax)
names:equalize_chance() -- Naev : Endless Names = 1 : 1

--[[
-- @brief Generates generic pilot names
--]]
local function generic ()
   local num = rnd.rnd(1, 99)
   local str
   local letter = ""
   local r = rnd.rnd()
   if r < 0.5 then
      str = tostring(num)
   elseif r < 0.85 then
      str = utility.roman_encode(num)
   else
      letter = greek:generate()
      str = ""
      if rnd.rnd() < 0.5 then
         local comb = greek:get_combination_number()
         str = tostring(math.floor(num/comb+0.5)+1)
      end
   end
   return names:generate({ LETTER = letter, SUFFIX = str })
end

return generic
