------------------
-- AbilityTables namespace
local A = {}

-- ---------------------------------------------------
-- MAJOR/MINOR DEBUFFS & DEBUFFS ---------------------
-- ---------------------------------------------------

-- Major/Minor Buffs
A.Skill_Minor_Resolve               = 24159
A.Skill_Major_Resolve               = 22236
A.Skill_Minor_Ward                  = 32761
A.Skill_Major_Ward                  = 18868
A.Skill_Minor_Fortitude             = 26213
A.Skill_Major_Fortitude             = 29011
A.Skill_Minor_Endurance             = 26215
A.Skill_Major_Endurance             = 32748
A.Skill_Minor_Intellect             = 26216
A.Skill_Major_Intellect             = 45224
A.Skill_Minor_Sorcery               = 61685
A.Skill_Major_Sorcery               = 45227
A.Skill_Minor_Prophecy              = 61688
A.Skill_Major_Prophecy              = 47195
A.Skill_Minor_Brutality             = 61662
A.Skill_Major_Brutality             = 23673
A.Skill_Minor_Savagery              = 79453
A.Skill_Major_Savagery              = 26795
A.Skill_Minor_Berserk               = 62636
A.Skill_Major_Berserk               = 36973
A.Skill_Minor_Force                 = 68595
A.Skill_Major_Force                 = 46533
A.Skill_Minor_Vitality              = 34837
A.Skill_Major_Vitality              = 42197
A.Skill_Minor_Mending               = 29096
A.Skill_Major_Mending               = 61758
A.Skill_Minor_Protection            = 40171
A.Skill_Major_Protection            = 22233
A.Skill_Minor_Evasion               = 61715
A.Skill_Major_Evasion               = 61716
A.Skill_Minor_Expedition            = 40219
A.Skill_Major_Expedition            = 23216
--A.Skill_Minor_Gallop              =
A.Skill_Major_Gallop                = 57472
A.Skill_Minor_Heroism               = 38746
A.Skill_Major_Heroism               = 61709
A.Skill_Minor_Toughness             = 46542
A.Skill_Major_Courage               = 66902

-- Major/Minor Debuffs
A.Skill_Minor_Breach                = 46206
A.Skill_Major_Breach                = 33363
A.Skill_Minor_Fracture              = 38688
A.Skill_Major_Fracture              = 28307
A.Skill_Minor_Vulnerability         = 51434
A.Skill_Major_Vulnerability         = 106754
A.Skill_Minor_Maim                  = 61856
A.Skill_Major_Maim                  = 92041
A.Skill_Minor_Defile                = 61726
A.Skill_Major_Defile                = 38686
A.Skill_Minor_Magickasteal          = 40114
A.Skill_Minor_Lifesteal             = 33541
A.Skill_Minor_Enveration            = 47202
A.Skill_Minor_Uncertainty           = 47204
A.Skill_Minor_Cowardice             = 46202
A.Skill_Minor_Mangle                = 39168

A.Skill_Minor_Slayer				= 76618
A.Skill_Minor_Aegis					= 76617
A.Skill_Off_Balance                 = 14062
A.Skill_Off_Balace_Immunity         = 102771

A.Skill_Empower                     = 61737
A.Skill_Hindrance                   = 46210
A.Skill_Stun                        = 68565

-- ---------------------------------------------------
-- INNATE ABILITIES ----------------------------------
-- ---------------------------------------------------

-- Simulated Auras
A.Innate_Recall                     = 6811
A.Innate_Recall_Penalty             = GetString(SI_LUIE_SKILL_RECALL_PENALTY) -- Recall Penalty
A.Innate_Resurrection_Immunity      = GetString(SI_LUIE_SKILL_RESURRECTION_IMMUNITY) -- Resurrection Immunity
A.Innate_Soul_Gem_Resurrection      = GetString(SI_LUIE_SKILL_SOUL_GEM_RESURRECTION) -- Soul Gem Resurrection

-- Player Basic
A.Innate_Crouch                     = 20306 -- Crouch
A.Innate_Stealth_Stun               = GetString(SI_LUIE_SKILL_STEALTH_STUN) -- Crouch Stun
A.Innate_Disguised                  = 23553 -- Disguised
A.Innate_Hidden                     = 20309 -- Hidden
A.Innate_Sprint                     = 973   -- Sprint
A.Innate_Block                      = 14890 -- Block
A.Innate_Block_Stun                 = GetString(SI_LUIE_SKILL_BLOCK_STUN) -- Block Stun
A.Innate_Bash                       = 21970 -- Bash
A.Innate_Bash_Stun                  = 21971 -- Bash Stun
A.Innate_Gallop                     = GetString(SI_LUIE_SKILL_MOUNT_SPRINT) -- Gallop
A.Innate_Hard_Dismount              = 42514
A.Innate_Fall_Damage                = GetString(SI_LUIE_SKILL_FALL_DAMAGE) -- Fall Damage
A.Innate_Absorbing_Skyshard         = GetString(SI_LUIE_SKILL_ABSORBING_SKYSHARD) -- Absorbing Skyshard
A.Innate_Receiving_Boon             = GetString(SI_LUIE_SKILL_RECEIVING_BOON) -- Receiving Boon
A.Innate_Ayleid_Well                = GetString(SI_LUIE_SKILL_AYLEID_WELL) -- Ayleid Well
A.Innate_Ayleid_Well_Fortified      = GetString(SI_LUIE_SKILL_AYLEID_WELL_FORTIFIED) -- Ayleid Well
A.Innate_CC_Immunity                = 38117 -- CC Immunity
A.Innate_Stagger                    = 1834 -- Stagger
A.Innate_Revive                     = 5823 -- Revive

A.Innate_Create_Station_Jewelry     = GetString(SI_LUIE_SKILL_CRAFTING_STATION_JEWELRY)
A.Innate_Create_Station_Blacksmith  = GetString(SI_LUIE_SKILL_CRAFTING_STATION_BLACKSMITH)
A.Innate_Create_Station_Clothing    = GetString(SI_LUIE_SKILL_CRAFTING_STATION_CLOTHING)
A.Innate_Create_Station_Woodwork    = GetString(SI_LUIE_SKILL_CRAFTING_STATION_WOODWORK)
A.Innate_Fillet_Fish                = GetString(SI_LUIE_SKILL_FILLET_FISH)
A.Innate_Pardon_Edict_Low           = GetString(SI_LUIE_SKILL_COUNTERFEIT_PARDON_EDICT)
A.Innate_Pardon_Edict_Medium        = GetString(SI_LUIE_SKILL_LENIENCY_EDICT)
A.Innate_Pardon_Edict_High          = GetString(SI_LUIE_SKILL_GRAND_AMNESTY_EDICT)

-- Champion
A.Champion_Last_Stand               = 60413

-- World
A.Innate_Drop_Anchor                = 86717 -- Drop Anchor
A.Innate_Anchor_Drop                = GetString(SI_LUIE_SKILL_ANCHOR_DROP) -- Anchor Drop
A.Innate_Power_of_the_Daedra        = 46690 -- Power of the Daedra

-- Weapon Attacks
A.Skill_Light_Attack                = 23604 -- Light Attack
A.Skill_Medium_Attack               = 39097 -- Medium Attack
A.Skill_Heavy_Attack                = 18431 -- Heavy Attack
A.Skill_Heavy_Attack_Dual_Wield     = 16420 -- Heavy Attack (Dual Wield)
A.Skill_Heavy_Attack_Werewolf       = 32480 -- Heavy Attack Werewolf
A.Skill_Heavy_Attack_Shock          = 18396 -- Heavy Attack (Shock)
A.Skill_Heavy_Attack_Main_Hand      = GetString(SI_LUIE_SKILL_PASSIVE_HEAVY_MAIN_HAND)
A.Skill_Heavy_Attack_Off_Hand       = GetString(SI_LUIE_SKILL_PASSIVE_HEAVY_OFF_HAND)

-- ---------------------------------------------------
-- COMSUMABLES & ITEMS -------------------------------
-- ---------------------------------------------------

-- Glyphs
A.Item_Glyph_of_Absorb_Health       = 28919
A.Item_Glyph_of_Absorb_Magicka      = 46743
A.Item_Glyph_of_Absorb_Stamina      = 46746
A.Item_Glyph_of_Crushing            = GetString(SI_LUIE_SKILL_GLYPH_CRUSHING)
A.Item_Glyph_of_Damage_Health       = 46749
A.Item_Glyph_of_Decrease_Health     = GetString(SI_LUIE_SKILL_GLYPH_DECREASE_HEALTH)
A.Item_Glyph_of_Flame               = 17895
A.Item_Glyph_of_Foulness            = 17904
A.Item_Glyph_of_Frost               = 17897
A.Item_Glyph_of_Hardening           = GetString(SI_LUIE_SKILL_GLYPH_HARDENING)
A.Item_Glyph_of_Poison              = 17902
A.Item_Glyph_of_Prismatic_Onslaught = 40337
A.Item_Glyph_of_Shock               = 17899
A.Item_Glyph_of_Weakening           = GetString(SI_LUIE_SKILL_GLYPH_WEAKENING)
A.Item_Glyph_of_Weapon_Damage       = GetString(SI_LUIE_SKILL_GLYPH_WEAPON_DAMAGE)

-- Elemental Status Effect
A.Proc_Burning                      = 18084
A.Proc_Diseased                     = 21925
A.Proc_Chill                        = 21481
A.Proc_Chilled                      = 7145
A.Proc_Poisoned                     = 21929
A.Proc_Concussion                   = GetString(SI_LUIE_SKILL_CONCUSSED)

-- Potions/Poisons
A.Potion                            = 32732
A.Poison                            = 2563
A.Potion_Invisiblity                = 3668
A.Potion_Ravage_Health              = 46111
A.Potion_Restore_Health             = 45221
A.Potion_Restore_Magicka            = 45223
A.Potion_Restore_Stamina            = 45225
A.Poison_Creeping_Drain_Health      = 79701
A.Poison_Lingering_Restore_Health   = 79702
A.Poison_Stealth_Draining_Poison    = GetString(SI_LUIE_SKILL_POISON_STEALTH_DRAIN)
A.Poison_Conspicuous_Poison         = GetString(SI_LUIE_SKILL_POISON_CONSPICUOUS)

-- Food/Drink
A.Food_Magicka_Stamina_Increase     = 61294
A.Food_Health_Stamina_Increase      = 61255
A.Food_Health_Magicka_Increase      = 61257
A.Food_Orzorgas_Tripe_Trifle_Pocket = GetItemLinkName("|H0:item:71057:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
A.Food_Orzorgas_Blood_Price_Pie     = GetItemLinkName("|H0:item:71058:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
A.Food_Orzorgas_Smoked_Bear_Haunch  = GetItemLinkName("|H0:item:71059:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
A.Food_Pumpkin_Snack_Skewer         = GetItemLinkName("|H0:item:87686:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
A.Food_Frosted_Brains               = GetItemLinkName("|H0:item:87696:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
A.Food_Jagga_Drenched_Mud_Ball      = GetItemLinkName("|H0:item:112434:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
A.Food_Lava_Foot_Soup               = GetItemLinkName("|H0:item:112425:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
A.Food_Artaeum_Pickled_Fish_Bowl    = GetItemLinkName("|H0:item:139016:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
A.Food_Crown_Crate_Meal             = GetItemLinkName("|H0:item:94437:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
A.Food_Crown_Meal                   = GetItemLinkName("|H0:item:64711:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
A.Food_Crown_Combat_Mystics_Stew    = GetItemLinkName("|H0:item:124675:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
A.Food_Crown_Vigorous_Ragout        = GetItemLinkName("|H0:item:124676:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
A.Drink_Health_Recovery             = 61322
A.Drink_Magicka_Recovery            = 61325
A.Drink_Stamina_Recovery            = 61328
A.Drink_Magicka_Stamina_Recovery    = 61345
A.Drink_Health_Stamina_Recovery     = 61340
A.Drink_Health_Magicka_Recovery     = 61335
A.Drink_Primary_Stat_Recovery       = 61350
A.Drink_Increase                    = GetString(SI_LUIE_SKILL_DRINK_INCREASE)
A.Drink_Orzorgas_Red_Frothgar       = GetItemLinkName("|H0:item:71056:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
A.Drink_Bowl_of_Peeled_Eyeballs     = GetItemLinkName("|H0:item:87687:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
A.Drink_Ghastly_Eye_Bowl            = GetItemLinkName("|H0:item:87695:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
A.Drink_Bergama_Warning_Fire        = GetItemLinkName("|H0:item:112426:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
A.Drink_Betnikh_Twice_Spiked_Ale    = GetItemLinkName("|H0:item:112433:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
A.Drink_Hissmir_Fish_Eye_Rye        = GetItemLinkName("|H0:item:101879:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
A.Drink_Snow_Bear_Glow_Wine         = GetItemLinkName("|H0:item:112440:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
A.Drink_Crown_Crate_Drink           = GetItemLinkName("|H0:item:94438:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
A.Drink_Crown_Drink                 = GetItemLinkName("|H0:item:64712:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
A.Drink_Crown_Stout_Magic_Liqueur   = GetItemLinkName("|H0:item:124677:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
A.Drink_Crown_Vigorous_Tincture     = GetItemLinkName("|H0:item:124678:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")

-- Experience Consumables
A.Experience_Psijic_Ambrosia        = GetItemLinkName("|H0:item:64221:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h") -- Psijic Ambrosia
A.Experience_Aetherial_Ambrosia     = GetItemLinkName("|H0:item:120076:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h") -- Aetherial Ambrosia
A.Experience_Mythic_Ambrosia        = GetItemLinkName("|H0:item:115027:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h") -- Mythic Aetherial Ambrosia
A.Experience_Crown_Scroll           = GetItemLinkName("|H0:item:64537:1:1:0:0:0:0:0:0:0:0:0:0:0:0:36:0:0:0:0:0|h|h") -- Crown Experience Scroll
A.Experience_Crown_Crate_Scroll_1   = GetItemLinkName("|H0:item:94439:1:1:0:0:0:0:0:0:0:0:0:0:0:0:36:0:0:0:0:0|h|h") -- Gold Coast Experience Scroll
A.Experience_Crown_Crate_Scroll_2   = GetItemLinkName("|H0:item:94440:1:1:0:0:0:0:0:0:0:0:0:0:0:0:36:0:0:0:0:0|h|h") -- Major Gold Coast Experience Scroll
A.Experience_Crown_Crate_Scroll_3   = GetItemLinkName("|H0:item:94441:1:1:0:0:0:0:0:0:0:0:0:0:0:0:36:0:0:0:0:0|h|h") -- Grand Gold Coast Experience Scroll

-- Misc Consumables
A.Consumable_Festival_Mints         = GetItemLinkName("|H0:item:112442:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h") -- High Hrothgar Festival Mints
A.Consumable_Sailors_Grog           = GetItemLinkName("|H0:item:112441:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h") -- Sailor's Warning Festival Grog
A.Consumable_Sparkwreath_Dazzler    = GetItemLinkName("|H0:item:114946:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h") -- Sparkwreath Dazzler
A.Consumable_Plume_Dazzler          = GetItemLinkName("|H0:item:114947:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h") -- Plume Dazzler
A.Consumable_Spiral_Dazzler         = GetItemLinkName("|H0:item:114948:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h") -- Spiral Dazzler
A.Skill_Sparkly_Hat_Dazzler         = GetItemLinkName("|H0:item:120891:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h") -- Sparkly Hat Dazzler

-- Mementos
A.Memento_Almalexias_Lantern        = GetCollectibleName(341)
A.Memento_Bonesnap_Binding_Stone    = GetCollectibleName(348)
A.Memento_Nirnroot_Wine             = GetCollectibleName(344)
A.Memento_Mystery_Meat              = GetString(SI_LUIE_SKILL_COLLECTIBLE_MYSTERY_MEAT)
A.Memento_Sanguines_Goblet          = GetCollectibleName(338)
A.Memento_Token_of_Root_Sunder      = GetCollectibleName(349)
A.Memento_Storm_Atronach_Transform  = GetCollectibleName(596)
A.Memento_Wild_Hunt_Transform       = GetCollectibleName(759)
A.Memento_Dwemervamidium_Mirage     = GetCollectibleName(1183)
A.Memento_Swarm_of_Crows            = GetCollectibleName(1384)
A.Memento_Fire_Breathers_Torches    = GetCollectibleName(600)
A.Memento_Jugglers_Knives           = GetCollectibleName(598)
A.Memento_Sword_Swallowers_Blade    = GetCollectibleName(597)
A.Memento_Discourse_Amaranthine     = GetCollectibleName(345)
A.Memento_Sealing_Amulet            = GetCollectibleName(351)
A.Memento_Twilight_Shard            = GetCollectibleName(1158)
A.Memento_Yokudan_Totem             = GetCollectibleName(350)
A.Memento_Blade_of_the_Blood_Oath   = GetCollectibleName(390)
A.Memento_Dreamers_Chime            = GetCollectibleName(1229)
A.Memento_Hidden_Pressure_Vent      = GetCollectibleName(354)
A.Memento_Coin_of_Illusory_Riches   = GetCollectibleName(361)
A.Memento_Malacaths_Wrathful_Flame  = GetCollectibleName(353)
A.Memento_Jubliee_Cake              = 87998
A.Memento_Mud_Ball                  = 86749
A.Memento_Storm_Atronach_Aura       = GetCollectibleName(594)
A.Memento_Storm_Orb_Juggle          = GetCollectibleName(595)
A.Memento_Wild_Hunt_Aura            = GetCollectibleName(760)
A.Memento_Floral_Swirl_Aura         = GetCollectibleName(758)
A.Memento_Dwarven_Puzzle_Orb        = GetCollectibleName(1181)
A.Memento_Dwarven_Tonal_Forks       = GetCollectibleName(1182)
A.Memento_Crows_Calling             = GetCollectibleName(1383)
A.Memento_Fiery_Orb                 = GetCollectibleName(1481)
A.Memento_Flame_Pixie               = GetCollectibleName(1482)
A.Memento_Flame_Eruption            = GetCollectibleName(1483)
A.Memento_Frost_Shard               = GetCollectibleName(4707)
A.Memento_Rune_of_Levitation        = GetCollectibleName(4706)
A.Memento_Dragon_Summons_Focus      = GetCollectibleName(4708)
A.Memento_The_Pie_of_Misrule        = GetCollectibleName(1167)

-- ---------------------------------------------------
-- EVENT EVENTS -----------------------------------
-- ---------------------------------------------------

A.Event_Petal_Pelters               = GetQuestItemNameFromLink("|H0:quest_item:6145|h|h")

-- ---------------------------------------------------
-- ITEM SETS -----------------------------------------
-- ---------------------------------------------------

A.Set_Asylum_Destruction_Staff      = 99596 -- Concentrated Force (Perfected)
A.Set_Bogdan_the_Nightflame         = GetString(SI_LUIE_SKILL_SET_BOGDAN_THE_NIGHTFLAME)
A.Set_Lord_Warden_Dusk              = GetString(SI_LUIE_SKILL_SET_LORD_WARDEN_DUSK)
A.Set_Malubeth_the_Scourger         = GetString(SI_LUIE_SKILL_SET_MALUBETH_THE_SCOURGER)
A.Set_Maw_of_the_Infernal           = 59507
A.Set_Nerieneth                     = 59592
A.Set_Shadowrend                    = 80989
A.Set_Spawn_of_Mephala              = 59497
A.Set_Swarm_Mother                  = 80592
A.Set_Engine_Guardian               = 59521
A.Set_The_Troll_King                = GetString(SI_LUIE_SKILL_SET_TROLL_KING)
A.Set_Redistribution                = GetString(SI_LUIE_SKILL_SET_REDISTRIBUTION)
A.Set_Varens_Legacy                 = 79029
A.Set_Syvarras_Scales               = 75717
A.Set_Twin_Sisters                  = 32828
A.Set_Way_of_Fire                   = 52710
A.Set_Plague_Slinger                = 102113
A.Set_Ice_Furnace                   = GetString(SI_LUIE_SKILL_SET_ICE_FURNACE)
A.Set_Jolting_Arms                  = 67077
A.Set_Hand_of_Mephala               = 84355
A.Set_Tormentor                     = 67282
A.Set_Immortal_Warrior              = 90938
A.Set_Eternal_Warrior               = 90939
A.Set_Destructive_Mage              = 51315
A.Set_Healing_Mage                  = 51442
A.Set_Vicious_Serpent               = 61440
A.Set_Phoenix                       = 90935
A.Set_Vicecannon_of_Venom           = 79464
A.Set_Bahrahas_Curse                = 75673
A.Set_Pirate_Skeleton               = 98421
A.Set_Briarheart                    = 71102
A.Set_Ironblood                     = 97626
A.Set_Cooldown                      = GetString(SI_LUIE_SKILL_SET_COOLDOWN)
A.Set_Eternal_Hunt                  = 75927
A.Set_Glorious_Defender             = 71180
A.Set_Para_Bellum                   = 71191
A.Set_Winterborn                    = 71644
A.Set_Dust_Cloud                    = GetString(SI_LUIE_SKILL_DUST_CLOUD)
A.Set_Nocturnals_Favor              = 106803
A.Set_Vestment_of_Olorime           = 107117
A.Set_Mantle_of_Siroria             = 107093
A.Set_Arms_of_Relequen              = 107202

A.Disguise_Monks_Disguise           = GetString(SI_LUIE_SKILL_DISGUISE_MONKS_DISGUISE)

-- ---------------------------------------------------
-- CHAMPION ABILITIES --------------------------------
-- ---------------------------------------------------

A.Champion_Vengeance_Charge         = GetString(SI_LUIE_SKILL_VENGEANCE_CHARGE) -- Vengeance Counter
A.Champion_Riposte                  = 60230

-- ---------------------------------------------------
-- SKILL LINE PASSIVES -------------------------------
-- ---------------------------------------------------

-- Sorcerer
A.Passive_Persistence               = 31378
A.Passive_Rebate                    = 31398

-- Templar
A.Passive_Light_Weaver              = 31760

-- Warden
A.Passive_Bond_with_Nature          = GetString(SI_LUIE_SKILL_BOND_WITH_NATURE)
A.Passive_Savage_Beast              = 86062
A.Passive_Natures_Gift              = 93054

-- Weapon
A.Passive_Heavy_Weapons             = 29375
A.Passive_Follow_Up                 = 29389
A.Passive_Twin_Blade_and_Blunt      = 30893
A.Passive_Destruction_Expert        = 30965

-- Soul Magic
A.Passive_Soul_Summons              = 39269

-- Vampire
A.Passive_Savage_Feeding            = 42054
A.Passive_Blood_Ritual              = 33091
A.Passive_Noxiphilic_Sanguivoria    = GetString(SI_LUIE_SKILL_PASSIVE_NOXIPHILIC_SANGUIVORIA)

-- Werewolf
A.Passive_Bloodmoon                 = 32639

-- Undaunted
A.Passive_Undaunted_Command         = 55584

-- Racial
A.Passive_Red_Diamond               = 36155

-- ---------------------------------------------------
-- CLASS SKILLS --------------------------------------
-- ---------------------------------------------------

-- Dragonknight

A.Skill_Power_Lash                  = 20824
A.Skill_Fiery_Grip                  = 20492
A.Skill_Fiery_Breath                = 20917
A.Skill_Standard_of_Might           = 32947
A.Skill_Shackle                     = 32905
A.Skill_Spiked_Armor                = 20319
A.Skill_Dragon_Blood                = 29004
A.Skill_Inhale                      = 31837
A.Skill_Deep_Breath                 = 32792
A.Skill_Draw_Essence                = 32785
A.Skill_Stonefist                   = 29032
A.Skill_Shattering_Rocks            = 32678

-- Nightblade
A.Skill_Piercing_Mark               = 36968
A.Skill_Assassins_Will              = 61907
A.Skill_Assassins_Scourge           = 61932
A.Skill_Vulnerability               = GetString(SI_LUIE_SKILL_VULNERABILITY)
A.Skill_Death_Stroke                = 33398
A.Skill_Incapacitating_Strike       = 36508
A.Skill_Soul_Harvest                = 36514
A.Skill_Refreshing_Path             = 36028
A.Skill_Aspect_of_Terror            = 25352
A.Skill_Manifestation_of_Terror     = 37475
A.Skill_Corrode                     = 89010
A.Skill_Dark_Shade                  = 35434
A.Skill_Shadow_Image                = 35441
A.Skill_Crippling_Grasp             = 36957
A.Skill_Sap_Essence                 = 36891
A.Skill_Soul_Tether                 = 35460

-- Sorcerer
A.Skill_Crystal_Shard               = 43714
A.Skill_Crystal_Blast               = 46331
A.Skill_Crystal_Fragments           = 46324
A.Skill_Rune_Cage                   = 24578
A.Skill_Dark_Exchange               = 24584
A.Skill_Dark_Deal                   = 24595
A.Skill_Dark_Conversion             = 24589
A.Skill_Daedric_Tomb                = 24842
A.Skill_Daedric_Minefield           = 24834
A.Skill_Familiar_Damage_Pulse       = 108844
A.Skill_Winged_Twilight_Restore     = 108845
A.Skill_Tormentor_Damage_Boost      = GetString(SI_LUIE_SKILL_TORMENTOR_DAMAGE_BOOST)
A.Skill_Twilight_Matriarch_Restore  = 77369
A.Skill_Atronach_Zap                = 23428
A.Skill_Greater_Storm_Atronach      = 23492
A.Skill_Summon_Charged_Atronach     = 23495
A.Skill_Mages_Fury                  = 18718
A.Skill_Mages_Wrath                 = 19123
A.Skill_Endless_Fury                = 19109
A.Skill_Critical_Surge              = 23678
A.Skill_Overload                    = 24785
A.Skill_Overload_Heavy_Attack       = 24794

-- Templar
A.Skill_Puncturing_Sweep            = 26797
A.Skill_Aurora_Javelin              = 26800
A.Skill_Empowering_Sweep            = 22144
A.Skill_Crescent_Sweep              = 22139
A.Skill_Purifying_Light             = 21765
A.Skill_Unstable_Core               = 22004
A.Skill_Radiant_Glory               = 63044
A.Skill_Solar_Disturbance           = 21758
A.Skill_Repentance                  = 26821
A.Skill_Cleansing_Ritual            = 22265
A.Skill_Rite_Of_Passage             = 22223
A.Skill_Remembrance                 = 22229
A.Skill_Practiced_Incantation       = 22226

-- Warden
A.Skill_Bull_Netch                  = 86058
A.Skill_Feral_Guardian              = 85982
A.Skill_Eternal_Guardian            = 85986
A.Skill_Healing_Seed                = 85578
A.Skill_Budding_Seeds               = 85840
A.Skill_Corrupting_Pollen           = 85845
A.Skill_Living_Vines                = 85552
A.Skill_Living_Trellis              = 85851
A.Skill_Lotus_Blossom               = 85855
A.Skill_Natures_Grasp               = 85564
A.Skill_Bursting_Vines              = 85859
A.Skill_Natures_Embrace             = 85858
A.Skill_Secluded_Grove              = 85532
A.Skill_Enchanted_Forest            = 85804
A.Skill_Healing_Thicket             = 85807
A.Skill_Crystallized_Shield         = 86135
A.Skill_Crystallized_Slab           = 86139
A.Skill_Shimmering_Shield           = 86143
A.Skill_Frozen_Gate                 = 86175
A.Skill_Frozen_Device               = 86179
A.Skill_Frozen_Retreat              = 86183

-- ---------------------------------------------------
-- WEAPON SKILLS -------------------------------------
-- ---------------------------------------------------

-- Restoration Staff
A.Skill_Blessing_of_Restoration     = GetString(SI_LUIE_SKILL_BLESSING_OF_RESTORATION)

-- Destruction Staff
A.Skill_Crushing_Shock              = 46348
A.Skill_Frozen                      = 68719
A.Skill_Flame_Touch                 = 29073
A.Skill_Frost_Touch                 = 29078
A.Skill_Flame_Clench                = 38985
A.Skill_Shock_Clench                = 38993
A.Skill_Frost_Clench                = 38989
A.Skill_Flame_Reach                 = 38944
A.Skill_Shock_Reach                 = 38978
A.Skill_Frost_Reach                 = 38970

-- Two-Handed
A.Skill_Dizzying_Swing              = 38814
A.Skill_Stampede                    = 38788
A.Skill_Cleave                      = 20919
A.Skill_Carve                       = 38745
A.Skill_Brawler                     = 38754
A.Skill_Forward_Momentum            = 38794

-- One Hand & Shield
A.Skill_Low_Slash                   = 28304
A.Skill_Heroic_Slash                = 38264
A.Skill_Shield_Charge               = 28719
A.Skill_Invasion                    = 38405
A.Skill_Power_Bash                  = 28365

-- Dual Wield
A.Skill_Twin_Slashes                = 28379
A.Skill_Rending_Slashes             = 38839
A.Skill_Blood_Craze                 = 38845
A.Skill_Quick_Cloak                 = 38901
A.Skill_Deadly_Cloak                = 38906

-- Bow
A.Skill_Magnum_Shot                 = 38672
A.Skill_Draining_Shot               = 38669
A.Skill_Bombard                     = 38705
A.Skill_Venom_Arrow                 = 38645

-- ---------------------------------------------------
-- VAMPIRE SKILLS -----------------------------------
-- ---------------------------------------------------

A.Skill_Feed                        = 33152
A.Skill_Vampirism                   = 39472

-- ---------------------------------------------------
-- WEREWOLF SKILLS -----------------------------------
-- ---------------------------------------------------

A.Skill_Werewolf_Bleed              = 89146
A.Skill_Devour                      = 32634
A.Skill_Piercing_Howl               = 58405
A.Skill_Feeding_Frenzy              = 58775
A.Skill_Howl_of_Despair             = 58742
A.Skill_Howl_of_Agony               = 58798
A.Skill_Infectious_Claws            = 58855
A.Skill_Claws_of_Anguish            = 58864
A.Skill_Claws_of_Life               = 58879
A.Skill_Werewolf_Fear               = 39045
A.Skill_Remove                      = 31262

-- ---------------------------------------------------
-- GUILD SKILLS --------------------------------------
-- ---------------------------------------------------

-- Dark Brotherhood
A.Skill_Blade_of_Woe                = 78219

-- Fighters Guild
A.Skill_Revealed                    = 11717
A.Skill_Trap_Beast                  = 35750
A.Skill_Rearming_Trap               = 40382
A.Skill_Lightweight_Beast_Trap      = 40372

-- Mages Guild
A.Skill_Magelight                   = 30920
A.Skill_Spell_Symmetry              = 40445
A.Skill_Meteor                      = 16536
A.Skill_Ice_Comet                   = 40489

-- Psijic Order
A.Skill_Imbue_Weapon                = 103483
A.Skill_Elemental_Weapon            = 103571
A.Skill_Crushing_Weapon             = 103623
A.Skill_Symbiosis                   = 103755

-- Undaunted
A.Skill_Black_Widows                = 41994
A.Skill_Arachnophobia               = 42016
A.Skill_Healing_Combustion          = 63507

-- ---------------------------------------------------
-- ALLIANCE WAR --------------------------------------
-- ---------------------------------------------------

-- Assault
A.Skill_Rapid_Manuever              = 38566
A.Skill_Retreating_Manuever         = 40211
A.Skill_Charging_Manuever           = 40215
A.Skill_Caltrops                    = 33376
A.Skill_Razor_Caltrops              = 40242

-- Support
A.Skill_Efficient_Purge             = 40232
A.Skill_Lingering_Flare             = 61519
A.Skill_Scorching_Flare             = 61524
A.Skill_Reviving_Barrier            = 40237

-- ---------------------------------------------------
-- CYRODIIL ------------------------------------------
-- ---------------------------------------------------

A.Skill_Battle_Spirit               = GetString(SI_LUIE_SKILL_BATTLE_SPIRIT)

-- ---------------------------------------------------
-- NPC ABILITIES -------------------------------------
-- ---------------------------------------------------

-- Shared/Basic

A.Skill_Hamstring                   = 70068
A.Skill_Backstabber                 = 13739

-- Human
A.Skill_Oil_Drenched                = 10650
A.Skill_Ignite                      = 14070
A.Skill_Shield_Rush                 = GetString(SI_LUIE_SKILL_SHIELD_RUSH)
A.Skill_Shock_Aura                  = 17867
A.Skill_Shock_Blast                 = 85255
A.Skill_Improved                    = GetString(SI_LUIE_SKILL_IMPROVED)
A.Skill_Knockback                   = 77905
A.Skill_Weakness                    = 8705
A.Skill_Staff_Strike                = 2901
A.Skill_Ice_Barrier                 = 14178
A.Skill_Vanish                      = 24687
A.Skill_Bone_Cage                   = 35387
A.Skill_Defensive_Ward              = GetString(SI_LUIE_SKILL_DEFENSIVE_WARD)
A.Skill_Great_Cleave                = GetString(SI_LUIE_SKILL_GREAT_CLEAVE)
A.Skill_Retaliation                 = 65033
A.Skill_Divine_Leap                 = 54027
A.Skill_Inspire                     = GetString(SI_LUIE_SKILL_INSPIRE)
A.Skill_Hide_in_Shadows             = GetString(SI_LUIE_SKILL_HIDE_IN_SHADOWS)
A.Skill_Recover                     = 42905
A.Skill_Lunge                       = 78664
A.Skill_Clobber                     = 24671
A.Skill_Shadowy_Barrier             = GetString(SI_LUIE_SKILL_SHADOWY_BARRIER)

-- Justice
A.Skill_Cage_Talons                 = 63168
A.Skill_Heavy_Blow                  = 63157
A.Skill_Mighty_Charge               = GetString(SI_LUIE_SKILL_MIGHTY_CHARGE)
A.Skill_Throw_Dagger                = 28499
A.Skill_Detection                   = GetString(SI_LUIE_SKILL_DETECTION)

-- Cyrodiil
A.Skill_Shock_Torrent               = 46726
A.Skill_Improved_Shock_Torrent      = GetString(SI_LUIE_SKILL_IMPROVED_SHOCK_TORRENT)
A.Skill_Steal_Essence               = 2786
A.Skill_Lasting_Storm               = 46818
A.Skill_Bleeding_Strike             = 46830
A.Skill_Telekinetic_Prison          = 21636
A.Skill_Shattering_Prison           = 46905
A.Skill_Siege_Barrier               = GetString(SI_LUIE_SKILL_SIEGE_BARRIER)
A.Skill_Fire_Torrent                = GetString(SI_LUIE_SKILL_FIRE_TORRENT)
A.Skill_Improved_Fire_Torrent       = 46990
A.Skill_Extended_Chains             = 35113
A.Skill_Puncturing_Chains           = GetString(SI_LUIE_SKILL_PUNCTURING_CHAINS)
A.Skill_Improved_Volley             = GetString(SI_LUIE_SKILL_IMPROVED_VOLLEY)

-- Animals
A.Skill_Lacerate                    = 5452
A.Skill_Bite                        = 17957
A.Skill_Savage_Blows                = 4416
A.Skill_Slam                        = 70366
A.Skill_Rip_and_Tear                = GetString(SI_LUIE_SKILL_RIP_AND_TEAR)
A.Skill_Rush                        = 14380
A.Skill_Vigorus_Swipes              = 75634
A.Skill_Barreling_Charge            = GetString(SI_LUIE_SKILL_BARRELING_CHARGE)
A.Skill_Swipe                       = 2850
A.Skill_Blitz                       = GetString(SI_LUIE_SKILL_BLITZ)
A.Skill_Toxic_Mucus                 = 72793
A.Skill_Bog_Burst                   = 72796
A.Skill_Gore                        = 85202
A.Skill_Bile_Spit                   = 64559

-- Insects
A.Skill_Paralyze                    = 6756
A.Skill_Poisonous_Burst             = 5790
A.Skill_Web                         = 58521
A.Skill_Inject_Larva                = 9229
A.Skill_Zoom                        = GetString(SI_LUIE_SKILL_ZOOM)
A.Skill_Latch_On                    = 6795
A.Skill_Vile_Bite                   = 61243
A.Skill_Infectious_Swarm            = 61360
A.Skill_Necrotic_Explosion          = 61427
A.Skill_Contagion                   = 47838
A.Skill_Plow                        = GetString(SI_LUIE_SKILL_PLOW)
A.Skill_Zap                         = 8429
A.Skill_Leeching_Bite               = GetString(SI_LUIE_SKILL_LEECHING_BITE)
A.Skill_Fetcherfly_Colony           = GetString(SI_LUIE_SKILL_FETCHERFLY_COLONY)

-- Daedra
A.Skill_Summon_Daedric_Arch         = 65404
A.Skill_Empower_Atronach_Flame      = GetString(SI_LUIE_SKILL_EMPOWER_ATRONACH_FLAME)
A.Skill_Empower_Atronach_Frost      = GetString(SI_LUIE_SKILL_EMPOWER_ATRONACH_FROST)
A.Skill_Empower_Atronach_Storm      = GetString(SI_LUIE_SKILL_EMPOWER_ATRONACH_STORM)
A.Skill_Lightning_Rod               = 50023
A.Skill_Headbutt                    = 54380
A.Skill_Tail_Spike                  = 4799
A.Skill_Rending_Leap                = 93745
A.Skill_Radiance                    = 4891
A.Skill_Unyielding_Mace             = 4817
A.Skill_Tremor                      = 67123
A.Skill_Pin                         = 65709
A.Skill_Sweep                       = 67872
A.Skill_Enrage                      = 71696
A.Skill_Chilling_Aura               = 33549
A.Skill_Frozen_Ground               = 33502
A.Skill_Body_Slam                   = 24689
A.Skill_Stomp                       = 91848
A.Skill_Boulder_Toss                = 91855
A.Skill_Storm_Bound                 = 4864
A.Skill_Shockwave                   = 4653
A.Skill_Doom_Truths_Gaze            = 9219
A.Skill_Dusks_Howl                  = 6412

-- Undead
A.Skill_Desecrated_Ground           = 38828
A.Skill_Colossal_Stomp              = GetString(SI_LUIE_SKILL_COLOSSAL_STOMP)
A.Skill_Defiled_Ground              = 22521
A.Skill_Soul_Rupture                = 73931
A.Skill_Winters_Reach               = 4337

-- Monsters
A.Skill_Luring_Snare                = 2821
A.Skill_Assault                     = 4304
A.Skill_Flame_Ray                   = 17703
A.Skill_Frost_Ray                   = 81794
A.Skill_Consuming_Omen              = 48282
A.Skill_Crushing_Limbs              = 3855
A.Skill_Pillars_of_Nirn             = 75955
A.Skill_Claw                        = 27922

-- Dwemer
A.Skill_Static_Shield               = 64463
A.Skill_Dart                        = 7485
A.Skill_Split_Bolt                  = 91093
A.Skill_Turret_Mode                 = 71045
A.Skill_Overcharge                  = 27333

-- ---------------------------------------------------
-- TRAPS ---------------------------------------------
-- ---------------------------------------------------

A.Trap_Cold_Fire_Trap               = GetString(SI_LUIE_SKILL_COLD_FIRE_TRAP)
A.Trap_Falling_Rocks                = 20886
A.Trap_Fire_Trap                    = 17198
A.Trap_Spike_Trap                   = 21940
A.Trap_Sigil_of_Frost               = 20258
A.Trap_Lava                         = 5139

-- ---------------------------------------------------
-- QUEST ABILITIES -----------------------------------
-- ---------------------------------------------------

-- Seasonal
A.Skill_Lava_Foot_Stomp             = GetString(SI_LUIE_SKILL_LAVA_FOOT_STOMP)
A.Skill_Knife_Juggling              = GetString(SI_LUIE_SKILL_KNIFE_JUGGLING)
A.Skill_Torch_Juggling              = GetString(SI_LUIE_SKILL_TORCH_JUGGLING)
A.Skill_Sword_Swallowing            = 84533
A.Skill_Celebratory_Belch           = 84847

-- MSQ
A.Skill_Wall_of_Flames              = GetString(SI_LUIE_SKILL_WALL_OF_FLAMES)
A.Skill_Focused_Healing             = 48345
A.Skill_Necrotic                    = 41852
A.Skill_Barrier                     = 38573
A.Skill_Swordstorm                  = 36858
A.Skill_Flame_Shield                = 37173
A.Skill_Royal_Strike                = 38729
A.Skill_Consecrate_Shrine           = GetString(SI_LUIE_SKILL_CONSECRATE_SHRINE)
A.Skill_Remove_Ward                 = 18606
A.Skill_Nova                        = 21752
A.Skill_Shock                       = 27598
A.Skill_Drink_Mead                  = 13941
A.Skill_Unstable_Portal             = GetString(SI_LUIE_SKILL_UNSTABLE_PORTAL)
A.Skill_Stabilize_Portal            = GetString(SI_LUIE_SKILL_STABILIZE_PORTAL)
A.Skill_Close_Unstable_Rift         = GetString(SI_LUIE_SKILL_CLOSE_UNSTABLE_RIFT)

-- FIGHTERS GUILD
A.Skill_Palolels_Rage               = 39577
A.Skill_Prismatic_Light             = 25981
A.Skill_Quick_Strike                = 10618
A.Skill_Flame_Blossom               = GetString(SI_LUIE_SKILL_FLAME_BLOSSOM)

-- MAGES GUILD
A.Skill_Rock                        = 26775
A.Skill_Essence                     = 25337
A.Skill_Sahdinas_Essence            = GetString(SI_LUIE_SKILL_SAHDINAS_ESSENCE)
A.Skill_Rashomtas_Essence           = GetString(SI_LUIE_SKILL_RASHOMTAS_ESSENCE)
A.Skill_Polymorph_Skeleton          = GetString(SI_LUIE_SKILL_POLYMORPH_SKELETON)
A.Skill_Drain_Vitality              = 8787
A.Skill_Ungulate_Ordnance           = 39393

-- ALDMERI DOMINION
A.Skill_Drain_Energy                = GetString(SI_LUIE_SKILL_DRAIN_ENERGY)
A.Skill_Blessing                    = 33029
A.Skill_Disruption                  = 31321
A.Skill_Barrier_Rebuke              = GetString(SI_LUIE_SKILL_BARRIER_REBUKE)
A.Skill_Dispel                      = 8490
A.Skill_Teleport_Scroll             = GetString(SI_LUIE_SKILL_TELEPORT_SCROLL)
A.Skill_Purify                      = 22260
A.Skill_Bind_Hands                  = GetString(SI_LUIE_SKILL_BIND_HANDS)
A.Skill_Bind_Bear                   = GetString(SI_LUIE_SKILL_BIND_BEAR)
A.Skill_Ferocious_Charge            = 83033
A.Skill_Daedric_Explosion           = 83017
A.Skill_Spiritual_Cloak             = 21403
A.Skill_Aetherial_Shift             = GetString(SI_LUIE_SKILL_AETHERIAL_SHIFT)
A.Skill_Free_Spirit                 = GetString(SI_LUIE_SKILL_FREE_SPIRIT)
A.Skill_Unbind                      = GetString(SI_LUIE_SKILL_UNBIND)
A.Skill_Crystal                     = 67121
A.Skill_Backfire                    = GetString(SI_LUIE_SKILL_BACKFIRE)
A.Skill_Close_Portal                = 23370
A.Skill_Lightning_Strike            = 27596
A.Skill_Push                        = 8692
A.Skill_Mantles_Shadow              = GetString(SI_LUIE_SKILL_MANTLES_SHADOW)
A.Skill_Quaking_Stomp               = 43820
A.Skill_Projectile_Vomit            = 43827
A.Skill_Call_for_Help               = 53430
A.Skill_Throw_Water                 = GetString(SI_LUIE_SKILL_THROW_WATER)
A.Skill_Snake_Scales                = 36713
A.Skill_Wolfs_Pelt                  = 36843
A.Skill_Tigers_Fur                  = 36828
A.Skill_Feedback                    = 32063
A.Skill_Soul_Binding                = 21171
A.Skill_Empower_Heart               = GetString(SI_LUIE_SKILL_EMPOWER_TWILIT_HEART)
A.Skill_Restricting_Vines           = GetString(SI_LUIE_SKILL_RESTRICTING_VINES)
A.Skill_Change_Clothes              = GetString(SI_LUIE_SKILL_CHANGE_CLOTHES)
A.Skill_Fancy_Clothing              = GetString(SI_LUIE_SKILL_FANCY_CLOTHING)
A.Skill_Fire                        = 33594
A.Skill_Burrow                      = 8974
A.Skill_Serpent_Spit                = GetString(SI_LUIE_SKILL_SERPENT_SPIT)
A.Skill_Shadow_Wood                 = GetString(SI_LUIE_SKILL_SHADOW_WOOD)

-- ---------------------------------------------------
-- OTHER EFFECTS -------------------------------------
-- ---------------------------------------------------

-- Sanctum Ophidia
A.Effect_Magicka_Bomb               = 59036

-- vMOL Debuffs
A.Effect_Colossal_Mark              = 75672
A.Effect_Shattered                  = 75071
A.Effect_Shattered2                 = 73250
A.Effect_Grip_of_Lorkaj             = 57517
A.Effect_Unstable_Void              = 74488
A.Effect_Curse_Duration             = 25000


-- Replace ability IDs with names
local pairs = pairs
for k, v in pairs(A) do
    if type(v) == "number" then
        A[k] = GetAbilityName(v)
    end
end

-- Export string data to global namespace
LUIE.GetAbility = function() return A end
