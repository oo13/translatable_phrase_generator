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

The definitions of the Endless names derive from "data/names.txt" in Endless Sky 0.9.8.

Generic names:
Copyright (c) 2014 by Michael Zahniser
Copyright (c) 2015 lehgogh@github
Copyright (c) 2015-2017 Pointedstick@github

Pirate names:
Copyright (c) 2014 by Michael Zahniser
Copyright (c) 2015 eflyon@github
Copyright (c) 2015 akien-mga@github
Copyright (c) 2015-2017 Pointedstick@github
--]]

local static_phrase_generator = require "static_phrase_generator"
local phrase = require "phrase"


local function add_generic()
   -- Generic names
   local generic_syntax = phrase.compile()

   generic_syntax:add(_([[
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

   generic_syntax:add(_([[
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

   generic_syntax:add(_([[
    CARDINAL_DIRECTIONS = North | South | East | West
   ]]))

   generic_syntax:add(_([[
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

   generic_syntax:add(_([[
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

   generic_syntax:add(_([[
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

   generic_syntax:add(_([[
    THE_NOUNS = the {={SINGULAR_NOUNS} | {PLURAL_NOUNS} | {CARDINAL_DIRECTIONS}}
   ]]))

   generic_syntax:add(_([[
    THINGS_YOU_CAN_BE_OF = of {=
     {PLURAL_NOUNS} |
     {THE_NOUNS} |
     {NOUNS_OF_INDETERMINATE_QUANTITY}
    }
   ]]))

   -- Make sure to add any additions to the "plural nouns" list in plural form
   generic_syntax:add(_([[
    MALE_TITLES =
     Lord |
     Prince |
     King |
     Emperor |
     Duke |
     Master
   ]]))

   -- Make sure to add any additions to the "plural nouns" list in plural form
   generic_syntax:add(_([[
    FEMALE_TITLES =
     Lady |
     Princess |
     Queen |
     Empress |
     Duchess |
     Mistress
   ]]))

   generic_syntax:add(_([[
    GENDER_NEUTRAL_TITLES =
     Saint |
     Captain |
     Champion |
     Admiral |
     Sovereign
   ]]))

   generic_syntax:add(_([[
    ALL_TITLES = {MALE_TITLES} | {FEMALE TITLES} | {GENDER_NEUTRAL_TITLES}
   ]]))

   generic_syntax:add(_([[
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

   generic_syntax:add(_([[
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

   generic_syntax:add(_([[
    ALL_POSSESSIVE_NAMES_AND_TITLES =
     {MALE_NAMES}'s |
     {FEMALE_NAMES}'s |
     {MALE_TITLES}'s |
     {FEMALE_TITLES}'s |
     {GENDER_NEUTRAL_TITLES}'s
   ]]))

   generic_syntax:add(_([[
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

   generic_syntax:add(_([[
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
   generic_syntax:add(_([[
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
   generic_syntax:add(_([[
    MAIN_1 = {PLURAL_QUANTITIES} {PLURAL_NOUNS}
   ]]))

   -- e.g.
   -- Honorable Guardian
   -- Poor Richard
   -- Golden Mary
   -- Infinite Mystery
   generic_syntax:add(_([[
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
   generic_syntax:add(_([[
    MAIN_3 = {SUB_30} {SUB_31}
    SUB_30 = {MALE_TITLES} | {GENDER_NEUTRAL_TITLES}
    SUB_31 = {MALE_NAMES} | {THINGS_YOU_CAN_BE_OF}
   ]]))

   -- e.g.:
   -- Queen of Thoughts
   -- Lady Caroline
   generic_syntax:add(_([[
    MAIN_4 = {SUB_40} {SUB_41}
    SUB_40 = {FEMALE_TITLES} | {GENDER_NEUTRAL_TITLES}
    SUB_41 = {FEMALE_NAMES} | {THINGS_YOU_CAN_BE_OF}
   ]]))

   -- e.g.:
   -- Ivan the Bold
   -- Wendy the White
   generic_syntax:add(_([[
    MAIN_5 = {SUB_50} the {SUB_51}
    SUB_50 = {MALE_NAMES} | {FEMALE_NAMES}
    SUB_51 = {ADJECTIVES} | {COLORS}
   ]]))

   -- e.g.:
   -- Sword King
   -- Dawn Empress
   -- Lucky Princess
   -- Green Admiral
   generic_syntax:add(_([[
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
   generic_syntax:add(_([[
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
   generic_syntax:add(_([[
    MAIN_8 = {SUB_80} {CLASSIC_SHIP_NAMES}
    SUB_80 = {ADJECTIVES} | {COLORS} | {ALL_POSSESSIVE_NAMES_AND_TITLES}
   ]]))

   -- e.g.:
   -- Bittersweet Stone
   -- Azure Nymph
   -- Xu's Flags
   -- Katerina's Silhouette
   -- Lord's Whispers
   generic_syntax:add(_([[
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
   generic_syntax:add(_([[
    MAIN_A = {NOUNS_OF_INDETERMINATE_QUANTITY} {SUB_A1}
    SUB_A1 = {SINGULAR_NOUNS} | {PLURAL_NOUNS}
   ]]))

   -- e.g.:
   -- Words and Changes
   -- Beauty and Legends
   -- Tears and Sorrow
   generic_syntax:add(_([[
    MAIN_B = {SUB_B1} and {SUB_B1}
    SUB_B1 = {PLURAL_NOUNS} | {NOUNS_OF_INDETERMINATE_QUANTITY}
   ]]))

   -- The weight of "main" is to normalize to 1.
   generic_syntax:add(_([[
    main 1 =
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

   local pilotname_generic = static_phrase_generator.get("pilotname_generic")
   pilotname_generic:add(generic_syntax)
end


local function add_pirate()
   -- Pirate names
   local pirate_syntax = phrase.compile()

   -- All of these should sound good when preceded by the word "of" or when "'s" is added onto the end
   pirate_syntax:add(_([[
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

   pirate_syntax:add(_([[
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

   pirate_syntax:add(_([[
    PIRATE_ADJECTIVES_THAT_DONT_WORK_BEFORE_SINGULAR_NOUNS =
     Flames of |
     Reign of |
     Death by |
     Screams of |
     Cackles of
   ]]))

   pirate_syntax:add(_([[
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

   pirate_syntax:add(_([[
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

   pirate_syntax:add(_([[
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

   pirate_syntax:add(_([[
    PIRATE_1 =
     {PIRATE_ADJECTIVES} {= {PIRATE_NOUNS} | {SINISTER_NAMES} | {BAD_OUTCOMES} }
   ]]))

   pirate_syntax:add(_([[
    PIRATE_2 = {SUB_20} {SUB_21}

    SUB_20 =
     {PIRATE_ADJECTIVES_THAT_DONT_WORK_BEFORE_SINGULAR_NOUNS} |
     {PIRATE_ADJECTIVES}

    SUB_21 =
     {SINISTER_NAMES} |
     {BAD_OUTCOMES}
   ]]))

   pirate_syntax:add(_([[
    PIRATE_3 = {SINISTER_NAMES}'s {= {PIRATE_NOUNS} | {BAD_OUTCOMES} }
   ]]))

   pirate_syntax:add(_([[
    PIRATE_4 = {PIRATE_NOUNS} of {BAD_OUTCOMES}
   ]]))

   pirate_syntax:add(_([[
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

   -- The weight of "main" is to normalize to 1.
   pirate_syntax:add(_([[
    main 1 =
     {PIRATE_0} |
     {PIRATE_1} |
     {PIRATE_2} |
     {PIRATE_3} |
     {PIRATE_4} |
     {PIRATE_5}
   ]]))

   local pilotname_pirate = static_phrase_generator.get("pilotname_pirate")
   pilotname_pirate:add(pirate_syntax)
end

return function ()
   add_generic()
   add_pirate()
end
