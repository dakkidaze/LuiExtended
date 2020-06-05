--[[
    LuiExtended
    License: The MIT License (MIT)
--]]

local CombatInfo = LUIE.CombatInfo
local CrowdControlTracker = CombatInfo.CrowdControlTracker
local AbilityAlerts = CombatInfo.AbilityAlerts

local zo_strformat = zo_strformat

local castBarMovingEnable = false -- Helper local flag
local alertFrameMovingEnabled = false -- Helper local flag

local globalMethodOptions = { "Ascending", "Descending", "Radial" }
local globalMethodOptionsKeys = { ["Ascending"] = 1, ["Descending"] = 2, ["Radial"] = 3 }
local globalAlertOptions = { "Show All Incoming Abilities", "Only Show Hard CC Effects", "Only Show Unbreakable CC Effects" }
local globalAlertOptionsKeys = { ["Show All Incoming Abilities"] = 1, ["Only Show Hard CC Effects"] = 2, ["Only Show Unbreakable CC Effects"] = 3 }

local ACTION_RESULT_AREA_EFFECT = 669966

function CombatInfo.CreateSettings()
    -- Load LibAddonMenu
    local LAM = LibAddonMenu2
    if LAM == nil then return end

    local Defaults = CombatInfo.Defaults
    local Settings = CombatInfo.SV

    -- Get fonts
    local FontsList = {}
    for f in pairs(LUIE.Fonts) do
        table.insert(FontsList, f)
    end

    -- Get sounds
    local SoundsList = {}
    for sound, _ in pairs(LUIE.Sounds) do
        table.insert(SoundsList, sound)
    end

    -- Get statusbar textures
    local StatusbarTexturesList = {}
    for key, _ in pairs(LUIE.StatusbarTextures) do
        table.insert(StatusbarTexturesList, key)
    end

    local panelDataCombatInfo = {
        type = "panel",
        name = zo_strformat("<<1>> - <<2>>", LUIE.name, GetString(SI_LUIE_LAM_CI)),
        displayName = zo_strformat("<<1>> <<2>>", LUIE.name, GetString(SI_LUIE_LAM_CI)),
        author = LUIE.author,
        version = LUIE.version,
        website = LUIE.website,
        feedback = LUIE.feedback,
        translation = LUIE.translation,
        donation = LUIE.donation,
        slashCommand = "/luici",
        registerForRefresh = true,
        registerForDefaults = true,
    }

    local optionsDataCombatInfo = {}

    -- Combat Info Description
    optionsDataCombatInfo[#optionsDataCombatInfo + 1] = {
        type = "description",
        text = GetString(SI_LUIE_LAM_CI_DESCRIPTION),
    }

    -- ReloadUI Button
    optionsDataCombatInfo[#optionsDataCombatInfo + 1] = {
        type = "button",
        name = GetString(SI_LUIE_LAM_RELOADUI),
        tooltip = GetString(SI_LUIE_LAM_RELOADUI_BUTTON),
        func = function() ReloadUI("ingame") end,
        width = "full",
    }

    -- Combat Info - Global Cooldown Options Submenu
    optionsDataCombatInfo[#optionsDataCombatInfo + 1] = {
        type = "submenu",
        name = GetString(SI_LUIE_LAM_CI_HEADER_GCD),
        controls = {
            {
                type = "checkbox",
                name = GetString(SI_LUIE_LAM_CI_GCD_SHOW),
                tooltip = GetString(SI_LUIE_LAM_CI_GCD_SHOW_TP),
                getFunc = function() return Settings.GlobalShowGCD end,
                setFunc = function(value) Settings.GlobalShowGCD = value CombatInfo.HookGCD() end,
                width = "full",
                warning = GetString(SI_LUIE_LAM_CI_GCD_SHOW_WARN),
                default = Defaults.GlobalShowGCD,
                disabled = function() return not LUIE.SV.CombatInfo_Enabled end,
            },
            {
                type = "checkbox",
                name = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_GCD_QUICK)),
                tooltip = GetString(SI_LUIE_LAM_CI_GCD_QUICK_TP),
                getFunc = function() return Settings.GlobalPotion end,
                setFunc = function(value) Settings.GlobalPotion = value end,
                width = "full",
                default = Defaults.GlobalPotion,
                disabled = function() return not (LUIE.SV.CombatInfo_Enabled and Settings.GlobalShowGCD) end,
            },
            {
                -- Show GCD Ready Flash
                type = "checkbox",
                name = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_GCD_FLASH)),
                tooltip = GetString(SI_LUIE_LAM_CI_GCD_FLASH_TP),
                getFunc = function() return Settings.GlobalFlash end,
                setFunc = function(value) Settings.GlobalFlash = value end,
                width = "full",
                default = Defaults.GlobalFlash,
                disabled = function() return not (LUIE.SV.CombatInfo_Enabled and Settings.GlobalShowGCD) end,
            },
            {
                -- GCD - Desaturate Icons on GCD
                type = "checkbox",
                name = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_GCD_DESAT)),
                tooltip = GetString(SI_LUIE_LAM_CI_GCD_DESAT_TP),
                getFunc = function() return Settings.GlobalDesat end,
                setFunc = function(value) Settings.GlobalDesat = value end,
                width = "full",
                default = Defaults.GlobalDesat,
                disabled = function() return not (LUIE.SV.CombatInfo_Enabled and Settings.GlobalShowGCD) end,
            },
            {
                -- GCD - Color Slot Label Red
                type = "checkbox",
                name = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_GCD_COLOR)),
                tooltip = GetString(SI_LUIE_LAM_CI_GCD_COLOR_TP),
                getFunc = function() return Settings.GlobalLabelColor end,
                setFunc = function(value) Settings.GlobalLabelColor = value end,
                width = "full",
                default = Defaults.GlobalLabelColor,
                disabled = function() return not (LUIE.SV.CombatInfo_Enabled and Settings.GlobalShowGCD) end,
            },
            {
                -- GCD - Animation Method
                type = "dropdown",
                name = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_GCD_ANIMATION)),
                tooltip = GetString(SI_LUIE_LAM_CI_GCD_ANIMATION_TP),
                choices = globalMethodOptions,
                getFunc = function() return globalMethodOptions[Settings.GlobalMethod] end,
                setFunc = function(value) Settings.GlobalMethod = globalMethodOptionsKeys[value] end,
                width = "full",
                default = Defaults.GlobalMethod,
                disabled = function() return not (LUIE.SV.CombatInfo_Enabled and Settings.GlobalShowGCD) end,
            },
        },
    }

    -- Combat Info - Ultimate Tracking Options Submenu
    optionsDataCombatInfo[#optionsDataCombatInfo + 1] = {
        type = "submenu",
        name = GetString(SI_LUIE_LAM_CI_HEADER_ULTIMATE),
        controls = {
            {
                type = "checkbox",
                name = GetString(SI_LUIE_LAM_CI_ULTIMATE_SHOW_VAL),
                tooltip = GetString(SI_LUIE_LAM_CI_ULTIMATE_SHOW_VAL_TP),
                getFunc = function() return Settings.UltimateLabelEnabled end,
                setFunc = function(value) Settings.UltimateLabelEnabled = value CombatInfo.RegisterCombatInfo() CombatInfo.UpdateUltimateLabel() end,
                width = "full",
                default = Defaults.UltimateLabelEnabled,
                disabled = function() return not LUIE.SV.CombatInfo_Enabled end,
            },
            {
                type = "checkbox",
                name = GetString(SI_LUIE_LAM_CI_ULTIMATE_SHOW_PCT),
                tooltip = GetString(SI_LUIE_LAM_CI_ULTIMATE_SHOW_PCT_TP),
                getFunc = function() return Settings.UltimatePctEnabled end,
                setFunc = function(value) Settings.UltimatePctEnabled = value CombatInfo.RegisterCombatInfo() CombatInfo.UpdateUltimateLabel() end,
                width = "full",
                default = Defaults.UltimatePctEnabled,
                disabled = function() return not LUIE.SV.CombatInfo_Enabled end,
            },
            {
                type = "slider",
                name = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_SHARED_POSITION)),
                tooltip = GetString(SI_LUIE_LAM_CI_SHARED_POSITION_TP),
                min = -72, max = 40, step = 2,
                getFunc = function() return Settings.UltimateLabelPosition end,
                setFunc = function(value) Settings.UltimateLabelPosition = value CombatInfo.ResetUltimateLabel() end,
                width = "full",
                default = Defaults.UltimateLabelPosition,
                disabled = function() return not ( LUIE.SV.CombatInfo_Enabled and Settings.UltimatePctEnabled ) end,
            },
            {
                type = "dropdown",
                scrollable = true,
                name = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_FONT)),
                tooltip = GetString(SI_LUIE_LAM_CI_SHARED_FONT_TP),
                choices = FontsList,
                sort = "name-up",
                getFunc = function() return Settings.UltimateFontFace end,
                setFunc = function(var) Settings.UltimateFontFace = var CombatInfo.ApplyFont() end,
                width = "full",
                default = Defaults.UltimateFontFace,
                disabled = function() return not ( LUIE.SV.CombatInfo_Enabled and Settings.UltimatePctEnabled ) end,
            },
            {
                type = "slider",
                name = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_FONT_SIZE)),
                tooltip = GetString(SI_LUIE_LAM_CI_SHARED_FONTSIZE_TP),
                min = 10, max = 30, step = 1,
                getFunc = function() return Settings.UltimateFontSize end,
                setFunc = function(value) Settings.UltimateFontSize = value CombatInfo.ApplyFont() end,
                width = "full",
                default = Defaults.UltimateFontSize,
                disabled = function() return not ( LUIE.SV.CombatInfo_Enabled and Settings.UltimatePctEnabled ) end,
            },
            {
                type = "dropdown",
                name = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_FONT_STYLE)),
                tooltip = GetString(SI_LUIE_LAM_CI_SHARED_FONTSTYLE_TP),
                choices = { "normal", "outline", "shadow", "soft-shadow-thick", "soft-shadow-thin", "thick-outline" },
                sort = "name-up",
                getFunc = function() return Settings.UltimateFontStyle end,
                setFunc = function(var) Settings.UltimateFontStyle = var CombatInfo.ApplyFont() end,
                width = "full",
                default = Defaults.UltimateFontStyle,
                disabled = function() return not ( LUIE.SV.CombatInfo_Enabled and Settings.UltimatePctEnabled ) end,
            },
            {
                type = "checkbox",
                name = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_ULTIMATE_HIDEFULL)),
                tooltip = GetString(SI_LUIE_LAM_CI_ULTIMATE_HIDEFULL_TP),
                getFunc = function() return Settings.UltimateHideFull end,
                setFunc = function(value) Settings.UltimateHideFull = value CombatInfo.UpdateUltimateLabel() end,
                width = "full",
                default = Defaults.UltimateHideFull,
                disabled = function() return not ( LUIE.SV.CombatInfo_Enabled and Settings.UltimatePctEnabled ) end,
            },
            {
                type = "checkbox",
                name = GetString(SI_LUIE_LAM_CI_ULTIMATE_TEXTURE),
                tooltip = GetString(SI_LUIE_LAM_CI_ULTIMATE_TEXTURE_TP),
                getFunc = function() return Settings.UltimateGeneration end,
                setFunc = function(value) Settings.UltimateGeneration = value end,
                width = "full",
                default = Defaults.UltimateGeneration,
                disabled = function() return not LUIE.SV.CombatInfo_Enabled end,
            },
        },
    }

    -- Combat Info - Bar Ability Highlight Options Submenu
    optionsDataCombatInfo[#optionsDataCombatInfo + 1] = {
        type = "submenu",
        name = GetString(SI_LUIE_LAM_CI_HEADER_BAR),
        controls = {
            {
                -- Highlight Ability Bar Icon for Active Procs
                type = "checkbox",
                name = GetString(SI_LUIE_LAM_CI_BAR_PROC),
                tooltip = GetString(SI_LUIE_LAM_CI_BAR_PROC_TP),
                getFunc = function() return Settings.ShowTriggered end,
                setFunc = function(value) Settings.ShowTriggered = value CombatInfo.UpdateBarHighlightTables() CombatInfo.OnSlotsFullUpdate() end,
                width = "full",
                default = Defaults.ShowTriggered,
                disabled = function() return not LUIE.SV.CombatInfo_Enabled end,
            },
            {
                -- Bar Proc Sound
                type = "checkbox",
                name = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_BAR_PROCSOUND)),
                tooltip = GetString(SI_LUIE_LAM_CI_BAR_PROCSOUND_TP),
                getFunc = function() return Settings.ProcEnableSound end,
                setFunc = function(value) Settings.ProcEnableSound = value end,
                width = "half",
                default = Defaults.ProcEnableSound,
                disabled = function() return not (Settings.ShowTriggered and LUIE.SV.CombatInfo_Enabled) end,
            },
            {
                -- Bar Proc Sound Choice
                type = "dropdown",
                scrollable = true,
                choices = SoundsList,
                sort = "name-up",
                getFunc = function() return Settings.ProcSoundName end,
                setFunc = function(value) Settings.ProcSoundName = value CombatInfo.ApplyProcSound(true) end,
                width = "half",
                default = Defaults.ProcSoundName,
                disabled = function() return not (Settings.ShowTriggered and Settings.ProcEnableSound and LUIE.SV.CombatInfo_Enabled) end,
            },
            {
                -- Highlight Ability Bar Icon for Active Effects
                type = "checkbox",
                name = GetString(SI_LUIE_LAM_CI_BAR_EFFECT),
                tooltip = GetString(SI_LUIE_LAM_CI_BAR_EFFECT_TP),
                getFunc = function() return Settings.ShowToggled end,
                setFunc = function(value) Settings.ShowToggled = value CombatInfo.UpdateBarHighlightTables() CombatInfo.OnSlotsFullUpdate() end,
                width = "full",
                default = Defaults.ShowToggled,
                disabled = function() return not LUIE.SV.CombatInfo_Enabled end,
            },
            {
                -- Show Toggled Secondary
                type = "checkbox",
                name = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_BAR_SECONDARY)),
                tooltip = GetString(SI_LUIE_LAM_CI_BAR_SECONDARY_TP),
                getFunc = function() return Settings.ShowToggledSecondary end,
                setFunc = function(value) Settings.ShowToggledSecondary = value CombatInfo.UpdateBarHighlightTables() CombatInfo.OnSlotsFullUpdate() end,
                width = "full",
                default = Defaults.ShowToggledSecondary,
                disabled = function() return not (Settings.ShowToggled and LUIE.SV.CombatInfo_Enabled) end,
            },
            {
                -- Show Toggled Ultimate
                type = "checkbox",
                name = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_BAR_ULTIMATE)),
                tooltip = GetString(SI_LUIE_LAM_CI_BAR_ULTIMATE_TP),
                getFunc = function() return Settings.ShowToggledUltimate end,
                setFunc = function(value) Settings.ShowToggledUltimate = value CombatInfo.UpdateBarHighlightTables() CombatInfo.OnSlotsFullUpdate() end,
                width = "full",
                default = Defaults.ShowToggledUltimate,
                disabled = function() return not (Settings.ShowToggled and LUIE.SV.CombatInfo_Enabled) end,
            },
            {
                -- Show Label On Bar Highlight
                type = "checkbox",
                name = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_BAR_LABEL)),
                tooltip = GetString(SI_LUIE_LAM_CI_BAR_LABEL_TP),
                getFunc = function() return Settings.BarShowLabel end,
                setFunc = function(value) Settings.BarShowLabel = value CombatInfo.ResetBarLabel() end,
                width = "full",
                default = Defaults.BarShowLabel,
                disabled = function() return not ( LUIE.SV.CombatInfo_Enabled and ( Settings.ShowTriggered or Settings.ShowToggled) ) end,
            },
            {
                type = "slider",
                name = zo_strformat("\t\t\t\t\t\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_SHARED_POSITION)),
                tooltip = GetString(SI_LUIE_LAM_CI_SHARED_POSITION_TP),
                min = -72, max = 40, step = 2,
                getFunc = function() return Settings.BarLabelPosition end,
                setFunc = function(value) Settings.BarLabelPosition = value CombatInfo.ResetBarLabel() end,
                width = "full",
                default = Defaults.BarLabelPosition,
                disabled = function() return not ( LUIE.SV.CombatInfo_Enabled and Settings.BarShowLabel and ( Settings.ShowTriggered or Settings.ShowToggled)) end,
            },
            {
                type = "dropdown",
                scrollable = true,
                name = zo_strformat("\t\t\t\t\t\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_FONT)),
                tooltip = GetString(SI_LUIE_LAM_CI_SHARED_FONT_TP),
                choices = FontsList,
                sort = "name-up",
                getFunc = function() return Settings.BarFontFace end,
                setFunc = function(var) Settings.BarFontFace = var CombatInfo.ApplyFont() end,
                width = "full",
                default = Defaults.BarFontFace,
                disabled = function() return not ( LUIE.SV.CombatInfo_Enabled and Settings.BarShowLabel and ( Settings.ShowTriggered or Settings.ShowToggled)) end,
            },
            {
                type = "slider",
                name = zo_strformat("\t\t\t\t\t\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_FONT_SIZE)),
                tooltip = GetString(SI_LUIE_LAM_CI_SHARED_FONTSIZE_TP),
                min = 10, max = 30, step = 1,
                getFunc = function() return Settings.BarFontSize end,
                setFunc = function(value) Settings.BarFontSize = value CombatInfo.ApplyFont() end,
                width = "full",
                default = Defaults.BarFontSize,
                disabled = function() return not ( LUIE.SV.CombatInfo_Enabled and Settings.BarShowLabel and ( Settings.ShowTriggered or Settings.ShowToggled)) end,
            },
            {
                type = "dropdown",
                name = zo_strformat("\t\t\t\t\t\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_FONT_STYLE)),
                tooltip = GetString(SI_LUIE_LAM_CI_SHARED_FONTSTYLE_TP),
                choices = { "normal", "outline", "shadow", "soft-shadow-thick", "soft-shadow-thin", "thick-outline" },
                sort = "name-up",
                getFunc = function() return Settings.BarFontStyle end,
                setFunc = function(var) Settings.BarFontStyle = var CombatInfo.ApplyFont() end,
                width = "full",
                default = Defaults.BarFontStyle,
                disabled = function() return not ( LUIE.SV.CombatInfo_Enabled and Settings.BarShowLabel and ( Settings.ShowTriggered or Settings.ShowToggled)) end,
            },
            {
                type = "checkbox",
                name = zo_strformat("\t\t\t\t\t\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_BUFF_SHOWSECONDFRACTIONS)),
                tooltip = GetString(SI_LUIE_LAM_BUFF_SHOWSECONDFRACTIONS_TP),
                getFunc = function() return Settings.BarMiilis end,
                setFunc = function(value) Settings.BarMiilis = value end,
                width = "full",
                default = Defaults.BarMiilis,
                disabled = function() return not ( LUIE.SV.CombatInfo_Enabled and Settings.BarShowLabel and ( Settings.ShowTriggered or Settings.ShowToggled)) end,
            },
            {
                type = "divider",
                width = "full",
            },
            {
                type = "description",
                text = GetString(SI_LUIE_LAM_CI_BACKBAR_NOTE),
            },
            {
                -- Show Backbar
                type = "checkbox",
                name = GetString(SI_LUIE_LAM_CI_BACKBAR_ENABLE),
                tooltip = GetString(SI_LUIE_LAM_CI_BACKBAR_ENABLE_TP),
                getFunc = function() return Settings.BarShowBack end,
                setFunc = function(value) Settings.BarShowBack = value CombatInfo.OnSlotsFullUpdate() CombatInfo.BackbarToggleSettings() end,
                width = "full",
                default = Defaults.BarShowBack,
                disabled = function() return not (Settings.ShowToggled and LUIE.SV.CombatInfo_Enabled) end,
            },
            {
                -- Dark Backbar
                type = "checkbox",
                name = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_BACKBAR_DARK)),
                tooltip = GetString(SI_LUIE_LAM_CI_BACKBAR_DARK_TP),
                getFunc = function() return Settings.BarDarkUnused end,
                setFunc = function(value) Settings.BarDarkUnused = value CombatInfo.OnSlotsFullUpdate() CombatInfo.BackbarToggleSettings() end,
                width = "full",
                default = Defaults.BarDarkUnused,
                disabled = function() return not (Settings.ShowToggled and Settings.BarShowBack and LUIE.SV.CombatInfo_Enabled) end,
            },
            {
                -- Desaturate Backbar
                type = "checkbox",
                name = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_BACKBAR_DESATURATE)),
                tooltip = GetString(SI_LUIE_LAM_CI_BACKBAR_DESATURATE_TP),
                getFunc = function() return Settings.BarDesaturateUnused end,
                setFunc = function(value) Settings.BarDesaturateUnused = value CombatInfo.OnSlotsFullUpdate() CombatInfo.BackbarToggleSettings() end,
                width = "full",
                default = Defaults.BarDesaturateUnused,
                disabled = function() return not (Settings.ShowToggled and LUIE.SV.CombatInfo_Enabled) end,
            },
            {
                -- Hide Unused Backbar
                type = "checkbox",
                name = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_BACKBAR_HIDE_UNUSED)),
                tooltip = GetString(SI_LUIE_LAM_CI_BACKBAR_HIDE_UNUSED_TP),
                getFunc = function() return Settings.BarHideUnused end,
                setFunc = function(value) Settings.BarHideUnused = value CombatInfo.OnSlotsFullUpdate() CombatInfo.BackbarToggleSettings() end,
                width = "full",
                default = Defaults.BarHideUnused,
                disabled = function() return not (Settings.ShowToggled and Settings.BarShowBack and LUIE.SV.CombatInfo_Enabled) end,
            },
        },
    }

    -- Combat Info - Quickslot Cooldown Timer Option Submenu
    optionsDataCombatInfo[#optionsDataCombatInfo + 1] = {
        type = "submenu",
        name = GetString(SI_LUIE_LAM_CI_HEADER_POTION),
        controls = {
            {
                -- Show Quickslot Cooldown
                type = "checkbox",
                name = GetString(SI_LUIE_LAM_CI_POTION),
                tooltip = GetString(SI_LUIE_LAM_CI_POTION_TP),
                getFunc = function() return Settings.PotionTimerShow end,
                setFunc = function(value) Settings.PotionTimerShow = value end,
                width = "full",
                default = Defaults.PotionTimerShow,
                disabled = function() return not LUIE.SV.CombatInfo_Enabled end,
            },
            {
                type = "slider",
                name = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_SHARED_POSITION)),
                tooltip = GetString(SI_LUIE_LAM_CI_SHARED_POSITION_TP),
                min = -72, max = 40, step = 2,
                getFunc = function() return Settings.PotionTimerLabelPosition end,
                setFunc = function(value) Settings.PotionTimerLabelPosition = value CombatInfo.ResetPotionTimerLabel() end,
                width = "full",
                default = Defaults.PotionTimerLabelPosition,
                disabled = function() return not ( LUIE.SV.CombatInfo_Enabled and Settings.PotionTimerShow ) end,
            },
            {
                type = "dropdown",
                scrollable = true,
                name = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_FONT)),
                tooltip = GetString(SI_LUIE_LAM_CI_SHARED_FONT_TP),
                choices = FontsList,
                sort = "name-up",
                getFunc = function() return Settings.PotionTimerFontFace end,
                setFunc = function(var) Settings.PotionTimerFontFace = var CombatInfo.ApplyFont() end,
                width = "full",
                default = Defaults.PotionTimerFontFace,
                disabled = function() return not ( LUIE.SV.CombatInfo_Enabled and Settings.PotionTimerShow ) end,
            },
            {
                type = "slider",
                name = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_FONT_SIZE)),
                tooltip = GetString(SI_LUIE_LAM_CI_SHARED_FONTSIZE_TP),
                min = 10, max = 30, step = 1,
                getFunc = function() return Settings.PotionTimerFontSize end,
                setFunc = function(value) Settings.PotionTimerFontSize = value CombatInfo.ApplyFont() end,
                width = "full",
                default = Defaults.PotionTimerFontSize,
                disabled = function() return not ( LUIE.SV.CombatInfo_Enabled and Settings.PotionTimerShow ) end,
            },
            {
                type = "dropdown",
                name = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_FONT_STYLE)),
                tooltip = GetString(SI_LUIE_LAM_CI_SHARED_FONTSTYLE_TP),
                choices = { "normal", "outline", "shadow", "soft-shadow-thick", "soft-shadow-thin", "thick-outline" },
                sort = "name-up",
                getFunc = function() return Settings.PotionTimerFontStyle end,
                setFunc = function(var) Settings.PotionTimerFontStyle = var CombatInfo.ApplyFont() end,
                width = "full",
                default = Defaults.PotionTimerFontStyle,
                disabled = function() return not ( LUIE.SV.CombatInfo_Enabled and Settings.PotionTimerShow ) end,
            },
            {
                type = "checkbox",
                name = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_POTION_COLOR)),
                tooltip = GetString(SI_LUIE_LAM_CI_POTION_COLOR_TP),
                getFunc = function() return Settings.PotionTimerColor end,
                setFunc = function(value) Settings.PotionTimerColor = value end,
                width = "full",
                default = Defaults.PotionTimerColor,
                disabled = function() return not ( LUIE.SV.CombatInfo_Enabled and Settings.PotionTimerShow ) end,
            },
            {
                type = "checkbox",
                name = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_BUFF_SHOWSECONDFRACTIONS)),
                tooltip = GetString(SI_LUIE_LAM_BUFF_SHOWSECONDFRACTIONS_TP),
                getFunc = function() return Settings.PotionTimerMillis end,
                setFunc = function(value) Settings.PotionTimerMillis = value end,
                width = "full",
                default = Defaults.PotionTimerMillis,
                disabled = function() return not ( LUIE.SV.CombatInfo_Enabled and Settings.PotionTimerShow ) end,
            },
        },
    }
    -- Combat Info -- Cast Bar Option Submenu
    optionsDataCombatInfo[#optionsDataCombatInfo + 1] = {
        type = "submenu",
        name = GetString(SI_LUIE_LAM_CI_HEADER_CASTBAR),
        controls = {

            -- Cast Bar Unlock
            {
                type = "checkbox",
                name = GetString(SI_LUIE_LAM_CI_CASTBAR_MOVE),
                tooltip = GetString(SI_LUIE_LAM_CI_CASTBAR_MOVE_TP),
                getFunc = function() return castBarMovingEnabled end,
                setFunc = CombatInfo.SetMovingState,
                width = "half",
                default = false,
                resetFunc = CombatInfo.ResetCastBarPosition,
                disabled = function() return not ( LUIE.SV.CombatInfo_Enabled and Settings.CastBarEnable ) end,
            },
            -- Cast Bar Unlock Reset position
            {
                type = "button",
                name = GetString(SI_LUIE_LAM_RESETPOSITION),
                tooltip = GetString(SI_LUIE_LAM_CI_CASTBAR_RESET_TP),
                func = CombatInfo.ResetCastBarPosition,
                width = "half",
                disabled = function() return not ( LUIE.SV.CombatInfo_Enabled and Settings.CastBarEnable ) end,
            },
            {
                -- Enable Cast Bar
                type = "checkbox",
                name = GetString(SI_LUIE_LAM_CI_CASTBAR_ENABLE),
                tooltip = GetString(SI_LUIE_LAM_CI_CASTBAR_ENABLE_TP),
                getFunc = function() return Settings.CastBarEnable end,
                setFunc = function(value) Settings.CastBarEnable = value CombatInfo.RegisterCombatInfo() end,
                width = "full",
                default = Defaults.CastBarEnable,
                disabled = function() return not ( LUIE.SV.CombatInfo_Enabled ) end,
            },
            {
                -- Cast Bar Width
                type = "slider",
                name = GetString(SI_LUIE_LAM_CI_CASTBAR_SIZEW),
                min = 100, max = 500, step = 5,
                getFunc = function() return Settings.CastBarSizeW end,
                setFunc = function(value) Settings.CastBarSizeW = value CombatInfo.ResizeCastBar() end,
                width = "full",
                default = Defaults.CastBarSizeW,
                disabled = function() return not ( LUIE.SV.CombatInfo_Enabled ) end,
            },
            {
                -- Cast Bar Height
                type = "slider",
                name = GetString(SI_LUIE_LAM_CI_CASTBAR_SIZEH),
                min = 16, max = 64, step = 2,
                getFunc = function() return Settings.CastBarSizeH end,
                setFunc = function(value) Settings.CastBarSizeH = value CombatInfo.ResizeCastBar() end,
                width = "full",
                default = Defaults.CastBarSizeH,
                disabled = function() return not ( LUIE.SV.CombatInfo_Enabled ) end,
            },
            {
                -- Cast Bar Icon Size
                type = "slider",
                name = GetString(SI_LUIE_LAM_CI_CASTBAR_ICONSIZE),
                min = 16, max = 64, step = 2,
                getFunc = function() return Settings.CastBarIconSize end,
                setFunc = function(value) Settings.CastBarIconSize = value CombatInfo.ResizeCastBar() end,
                width = "full",
                default = Defaults.CastBarIconSize,
                disabled = function() return not ( LUIE.SV.CombatInfo_Enabled ) end,
            },
            {
                -- Display Label
                type = "checkbox",
                name = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_CASTBAR_LABEL)),
                tooltip = GetString(SI_LUIE_LAM_CI_CASTBAR_LABEL_TP),
                getFunc = function() return Settings.CastBarLabel end,
                setFunc = function(value) Settings.CastBarLabel = value end,
                width = "full",
                default = Defaults.CastBarLabel,
                disabled = function() return not ( LUIE.SV.CombatInfo_Enabled and Settings.CastBarEnable ) end,
            },
            {
                -- Display Timer
                type = "checkbox",
                name = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_CASTBAR_TIMER)),
                tooltip = GetString(SI_LUIE_LAM_CI_CASTBAR_TIMER_TP),
                getFunc = function() return Settings.CastBarTimer end,
                setFunc = function(value) Settings.CastBarTimer = value end,
                width = "full",
                default = Defaults.CastBarTimer,
                disabled = function() return not ( LUIE.SV.CombatInfo_Enabled and Settings.CastBarEnable ) end,
            },
            {
                -- Cast Bar Font Face
                type = "dropdown",
                scrollable = true,
                name = zo_strformat("\t\t\t\t\t\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_CASTBAR_FONTFACE)),
                tooltip = GetString(SI_LUIE_LAM_CI_CASTBAR_FONTFACE_TP),
                choices = FontsList,
                sort = "name-up",
                getFunc = function() return Settings.CastBarFontFace end,
                setFunc = function(var) Settings.CastBarFontFace = var CombatInfo.ApplyFont() CombatInfo.UpdateCastBar() end,
                width = "full",
                default = Defaults.CastBarFontFace,
                disabled = function() return not ( LUIE.SV.SpellCastBuff_Enable and Settings.CastBarEnable and (Settings.CastBarTimer or Settings.CastBarLabel) ) end,
            },
            {
                -- Cast Bar Font Size
                type = "slider",
                name = zo_strformat("\t\t\t\t\t\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_CASTBAR_FONTSIZE)),
                tooltip = GetString(SI_LUIE_LAM_CI_CASTBAR_FONTSIZE_TP),
                min = 10, max = 30, step = 1,
                getFunc = function() return Settings.CastBarFontSize end,
                setFunc = function(value) Settings.CastBarFontSize = value CombatInfo.ApplyFont() CombatInfo.UpdateCastBar() end,
                width = "full",
                default = Defaults.CastBarFontSize,
                disabled = function() return not ( LUIE.SV.SpellCastBuff_Enable and Settings.CastBarEnable and (Settings.CastBarTimer or Settings.CastBarLabel) ) end,
            },
            {
                -- Cast Bar Font Style
                type = "dropdown",
                name = zo_strformat("\t\t\t\t\t\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_CASTBAR_FONTSTYLE)),
                tooltip = GetString(SI_LUIE_LAM_CI_CASTBAR_FONTSTYLE_TP),
                choices = { "normal", "outline", "shadow", "soft-shadow-thick", "soft-shadow-thin", "thick-outline" },
                sort = "name-up",
                getFunc = function() return Settings.CastBarFontStyle end,
                setFunc = function(var) Settings.CastBarFontStyle = var CombatInfo.ApplyFont() CombatInfo.UpdateCastBar() end,
                width = "full",
                default = Defaults.CastBarFontStyle,
                disabled = function() return not ( LUIE.SV.SpellCastBuff_Enable and Settings.CastBarEnable and (Settings.CastBarTimer or Settings.CastBarLabel) ) end,
            },
            {
                -- Cast Bar Texture
                type = "dropdown",
                scrollable = true,
                name = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_CASTBAR_TEXTURE)),
                tooltip = GetString(SI_LUIE_LAM_CI_CASTBAR_TEXTURE_TP),
                choices = StatusbarTexturesList,
                sort = "name-up",
                getFunc = function() return Settings.CastBarTexture end,
                setFunc = function(value) Settings.CastBarTexture = value CombatInfo.UpdateCastBar() end,
                width = "full",
                default = Defaults.CastBarTexture,
                disabled = function() return not ( LUIE.SV.CombatInfo_Enabled and Settings.CastBarEnable ) end,
            },
            {
                -- Cast Bar Gradient Color 1
                type    = "colorpicker",
                name    = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_CASTBAR_GRADIENTC1)),
                tooltip = GetString(SI_LUIE_LAM_CI_CASTBAR_GRADIENTC1_TP),
                getFunc = function() return unpack(Settings.CastBarGradientC1) end,
                setFunc = function(r, g, b, a) Settings.CastBarGradientC1 = { r, g, b, a } CombatInfo.UpdateCastBar() end,
                width = "half",
                default = {r=Settings.CastBarGradientC1[1], g=Settings.CastBarGradientC1[2], b=Settings.CastBarGradientC1[3]},
                disabled = function() return not ( LUIE.SV.CombatInfo_Enabled and Settings.CastBarEnable ) end,
            },
            {
                -- Cast Bar Gradient Color 2
                type    = "colorpicker",
                name    = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_CASTBAR_GRADIENTC2)),
                tooltip = GetString(SI_LUIE_LAM_CI_CASTBAR_GRADIENTC2_TP),
                getFunc = function() return unpack(Settings.CastBarGradientC2) end,
                setFunc = function(r, g, b, a) Settings.CastBarGradientC2 = { r, g, b, a } CombatInfo.UpdateCastBar() end,
                width = "half",
                default = {r=Settings.CastBarGradientC2[1], g=Settings.CastBarGradientC2[2], b=Settings.CastBarGradientC2[3]},
                disabled = function() return not ( LUIE.SV.CombatInfo_Enabled and Settings.CastBarEnable ) end,
            },
        },
    }

    -- Active Combat Alerts
    optionsDataCombatInfo[#optionsDataCombatInfo + 1] = {
        type = "submenu",
        name = GetString(SI_LUIE_LAM_CI_HEADER_ACTIVE_COMBAT_ALERT),
        controls = {
            {
                type = "description",
                text = GetString(SI_LUIE_LAM_CI_ALERT_DESCRIPTION),
            },
            {
                -- Unlock Alert Frame
                type = "checkbox",
                name = GetString(SI_LUIE_LAM_CI_ALERT_UNLOCK),
                tooltip = GetString(SI_LUIE_LAM_CI_ALERT_UNLOCK_TP),
                getFunc = function() return alertFrameMovingEnabled end,
                setFunc = AbilityAlerts.SetMovingStateAlert,
                width = "half",
                default = false,
                resetFunc = CombatInfo.ResetAlertFramePosition,
                disabled = function() return not ( LUIE.SV.CombatInfo_Enabled ) end,
            },
            {
                -- Reset Alert Frame
                type = "button",
                name = GetString(SI_LUIE_LAM_RESETPOSITION),
                tooltip = GetString(SI_LUIE_LAM_CI_ALERT_RESET_TP),
                func = AbilityAlerts.ResetAlertFramePosition,
                width = "half",
                disabled = function() return not ( LUIE.SV.CombatInfo_Enabled ) end,
            },
            {
                -- Show Alerts
                type    = "checkbox",
                name    = GetString(SI_LUIE_LAM_CI_ALERT_TOGGLE),
                tooltip = GetString(SI_LUIE_LAM_CI_ALERT_TOGGLE_TP),
                getFunc = function() return Settings.alerts.toggles.alertEnable end,
                setFunc = function(v) Settings.alerts.toggles.alertEnable = v end,
                default = Defaults.alerts.toggles.alertEnable,
            },
            {
                -- Alert Font Face
                type = "dropdown",
                scrollable = true,
                name = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_FONT)),
                tooltip = GetString(SI_LUIE_LAM_CI_ALERT_FONTFACE_TP),
                choices = FontsList,
                sort = "name-up",
                getFunc = function() return Settings.alerts.toggles.alertFontFace end,
                setFunc = function(var) Settings.alerts.toggles.alertFontFace = var AbilityAlerts.ApplyFontAlert() AbilityAlerts.ResetAlertSize() end,
                width = "full",
                default = Defaults.alerts.toggles.alertFontFace,
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
            },
            {
                    -- Alert Font Size
                type = "slider",
                name = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_FONT_SIZE)),
                tooltip = GetString(SI_LUIE_LAM_CI_ALERT_FONTSIZE_TP),
                min = 16, max = 64, step = 1,
                getFunc = function() return Settings.alerts.toggles.alertFontSize end,
                setFunc = function(value) Settings.alerts.toggles.alertFontSize = value AbilityAlerts.ApplyFontAlert() AbilityAlerts.ResetAlertSize() end,
                width = "full",
                default = Defaults.alerts.toggles.alertFontSize,
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
            },
            {
                -- Alert Font Style
                type = "dropdown",
                name = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_FONT_STYLE)),
                tooltip = GetString(SI_LUIE_LAM_CI_ALERT_FONTSTYLE_TP),
                choices = { "normal", "outline", "shadow", "soft-shadow-thick", "soft-shadow-thin", "thick-outline" },
                sort = "name-up",
                getFunc = function() return Settings.alerts.toggles.alertFontStyle end,
                setFunc = function(var) Settings.alerts.toggles.alertFontStyle = var AbilityAlerts.ApplyFontAlert() AbilityAlerts.ResetAlertSize() end,
                width = "full",
                default = Defaults.alerts.toggles.alertFontStyle,
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
            },
            {
                -- Alert Timer
                type    = "checkbox",
                name    = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_ALERT_TIMER_TOGGLE)),
                tooltip = GetString(SI_LUIE_LAM_CI_ALERT_TIMER_TOGGLE_TP),
                getFunc = function() return Settings.alerts.toggles.alertTimer end,
                setFunc = function(v) Settings.alerts.toggles.alertTimer = v end,
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
                default = Defaults.alerts.toggles.alertTimer,
            },
            {
                -- Shared Timer Color
                type    = "colorpicker",
                name    = zo_strformat("\t\t\t\t\t\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_ALERT_TIMER_COLOR)),
                tooltip = GetString(SI_LUIE_LAM_CI_ALERT_TIMER_COLOR_TP),
                getFunc = function() return unpack(Settings.alerts.colors.alertTimer) end,
                setFunc = function(r, g, b, a) Settings.alerts.colors.alertTimer = { r, g, b, a } AbilityAlerts.SetAlertColors() end,
                disabled = function() return not (Settings.alerts.toggles.alertEnable and Settings.alerts.toggles.alertTimer) end,
                default = {r=Defaults.alerts.colors.alertTimer[1], g=Defaults.alerts.colors.alertTimer[2], b=Defaults.alerts.colors.alertTimer[3]}
            },
            {
                -- Shared Label Color
                type    = "colorpicker",
                name    = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_ALERT_COLOR_BASE)),
                tooltip = GetString(SI_LUIE_LAM_CI_ALERT_COLOR_BASE_TP),
                getFunc = function() return unpack(Settings.alerts.colors.alertShared) end,
                setFunc = function(r, g, b, a) Settings.alerts.colors.alertShared = { r, g, b, a } AbilityAlerts.SetAlertColors() end,
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
                default = {r=Defaults.alerts.colors.alertShared[1], g=Defaults.alerts.colors.alertShared[2], b=Defaults.alerts.colors.alertShared[3]}
            },

            {
                type = "header",
                name = GetString(SI_LUIE_LAM_CI_ALERT_HEADER_SHARED),
                width = "full",
            },
            {
                -- Mitigation Rank 3
                type    = "checkbox",
                name    = GetString(SI_LUIE_LAM_CI_ALERT_RANK3),
                tooltip = GetString(SI_LUIE_LAM_CI_ALERT_RANK3_TP),
                getFunc = function() return Settings.alerts.toggles.mitigationRank3 end,
                setFunc = function(v) Settings.alerts.toggles.mitigationRank3 = v end,
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
                default = Defaults.alerts.toggles.mitigationRank3,
            },
            {
                -- Mitigation Rank 2
                type    = "checkbox",
                name    = GetString(SI_LUIE_LAM_CI_ALERT_RANK2),
                tooltip = GetString(SI_LUIE_LAM_CI_ALERT_RANK2_TP),
                getFunc = function() return Settings.alerts.toggles.mitigationRank2 end,
                setFunc = function(v) Settings.alerts.toggles.mitigationRank2 = v end,
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
                default = Defaults.alerts.toggles.mitigationRank2,
            },
            {
                -- Mitigation Rank 1
                type    = "checkbox",
                name    = GetString(SI_LUIE_LAM_CI_ALERT_RANK1),
                tooltip = GetString(SI_LUIE_LAM_CI_ALERT_RANK1_TP),
                getFunc = function() return Settings.alerts.toggles.mitigationRank1 end,
                setFunc = function(v) Settings.alerts.toggles.mitigationRank1 = v end,
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
                default = Defaults.alerts.toggles.mitigationRank1,
            },
            {
                -- Mitigation Aura
                type    = "checkbox",
                name    = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_ALERT_AURA)),
                tooltip = GetString(SI_LUIE_LAM_CI_ALERT_AURA_TP),
                getFunc = function() return Settings.alerts.toggles.mitigationAura end,
                setFunc = function(v) Settings.alerts.toggles.mitigationAura = v end,
                disabled = function() return not (Settings.alerts.toggles.alertEnable) or not (Settings.alerts.toggles.mitigationRank1 or Settings.alerts.toggles.mitigationRank2 or Settings.alerts.toggles.mitigationRank3) end,
                default = Defaults.alerts.toggles.mitigationAura,
            },
            {
                -- Mitigation Dungeon
                type    = "checkbox",
                name    = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_ALERT_DUNGEON)),
                tooltip = GetString(SI_LUIE_LAM_CI_ALERT_DUNGEON_TP),
                getFunc = function() return Settings.alerts.toggles.mitigationDungeon end,
                setFunc = function(v) Settings.alerts.toggles.mitigationDungeon = v end,
                disabled = function() return not (Settings.alerts.toggles.alertEnable) or not (Settings.alerts.toggles.mitigationRank1 or Settings.alerts.toggles.mitigationRank2 or Settings.alerts.toggles.mitigationRank3) end,
                default = Defaults.alerts.toggles.mitigationDungeon,
            },
            {
                type = "header",
                name = GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_HEADER),
                width = "full",
            },
            {
                type = "description",
                text = GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_DESCRIPTION),
            },
            {
                -- MITIGATION ENABLE
                type    = "checkbox",
                name    = GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_ENABLE),
                tooltip = GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_ENABLE_TP),
                getFunc = function() return Settings.alerts.toggles.showAlertMitigate end,
                setFunc = function(v) Settings.alerts.toggles.showAlertMitigate = v end,
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
                default = Defaults.alerts.toggles.showAlertMitigate,
            },
            {
                -- Incoming Ability Filters
                type = "dropdown",
                name = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_FILTER)),
                tooltip = GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_FILTER_TP),
                choices = globalAlertOptions,
                getFunc = function() return globalAlertOptions[Settings.alerts.toggles.alertOptions] end,
                setFunc = function(value) Settings.alerts.toggles.alertOptions = globalAlertOptionsKeys[value] end,
                width = "full",
                disabled = function() return not ( Settings.alerts.toggles.showAlertMitigate and Settings.alerts.toggles.alertEnable) end,
                default = Defaults.alerts.toggles.alertOptions,
            },
            {
                -- Show Mitigation Suffix
                type    = "checkbox",
                name    = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_SUFFIX)),
                tooltip = GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_SUFFIX_TP),
                getFunc = function() return Settings.alerts.toggles.showMitigation end,
                setFunc = function(v) Settings.alerts.toggles.showMitigation = v end,
                disabled = function() return not ( Settings.alerts.toggles.showAlertMitigate and Settings.alerts.toggles.alertEnable) end,
                default = Defaults.alerts.toggles.showMitigation,
            },
            {
                -- Mitigation Prefix (No Name)
                type    = "editbox",
                name    = zo_strformat("\t\t\t\t\t<<1>> <<2>>", GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_FORMAT), GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_NO_NAME)),
                tooltip = zo_strformat("<<1>> <<2>>", GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_FORMAT_TP), GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_NO_NAME_TP)),
                getFunc = function() return Settings.alerts.toggles.mitigationPrefix end,
                setFunc = function(v) Settings.alerts.toggles.mitigationPrefix = v end,
                disabled = function() return not ( Settings.alerts.toggles.showAlertMitigate and Settings.alerts.toggles.alertEnable) end,
                default = Defaults.alerts.toggles.mitigationPrefix,
            },
            {
                -- Mitigation Prefix (Name)
                type    = "editbox",
                name    = zo_strformat("\t\t\t\t\t<<1>> <<2>>", GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_FORMAT), GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_NAME)),
                tooltip = zo_strformat("<<1>> <<2>>", GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_FORMAT_TP), GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_NAME_TP)),
                getFunc = function() return Settings.alerts.toggles.mitigationPrefixN end,
                setFunc = function(v) Settings.alerts.toggles.mitigationPrefixN = v end,
                disabled = function() return not ( Settings.alerts.toggles.showAlertMitigate and Settings.alerts.toggles.alertEnable) end,
                default = Defaults.alerts.toggles.mitigationPrefixN,
            },
            {
                -- Show Crowd Control Border
                type    = "checkbox",
                name    = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_BORDER)),
                tooltip = GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_BORDER_TP),
                getFunc = function() return Settings.alerts.toggles.showCrowdControlBorder end,
                setFunc = function(v) Settings.alerts.toggles.showCrowdControlBorder = v end,
                disabled = function() return not ( Settings.alerts.toggles.showAlertMitigate and Settings.alerts.toggles.alertEnable) end,
                default = Defaults.alerts.toggles.showCrowdControlBorder,
            },

            {
                type = "header",
                name = GetString(SI_LUIE_LAM_CT_SHARED_ALERT_BLOCK),
                width = "full",
            },
            {
                -- Block Format
                type    = "editbox",
                width   = "half",
                name    = zo_strformat("<<1>> (<<2>>)", GetString(SI_LUIE_LAM_CT_SHARED_FORMAT), GetString(SI_LUIE_LAM_CT_SHARED_ALERT_BLOCK)),
                tooltip = GetString(SI_LUIE_LAM_CT_FORMAT_NOTIFICATION_BLOCK_TP),
                getFunc = function() return Settings.alerts.formats.alertBlock end,
                setFunc = function(v) Settings.alerts.formats.alertBlock = v end,
                isMultiline = false,
                default = Defaults.alerts.formats.alertBlock,
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
            },
            {
                -- Block Stagger Format
                type    = "editbox",
                width   = "half",
                name    = zo_strformat("<<1>> (<<2>>)", GetString(SI_LUIE_LAM_CT_SHARED_FORMAT), GetString(SI_LUIE_LAM_CT_SHARED_ALERT_BLOCK_S)),
                tooltip = GetString(SI_LUIE_LAM_CT_FORMAT_NOTIFICATION_BLOCK_S_TP),
                getFunc = function() return Settings.alerts.formats.alertBlockStagger end,
                setFunc = function(v) Settings.alerts.formats.alertBlockStagger = v end,
                isMultiline = false,
                default = Defaults.alerts.formats.alertBlockStagger,
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
            },
            {
                -- Block Color
                type    = "colorpicker",
                name    = GetString(SI_LUIE_LAM_CT_SHARED_COLOR),
                tooltip = GetString(SI_LUIE_LAM_CT_COLOR_NOTIFICATION_BLOCK_TP),
                getFunc = function() return unpack(Settings.alerts.colors.alertBlockA) end,
                setFunc = function(r, g, b, a) Settings.alerts.colors.alertBlockA = { r, g, b, a } AbilityAlerts.SetAlertColors() end,
                default = {r=Defaults.alerts.colors.alertBlockA[1], g=Defaults.alerts.colors.alertBlockA[2], b=Defaults.alerts.colors.alertBlockA[3]},
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
            },
            {
                type = "header",
                name = GetString(SI_LUIE_LAM_CT_SHARED_ALERT_DODGE),
                width = "full",
            },
            {
                -- Dodge  Format
                type    = "editbox",
                name    = GetString(SI_LUIE_LAM_CT_SHARED_FORMAT),
                tooltip = GetString(SI_LUIE_LAM_CT_FORMAT_NOTIFICATION_DODGE_TP),
                getFunc = function() return Settings.alerts.formats.alertDodge end,
                setFunc = function(v) Settings.alerts.formats.alertDodge = v end,
                isMultiline = false,
                default = Defaults.alerts.formats.alertDodge,
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
            },
            {
                -- Dodge Color
                type    = "colorpicker",
                name    = GetString(SI_LUIE_LAM_CT_SHARED_COLOR),
                tooltip = GetString(SI_LUIE_LAM_CT_COLOR_NOTIFICATION_DODGE_TP),
                getFunc = function() return unpack(Settings.alerts.colors.alertDodgeA) end,
                setFunc = function(r, g, b, a) Settings.alerts.colors.alertDodgeA = { r, g, b, a } AbilityAlerts.SetAlertColors() end,
                default = {r=Defaults.alerts.colors.alertDodgeA[1], g=Defaults.alerts.colors.alertDodgeA[2], b=Defaults.alerts.colors.alertDodgeA[3]},
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
            },
            {
                type = "header",
                name = GetString(SI_LUIE_LAM_CT_SHARED_ALERT_AVOID),
                width = "full",
            },
            {
                -- Avoid Format
                type    = "editbox",
                name    = GetString(SI_LUIE_LAM_CT_SHARED_FORMAT),
                tooltip = GetString(SI_LUIE_LAM_CT_FORMAT_NOTIFICATION_AVOID_TP),
                getFunc = function() return Settings.alerts.formats.alertAvoid end,
                setFunc = function(v) Settings.alerts.formats.alertAvoid = v end,
                isMultiline = false,
                default = Defaults.alerts.formats.alertAvoid,
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
            },
            {
                -- Avoid Color
                type    = "colorpicker",
                name    = GetString(SI_LUIE_LAM_CT_SHARED_COLOR),
                tooltip = GetString(SI_LUIE_LAM_CT_COLOR_NOTIFICATION_AVOID_TP),
                getFunc = function() return unpack(Settings.alerts.colors.alertAvoidB) end,
                setFunc = function(r, g, b, a) Settings.alerts.colors.alertAvoidB = { r, g, b, a } AbilityAlerts.SetAlertColors() end,
                default = {r=Defaults.alerts.colors.alertAvoidB[1], g=Defaults.alerts.colors.alertAvoidB[2], b=Defaults.alerts.colors.alertAvoidB[3]},
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
            },
            {
                type = "header",
                name = GetString(SI_LUIE_LAM_CT_SHARED_ALERT_INTERRUPT),
                width = "full",
            },
            {
                -- Interrupt Format
                type    = "editbox",
                name    = GetString(SI_LUIE_LAM_CT_SHARED_FORMAT),
                tooltip = GetString(SI_LUIE_LAM_CT_FORMAT_NOTIFICATION_INTERRUPT_TP),
                getFunc = function() return Settings.alerts.formats.alertInterrupt end,
                setFunc = function(v) Settings.alerts.formats.alertInterrupt = v end,
                isMultiline = false,
                default = Defaults.alerts.formats.alertInterrupt,
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
            },
            {
                -- Interrupt Color
                type    = "colorpicker",
                name    = GetString(SI_LUIE_LAM_CT_SHARED_COLOR),
                tooltip = GetString(SI_LUIE_LAM_CT_COLOR_NOTIFICATION_INTERRUPT_TP),
                getFunc = function() return unpack(Settings.alerts.colors.alertInterruptB) end,
                setFunc = function(r, g, b, a) Settings.alerts.colors.alertInterruptB = { r, g, b, a } AbilityAlerts.SetAlertColors() end,
                default = {r=Defaults.alerts.colors.alertInterruptB[1], g=Defaults.alerts.colors.alertInterruptB[2], b=Defaults.alerts.colors.alertInterruptB[3]},
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
            },
            {
                type = "header",
                name = GetString(SI_LUIE_LAM_CT_SHARED_ALERT_UNMIT),
                width = "full",
            },
            {
                -- Unmit Enable
                type    = "checkbox",
                name    = zo_strformat("<<1>> <<2>>", GetString(SI_LUIE_LAM_CT_SHARED_DISPLAY), GetString(SI_LUIE_LAM_CT_SHARED_ALERT_UNMIT)),
                tooltip = GetString(SI_LUIE_LAM_CT_NOTIFICATION_ALERT_UNMIT_TP),
                getFunc = function() return Settings.alerts.toggles.showAlertUnmit end,
                setFunc = function(v) Settings.alerts.toggles.showAlertUnmit = v end,
                default = Defaults.alerts.toggles.showAlertUnmit,
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
            },
            {
                -- Unmit Format
                type    = "editbox",
                name    = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CT_SHARED_FORMAT)),
                tooltip = GetString(SI_LUIE_LAM_CT_FORMAT_NOTIFICATION_UNMIT_TP),
                getFunc = function() return Settings.alerts.formats.alertUnmit end,
                setFunc = function(v) Settings.alerts.formats.alertUnmit = v end,
                isMultiline = false,
                default = Defaults.alerts.formats.alertUnmit,
                disabled = function() return not (Settings.alerts.toggles.alertEnable and Settings.alerts.toggles.showAlertUnmit) end,
            },
            {
                -- Unmit Color
                type    = "colorpicker",
                name    = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CT_SHARED_COLOR)),
                tooltip = GetString(SI_LUIE_LAM_CT_COLOR_NOTIFICATION_UNMIT_TP),
                getFunc = function() return unpack(Settings.alerts.colors.alertUnmit) end,
                setFunc = function(r, g, b, a) Settings.alerts.colors.alertUnmit = { r, g, b, a } AbilityAlerts.SetAlertColors() end,
                default = {r=Defaults.alerts.colors.alertUnmit[1], g=Defaults.alerts.colors.alertUnmit[2], b=Defaults.alerts.colors.alertUnmit[3]},
                disabled = function() return not (Settings.alerts.toggles.alertEnable and Settings.alerts.toggles.showAlertUnmit) end,
            },
            {
                type = "header",
                name = GetString(SI_LUIE_LAM_CT_SHARED_ALERT_POWER),
                width = "full",
            },
            {
                -- Power Enable
                type    = "checkbox",
                name    = zo_strformat("<<1>> <<2>>", GetString(SI_LUIE_LAM_CT_SHARED_DISPLAY), GetString(SI_LUIE_LAM_CT_SHARED_ALERT_POWER)),
                tooltip = GetString(SI_LUIE_LAM_CT_NOTIFICATION_ALERT_POWER_TP),
                getFunc = function() return Settings.alerts.toggles.showAlertPower end,
                setFunc = function(v) Settings.alerts.toggles.showAlertPower = v end,
                default = Defaults.alerts.toggles.showAlertPower,
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
            },
            {
                -- Power Format
                type    = "editbox",
                name    = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CT_SHARED_FORMAT)),
                tooltip = GetString(SI_LUIE_LAM_CT_FORMAT_NOTIFICATION_POWER_TP),
                getFunc = function() return Settings.alerts.formats.alertPower end,
                setFunc = function(v) Settings.alerts.formats.alertPower = v end,
                isMultiline = false,
                default = Defaults.alerts.formats.alertPower,
                disabled = function() return not (Settings.alerts.toggles.alertEnable and Settings.alerts.toggles.showAlertPower) end,
            },
            {
                -- Prefix Power (No Name)
                type    = "editbox",
                name    = zo_strformat("\t\t\t\t\t<<1>> <<2>>", GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_FORMAT_P), GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_NO_NAME)),
                tooltip = zo_strformat("<<1>> <<2>>", GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_FORMAT_P_TP), GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_NO_NAME_TP)),
                getFunc = function() return Settings.alerts.toggles.mitigationPowerPrefix2 end,
                setFunc = function(v) Settings.alerts.toggles.mitigationPowerPrefix2 = v end,
                disabled = function() return not (Settings.alerts.toggles.alertEnable and Settings.alerts.toggles.showAlertPower) end,
                default = Defaults.alerts.toggles.mitigationPowerPrefix2,
            },
            {
                -- Prefix Power (Name)
                type    = "editbox",
                name    = zo_strformat("\t\t\t\t\t<<1>> <<2>>", GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_FORMAT_P), GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_NAME)),
                tooltip = zo_strformat("<<1>> <<2>>", GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_FORMAT_P_TP), GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_NAME_TP)),
                getFunc = function() return Settings.alerts.toggles.mitigationPowerPrefixN2 end,
                setFunc = function(v) Settings.alerts.toggles.mitigationPowerPrefixN2 = v end,
                disabled = function() return not (Settings.alerts.toggles.alertEnable and Settings.alerts.toggles.showAlertPower) end,
                default = Defaults.alerts.toggles.mitigationPowerPrefixN2,
            },
            {
                -- Power Color
                type    = "colorpicker",
                name    = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CT_SHARED_COLOR)),
                tooltip = GetString(SI_LUIE_LAM_CT_COLOR_NOTIFICATION_POWER_TP),
                getFunc = function() return unpack(Settings.alerts.colors.alertPower) end,
                setFunc = function(r, g, b, a) Settings.alerts.colors.alertPower = { r, g, b, a } AbilityAlerts.SetAlertColors() end,
                default = {r=Defaults.alerts.colors.alertPower[1], g=Defaults.alerts.colors.alertPower[2], b=Defaults.alerts.colors.alertPower[3]},
                disabled = function() return not (Settings.alerts.toggles.alertEnable and Settings.alerts.toggles.showAlertPower) end,
            },
            {
                type = "header",
                name = GetString(SI_LUIE_LAM_CT_SHARED_ALERT_DESTROY),
                width = "full",
            },
            {
                -- Destroy Enable
                type    = "checkbox",
                name    = zo_strformat("<<1>> <<2>>", GetString(SI_LUIE_LAM_CT_SHARED_DISPLAY), GetString(SI_LUIE_LAM_CT_SHARED_ALERT_DESTROY)),
                tooltip = GetString(SI_LUIE_LAM_CT_NOTIFICATION_ALERT_DESTROY_TP),
                getFunc = function() return Settings.alerts.toggles.showAlertDestroy end,
                setFunc = function(v) Settings.alerts.toggles.showAlertDestroy = v end,
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
                default = Defaults.alerts.toggles.showAlertDestroy,
            },
            {
                -- Destroy Format
                type    = "editbox",
                name    = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CT_SHARED_FORMAT)),
                tooltip = GetString(SI_LUIE_LAM_CT_FORMAT_NOTIFICATION_DESTROY_TP),
                getFunc = function() return Settings.alerts.formats.alertDestroy end,
                setFunc = function(v) Settings.alerts.formats.alertDestroy = v end,
                isMultiline = false,
                default = Defaults.alerts.formats.alertDestroy,
                disabled = function() return not (Settings.alerts.toggles.alertEnable and Settings.alerts.toggles.showAlertDestroy) end,
            },
            {
                -- Prefix Destroy (No Name)
                type    = "editbox",
                name    = zo_strformat("\t\t\t\t\t<<1>> <<2>>", GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_FORMAT_D), GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_NO_NAME)),
                tooltip = zo_strformat("<<1>> <<2>>", GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_FORMAT_D_TP), GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_NO_NAME_TP)),
                getFunc = function() return Settings.alerts.toggles.mitigationDestroyPrefix2 end,
                setFunc = function(v) Settings.alerts.toggles.mitigationDestroyPrefix2 = v end,
                disabled = function() return not (Settings.alerts.toggles.alertEnable and Settings.alerts.toggles.showAlertDestroy) end,
                default = Defaults.alerts.toggles.mitigationDestroyPrefix2,
            },
            {
                -- Prefix Destroy (Name)
                type    = "editbox",
                name    = zo_strformat("\t\t\t\t\t<<1>> <<2>>", GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_FORMAT_D), GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_NAME)),
                tooltip = zo_strformat("<<1>> <<2>>", GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_FORMAT_D_TP), GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_NAME_TP)),
                getFunc = function() return Settings.alerts.toggles.mitigationDestroyPrefixN2 end,
                setFunc = function(v) Settings.alerts.toggles.mitigationDestroyPrefixN2 = v end,
                disabled = function() return not (Settings.alerts.toggles.alertEnable and Settings.alerts.toggles.showAlertDestroy) end,
                default = Defaults.alerts.toggles.mitigationDestroyPrefixN2,
            },
            {
                -- Destroy Color
                type    = "colorpicker",
                name    = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CT_SHARED_COLOR)),
                tooltip = GetString(SI_LUIE_LAM_CT_COLOR_NOTIFICATION_DESTROY_TP),
                getFunc = function() return unpack(Settings.alerts.colors.alertDestroy) end,
                setFunc = function(r, g, b, a) Settings.alerts.colors.alertDestroy = { r, g, b, a } AbilityAlerts.SetAlertColors() end,
                default = {r=Defaults.alerts.colors.alertDestroy[1], g=Defaults.alerts.colors.alertDestroy[2], b=Defaults.alerts.colors.alertDestroy[3]},
                disabled = function() return not (Settings.alerts.toggles.alertEnable and Settings.alerts.toggles.showAlertDestroy) end,
            },
            {
                type = "header",
                name = GetString(SI_LUIE_LAM_CT_SHARED_ALERT_SUMMON),
                width = "full",
            },
            {
                -- Summon Enable
                type    = "checkbox",
                name    = zo_strformat("\t\t\t\t\t<<1>> <<2>>", GetString(SI_LUIE_LAM_CT_SHARED_DISPLAY), GetString(SI_LUIE_LAM_CT_SHARED_ALERT_SUMMON)),
                tooltip = GetString(SI_LUIE_LAM_CT_NOTIFICATION_ALERT_SUMMON_TP),
                getFunc = function() return Settings.alerts.toggles.showAlertSummon end,
                setFunc = function(v) Settings.alerts.toggles.showAlertSummon = v end,
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
                default = Defaults.alerts.toggles.showAlertSummon,
            },
            {
                -- Summon Format
                type    = "editbox",
                name    = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CT_SHARED_FORMAT)),
                tooltip = GetString(SI_LUIE_LAM_CT_FORMAT_NOTIFICATION_SUMMON_TP),
                getFunc = function() return Settings.alerts.formats.alertSummon end,
                setFunc = function(v) Settings.alerts.formats.alertSummon = v end,
                isMultiline = false,
                default = Defaults.alerts.formats.alertSummon,
                disabled = function() return not (Settings.alerts.toggles.alertEnable and Settings.alerts.toggles.showAlertSummon) end,
            },
            {
                -- Prefix Summon (No Name)
                type    = "editbox",
                name    = zo_strformat("\t\t\t\t\t<<1>> <<2>>", GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_FORMAT_S), GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_NO_NAME)),
                tooltip = zo_strformat("<<1>> <<2>>", GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_FORMAT_S_TP), GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_NO_NAME_TP)),
                getFunc = function() return Settings.alerts.toggles.mitigationSummonPrefix2 end,
                setFunc = function(v) Settings.alerts.toggles.mitigationSummonPrefix2 = v end,
                disabled = function() return not (Settings.alerts.toggles.alertEnable and Settings.alerts.toggles.showAlertSummon) end,
                default = Defaults.alerts.toggles.mitigationSummonPrefix2,
            },
            {
                -- Prefix Summon (Name)
                type    = "editbox",
                name    = zo_strformat("\t\t\t\t\t<<1>> <<2>>", GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_FORMAT_S), GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_NAME)),
                tooltip = zo_strformat("<<1>> <<2>>", GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_FORMAT_S_TP), GetString(SI_LUIE_LAM_CI_ALERT_MITIGATION_NAME_TP)),
                getFunc = function() return Settings.alerts.toggles.mitigationSummonPrefixN2 end,
                setFunc = function(v) Settings.alerts.toggles.mitigationSummonPrefixN2 = v end,
                disabled = function() return not (Settings.alerts.toggles.alertEnable and Settings.alerts.toggles.showAlertSummon) end,
                default = Defaults.alerts.toggles.mitigationSummonPrefixN2,
                disabled = function() return not (Settings.alerts.toggles.alertEnable and Settings.alerts.toggles.showAlertSummon) end,
            },
            {
                -- Summon Color
                type    = "colorpicker",
                name    = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CT_SHARED_COLOR)),
                tooltip = GetString(SI_LUIE_LAM_CT_COLOR_NOTIFICATION_SUMMON_TP),
                getFunc = function() return unpack(Settings.alerts.colors.alertSummon) end,
                setFunc = function(r, g, b, a) Settings.alerts.colors.alertSummon = { r, g, b, a } AbilityAlerts.SetAlertColors() end,
                default = {r=Defaults.alerts.colors.alertSummon[1], g=Defaults.alerts.colors.alertSummon[2], b=Defaults.alerts.colors.alertSummon[3]},
                disabled = function() return not (Settings.alerts.toggles.alertEnable and Settings.alerts.toggles.showAlertSummon) end,
            },

            {
                type = "header",
                name = GetString(SI_LUIE_LAM_CI_ALERT_HEADER_CC_COLOR),
                width = "full",
            },
            {
                -- Stun
                type    = "colorpicker",
                name    = GetString(SI_LUIE_LAM_CI_ALERT_CC_COLOR_STUN),
                tooltip = GetString(SI_LUIE_LAM_CI_ALERT_CC_COLOR_STUN_TP),
                getFunc = function() return unpack(Settings.alerts.colors.stunColor) end,
                setFunc = function(r, g, b, a) Settings.alerts.colors.stunColor = { r, g, b, a } AbilityAlerts.SetAlertColors() end,
                default = {r=Defaults.alerts.colors.stunColor[1], g=Defaults.alerts.colors.stunColor[2], b=Defaults.alerts.colors.stunColor[3]},
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
            },
            {
                -- Disorient
                type    = "colorpicker",
                name    = GetString(SI_LUIE_LAM_CI_ALERT_CC_COLOR_DISORIENT),
                tooltip = GetString(SI_LUIE_LAM_CI_ALERT_CC_COLOR_DISORIENT_TP),
                getFunc = function() return unpack(Settings.alerts.colors.disorientColor) end,
                setFunc = function(r, g, b, a) Settings.alerts.colors.disorientColor = { r, g, b, a } AbilityAlerts.SetAlertColors() end,
                default = {r=Defaults.alerts.colors.disorientColor[1], g=Defaults.alerts.colors.disorientColor[2], b=Defaults.alerts.colors.disorientColor[3]},
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
            },
            {
                -- Fear
                type    = "colorpicker",
                name    = GetString(SI_LUIE_LAM_CI_ALERT_CC_COLOR_FEAR),
                tooltip = GetString(SI_LUIE_LAM_CI_ALERT_CC_COLOR_FEAR_TP),
                getFunc = function() return unpack(Settings.alerts.colors.fearColor) end,
                setFunc = function(r, g, b, a) Settings.alerts.colors.fearColor = { r, g, b, a } AbilityAlerts.SetAlertColors() end,
                default = {r=Defaults.alerts.colors.fearColor[1], g=Defaults.alerts.colors.fearColor[2], b=Defaults.alerts.colors.fearColor[3]},
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
            },
            {
                -- Silence
                type    = "colorpicker",
                name    = GetString(SI_LUIE_LAM_CI_ALERT_CC_COLOR_SILENCE),
                tooltip = GetString(SI_LUIE_LAM_CI_ALERT_CC_COLOR_SILENCE_TP),
                getFunc = function() return unpack(Settings.alerts.colors.silenceColor) end,
                setFunc = function(r, g, b, a) Settings.alerts.colors.silenceColor = { r, g, b, a } AbilityAlerts.SetAlertColors() end,
                default = {r=Defaults.alerts.colors.silenceColor[1], g=Defaults.alerts.colors.silenceColor[2], b=Defaults.alerts.colors.silenceColor[3]},
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
            },
            {
                -- Stagger
                type    = "colorpicker",
                name    = GetString(SI_LUIE_LAM_CI_ALERT_CC_COLOR_STAGGER),
                tooltip = GetString(SI_LUIE_LAM_CI_ALERT_CC_COLOR_STAGGER_TP),
                getFunc = function() return unpack(Settings.alerts.colors.staggerColor) end,
                setFunc = function(r, g, b, a) Settings.alerts.colors.sstaggerColor = { r, g, b, a } AbilityAlerts.SetAlertColors() end,
                default = {r=Defaults.alerts.colors.staggerColor[1], g=Defaults.alerts.colors.staggerColor[2], b=Defaults.alerts.colors.staggerColor[3]},
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
            },
            {
                -- Unbreakable
                type    = "colorpicker",
                name    = GetString(SI_LUIE_LAM_CI_ALERT_CC_COLOR_UNBREAKABLE),
                tooltip = GetString(SI_LUIE_LAM_CI_ALERT_CC_COLOR_UNBREAKABLE_TP),
                getFunc = function() return unpack(Settings.alerts.colors.unbreakableColor) end,
                setFunc = function(r, g, b, a) Settings.alerts.colors.unbreakableColor = { r, g, b, a } AbilityAlerts.SetAlertColors() end,
                default = {r=Defaults.alerts.colors.unbreakableColor[1], g=Defaults.alerts.colors.unbreakableColor[2], b=Defaults.alerts.colors.unbreakableColor[3]},
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
            },
            {
                -- Snare
                type    = "colorpicker",
                name    = GetString(SI_LUIE_LAM_CI_ALERT_CC_COLOR_SNARE),
                tooltip = GetString(SI_LUIE_LAM_CI_ALERT_CC_COLOR_SNARE_TP),
                getFunc = function() return unpack(Settings.alerts.colors.snareColor) end,
                setFunc = function(r, g, b, a) Settings.alerts.snareColor = { r, g, b, a } AbilityAlerts.SetAlertColors() end,
                default = {r=Defaults.alerts.colors.snareColor[1], g=Defaults.alerts.colors.snareColor[2], b=Defaults.alerts.colors.snareColor[3]},
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
            },

            {
                type = "header",
                name = GetString(SI_LUIE_LAM_CI_ALERT_SOUND_HEADER),
                width = "full",
            },

            {
                -- Play Sound Priority 3
                type    = "checkbox",
                name    = zo_strformat(GetString(SI_LUIE_LAM_CI_ALERT_SOUND_ENABLE), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_PRIORITY_3), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_NO_CC)),
                tooltip = zo_strformat(GetString(SI_LUIE_LAM_CI_ALERT_SOUND_ENABLE_TP), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_PRIORITY_3), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_NO_CC)),
                getFunc = function() return Settings.alerts.toggles.soundEnable3 end,
                setFunc = function(v) Settings.alerts.toggles.soundEnable3 = v end,
                width = "half",
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
                default = Defaults.alerts.toggles.soundEnable3,
            },

            {
                -- Sound Priority 3
                type = "dropdown",
                scrollable = true,
                choices = SoundsList,
                sort = "name-up",
                getFunc = function() return Settings.alerts.sounds.sound3 end,
                setFunc = function(value) Settings.alerts.sounds.sound3 = value AbilityAlerts.PreviewAlertSound(value) end,
                width = "half",
                default = Defaults.alerts.sounds.sound3,
                disabled = function() return not (Settings.alerts.toggles.soundEnable3 and Settings.alerts.toggles.alertEnable) end,
            },

            {
                -- Play Sound Priority 3 CC
                type    = "checkbox",
                name    = zo_strformat(GetString(SI_LUIE_LAM_CI_ALERT_SOUND_ENABLE), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_PRIORITY_3), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_HARD_CC)),
                tooltip = zo_strformat(GetString(SI_LUIE_LAM_CI_ALERT_SOUND_ENABLE_TP), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_PRIORITY_3), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_HARD_CC)),
                getFunc = function() return Settings.alerts.toggles.soundEnable3CC end,
                setFunc = function(v) Settings.alerts.toggles.soundEnable3CC = v end,
                width = "half",
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
                default = Defaults.alerts.toggles.soundEnable3CC,
            },

            {
                -- Sound Priority 3 CC
                type = "dropdown",
                scrollable = true,
                choices = SoundsList,
                sort = "name-up",
                getFunc = function() return Settings.alerts.sounds.sound3CC end,
                setFunc = function(value) Settings.alerts.sounds.sound3CC = value AbilityAlerts.PreviewAlertSound(value) end,
                width = "half",
                default = Defaults.alerts.sounds.sound3CC,
                disabled = function() return not (Settings.alerts.toggles.soundEnable3CC and Settings.alerts.toggles.alertEnable) end,
            },

            {
                -- Play Sound Priority 3 UB
                type    = "checkbox",
                name    = zo_strformat(GetString(SI_LUIE_LAM_CI_ALERT_SOUND_ENABLE), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_PRIORITY_3), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_UNBREAKABLE_CC)),
                tooltip = zo_strformat(GetString(SI_LUIE_LAM_CI_ALERT_SOUND_ENABLE_TP), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_PRIORITY_3), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_UNBREAKABLE_CC)),
                getFunc = function() return Settings.alerts.toggles.soundEnable3UB end,
                setFunc = function(v) Settings.alerts.toggles.soundEnable3UB = v end,
                width = "half",
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
                default = Defaults.alerts.toggles.soundEnable3UB,
            },

            {
                -- Sound Priority 3 UB
                type = "dropdown",
                scrollable = true,
                choices = SoundsList,
                sort = "name-up",
                getFunc = function() return Settings.alerts.sounds.sound3UB end,
                setFunc = function(value) Settings.alerts.sounds.sound3UB = value AbilityAlerts.PreviewAlertSound(value) end,
                width = "half",
                default = Defaults.alerts.sounds.sound3UB,
                disabled = function() return not (Settings.alerts.toggles.soundEnable3UB and Settings.alerts.toggles.alertEnable) end,
            },

            {
                -- Play Sound Priority 2
                type    = "checkbox",
                name    = zo_strformat(GetString(SI_LUIE_LAM_CI_ALERT_SOUND_ENABLE), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_PRIORITY_2), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_NO_CC)),
                tooltip = zo_strformat(GetString(SI_LUIE_LAM_CI_ALERT_SOUND_ENABLE_TP), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_PRIORITY_2), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_NO_CC)),
                getFunc = function() return Settings.alerts.toggles.soundEnable2 end,
                setFunc = function(v) Settings.alerts.toggles.soundEnable2 = v end,
                width = "half",
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
                default = Defaults.alerts.toggles.soundEnable2,
            },

            {
                -- Sound Priority 2
                type = "dropdown",
                scrollable = true,
                choices = SoundsList,
                sort = "name-up",
                getFunc = function() return Settings.alerts.sounds.sound2 end,
                setFunc = function(value) Settings.alerts.sounds.sound2 = value AbilityAlerts.PreviewAlertSound(value) end,
                width = "half",
                default = Defaults.alerts.sounds.sound2,
                disabled = function() return not (Settings.alerts.toggles.soundEnable2 and Settings.alerts.toggles.alertEnable) end,
            },

            {
                -- Play Sound Priority 2 CC
                type    = "checkbox",
                name    = zo_strformat(GetString(SI_LUIE_LAM_CI_ALERT_SOUND_ENABLE), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_PRIORITY_2), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_HARD_CC)),
                tooltip = zo_strformat(GetString(SI_LUIE_LAM_CI_ALERT_SOUND_ENABLE_TP), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_PRIORITY_2), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_HARD_CC)),
                getFunc = function() return Settings.alerts.toggles.soundEnable2CC end,
                setFunc = function(v) Settings.alerts.toggles.soundEnable2CC = v end,
                width = "half",
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
                default = Defaults.alerts.toggles.soundEnable2CC,
            },

            {
                -- Sound Priority 2 CC
                type = "dropdown",
                scrollable = true,
                choices = SoundsList,
                sort = "name-up",
                getFunc = function() return Settings.alerts.sounds.sound2CC end,
                setFunc = function(value) Settings.alerts.sounds.sound2CC = value AbilityAlerts.PreviewAlertSound(value) end,
                width = "half",
                default = Defaults.alerts.sounds.sound2CC,
                disabled = function() return not (Settings.alerts.toggles.soundEnable2CC and Settings.alerts.toggles.alertEnable) end,
            },

            {
                -- Play Sound Priority 2 UB
                type    = "checkbox",
                name    = zo_strformat(GetString(SI_LUIE_LAM_CI_ALERT_SOUND_ENABLE), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_PRIORITY_2), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_UNBREAKABLE_CC)),
                tooltip = zo_strformat(GetString(SI_LUIE_LAM_CI_ALERT_SOUND_ENABLE_TP), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_PRIORITY_2), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_UNBREAKABLE_CC)),
                getFunc = function() return Settings.alerts.toggles.soundEnable2UB end,
                setFunc = function(v) Settings.alerts.toggles.soundEnable2UB = v end,
                width = "half",
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
                default = Defaults.alerts.toggles.soundEnable2UB,
            },

            {
                -- Sound Priority 2 UB
                type = "dropdown",
                scrollable = true,
                choices = SoundsList,
                sort = "name-up",
                getFunc = function() return Settings.alerts.sounds.sound2UB end,
                setFunc = function(value) Settings.alerts.sounds.sound2UB = value AbilityAlerts.PreviewAlertSound(value) end,
                width = "half",
                default = Defaults.alerts.sounds.sound2UB,
                disabled = function() return not (Settings.alerts.toggles.soundEnable2UB and Settings.alerts.toggles.alertEnable) end,
            },

            {
                -- Play Sound Priority 1
                type    = "checkbox",
                name    = zo_strformat(GetString(SI_LUIE_LAM_CI_ALERT_SOUND_ENABLE), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_PRIORITY_1), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_NO_CC)),
                tooltip = zo_strformat(GetString(SI_LUIE_LAM_CI_ALERT_SOUND_ENABLE_TP), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_PRIORITY_1), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_NO_CC)),
                getFunc = function() return Settings.alerts.toggles.soundEnable1 end,
                setFunc = function(v) Settings.alerts.toggles.soundEnable1 = v end,
                width = "half",
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
                default = Defaults.alerts.toggles.soundEnable1,
            },

            {
                -- Sound Priority 1
                type = "dropdown",
                scrollable = true,
                choices = SoundsList,
                sort = "name-up",
                getFunc = function() return Settings.alerts.sounds.sound1 end,
                setFunc = function(value) Settings.alerts.sounds.sound1 = value AbilityAlerts.PreviewAlertSound(value) end,
                width = "half",
                default = Defaults.alerts.sounds.sound1,
                disabled = function() return not (Settings.alerts.toggles.soundEnable1 and Settings.alerts.toggles.alertEnable) end,
            },

            {
                -- Play Sound Priority 1 CC
                type    = "checkbox",
                name    = zo_strformat(GetString(SI_LUIE_LAM_CI_ALERT_SOUND_ENABLE), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_PRIORITY_1), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_HARD_CC)),
                tooltip = zo_strformat(GetString(SI_LUIE_LAM_CI_ALERT_SOUND_ENABLE_TP), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_PRIORITY_1), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_HARD_CC)),
                getFunc = function() return Settings.alerts.toggles.soundEnable1CC end,
                setFunc = function(v) Settings.alerts.toggles.soundEnable1CC = v end,
                width = "half",
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
                default = Defaults.alerts.toggles.soundEnable1CC,
            },

            {
                -- Sound Priority 1 CC
                type = "dropdown",
                scrollable = true,
                choices = SoundsList,
                sort = "name-up",
                getFunc = function() return Settings.alerts.sounds.sound1CC end,
                setFunc = function(value) Settings.alerts.sounds.sound1CC = value AbilityAlerts.PreviewAlertSound(value) end,
                width = "half",
                default = Defaults.alerts.sounds.sound1CC,
                disabled = function() return not (Settings.alerts.toggles.soundEnable1CC and Settings.alerts.toggles.alertEnable) end,
            },

            {
                -- Play Sound Priority 1 UB
                type    = "checkbox",
                name    = zo_strformat(GetString(SI_LUIE_LAM_CI_ALERT_SOUND_ENABLE), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_PRIORITY_1), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_UNBREAKABLE_CC)),
                tooltip = zo_strformat(GetString(SI_LUIE_LAM_CI_ALERT_SOUND_ENABLE_TP), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_PRIORITY_1), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_UNBREAKABLE_CC)),
                getFunc = function() return Settings.alerts.toggles.soundEnable1UB end,
                setFunc = function(v) Settings.alerts.toggles.soundEnable1UB = v end,
                width = "half",
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
                default = Defaults.alerts.toggles.soundEnable1UB,
            },

            {
                -- Sound Priority 1 UB
                type = "dropdown",
                scrollable = true,
                choices = SoundsList,
                sort = "name-up",
                getFunc = function() return Settings.alerts.sounds.sound1UB end,
                setFunc = function(value) Settings.alerts.sounds.sound1UB = value AbilityAlerts.PreviewAlertSound(value) end,
                width = "half",
                default = Defaults.alerts.sounds.sound1UB,
                disabled = function() return not (Settings.alerts.toggles.soundEnable1UB and Settings.alerts.toggles.alertEnable) end,
            },

            {
                -- Play Sound Unmit
                type    = "checkbox",
                name    = zo_strformat(GetString(SI_LUIE_LAM_CI_ALERT_SOUND_ENABLE_MISC), GetString(SI_LUIE_LAM_CT_SHARED_ALERT_UNMIT)),
                tooltip = zo_strformat(GetString(SI_LUIE_LAM_CI_ALERT_SOUND_ENABLE_MISC_TP), GetString(SI_LUIE_LAM_CT_SHARED_ALERT_UNMIT)),
                getFunc = function() return Settings.alerts.toggles.soundEnableUnmit end,
                setFunc = function(v) Settings.alerts.toggles.soundEnableUnmit = v end,
                width = "half",
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
                default = Defaults.alerts.toggles.soundEnableUnmit,
            },

            {
                -- Sound Unmit
                type = "dropdown",
                scrollable = true,
                choices = SoundsList,
                sort = "name-up",
                getFunc = function() return Settings.alerts.sounds.soundUnmit end,
                setFunc = function(value) Settings.alerts.sounds.soundUnmit = value AbilityAlerts.PreviewAlertSound(value) end,
                width = "half",
                default = Defaults.alerts.sounds.soundUnmit,
                disabled = function() return not (Settings.alerts.toggles.soundEnableUnmit and Settings.alerts.toggles.alertEnable) end,
            },

            {
                -- Play Sound Power
                type    = "checkbox",
                name    = zo_strformat(GetString(SI_LUIE_LAM_CI_ALERT_SOUND_ENABLE_MISC), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_POWER)),
                tooltip = zo_strformat(GetString(SI_LUIE_LAM_CI_ALERT_SOUND_ENABLE_MISC_TP), GetString(SI_LUIE_LAM_CT_SHARED_ALERT_POWER)),
                getFunc = function() return Settings.alerts.toggles.soundEnablePower end,
                setFunc = function(v) Settings.alerts.toggles.soundEnablePower = v end,
                width = "half",
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
                default = Defaults.alerts.toggles.soundEnablePower,
            },

            {
                -- Sound Power
                type = "dropdown",
                scrollable = true,
                choices = SoundsList,
                sort = "name-up",
                getFunc = function() return Settings.alerts.sounds.soundPower end,
                setFunc = function(value) Settings.alerts.sounds.soundPower = value AbilityAlerts.PreviewAlertSound(value) end,
                width = "half",
                default = Defaults.alerts.sounds.soundPower,
                disabled = function() return not (Settings.alerts.toggles.soundEnablePower and Settings.alerts.toggles.alertEnable) end,
            },

            {
                -- Play Sound Summon
                type    = "checkbox",
                name    = zo_strformat(GetString(SI_LUIE_LAM_CI_ALERT_SOUND_ENABLE_MISC), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_SUMMON)),
                tooltip = zo_strformat(GetString(SI_LUIE_LAM_CI_ALERT_SOUND_ENABLE_MISC_TP), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_SUMMON)),
                getFunc = function() return Settings.alerts.toggles.soundEnableSummon end,
                setFunc = function(v) Settings.alerts.toggles.soundEnableSummon = v end,
                width = "half",
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
                default = Defaults.alerts.toggles.soundEnableSummon,
            },

            {
                -- Sound Summon
                type = "dropdown",
                scrollable = true,
                choices = SoundsList,
                sort = "name-up",
                getFunc = function() return Settings.alerts.sounds.soundSummon end,
                setFunc = function(value) Settings.alerts.sounds.soundSummon = value AbilityAlerts.PreviewAlertSound(value) end,
                width = "half",
                default = Defaults.alerts.sounds.soundSummon,
                disabled = function() return not (Settings.alerts.toggles.soundEnableSummon and Settings.alerts.toggles.alertEnable) end,
            },

            {
                -- Play Sound Destroy
                type    = "checkbox",
                name    = zo_strformat(GetString(SI_LUIE_LAM_CI_ALERT_SOUND_ENABLE_MISC), GetString(SI_LUIE_LAM_CI_ALERT_SOUND_DESTROY)),
                tooltip = zo_strformat(GetString(SI_LUIE_LAM_CI_ALERT_SOUND_ENABLE_MISC_TP), GetString(SI_LUIE_LAM_CT_SHARED_ALERT_DESTROY)),
                getFunc = function() return Settings.alerts.toggles.soundEnableDestroy end,
                setFunc = function(v) Settings.alerts.toggles.soundEnableDestroy = v end,
                width = "half",
                disabled = function() return not Settings.alerts.toggles.alertEnable end,
                default = Defaults.alerts.toggles.soundEnableDestroy,
            },

            {
                -- Sound Destroy
                type = "dropdown",
                scrollable = true,
                choices = SoundsList,
                sort = "name-up",
                getFunc = function() return Settings.alerts.sounds.soundDestroy end,
                setFunc = function(value) Settings.alerts.sounds.soundDestroy = value AbilityAlerts.PreviewAlertSound(value) end,
                width = "half",
                default = Defaults.alerts.sounds.soundDestroy,
                disabled = function() return not (Settings.alerts.toggles.soundEnableDestroy and Settings.alerts.toggles.alertEnable) end,
            },
        },
    }

    -- Crowd Control Tracker
    optionsDataCombatInfo[#optionsDataCombatInfo + 1] = {
        type = "submenu",
        name = GetString(SI_LUIE_LAM_CI_CCT_HEADER),
        controls = {

            -- CCT Description
            {
                type = "description",
                text = GetString(SI_LUIE_LAM_CI_CCT_DESCRIPTION)
            },

            {
                -- Unlock CCT
                type = "checkbox",
                name = GetString(SI_LUIE_LAM_CI_CCT_UNLOCK),
                tooltip = GetString(SI_LUIE_LAM_CI_CCT_UNLOCK_TP),
                default = Defaults.cct.unlock,
                width = "half",
                getFunc = function() return Settings.cct.unlock end,
                setFunc = function(newValue) Settings.cct.unlock = newValue if newValue then CrowdControlTracker:SetupDisplay("draw") end CrowdControlTracker:InitControls() end,
            },
            {
                -- Reset CCT
                type = "button",
                name = GetString(SI_LUIE_LAM_RESETPOSITION),
                tooltip = GetString(SI_LUIE_LAM_CI_CCT_RESET_TP),
                func = CrowdControlTracker.ResetPosition,
                width = "half",
            },
            {
                -- Enable Crowd Control Tracker
                type = "checkbox",
                name = GetString(SI_LUIE_LAM_CI_CCT_TOGGLE),
                tooltip = GetString(SI_LUIE_LAM_CI_CCT_TOGGLE_TP),
                default = Defaults.cct.enabled,
                getFunc = function() return Settings.cct.enabled end,
                setFunc = function(newValue) Settings.cct.enabled = newValue CrowdControlTracker:OnOff() end,
            },
            {
                -- Enable only in PVP
                type = "checkbox",
                name = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_CCT_PVP_ONLY)),
                tooltip = GetString(SI_LUIE_LAM_CI_CCT_PVP_ONLY_TP),
                default = Defaults.cct.enabledOnlyInCyro,
                disabled = function() return not Settings.cct.enabled end,
                getFunc = function() return Settings.cct.enabledOnlyInCyro end,
                setFunc = function(newValue) Settings.cct.enabledOnlyInCyro = newValue CrowdControlTracker:OnOff() end,
            },
            {
                -- Display Options Header
                type = "header",
                name = GetString(SI_LUIE_LAM_CI_CCT_DISPLAY_HEADER),
            },
            {
                -- Display Method
                -- TODO: Change theses to displayOptions + better punctuation
                type = "dropdown",
                name = GetString(SI_LUIE_LAM_CI_CCT_DISPLAY_STYLE),
                tooltip = GetString(SI_LUIE_LAM_CI_CCT_DISPLAY_STYLE_TP),
                choices = {"Both icon and text", "Icon only", "Text only"},
                getFunc = function()
                    if Settings.cct.showOptions=="all" then
                        return "Both icon and text"
                    elseif Settings.cct.showOptions=="icon" then
                        return "Icon only"
                    elseif Settings.cct.showOptions=="text" then
                        return "Text only"
                    end
                end,
                setFunc = function(newValue)
                    if newValue=="Both icon and text" then
                        Settings.cct.showOptions="all"
                    elseif newValue=="Icon only" then
                        Settings.cct.showOptions="icon"
                    elseif newValue=="Text only" then
                        Settings.cct.showOptions="text"
                    end
                        CrowdControlTracker:InitControls()
                end,
                    default = "Both icon and text",
                    disabled = function() return not Settings.cct.enabled end,
            },
            {
                -- Ability Name or CC Type
                type = "checkbox",
                name = GetString(SI_LUIE_LAM_CI_CCT_DISPLAY_NAME),
                tooltip = GetString(SI_LUIE_LAM_CI_CCT_DISPLAY_NAME_TP),
                default = Defaults.cct.useAbilityName,
                disabled = function() return (not Settings.cct.enabled) or (Settings.cct.showOptions=="icon") end,
                getFunc = function() return Settings.cct.useAbilityName end,
                setFunc = function(newValue) Settings.cct.useAbilityName = newValue CrowdControlTracker:InitControls() end,
            },
            {
                -- Icon and Text Scale
                type = "slider",
                name = GetString(SI_LUIE_LAM_CI_CCT_SCALE),
                tooltip = GetString(SI_LUIE_LAM_CI_CCT_SCALE_TP),
                default = tonumber(string.format("%.0f", 100*Defaults.cct.controlScale)),
                disabled = function() return not Settings.cct.enabled end,
                min     = 20,
                max     = 200,
                step    = 1,
                getFunc = function() return tonumber(string.format("%.0f", 100*Settings.cct.controlScale)) end,
                setFunc = function(newValue) Settings.cct.controlScale = newValue/100 CrowdControlTracker:InitControls() end,
            },
            {
                type = "header",
                name = GetString(SI_LUIE_LAM_CI_CCT_MISC_OPTIONS_HEADER),
            },
            {
                -- Play Sound when CC'ed
                type = "checkbox",
                name = GetString(SI_LUIE_LAM_CI_CCT_SOUND),
                tooltip = GetString(SI_LUIE_LAM_CI_CCT_SOUND_TP),
                default = Defaults.cct.playSound,
                width = "half",
                getFunc = function() return Settings.cct.playSound end,
                setFunc = function(newValue) Settings.cct.playSound = newValue
                    CrowdControlTracker:InitControls()
                end,
                disabled = function() return not Settings.cct.enabled end,
            },

            {
                -- Sound CC
                type = "dropdown",
                scrollable = true,
                choices = SoundsList,
                sort = "name-up",
                getFunc = function() return Settings.cct.playSoundOption end,
                setFunc = function(value) Settings.cct.playSoundOption = value AbilityAlerts.PreviewAlertSound(value) end,
                width = "half",
                default = Settings.cct.playSoundOption,
                disabled = function() return not (Settings.cct.playSound and Settings.cct.enabled) end,
            },
            {
                -- Show Stagger (Text Only)
                type = "checkbox",
                name = GetString(SI_LUIE_LAM_CI_CCT_STAGGER),
                tooltip = GetString(SI_LUIE_LAM_CI_CCT_STAGGER_TP),
                default = Defaults.cct.showStaggered,
                disabled = function() return not Settings.cct.enabled end,
                getFunc = function() return Settings.cct.showStaggered end,
                setFunc = function(newValue) Settings.cct.showStaggered = newValue
                    CrowdControlTracker:InitControls()
                end,
            },
            {
                -- Show Global Cooldown
                type = "checkbox",
                name = GetString(SI_LUIE_LAM_CI_CCT_GCD_TOGGLE),
                tooltip = GetString(SI_LUIE_LAM_CI_CCT_GCD_TOGGLE_TP),
                default = Defaults.cct.showGCD,
                disabled = function() return (not Settings.cct.enabled) end,
                getFunc = function() return Settings.cct.showGCD end,
                setFunc = function(newValue) Settings.cct.showGCD = newValue
                    CrowdControlTracker:InitControls()
                end,
            },
            {
                -- Show when Immune
                type = "checkbox",
                name = GetString(SI_LUIE_LAM_CI_CCT_IMMUNE_TOGGLE),
                tooltip = GetString(SI_LUIE_LAM_CI_CCT_IMMUNE_TOGGLE_TP),
                default = Defaults.cct.showImmune,
                getFunc = function() return Settings.cct.showImmune end,
                setFunc = function(newValue) Settings.cct.showImmune = newValue
                    CrowdControlTracker:InitControls()
                end,
                disabled = function() return (not Settings.cct.enabled) end,
            },
            {
                -- Show when Immune only in Cyrodiil
                type = "checkbox",
                name = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_CCT_IMMUNE_CYRODIIL)),
                tooltip = GetString(SI_LUIE_LAM_CI_CCT_IMMUNE_CYRODIIL_TP),
                default = Defaults.cct.showImmuneOnlyInCyro,
                getFunc = function() return Settings.cct.showImmuneOnlyInCyro end,
                setFunc = function(newValue) Settings.cct.showImmuneOnlyInCyro = newValue
                    CrowdControlTracker:InitControls()
                end,
                disabled = function() return not (Settings.cct.showImmune and Settings.cct.enabled) end,
            },
            {
                -- Set Immune Display Time (MS)
                type = "slider",
                name = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CI_CCT_IMMUNE_TIME)),
                tooltip = GetString(SI_LUIE_LAM_CI_CCT_IMMUNE_TIME_TP),
                default = Defaults.cct.immuneDisplayTime,
                min     = 100,
                max     = 1500,
                step    = 1,
                getFunc = function() return Settings.cct.immuneDisplayTime end,
                setFunc = function(newValue) Settings.cct.immuneDisplayTime = newValue CrowdControlTracker:InitControls() end,
                disabled = function() return not (Settings.cct.showImmune and Settings.cct.enabled) end,
            },
            {
                -- Crowd Control Color Options
                type = "header",
                name = GetString(SI_LUIE_LAM_CI_ALERT_HEADER_CC_COLOR),
            },
            {
                -- Stun
                type = "colorpicker",
                name = GetString(SI_LUIE_LAM_CI_ALERT_CC_COLOR_STUN),
                tooltip = zo_strformat(GetString(SI_LUIE_LAM_CI_CCT_COLOR_TP), GetString(SI_LUIE_LAM_CI_ALERT_CC_COLOR_STUN)),
                default = ZO_ColorDef:New(unpack(Defaults.cct.colors[ACTION_RESULT_STUNNED])),
                disabled = function() return not Settings.cct.enabled end,
                getFunc = function() return unpack(Settings.cct.colors[ACTION_RESULT_STUNNED]) end,
                setFunc = function(r,g,b,a)
                    Settings.cct.colors[ACTION_RESULT_STUNNED] = {r,g,b,a}
                    CrowdControlTracker:InitControls()
                end,
            },
            {
                -- Disorient
                type = "colorpicker",
                name = GetString(SI_LUIE_LAM_CI_ALERT_CC_COLOR_DISORIENT),
                tooltip = zo_strformat(GetString(SI_LUIE_LAM_CI_CCT_COLOR_TP), GetString(SI_LUIE_LAM_CI_ALERT_CC_COLOR_DISORIENT)),
                default = ZO_ColorDef:New(unpack(Defaults.cct.colors[ACTION_RESULT_DISORIENTED])),
                disabled = function() return not Settings.cct.enabled end,
                getFunc = function() return unpack(Settings.cct.colors[ACTION_RESULT_DISORIENTED]) end,
                setFunc = function(r,g,b,a)
                    Settings.cct.colors[ACTION_RESULT_DISORIENTED] = {r,g,b,a}
                    CrowdControlTracker:InitControls()
                end,
            },
            {
                -- Silence
                type = "colorpicker",
                name = GetString(SI_LUIE_LAM_CI_ALERT_CC_COLOR_SILENCE),
                tooltip = zo_strformat(GetString(SI_LUIE_LAM_CI_CCT_COLOR_TP), GetString(SI_LUIE_LAM_CI_ALERT_CC_COLOR_SILENCE)),
                default = ZO_ColorDef:New(unpack(Defaults.cct.colors[ACTION_RESULT_SILENCED])),
                disabled = function() return not Settings.cct.enabled end,
                getFunc = function() return unpack(Settings.cct.colors[ACTION_RESULT_SILENCED]) end,
                setFunc = function(r,g,b,a)
                    Settings.cct.colors[ACTION_RESULT_SILENCED] = {r,g,b,a}
                    CrowdControlTracker:InitControls()
                end,
            },
            {
                -- Fear
                type = "colorpicker",
                name = GetString(SI_LUIE_LAM_CI_ALERT_CC_COLOR_FEAR),
                tooltip = zo_strformat(GetString(SI_LUIE_LAM_CI_CCT_COLOR_TP), GetString(SI_LUIE_LAM_CI_ALERT_CC_COLOR_FEAR)),
                default = ZO_ColorDef:New(unpack(Defaults.cct.colors[ACTION_RESULT_FEARED])),
                disabled = function() return not Settings.cct.enabled end,
                getFunc = function() return unpack(Settings.cct.colors[ACTION_RESULT_FEARED]) end,
                setFunc = function(r,g,b,a)
                    Settings.cct.colors[ACTION_RESULT_FEARED] = {r,g,b,a}
                    CrowdControlTracker:InitControls()
                end,
            },
            {
                -- Stagger
                type = "colorpicker",
                name = GetString(SI_LUIE_LAM_CI_ALERT_CC_COLOR_STAGGER),
                tooltip = zo_strformat(GetString(SI_LUIE_LAM_CI_CCT_COLOR_TP), GetString(SI_LUIE_LAM_CI_ALERT_CC_COLOR_STAGGER)),
                default = ZO_ColorDef:New(unpack(Defaults.cct.colors[ACTION_RESULT_STAGGERED])),
                disabled = function() return not Settings.cct.enabled end,
                getFunc = function() return unpack(Settings.cct.colors[ACTION_RESULT_STAGGERED]) end,
                setFunc = function(r,g,b,a)
                    Settings.cct.colors[ACTION_RESULT_STAGGERED] = {r,g,b,a}
                    CrowdControlTracker:InitControls()
                end,
            },
            {
                -- Unbreakable
                type = "colorpicker",
                name = GetString(SI_LUIE_LAM_CI_ALERT_CC_COLOR_UNBREAKABLE),
                tooltip = zo_strformat(GetString(SI_LUIE_LAM_CI_CCT_COLOR_TP), GetString(SI_LUIE_LAM_CI_ALERT_CC_COLOR_UNBREAKABLE)),
                default = ZO_ColorDef:New(unpack(Defaults.cct.colors.unbreakable)),
                disabled = function() return not Settings.cct.enabled end,
                getFunc = function() return unpack(Settings.cct.colors.unbreakable) end,
                setFunc = function(r,g,b,a)
                    Settings.cct.colors.unbreakable = {r,g,b,a}
                    CrowdControlTracker:InitControls()
                end,
            },
            {
                -- Immune
                type = "colorpicker",
                name = GetString(SI_LUIE_LAM_CI_CCT_IMMUNE),
                tooltip = zo_strformat(GetString(SI_LUIE_LAM_CI_CCT_COLOR_TP), GetString(SI_LUIE_LAM_CI_CCT_IMMUNE)),
                default = ZO_ColorDef:New(unpack(Defaults.cct.colors[ACTION_RESULT_IMMUNE])),
                disabled = function() return not Settings.cct.enabled end,
                getFunc = function() return unpack(Settings.cct.colors[ACTION_RESULT_IMMUNE]) end,
                setFunc = function(r,g,b,a)
                    Settings.cct.colors[ACTION_RESULT_IMMUNE] = {r,g,b,a}
                    Settings.cct.colors[ACTION_RESULT_DODGED] = {r,g,b,a}
                    Settings.cct.colors[ACTION_RESULT_BLOCKED] = {r,g,b,a}
                    Settings.cct.colors[ACTION_RESULT_BLOCKED_DAMAGE] = {r,g,b,a}
                    CrowdControlTracker:InitControls()
                end,
            },
            {
                type = "header",
                name = GetString(SI_LUIE_LAM_CI_CCT_AOE_HEADER),
            },
            {
                -- AOE SHOW
                type = "checkbox",
                name = GetString(SI_LUIE_LAM_CI_CCT_AOE_TOGGLE),
                tooltip = GetString(SI_LUIE_LAM_CI_CCT_AOE_TOGGLE_TP),
                default = Defaults.cct.showAoe,
                getFunc = function() return Settings.cct.showAoe end,
                setFunc = function(newValue) Settings.cct.showAoe = newValue
                    CrowdControlTracker:InitControls()
                end,
                disabled = function() return (not Settings.cct.enabled) end,
            },
            {
                -- AOE Color
                type = "colorpicker",
                name = zo_strformat("\t\t\t\t\t<<1>>", GetString(SI_LUIE_LAM_CT_CCT_AOE_COLOR)),
                tooltip = GetString(SI_LUIE_LAM_CT_CCT_AOE_COLOR_TP),
                default = ZO_ColorDef:New(unpack(Defaults.cct.colors[ACTION_RESULT_AREA_EFFECT])),
                getFunc = function() return unpack(Settings.cct.colors[ACTION_RESULT_AREA_EFFECT]) end,
                setFunc = function(r,g,b,a)
                    Settings.cct.colors[ACTION_RESULT_AREA_EFFECT] = {r,g,b,a}
                    CrowdControlTracker:InitControls()
                end,
                disabled = function() return not (Settings.cct.showAoe and Settings.cct.enabled) end,
            },

            {
            type = "divider",
            },

            -- AOE DISPLAY OPTIONS
            {
                -- Show AOE - Player Ultimate
                type = "checkbox",
                name = zo_strformat(GetString(SI_LUIE_LAM_CI_CCT_AOE_SHOW), GetString(SI_LUIE_LAM_CI_CCT_AOE_TIER_PLAYER_ULT)),
                tooltip = zo_strformat(GetString(SI_LUIE_LAM_CI_CCT_AOE_SHOW_TP), GetString(SI_LUIE_LAM_CI_CCT_AOE_TIER_PLAYER_ULT)),
                default = Defaults.cct.aoePlayerUltimate,
                getFunc = function() return Settings.cct.aoePlayerUltimate end,
                setFunc = function(newValue) Settings.cct.aoePlayerUltimate = newValue
                    CrowdControlTracker.UpdateAOEList()
                end,
                disabled = function() return not (Settings.cct.showAoe and Settings.cct.enabled) end,
            },
            {
                -- Sound AOE - Player Ultimate
                type = "checkbox",
                name = zo_strformat(GetString(SI_LUIE_LAM_CI_CCT_AOE_SOUND), GetString(SI_LUIE_LAM_CI_CCT_AOE_TIER_PLAYER_ULT)),
                tooltip = zo_strformat(GetString(SI_LUIE_LAM_CI_CCT_AOE_SOUND_TP), GetString(SI_LUIE_LAM_CI_CCT_AOE_TIER_PLAYER_ULT)),
                width = "half",
                default = Defaults.cct.aoePlayerUltimateSoundToggle,
                getFunc = function() return Settings.cct.aoePlayerUltimateSoundToggle end,
                setFunc = function(newValue) Settings.cct.aoePlayerUltimateSoundToggle = newValue
                end,
                disabled = function() return not ( Settings.cct.showAoe and Settings.cct.aoePlayerUltimate and Settings.cct.enabled) end,
            },
            {
                -- SOUND - aoePlayerUltimate
                type = "dropdown",
                scrollable = true,
                choices = SoundsList,
                sort = "name-up",
                getFunc = function() return Settings.cct.aoePlayerUltimateSound end,
                setFunc = function(value) Settings.cct.aoePlayerUltimateSound = value AbilityAlerts.PreviewAlertSound(value) end,
                width = "half",
                default = Settings.cct.aoePlayerUltimateSound,
                disabled = function() return not ( Settings.cct.showAoe and Settings.cct.aoePlayerUltimate and Settings.cct.aoePlayerUltimateSoundToggle and Settings.cct.enabled) end,
            },

            {
            type = "divider",
            },

            {
                -- Show AOE - Player Normal
                type = "checkbox",
                name = zo_strformat(GetString(SI_LUIE_LAM_CI_CCT_AOE_SHOW), GetString(SI_LUIE_LAM_CI_CCT_AOE_TIER_PLAYER_NORM)),
                tooltip = zo_strformat(GetString(SI_LUIE_LAM_CI_CCT_AOE_SHOW_TP), GetString(SI_LUIE_LAM_CI_CCT_AOE_TIER_PLAYER_NORM)),
                default = Defaults.cct.aoePlayerNormal,
                getFunc = function() return Settings.cct.aoePlayerNormal end,
                setFunc = function(newValue) Settings.cct.aoePlayerNormal = newValue
                    CrowdControlTracker.UpdateAOEList()
                end,
                disabled = function() return not (Settings.cct.showAoe and Settings.cct.enabled) end,
            },
            {
                -- Sound AOE - Player Normal
                type = "checkbox",
                name = zo_strformat(GetString(SI_LUIE_LAM_CI_CCT_AOE_SOUND), GetString(SI_LUIE_LAM_CI_CCT_AOE_TIER_PLAYER_NORM)),
                tooltip = zo_strformat(GetString(SI_LUIE_LAM_CI_CCT_AOE_SOUND_TP), GetString(SI_LUIE_LAM_CI_CCT_AOE_TIER_PLAYER_NORM)),
                width = "half",
                default = Defaults.cct.aoePlayerNormalSoundToggle,
                getFunc = function() return Settings.cct.aoePlayerNormalSoundToggle end,
                setFunc = function(newValue) Settings.cct.aoePlayerNormalSoundToggle = newValue
                end,
                disabled = function() return not ( Settings.cct.showAoe and Settings.cct.aoePlayerNormal and Settings.cct.enabled) end,
            },
            {
                -- SOUND - aoePlayerNormal
                type = "dropdown",
                scrollable = true,
                choices = SoundsList,
                sort = "name-up",
                getFunc = function() return Settings.cct.aoePlayerNormalSound end,
                setFunc = function(value) Settings.cct.aoePlayerNormalSound = value AbilityAlerts.PreviewAlertSound(value) end,
                width = "half",
                default = Settings.cct.aoePlayerNormalSound,
                disabled = function() return not ( Settings.cct.showAoe and Settings.cct.aoePlayerNormal and Settings.cct.aoePlayerNormalSoundToggle and Settings.cct.enabled) end,
            },

            {
            type = "divider",
            },

            {
                -- Show AOE - Player Set
                type = "checkbox",
                name = zo_strformat(GetString(SI_LUIE_LAM_CI_CCT_AOE_SHOW), GetString(SI_LUIE_LAM_CI_CCT_AOE_TIER_PLAYER_SET)),
                tooltip = zo_strformat(GetString(SI_LUIE_LAM_CI_CCT_AOE_SHOW_TP), GetString(SI_LUIE_LAM_CI_CCT_AOE_TIER_PLAYER_SET)),
                default = Defaults.cct.aoePlayerSet,
                getFunc = function() return Settings.cct.aoePlayerSet end,
                setFunc = function(newValue) Settings.cct.aoePlayerSet = newValue
                    CrowdControlTracker.UpdateAOEList()
                end,
                disabled = function() return not (Settings.cct.showAoe and Settings.cct.enabled) end,
            },
            {
                -- Sound AOE - Player Set
                type = "checkbox",
                name = zo_strformat(GetString(SI_LUIE_LAM_CI_CCT_AOE_SOUND), GetString(SI_LUIE_LAM_CI_CCT_AOE_TIER_PLAYER_SET)),
                tooltip = zo_strformat(GetString(SI_LUIE_LAM_CI_CCT_AOE_SOUND_TP), GetString(SI_LUIE_LAM_CI_CCT_AOE_TIER_PLAYER_SET)),
                width = "half",
                default = Defaults.cct.aoePlayerSetSoundToggle,
                getFunc = function() return Settings.cct.aoePlayerSetSoundToggle end,
                setFunc = function(newValue) Settings.cct.aoePlayerSetSoundToggle = newValue
                end,
                disabled = function() return not ( Settings.cct.showAoe and Settings.cct.aoePlayerSet and Settings.cct.enabled) end,
            },
            {
                -- SOUND - aoePlayerSet
                type = "dropdown",
                scrollable = true,
                choices = SoundsList,
                sort = "name-up",
                getFunc = function() return Settings.cct.aoePlayerSetSound end,
                setFunc = function(value) Settings.cct.aoePlayerSetSound = value AbilityAlerts.PreviewAlertSound(value) end,
                width = "half",
                default = Settings.cct.aoePlayerSetSound,
                disabled = function() return not ( Settings.cct.showAoe and Settings.cct.aoePlayerSet and Settings.cct.aoePlayerSetSoundToggle and Settings.cct.enabled) end,
            },

            {
            type = "divider",
            },

            {
                -- Show AOE - Trap
                type = "checkbox",
                name = zo_strformat(GetString(SI_LUIE_LAM_CI_CCT_AOE_SHOW), GetString(SI_LUIE_LAM_CI_CCT_AOE_TIER_TRAP)),
                tooltip = zo_strformat(GetString(SI_LUIE_LAM_CI_CCT_AOE_SHOW_TP), GetString(SI_LUIE_LAM_CI_CCT_AOE_TIER_TRAP)),
                default = Defaults.cct.aoeTraps,
                getFunc = function() return Settings.cct.aoeTraps end,
                setFunc = function(newValue) Settings.cct.aoeTraps = newValue
                    CrowdControlTracker.UpdateAOEList()
                end,
                disabled = function() return not (Settings.cct.showAoe and Settings.cct.enabled) end,
            },
            {
                -- Sound AOE - Trap
                type = "checkbox",
                name = zo_strformat(GetString(SI_LUIE_LAM_CI_CCT_AOE_SOUND), GetString(SI_LUIE_LAM_CI_CCT_AOE_TIER_TRAP)),
                tooltip = zo_strformat(GetString(SI_LUIE_LAM_CI_CCT_AOE_SOUND_TP), GetString(SI_LUIE_LAM_CI_CCT_AOE_TIER_TRAP)),
                width = "half",
                default = Defaults.cct.aoeTrapsSoundToggle,
                getFunc = function() return Settings.cct.aoeTrapsSoundToggle end,
                setFunc = function(newValue) Settings.cct.aoeTrapsSoundToggle = newValue
                end,
                disabled = function() return not ( Settings.cct.showAoe and Settings.cct.aoeTraps and Settings.cct.enabled) end,
            },
            {
                -- SOUND - aoeTraps
                type = "dropdown",
                scrollable = true,
                choices = SoundsList,
                sort = "name-up",
                getFunc = function() return Settings.cct.aoeTrapsSound end,
                setFunc = function(value) Settings.cct.aoeTrapsSound = value AbilityAlerts.PreviewAlertSound(value) end,
                width = "half",
                default = Settings.cct.aoeTrapsSound,
                disabled = function() return not ( Settings.cct.showAoe and Settings.cct.aoeTraps and Settings.cct.aoeTrapsSoundToggle and Settings.cct.enabled) end,
            },

            {
            type = "divider",
            },

            {
                -- Show AOE - NPC Boss
                type = "checkbox",
                name = zo_strformat(GetString(SI_LUIE_LAM_CI_CCT_AOE_SHOW), GetString(SI_LUIE_LAM_CI_CCT_AOE_TIER_NPC_BOSS)),
                tooltip = zo_strformat(GetString(SI_LUIE_LAM_CI_CCT_AOE_SHOW_TP), GetString(SI_LUIE_LAM_CI_CCT_AOE_TIER_NPC_BOSS)),
                default = Defaults.cct.aoeNPCBoss,
                getFunc = function() return Settings.cct.aoeNPCBoss end,
                setFunc = function(newValue) Settings.cct.aoeNPCBoss = newValue
                    CrowdControlTracker.UpdateAOEList()
                end,
                disabled = function() return not (Settings.cct.showAoe and Settings.cct.enabled) end,
            },
            {
                -- Sound AOE - NPC Boss
                type = "checkbox",
                name = zo_strformat(GetString(SI_LUIE_LAM_CI_CCT_AOE_SOUND), GetString(SI_LUIE_LAM_CI_CCT_AOE_TIER_NPC_BOSS)),
                tooltip = zo_strformat(GetString(SI_LUIE_LAM_CI_CCT_AOE_SOUND_TP), GetString(SI_LUIE_LAM_CI_CCT_AOE_TIER_NPC_BOSS)),
                width = "half",
                default = Defaults.cct.aoeNPCBossSoundToggle,
                getFunc = function() return Settings.cct.aoeNPCBossSoundToggle end,
                setFunc = function(newValue) Settings.cct.aoeNPCBossSoundToggle = newValue
                end,
                disabled = function() return not ( Settings.cct.showAoe and Settings.cct.aoeNPCBoss and Settings.cct.enabled) end,
            },
            {
                -- SOUND - aoeNPCBoss
                type = "dropdown",
                scrollable = true,
                choices = SoundsList,
                sort = "name-up",
                getFunc = function() return Settings.cct.aoeNPCBossSound end,
                setFunc = function(value) Settings.cct.aoeNPCBossSound = value AbilityAlerts.PreviewAlertSound(value) end,
                width = "half",
                default = Settings.cct.aoeNPCBossSound,
                disabled = function() return not ( Settings.cct.showAoe and Settings.cct.aoeNPCBoss and Settings.cct.aoeNPCBossSoundToggle and Settings.cct.enabled) end,
            },

            {
            type = "divider",
            },

            {
                -- Show AOE - NPC Elite
                type = "checkbox",
                name = zo_strformat(GetString(SI_LUIE_LAM_CI_CCT_AOE_SHOW), GetString(SI_LUIE_LAM_CI_CCT_AOE_TIER_NPC_ELITE)),
                tooltip = zo_strformat(GetString(SI_LUIE_LAM_CI_CCT_AOE_SHOW_TP), GetString(SI_LUIE_LAM_CI_CCT_AOE_TIER_NPC_ELITE)),
                default = Defaults.cct.aoeNPCElite,
                getFunc = function() return Settings.cct.aoeNPCElite end,
                setFunc = function(newValue) Settings.cct.aoeNPCElite = newValue
                    CrowdControlTracker.UpdateAOEList()
                end,
                disabled = function() return not (Settings.cct.showAoe and Settings.cct.enabled) end,
            },
            {
                -- Sound AOE - NPC Elite
                type = "checkbox",
                name = zo_strformat(GetString(SI_LUIE_LAM_CI_CCT_AOE_SOUND), GetString(SI_LUIE_LAM_CI_CCT_AOE_TIER_NPC_ELITE)),
                tooltip = zo_strformat(GetString(SI_LUIE_LAM_CI_CCT_AOE_SOUND_TP), GetString(SI_LUIE_LAM_CI_CCT_AOE_TIER_NPC_ELITE)),
                width = "half",
                default = Defaults.cct.aoeNPCEliteSoundToggle,
                getFunc = function() return Settings.cct.aoeNPCEliteSoundToggle end,
                setFunc = function(newValue) Settings.cct.aoeNPCEliteSoundToggle = newValue
                end,
                disabled = function() return not ( Settings.cct.showAoe and Settings.cct.aoeNPCElite and Settings.cct.enabled) end,
            },
            {
                -- SOUND - aoeNPCElite
                type = "dropdown",
                scrollable = true,
                choices = SoundsList,
                sort = "name-up",
                getFunc = function() return Settings.cct.aoeNPCEliteSound end,
                setFunc = function(value) Settings.cct.aoeNPCEliteSound = value AbilityAlerts.PreviewAlertSound(value) end,
                width = "half",
                default = Settings.cct.aoeNPCEliteSound,
                disabled = function() return not ( Settings.cct.showAoe and Settings.cct.aoeNPCElite and Settings.cct.aoeNPCEliteSoundToggle and Settings.cct.enabled) end,
            },

            {
            type = "divider",
            },

            {
                -- Show AOE - NPC Normal
                type = "checkbox",
                name = zo_strformat(GetString(SI_LUIE_LAM_CI_CCT_AOE_SHOW), GetString(SI_LUIE_LAM_CI_CCT_AOE_TIER_NPC_NORMAL)),
                tooltip = zo_strformat(GetString(SI_LUIE_LAM_CI_CCT_AOE_SHOW_TP), GetString(SI_LUIE_LAM_CI_CCT_AOE_TIER_NPC_NORMAL)),
                default = Defaults.cct.aoeNPCNormal,
                getFunc = function() return Settings.cct.aoeNPCNormal end,
                setFunc = function(newValue) Settings.cct.aoeNPCNormal = newValue
                    CrowdControlTracker.UpdateAOEList()
                end,
                disabled = function() return not (Settings.cct.showAoe and Settings.cct.enabled) end,
            },
            {
                -- Sound AOE - NPC Normal
                type = "checkbox",
                name = zo_strformat(GetString(SI_LUIE_LAM_CI_CCT_AOE_SOUND), GetString(SI_LUIE_LAM_CI_CCT_AOE_TIER_NPC_NORMAL)),
                tooltip = zo_strformat(GetString(SI_LUIE_LAM_CI_CCT_AOE_SOUND_TP), GetString(SI_LUIE_LAM_CI_CCT_AOE_TIER_NPC_NORMAL)),
                width = "half",
                default = Defaults.cct.aoeNPCNormalSoundToggle,
                getFunc = function() return Settings.cct.aoeNPCNormalSoundToggle end,
                setFunc = function(newValue) Settings.cct.aoeNPCNormalSoundToggle = newValue
                end,
                disabled = function() return not ( Settings.cct.showAoe and Settings.cct.aoeNPCNormal and Settings.cct.enabled) end,
            },
            {
                -- SOUND - aoeNPCNormal
                type = "dropdown",
                scrollable = true,
                choices = SoundsList,
                sort = "name-up",
                getFunc = function() return Settings.cct.aoeNPCNormalSound end,
                setFunc = function(value) Settings.cct.aoeNPCNormalSound = value AbilityAlerts.PreviewAlertSound(value) end,
                width = "half",
                default = Settings.cct.aoeNPCNormalSound,
                disabled = function() return not ( Settings.cct.showAoe and Settings.cct.aoeNPCNormal and Settings.cct.aoeNPCNormalSoundToggle and Settings.cct.enabled) end,
            },
        },
    }

    -- Register the settings panel
    if LUIE.SV.CombatInfo_Enabled then
        LAM:RegisterAddonPanel(LUIE.name .. 'CombatInfoOptions', panelDataCombatInfo)
        LAM:RegisterOptionControls(LUIE.name .. 'CombatInfoOptions', optionsDataCombatInfo)
    end
end