--------------------------------------------------------------------------------
--[[ L10nUtils.lua - Localization utilities and wrapper functions. ]]--
--
-- by erglo <erglo.coder+HNLM@gmail.com>
-- forked and supported by if1oke <cloud.hex+HNLM@gmail.com>
--
-- Copyright (C) 2024  Erwin D. Glockner (aka erglo, ergloCoder) & Igor Fedorov (aka if1oke)
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see http://www.gnu.org/licenses.
--
-- World of Warcraft API reference:
-- REF.: <https://www.townlong-yak.com/framexml/live/Helix/GlobalStrings.lua>
-- REF.: <https://www.townlong-yak.com/framexml/live/Blizzard_SharedXMLBase/TableUtil.lua>
-- REF.: <https://www.townlong-yak.com/framexml/live/Blizzard_FrameXMLBase/Constants.lua>
-- REF.: <https://www.townlong-yak.com/framexml/live/Blizzard_SharedXML/SharedConstants.lua>
-- (see also the function comments section for more reference)
--
--------------------------------------------------------------------------------

local AddonID, ns = ...;

-- Upvalues
local string = string;

--------------------------------------------------------------------------------

-- local L = LibStub('AceLocale-3.0'):GetLocale(ADDON_NAME)                     --> TODO - Try this library
-- local L = LibStub("AceLocale-3.0"):GetLocale("HandyNotes", true)

local L = {};
ns.L = L;

L.currentLocale = GetLocale();

-- Temp.
local HIGHLIGHT = function(txt) return HIGHLIGHT_FONT_COLOR:WrapTextInColorCode(txt); end

----- Constants -----

L.SLASHCMD_USAGE = "Usage:"

L.ADVANCED_OPTIONS = ADVANCED_OPTIONS;
L.ADVANCED_OPTIONS_TOOLTIP = ADVANCED_OPTIONS_TOOLTIP;
L.CONGRATULATIONS = SPLASH_BOOST_HEADER;
L.DEFAULT = DEFAULT;
L.DESCRIPTION = DESCRIPTION;
L.EXAMPLE_TEXT = EXAMPLE_TEXT;
L.GENERIC_FRACTION_STRING = GENERIC_FRACTION_STRING;  --> "%d/%d"
L.OPTION_STATUS_DISABLED = VIDEO_OPTIONS_DISABLED;
L.OPTION_STATUS_ENABLED = VIDEO_OPTIONS_ENABLED;
L.OPTION_STATUS_FORMAT = SLASH_TEXTTOSPEECH_HELP_FORMATSTRING;
L.OPTION_STATUS_FORMAT_READY = LFG_READY_CHECK_PLAYER_IS_READY;  -- "%s is ready."
L.OPTIONAL = string.gsub(AUCTION_HOUSE_BUYOUT_OPTIONAL_LABEL, "|cff777777", NORMAL_FONT_COLOR_CODE);
L.QUEST_WATCH_QUEST_READY = QUEST_WATCH_QUEST_READY;  -- "Ready for turn-in"
L.UNKNOWN = UNKNOWN;

L.DAILY = DAILY;
L.WEEKLY = WEEKLY;

L.DASH_LINE_STRING_FORMAT = "|TInterface\\Scenarios\\ScenarioIcon-Dash:16:16:0:-1|t %s";
L.DASH_ICON_STRING = "|TInterface\\Scenarios\\ScenarioIcon-Dash:16:16:0:-1|t";
L.CHECKMARK_ICON_STRING = "|A:achievementcompare-YellowCheckmark:0:0|a";

L.HEADER_COLON = HEADER_COLON;  -- ":"
L.NEW_LINE = "|n";
L.NEW_PARAGRAPH = L.NEW_LINE..L.NEW_LINE;
L.PARENS_TEMPLATE = PARENS_TEMPLATE;  -- "(%s)"
L.TEXT_DELIMITER = ITEM_NAME_DESCRIPTION_DELIMITER;  -- " "
L.TEXT_DELIMITER_2X = L.TEXT_DELIMITER..L.TEXT_DELIMITER;

L.CATEGORY_NAME_ZONE_STORY = ZONE;
L.CATEGORY_NAME_QUESTLINE = QUEST_CLASSIFICATION_QUESTLINE;
L.CATEGORY_NAME_CAMPAIGN = QUEST_CLASSIFICATION_CAMPAIGN;

L.QUEST_NAME_FORMAT_ALLIANCE = "%s |A:questlog-questtypeicon-alliance:16:16:0:-1|a";
L.QUEST_NAME_FORMAT_HORDE = "%s |A:questlog-questtypeicon-horde:16:16:0:-1|a";
L.QUEST_NAME_FORMAT_NEUTRAL = "%s";

L.QUEST_TYPE_NAME_FORMAT_TRIVIAL = string.gsub(TRIVIAL_QUEST_DISPLAY, "|cff000000", '');
-- MINIMAP_TRACKING_TRIVIAL_QUESTS = "Niedrigstufige Quests";                   --> TODO - Add hint to activate trivial quest tracking

L.ZONE_NAME_FORMAT = "|T137176:16:16:0:-1|t %s";  -- 136366
L.ZONE_ACHIEVEMENT_NAME_FORMAT_COMPLETE = "%s |A:achievementcompare-YellowCheckmark:0:0:1:0|a";
L.ZONE_ACHIEVEMENT_NAME_FORMAT_INCOMPLETE = "%s";
L.ZONE_ACHIEVEMENT_ICON_NAME_FORMAT_COMPLETE = "|T%d:16:16:0:0|t %s  |A:achievementcompare-YellowCheckmark:0:0|a";
L.ZONE_ACHIEVEMENT_ICON_NAME_FORMAT_INCOMPLETE = "|T%d:16:16:0:0|t %s";
L.ZONE_NAME_ACCOUNT_ACHIEVEMENT_FORMAT = "%s |A:questlog-questtypeicon-account:0:0:1:0|a";

L.ACHIEVEMENT_NOT_COMPLETED_BY  = string.gsub(ACHIEVEMENT_NOT_COMPLETED_BY, "HIGHLIGHT_FONT_COLOR", "BRIGHTBLUE_FONT_COLOR");

L.HINT_HOLD_KEY_FORMAT = "<Hold %s to see details>";
L.HINT_HOLD_KEY_FORMAT_HOVER = "<Hold %s and hover icon to see details>";
L.HINT_VIEW_ACHIEVEMENT_CRITERIA = "<Shift-hover to view chapters>";
L.HINT_VIEW_ACHIEVEMENT = "<Shift-click to view achievement>";  -- KEY_BUTTON1, KEY_BUTTON2, KEY_BUTTON3
L.HINT_SET_WAYPOINT = "<Alt-click to create waypoint>";

L.QUESTLINE_NAME_FORMAT = "|TInterface\\Icons\\INV_Misc_Book_07:16:16:0:-1|t %s";
L.QUESTLINE_CHAPTER_NAME_FORMAT = "|A:Campaign-QuestLog-LoreBook-Back:16:16:0:0|a %s";
L.QUESTLINE_PROGRESS_FORMAT = QUESTS_COLON..L.TEXT_DELIMITER..HIGHLIGHT(L.GENERIC_FRACTION_STRING).."|A:common-icon-checkmark-yellow:12:12:2:0|a";
L.QUESTLINE_WARBAND_PROGRESS_FORMAT = L.GENERIC_FRACTION_STRING.."|A:questlog-questtypeicon-account:14:14:1:0|a";
L.QUESTLINE_NUM_INPROGRESS_FORMAT = LIGHTYELLOW_FONT_COLOR:WrapTextInColorCode("+%d").."|A:WrapperInProgressquesticon:14:14:1:0|a";
L.QUESTLINE_NUM_TURNINREADY_FORMAT = LIGHTYELLOW_FONT_COLOR:WrapTextInColorCode("+%d").."|A:QuestTurnin:13:13:-1:0|a";
L.QUESTLINE_NUM_RECURRING_FORMAT = TUTORIAL_BLUE_FONT_COLOR:WrapTextInColorCode("+%d").."|A:Recurringavailablequesticon:12:12:1:0|a";

L.CAMPAIGN_NAME_FORMAT_COMPLETE = "|A:Campaign-QuestLog-LoreBook:16:16:0:0|a %s  |A:achievementcompare-YellowCheckmark:0:0|a";
L.CAMPAIGN_NAME_FORMAT_INCOMPLETE = "|A:Campaign-QuestLog-LoreBook:16:16:0:0|a %s";
L.CAMPAIGN_PROGRESS_FORMAT = "|"..string.gsub(strtrim(CAMPAIGN_PROGRESS_CHAPTERS_TOOLTIP, L.NEW_LINE), "[|]n[|]c", L.HEADER_COLON.." |c", 1);
-- L.CAMPAIGN_TYPE_FORMAT_QUEST = "This quest is part of the %s campaign.";
-- L.CAMPAIGN_TYPE_FORMAT_QUESTLINE = "|A:Campaign-QuestLog-LoreBook-Back:16:16:0:0|a This questline is part of the %s campaign.";

L.CHAPTER_NAME_FORMAT_COMPLETED = "|TInterface\\Scenarios\\ScenarioIcon-Check:16:16:0:-1|t %s";
L.CHAPTER_NAME_FORMAT_ACCOUNT_COMPLETED = "|TInterface\\Buttons\\UI-CheckBox-Check-Disabled:16:16:0:-1|t %s";
L.CHAPTER_NAME_FORMAT_NOT_COMPLETED = "|TInterface\\Scenarios\\ScenarioIcon-Dash:16:16:0:-1|t %s";
L.CHAPTER_NAME_FORMAT_CURRENT = "|A:common-icon-forwardarrow:16:16:2:-1|a %s";

----- Helper Functions -----

function L:StringIsEmpty(str)
	return str == nil or string.len(str) == 0
end
