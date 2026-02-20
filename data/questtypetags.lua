--------------------------------------------------------------------------------
--[[ Quest Type Tags - Utility and wrapper functions for handling quest tags. ]]--
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
-- REF.: <https://www.townlong-yak.com/framexml/live/Blizzard_APIDocumentationGenerated/QuestLogDocumentation.lua>
-- REF.: <https://www.townlong-yak.com/framexml/live/Blizzard_UIPanels_Game/QuestMapFrame.lua>
-- REF.: <https://www.townlong-yak.com/framexml/live/Blizzard_APIDocumentationGenerated/MapConstantsDocumentation.lua>
-- REF.: <https://www.townlong-yak.com/framexml/live/Blizzard_APIDocumentationGenerated/QuestConstantsDocumentation.lua>
-- REF.: <https://www.townlong-yak.com/framexml/live/Blizzard_FrameXMLBase/Constants.lua>
-- REF.: <https://www.townlong-yak.com/framexml/live/Blizzard_SharedXML/SharedConstants.lua>
-- REF.: <https://www.townlong-yak.com/framexml/live/Blizzard_APIDocumentationGenerated/QuestInfoSystemDocumentation.lua>
-- REF.: <https://www.townlong-yak.com/framexml/live/Blizzard_APIDocumentationGenerated/QuestLogDocumentation.lua>
-- REF.: <https://warcraft.wiki.gg/wiki/API_C_QuestLog.GetQuestTagInfo>
-- (see also the function comments section for more reference)
--
--------------------------------------------------------------------------------

local AddonID, ns = ...;

local L = ns.L;  --> <locales\L10nUtils.lua>

local QuestFactionGroupID = ns.FactionInfo.QuestFactionGroupID;  --> <data\faction.lua>
local LocalQuestInfo = ns.QuestInfo;  --> <data\questinfo.lua>

--------------------------------------------------------------------------------

local LocalQuestTagUtil = {};
ns.QuestTagUtil = LocalQuestTagUtil;

----- Constants -----

-- Upvalues + Wrapper
local QUEST_TAG_ATLAS = QUEST_TAG_ATLAS;
local QuestUtils_GetQuestTagAtlas = QuestUtils_GetQuestTagAtlas;
local QuestUtils_IsQuestDungeonQuest = QuestUtils_IsQuestDungeonQuest;
local QuestUtils_IsQuestWorldQuest = QuestUtils_IsQuestWorldQuest;

-- Quest tag IDs, additional to `Enum.QuestTag` and `Enum.QuestTagType`
--> REF.: [Enum.QuestTag](https://www.townlong-yak.com/framexml/live/Blizzard_APIDocumentationGenerated/QuestLogDocumentation.lua)
--> REF.: [Enum.QuestTagType](https://www.townlong-yak.com/framexml/live/Blizzard_APIDocumentationGenerated/QuestConstantsDocumentation.lua)
--
local LocalQuestTag = {}
LocalQuestTag.Class = 21
LocalQuestTag.Escort = 84
LocalQuestTag.Artifact = 107
LocalQuestTag.WorldQuest = 109
LocalQuestTag.BurningLegionWorldQuest = 145
LocalQuestTag.BurningLegionInvasionWorldQuest = 146
LocalQuestTag.WarModePvP = 255
LocalQuestTag.Profession = 267
LocalQuestTag.Threat = 268
LocalQuestTag.CovenantCalling = 271
LocalQuestTag.Important = 282


-- Expand the default quest tag atlas map
-- **Note:** Before adding more tag icons, check if they're not already part of `QUEST_TAG_ATLAS`!
--
local shallowCopy = true;
LocalQuestTagUtil.QUEST_TAG_ATLAS = CopyTable(QUEST_TAG_ATLAS, shallowCopy);
LocalQuestTagUtil.QUEST_TAG_ATLAS[LocalQuestTag.Artifact] = "ArtifactQuest"
LocalQuestTagUtil.QUEST_TAG_ATLAS[LocalQuestTag.BurningLegionWorldQuest] = "worldquest-icon-burninglegion"  --> Legion Invasion World Quest Wrapper (~= Enum.QuestTagType.Invasion)
LocalQuestTagUtil.QUEST_TAG_ATLAS[LocalQuestTag.BurningLegionInvasionWorldQuest] = "legioninvasion-map-icon-portal"  --> Legion Invasion World Quest Wrapper (~= Enum.QuestTagType.Invasion)
LocalQuestTagUtil.QUEST_TAG_ATLAS[LocalQuestTag.Class] = "questlog-questtypeicon-class"
LocalQuestTagUtil.QUEST_TAG_ATLAS[LocalQuestTag.Escort] = "nameplates-InterruptShield"
LocalQuestTagUtil.QUEST_TAG_ATLAS[LocalQuestTag.Profession] = "Profession"
LocalQuestTagUtil.QUEST_TAG_ATLAS[LocalQuestTag.WorldQuest] = "worldquest-tracker-questmarker"
LocalQuestTagUtil.QUEST_TAG_ATLAS[LocalQuestTag.Threat] = "worldquest-icon-nzoth"   -- "Ping_Map_Threat"
LocalQuestTagUtil.QUEST_TAG_ATLAS[LocalQuestTag.WarModePvP] = "questlog-questtypeicon-pvp"
LocalQuestTagUtil.QUEST_TAG_ATLAS[LocalQuestTag.CovenantCalling] = "Quest-DailyCampaign-Available"
LocalQuestTagUtil.QUEST_TAG_ATLAS["CAMPAIGN"] = "Quest-Campaign-Available"
LocalQuestTagUtil.QUEST_TAG_ATLAS["COMPLETED_CAMPAIGN"] = "Quest-Campaign-TurnIn"
LocalQuestTagUtil.QUEST_TAG_ATLAS["COMPLETED_DAILY_CAMPAIGN"] = "Quest-DailyCampaign-TurnIn"
-- LocalQuestTagUtil.QUEST_TAG_ATLAS["COMPLETED_IMPORTANT"] = "questlog-questtypeicon-importantturnin"  -- "quest-important-turnin"
LocalQuestTagUtil.QUEST_TAG_ATLAS["COMPLETED_REPEATABLE"] = "QuestRepeatableTurnin"
LocalQuestTagUtil.QUEST_TAG_ATLAS["DAILY_CAMPAIGN"] = "Quest-DailyCampaign-Available"
-- LocalQuestTagUtil.QUEST_TAG_ATLAS["IMPORTANT"] = "questlog-questtypeicon-important"  -- "quest-important-available"
-- LocalQuestTagUtil.QUEST_TAG_ATLAS[LocalQuestTag.Important] = "questlog-questtypeicon-important"
LocalQuestTagUtil.QUEST_TAG_ATLAS["TRIVIAL_CAMPAIGN"] = "Quest-Campaign-Available-Trivial"
-- LocalQuestTagUtil.QUEST_TAG_ATLAS["TRIVIAL_IMPORTANT"] = "quest-important-available-trivial"
LocalQuestTagUtil.QUEST_TAG_ATLAS["TRIVIAL_LEGENDARY"] = "quest-legendary-available-trivial"
LocalQuestTagUtil.QUEST_TAG_ATLAS["TRIVIAL"] = "TrivialQuests"
-- LocalQuestTagUtil.QUEST_TAG_ATLAS["MONTHLY"] = "questlog-questtypeicon-monthly"

--------------------------------------------------------------------------------

-- These types are handled separately or have fallback handler.
local classificationIgnoreTable = {
	Enum.QuestClassification.Important,
	-- Enum.QuestClassification.Legendary,
	Enum.QuestClassification.Campaign,
	Enum.QuestClassification.Calling,
	-- Enum.QuestClassification.Meta,
	-- Enum.QuestClassification.Recurring,
	-- Enum.QuestClassification.Questline,
	Enum.QuestClassification.Normal,
    -- Enum.QuestClassification.BonusObjective,
    -- Enum.QuestClassification.Threat,
    -- Enum.QuestClassification.WorldQuest,
}

local function FormatTagName(tagName, questInfo)
    if questInfo.isTrivial then
        questInfo.hasTrivialTag = true;
        return L.QUEST_TYPE_NAME_FORMAT_TRIVIAL:format(tagName) or tagName;
    end

    return tagName;
end

function LocalQuestTagUtil:ShouldIgnoreQuestTypeTag(questInfo)
    local isKnownQuestTypeTag = QuestUtils_IsQuestDungeonQuest(questInfo.questID);
    local shouldIgnoreShownTag = questInfo.isOnQuest and isKnownQuestTypeTag;

    return shouldIgnoreShownTag;
end

LocalQuestTagUtil.cache = {};
LocalQuestTagUtil.defaultIconWidth = 20;
LocalQuestTagUtil.defaultIconHeight = 20;

function LocalQuestTagUtil:GetQuestTagInfoList(questID, baseQuestInfo)
    local questIDstring = tostring(questID);
    if self.cache[questIDstring] then
        return SafeUnpack(self.cache[questIDstring]);
    end

    local questInfo = baseQuestInfo or LocalQuestInfo:GetCustomQuestInfo(questID);
    local width = self.defaultIconWidth;
    local height = self.defaultIconHeight;
    local tagInfoList = {};  --> {{atlasMarkup=..., tagName=..., tagID=...}, ...}

    -- Supported classification details from the game
    local classificationID, classificationText, classificationAtlas, clSize = LocalQuestInfo:GetQuestClassificationDetails(questID);
    if (classificationID and not tContains(classificationIgnoreTable, classificationID)) then
        local atlas = (classificationID == Enum.QuestClassification.Recurring and questInfo.isReadyForTurnIn) and "quest-recurring-turnin" or classificationAtlas;
        tinsert(tagInfoList, {
            ["atlasMarkup"] = CreateAtlasMarkup(atlas, width, height),
            ["tagName"] = classificationText,
            ["tagID"] = classificationID,
            ["ranking"] = 1,  -- manually ranking the quest type
        });
    end
    -- Supported quest (type) tags from the game
    if questInfo.questTagInfo then
        local info = {};
        info["tagID"] = questInfo.questTagInfo.tagID;
        info["tagName"] = FormatTagName(questInfo.questTagInfo.tagName, questInfo);
        info["ranking"] = 2;

        if (questInfo.questTagInfo.worldQuestType ~= nil) then
            local atlasName, atlasWidth, atlasHeight = QuestUtil.GetWorldQuestAtlasInfo(questInfo.questID, questInfo.questTagInfo, questInfo.isActive)
            info["atlasMarkup"] = CreateAtlasMarkup(atlasName, width, height);
        else
            -- Check WORLD_QUEST_TYPE_ATLAS and QUEST_TAG_ATLAS for a matching icon, alternatively try our local copy of QUEST_TAG_ATLAS.
            -- Note: works only with `Enum.QuestTag` and partially with `Enum.QuestTagType`. (see `Constants.lua`)
            local atlasName = QuestUtils_GetQuestTagAtlas(questInfo.questTagInfo.tagID, questInfo.questTagInfo.worldQuestType) or self.QUEST_TAG_ATLAS[questInfo.questTagInfo.tagID];
            if atlasName then
                info["atlasMarkup"] = CreateAtlasMarkup(atlasName, width, height);
            end
        end
        if questInfo.isThreat then
            local atlas = QuestUtil.GetThreatPOIIcon(questInfo.questID);
            info["atlasMarkup"] = CreateAtlasMarkup(atlas, width, height);
        end
        if (questInfo.questTagInfo.tagID == Enum.QuestTag.Account and questInfo.questFactionGroup ~= QuestFactionGroupID.Neutral) then
            local factionString = questInfo.questFactionGroup == LE_QUEST_FACTION_HORDE and FACTION_HORDE or FACTION_ALLIANCE;
            local factionTagID = questInfo.questFactionGroup == LE_QUEST_FACTION_HORDE and "HORDE" or "ALLIANCE";
            local tagName = questInfo.questTagInfo.tagName..L.TEXT_DELIMITER..L.PARENS_TEMPLATE:format(factionString);
            info["atlasMarkup"] = CreateAtlasMarkup(self.QUEST_TAG_ATLAS[factionTagID], width, height);
            info["tagName"] = FormatTagName(tagName, questInfo);
        end
        if not self:ShouldIgnoreQuestTypeTag(questInfo) then                         --> TODO - priorities (tagInfo vs. manual vs. classification)
            tinsert(tagInfoList, info);
        elseif questInfo.hasTrivialTag then
            questInfo.hasTrivialTag = nil;
        end
    end
    -- Neglected or unsupported tags prior to Dragonflight (tags unsupported through `questTagInfo`, but still in `QUEST_TAG_ATLAS`)
    local isRecurring = classificationID and classificationID == Enum.QuestClassification.Recurring;
    if (questInfo.isDaily and not isRecurring) then
        local atlas = questInfo.isReadyForTurnIn and "QuestRepeatableTurnin" or self.QUEST_TAG_ATLAS.DAILY;
        tinsert(tagInfoList, {
            ["atlasMarkup"] = CreateAtlasMarkup(atlas, width, height),
            ["tagName"] = L.DAILY,
            ["tagID"] = "D",
            ["ranking"] = 3,
        });
    end
    if (questInfo.isWeekly and not isRecurring) then
        local atlas = questInfo.isReadyForTurnIn and "QuestRepeatableTurnin" or self.QUEST_TAG_ATLAS.WEEKLY
        tinsert(tagInfoList, {
            ["atlasMarkup"] = CreateAtlasMarkup(atlas, width, height),
            ["tagName"] = L.WEEKLY,
            ["tagID"] = "W",
            ["ranking"] = 3,
        });
    end
    if (questInfo.isRepeatable and not isRecurring and not questInfo.isWorldQuest) or
       (questInfo.isRepeatable and questInfo.isWorldQuest and ns.settings.showTagRepeatableWQ) then
        local atlas = questInfo.isReadyForTurnIn and "RecurringActiveQuestIcon" or "RecurringAvailableQuestIcon"
        tinsert(tagInfoList, {  -- "quest-recurring-turnin" or "quest-recurring-available"
            ["atlasMarkup"] = CreateAtlasMarkup(atlas, width, height),
            ["tagName"] = MAP_LEGEND_REPEATABLE ,
            ["tagID"] = "R",
            ["ranking"] = 3,
        });
    end
    if questInfo.isFailed then
        tinsert(tagInfoList, {
            ["atlasMarkup"] = CreateAtlasMarkup(self.QUEST_TAG_ATLAS.FAILED, width, height),
            ["tagName"] = FAILED,
            ["tagID"] = "F",
            ["ranking"] = 3,
        });
    end
    if questInfo.isStory then
        tinsert(tagInfoList, {
            ["atlasMarkup"] = CreateAtlasMarkup(self.QUEST_TAG_ATLAS.STORY, width, height),
            ["tagName"] = STORY_PROGRESS,
            ["tagID"] = "S",
            ["ranking"] = 3,
        });
    end
    -- Unsupported by QuestClassification                                       --> TODO- Check frequently, currently: 11.0.2
    if questInfo.isBonusObjective then
        local bonusClassificationID = Enum.QuestClassification.BonusObjective;
        local bonusClassificationInfo = LocalQuestInfo:GetQuestClassificationInfo(bonusClassificationID);
        tinsert(tagInfoList, {
            ["atlasMarkup"] = CreateAtlasMarkup(bonusClassificationInfo.atlas, width, height),
            ["tagName"] = bonusClassificationInfo.text,
            ["tagID"] = bonusClassificationID,
            ["ranking"] = 3,
        });
    end
    if questInfo.isCampaign then
        -- Is supported by classification, but icon is awful.
        local atlas = questInfo.isReadyForTurnIn and "Quest-Campaign-TurnIn" or "Quest-Campaign-Available"
        tinsert(tagInfoList, {
            ["atlasMarkup"] = CreateAtlasMarkup(atlas, width, height),
            ["tagName"] = FormatTagName(L.CATEGORY_NAME_CAMPAIGN, questInfo),
            ["tagID"] = "C",
            ["ranking"] = 3,
        });
    end
    -- if questInfo.isCalling then
    --     -- Is supported by classification, but icon is awful.
    --     local atlas = questInfo.isReadyForTurnIn and "Quest-DailyCampaign-TurnIn" or "Quest-DailyCampaign-Available";
    --     tinsert(tagInfoList, {
    --         ["atlasMarkup"] = CreateAtlasMarkup(atlas, width, height),
    --         ["tagName"] = FormatTagName(QUEST_CLASSIFICATION_CALLING, questInfo),
    --         ["tagID"] = "CC",
    --         ["ranking"] = 3,
    --     });
    -- end
    if ns.settings.showTagQuestline and (questInfo.currentQuestLineID or questInfo.hasQuestLineInfo) then
        local questlineClassificationID = Enum.QuestClassification.Questline;
        local questlineClassificationInfo = LocalQuestInfo:GetQuestClassificationInfo(questlineClassificationID);
        tinsert(tagInfoList, {
            ["atlasMarkup"] = CreateAtlasMarkup(questlineClassificationInfo.atlas, width, height),
            ["tagName"] = questlineClassificationInfo.text,
            ["tagID"] = questlineClassificationID,
            ["ranking"] = 3,
        });
    end
    -- Legacy Tags (removed by Blizzard from `QUEST_TAG_ATLAS`)
    if questInfo.isAccountQuest then
        tinsert(tagInfoList, {
            ["atlasMarkup"] = CreateAtlasMarkup("questlog-questtypeicon-account", width, height),
            ["tagName"] = ACCOUNT_QUEST_LABEL,
            ["tagID"] = Enum.QuestTag.Account,
            ["ranking"] = 3,
        });
    end
    -- Custom tags
    if questInfo.isAccountCompleted then
        tinsert(tagInfoList, {
            ["atlasMarkup"] = CreateAtlasMarkup("questlog-questtypeicon-account", width, height),
            ["tagName"] = ACCOUNT_COMPLETED_QUEST_LABEL,
            ["tagID"] = -1,
            ["ranking"] = 4,
        });
    end
    if questInfo.isCompleted then       --> Test
        tinsert(tagInfoList, {
            ["atlasMarkup"] = CreateAtlasMarkup("questlog-questtypeicon-wrapperturnin", width, height),
            ["tagName"] = GOAL_COMPLETED,
            ["tagID"] = -1,
            ["ranking"] = 4,
        });
    end
    if questInfo.wasEarnedByMe then     --> Test
        tinsert(tagInfoList, {
            ["atlasMarkup"] = CreateAtlasMarkup("UI-Achievement-Shield-2", width, height / 1.1272),
            ["tagName"] = QUEST_COMPLETE..L.HEADER_COLON..L.TEXT_DELIMITER..UnitName("player"),
            ["tagID"] = -1,
            ["ranking"] = 4,
        });
    end

    self:AddTrivialQuestTagInfo(questInfo, tagInfoList);

    if (not questInfo.questTagInfo or questInfo.questTagInfo.tagID ~= Enum.QuestTag.Account) and (questInfo.questFactionGroup ~= QuestFactionGroupID.Neutral) then
        -- Add *faction group icon only* when no questTagInfo provided or not an account-wide quest
        local tagName = questInfo.questFactionGroup == LE_QUEST_FACTION_HORDE and FACTION_HORDE or FACTION_ALLIANCE;
        local factionTagID = questInfo.questFactionGroup == LE_QUEST_FACTION_HORDE and "HORDE" or "ALLIANCE";
        tinsert(tagInfoList, {
            ["atlasMarkup"] = CreateAtlasMarkup(self.QUEST_TAG_ATLAS[factionTagID], width, height),
            ["tagName"] = tagName,
            ["tagID"] = factionTagID,
            ["ranking"] = 5,
        });
    end

    if not self.cache[questIDstring] then
        self.cache[questIDstring] = {tagInfoList, questInfo};
    end

    return tagInfoList, questInfo;
end

function LocalQuestTagUtil:AddTrivialQuestTagInfo(questInfo, tagInfoList)
    if (#tagInfoList < 2 and (questInfo.isTrivial and not questInfo.hasTrivialTag)) then
        -- Add a standalone "trivial" tag
        tinsert(tagInfoList, {
            ["atlasMarkup"] = CreateAtlasMarkup("TrivialQuests", 20, 20),
            ["tagName"] = L.QUEST_TYPE_NAME_FORMAT_TRIVIAL:format(UNIT_NAMEPLATES_SHOW_ENEMY_MINUS),
            ["tagID"] = "T",
            ["ranking"] = 0,
            ["alpha"] = 0.5,
        });
    end
end

function LocalQuestTagUtil:GetInProgressQuestTypeAtlas(questInfo)
    return (
        questInfo.isImportant and "importantInProgressquesticon" or
        questInfo.isLegendary and "legendaryInProgressquesticon" or
        questInfo.isCampaign and "CampaignInProgressQuestIcon" or
        (questInfo.isRepeatable or questInfo.isDaily or questInfo.isWeekly) and "RepeatableInProgressquesticon" or
        "SideInProgressquesticon"
    );
end

--@do-not-package@
--------------------------------------------------------------------------------

--> TODO - New in Patch 11.0.0.:
--[[
QuestLineInfo
  + isLocalStory
  + isAccountCompleted
  + isCombatAllyQuest
  + isMeta
  + inProgress
  + isQuestStart

Enum.QuestTag
  + Delve

Enum.QuestTagType
  + Capstone
  + WorldBoss

-----

-- "Interface/QuestFrame/QuestFrameQuestIcons" (turn-in icons)
-- 
-->  only 16 pt
-- "Interface/GossipFrame/CampaignGossipIcons" (available + Callings + turn-in)
-- "Interface/GossipFrame/ImportantGossipIcons" (available + turn-in)
-- "Interface/GossipFrame/InProgressGossipIcons" (all types)
-- "Interface/GossipFrame/LegendaryGossipIcons" (available + turn-in)
-- "Interface/GossipFrame/RepeatableGossipIcons" (available + turn-in)
-- "Interface/GossipFrame/WrapperGossipIcons" (meta?) (available + turn-in)

    --> 32 ("Interface/Minimap/ObjectIconsAtlas")
    "TrivialQuests"
    ok --> "QuestRepeatableTurnin" or "QuestDaily"
    "QuestTurnin" or "QuestNormal"
    "QuestLegendaryTurnin" or "QuestLegendary"
    "QuestArtifactTurnin" / "QuestArtifact"
    "Quest-Campaign-TurnIn" or "Quest-Campaign-Available"
    ok --> "Quest-DailyCampaign-TurnIn" or "Quest-DailyCampaign-Available"
    "quest-legendary-turnin" or ("quest-legendary-available-trivial" or "quest-legendary-available")
    "quest-important-turnin" or ("quest-important-available-trivial" or "quest-important-available")
    "quest-recurring-turnin" or ("quest-recurring-trivial" or "quest-recurring-available")
    "quest-wrapper-turnin" or ("quest-wrapper-trivial" or "quest-wrapper-available")

    "questlog-questtypeicon-account"  --> 18 pt
    "questlog-questtypeicon-alliance"  --> 18 pt
    "questlog-questtypeicon-class"  --> 18 pt
    "questlog-questtypeicon-daily"  --> 18 pt
    "questlog-questtypeicon-dungeon"  --> 18 pt
    "questlog-questtypeicon-group"  --> 18 pt
    "questlog-questtypeicon-heroic"  --> 18 pt
    "questlog-questtypeicon-horde"  --> 18 pt
    "questlog-questtypeicon-legendary"  --> 18 pt
    "questlog-questtypeicon-legendaryturnin"  --> 18 pt
    "questlog-questtypeicon-lock"  --> 18 pt
    "questlog-questtypeicon-monthly"  --> 18 pt
    "questlog-questtypeicon-pvp"  --> 18 pt
    "questlog-questtypeicon-quest"  --> 18 pt
    "questlog-questtypeicon-questfailed"  --> 18 pt
    "questlog-questtypeicon-raid"  --> 18 pt
    "questlog-questtypeicon-scenario"  --> 18 pt
    "questlog-questtypeicon-story"  --> 18 pt
    "questlog-questtypeicon-weekly"  --> 18 pt
    "questlog-questtypeicon-clockorange"  --> 22 pt
    "questlog-questtypeicon-clockyellow"  --> 22 pt
    "questlog-questtypeicon-important"  --> 18 pt
    "questlog-questtypeicon-importantturnin"  --> 18 pt
    "questlog-questtypeicon-Recurring"  --> 18 pt
    "questlog-questtypeicon-Recurringturnin"  --> 18 pt
    "questlog-questtypeicon-Wrapper"  --> 18 pt
    "questlog-questtypeicon-Wrapperturnin"  --> 18 pt
    "questlog-storylineicon"  --> 22 pt
    "questlog-questtypeicon-Delves"  --> 18 pt

]]
--------------------------------------------------------------------------------
--@end-do-not-package@
