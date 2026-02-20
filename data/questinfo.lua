--------------------------------------------------------------------------------
--[[ Quest Information - Utility and Wrapper functions for handling quest data. ]]--
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
-- REF.: <https://warcraft.wiki.gg/wiki/World_of_Warcraft_API>
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
-- REF.: <https://www.townlong-yak.com/framexml/live/Blizzard_APIDocumentationGenerated/QuestInfoSharedDocumentation.lua>
-- REF.: <https://www.townlong-yak.com/framexml/live/Blizzard_APIDocumentationGenerated/QuestTaskInfoDocumentation.lua>
-- REF.: <https://warcraft.wiki.gg/wiki/API_C_QuestLog.GetQuestTagInfo>
-- (see also the function comments section for more reference)
--
--------------------------------------------------------------------------------

local AddonID, ns = ...;

-- Upvalues
local C_QuestLog = C_QuestLog;
local C_QuestInfoSystem = C_QuestInfoSystem;
local C_CampaignInfo = C_CampaignInfo;

local LocalQuestCache = ns.QuestCacheUtil; --> <data\questcache.lua>
local LocalQuestFilter = ns.QuestFilter;  --> <data\questfilter.lua>

local QuestFactionGroupID = ns.FactionInfo.QuestFactionGroupID  --> <data\faction.lua>

--------------------------------------------------------------------------------

local LocalQuestInfo = {};
ns.QuestInfo = LocalQuestInfo;

----- Wrapper -----

function LocalQuestInfo:GetQuestTagInfo(questID)
    return C_QuestLog.GetQuestTagInfo(questID);
end

-- Wrapper functions for quest classificationIDs.
---@param questID number
---@return (Enum.QuestClassification)? classificationID
-- 
-- Supported Enum.QuestClassification types (value/name): <br>
-- *  0 "Important" <br>
-- *  1 "Legendary" <br>
-- *  2 "Campaign" <br>
-- *  3 "Calling" <br>
-- *  4 "Meta" <br>
-- *  5 "Recurring" <br>
-- *  6 "Questline" <br>
-- *  7 "Normal" <br>
-- *  8 "BonusObjective" <br>
-- *  9 "Threat" <br>
-- * 10 "WorldQuest" <br>
--
-- REF.: [QuestInfoSharedDocumentation.lua](https://www.townlong-yak.com/framexml/live/Blizzard_APIDocumentationGenerated/QuestInfoSharedDocumentation.lua) <br>
-- REF.: [QuestInfoSystemDocumentation.lua](https://www.townlong-yak.com/framexml/live/Blizzard_APIDocumentationGenerated/QuestInfoSystemDocumentation.lua) <br>
-- REF.: [QuestUtils.lua](https://www.townlong-yak.com/framexml/live/Blizzard_FrameXMLUtil/QuestUtils.lua) <br>
--
function LocalQuestInfo:GetQuestClassificationID(questID)
    local classificationID = C_QuestInfoSystem.GetQuestClassification(questID);
    return classificationID;
end

function LocalQuestInfo:GetQuestClassificationDetails(questID, skipFormatting)
    return QuestUtil.GetQuestClassificationDetails(questID, skipFormatting);
end

-- returns { text=..., atlas=..., size=...}
function LocalQuestInfo:GetQuestClassificationInfo(classificationID)
    local info = QuestUtil.GetQuestClassificationInfo(classificationID);
    -- Add text + atlas for 'BonusObjective'. Leave 'Threat' and 'WorldQuest', since their type is dynamic and handled separately.
    local classificationInfoTableMore = {
        [Enum.QuestClassification.BonusObjective] =	{ text = MAP_LEGEND_BONUSOBJECTIVE, atlas = "questbonusobjective", size = 16 },
    };
    return info or classificationInfoTableMore[classificationID];
end

-- Return the factionGroupID for the given quest.
function LocalQuestInfo:GetQuestFactionGroup(questID)
    local questFactionGroup = GetQuestFactionGroup(questID);

    return questFactionGroup or QuestFactionGroupID.Neutral;
end

function LocalQuestInfo:ReadyForTurnIn(questID)
    return C_QuestLog.ReadyForTurnIn(questID);
end

----- Handler -----

-- Check if given quest is part of a questline.
function LocalQuestInfo:HasQuestLineInfo(questID, uiMapID)                      --> TODO - Refine
    if not uiMapID then
        uiMapID = ns.activeZoneMapInfo and ns.activeZoneMapInfo.mapID or WorldMapFrame:GetMapID();
    end
    return (C_QuestLine.GetQuestLineInfo(questID, uiMapID)) ~= nil;
end

-- Extend a default World Map quest pin with additional details needed for this
-- addon to work properly. The pin comes already with a lot of useful functions
-- and variables. Here is an example:
-- * `.achievementID`
-- * `.dataProvider` --> `table` (eg. QuestDataProviderMixin)
-- * `.inProgress`
-- * `.isAccountCompleted`
-- * `.isCampaign`
-- * `.isCombatAllyQuest`
-- * `.isDaily`
-- * `.isHidden`
-- * `.isImportant`
-- * `.isLegendary`
-- * `.isLocalStory` --> "QuestLineInfo"
-- * `.isMeta`
-- * `.isQuestStart` --> `true`
-- * `.mapID`
-- * `.numObjectives`
-- * `.pinAlpha`
-- * `.pinLevel`
-- * `.pinTemplate`
-- * `.questClassification`
-- * `.questIcon`
-- * `.questID`
-- * `.questLineID`
-- * `.questLineName`
-- * `.questName`
-- * `.scaleFactor`
-- * `.superTracked`
-- * `.x, y, normalizedX, normalizedY`
-- 
-- REF.:
-- [MapCanvas_DataProviderBase.lua](https://www.townlong-yak.com/framexml/56162/Blizzard_MapCanvas/MapCanvas_DataProviderBase.lua),
-- [QuestDataProvider.lua](https://www.townlong-yak.com/framexml/56162/Blizzard_SharedMapDataProviders/QuestDataProvider.lua),
-- 
---@param pin table
---@return table questInfo
--
function LocalQuestInfo:GetQuestInfoForPin(pin)
    -- local questInfo = {};
    local questInfo = self:GetGameQuestInfo(pin.questID);
    questInfo.questID = pin.questID;
    questInfo.isAccountCompleted = pin.isAccountCompleted or C_QuestLog.IsQuestFlaggedCompletedOnAccount(questInfo.questID);
    questInfo.isFlaggedCompleted = C_QuestLog.IsQuestFlaggedCompleted(questInfo.questID);  --> don't move from this position (!), might be overwritten by `:IsDaily` or `:IsWeekly`!

    local classificationID = pin.questClassification or self:GetQuestClassificationID(questInfo.questID);
    local tagInfo = self:GetQuestTagInfo(questInfo.questID);
    --> Note: Don't use `pin.questLineID`, yet. Currently NOT reliable! (11.0.2)
    questInfo.hasQuestLineInfo = (classificationID and classificationID == Enum.QuestClassification.Questline) or self:HasQuestLineInfo(questInfo.questID);
    questInfo.isAccountQuest = (tagInfo and tagInfo.tagID == Enum.QuestTag.Account) or C_QuestLog.IsAccountQuest(questInfo.questID);
    questInfo.isActive = C_TaskQuest.IsActive(questInfo.questID);
    questInfo.isBonusObjective = pin.isBonusObjective or (classificationID and classificationID == Enum.QuestClassification.BonusObjective or QuestUtils_IsQuestBonusObjective(questInfo.questID));
    questInfo.isCalling = (classificationID and classificationID == Enum.QuestClassification.Calling) or (tagInfo and tagInfo.tagID == Enum.QuestTagType.CovenantCalling) or C_QuestLog.IsQuestCalling(questInfo.questID);
    questInfo.isCampaign = pin.isCampaign or (questInfo.campaignID and questInfo.campaignID > 0) or (classificationID and classificationID == Enum.QuestClassification.Campaign) or C_CampaignInfo.IsCampaignQuest(questInfo.questID);
    questInfo.isDaily = pin.isDaily or LocalQuestFilter:IsDaily(questInfo.questID, questInfo);
    questInfo.isFailed = C_QuestLog.IsFailed(questInfo.questID);                --> TODO - Check if these quests would be even visible on the map
    questInfo.isImportant = pin.isImportant or (classificationID and classificationID == Enum.QuestClassification.Important) or C_QuestLog.IsImportantQuest(questInfo.questID);
    -- questInfo.isLegendary = pin.isLegendary or (classificationID and classificationID == Enum.QuestClassification.Legendary) or C_QuestLog.IsLegendaryQuest(questInfo.questID);
    questInfo.isLegendary = pin.isLegendary or (classificationID and classificationID == Enum.QuestClassification.Legendary) or (C_QuestLog.IsLegendaryQuest and C_QuestLog.IsLegendaryQuest(questInfo.questID));
    questInfo.isOnQuest = pin.inProgress or C_QuestLog.IsOnQuest(questInfo.questID);
    questInfo.isReadyForTurnIn = self:ReadyForTurnIn(questInfo.questID);
    -- questInfo.isRepeatable = (pin.IsRepeatableQuest and pin:IsRepeatableQuest()) or C_QuestLog.IsRepeatableQuest(questInfo.questID) or C_QuestLog.IsQuestRepeatableType(questInfo.questID);
    questInfo.isRepeatable = (pin.IsRepeatableQuest and pin:IsRepeatableQuest()) or (C_QuestLog.IsRepeatableQuest and C_QuestLog.IsRepeatableQuest(questInfo.questID)) or (C_QuestLog.IsQuestRepeatableType and C_QuestLog.IsQuestRepeatableType(questInfo.questID));
    questInfo.isStory = questInfo.isStory or LocalQuestFilter:IsStory(questInfo.questID, questInfo);
    questInfo.isThreat = (classificationID and classificationID == Enum.QuestClassification.Threat) or (tagInfo and tagInfo.tagID == Enum.QuestTagType.Threat);
    questInfo.isTrivial = pin.isHidden or questInfo.isHidden or C_QuestLog.IsQuestTrivial(questInfo.questID);
    questInfo.isWeekly = LocalQuestFilter:IsWeekly(questInfo.questID, questInfo);
    questInfo.isWorldQuest = questInfo.isTask or (classificationID and classificationID == Enum.QuestClassification.WorldQuest) or (tagInfo and tagInfo.worldQuestType ~= nil) or QuestUtils_IsQuestWorldQuest(questInfo.questID);
    questInfo.questFactionGroup = self:GetQuestFactionGroup(questInfo.questID);
    questInfo.questName = questInfo.questName or QuestUtils_GetQuestName(questInfo.questID);
    questInfo.questTagInfo = tagInfo;

    return questInfo;
end

local function AddMoreQuestInfo(questInfo)
    questInfo.isAccountCompleted = C_QuestLog.IsQuestFlaggedCompletedOnAccount(questInfo.questID);
    questInfo.isFlaggedCompleted = C_QuestLog.IsQuestFlaggedCompleted(questInfo.questID);  --> don't move from this position (!), might be overwritten by `:IsDaily` or `:IsWeekly`!

    local classificationID = questInfo.questClassification or LocalQuestInfo:GetQuestClassificationID(questInfo.questID);
    local tagInfo = LocalQuestInfo:GetQuestTagInfo(questInfo.questID);
    questInfo.isDaily = LocalQuestFilter:IsDaily(questInfo.questID, questInfo);
    questInfo.isWeekly = LocalQuestFilter:IsWeekly(questInfo.questID, questInfo);
    questInfo.isFailed = C_QuestLog.IsFailed(questInfo.questID);
    questInfo.isAccountQuest = (tagInfo and tagInfo.tagID == Enum.QuestTag.Account) or C_QuestLog.IsAccountQuest(questInfo.questID);
    questInfo.isActive = C_TaskQuest.IsActive(questInfo.questID);
    questInfo.isBonusObjective = (classificationID and classificationID == Enum.QuestClassification.BonusObjective) or QuestUtils_IsQuestBonusObjective(questInfo.questID);
    questInfo.isCalling = (classificationID and classificationID == Enum.QuestClassification.Calling) or (tagInfo and tagInfo.tagID == Enum.QuestTagType.CovenantCalling) or C_QuestLog.IsQuestCalling(questInfo.questID);
    questInfo.isCampaign = (questInfo.campaignID and questInfo.campaignID > 0) or (classificationID and classificationID == Enum.QuestClassification.Campaign) or C_CampaignInfo.IsCampaignQuest(questInfo.questID);
    questInfo.isImportant = (classificationID and classificationID == Enum.QuestClassification.Important) or C_QuestLog.IsImportantQuest(questInfo.questID);
    -- questInfo.isLegendary = (classificationID and classificationID == Enum.QuestClassification.Legendary) or C_QuestLog.IsLegendaryQuest(questInfo.questID);
    questInfo.isLegendary = (classificationID and classificationID == Enum.QuestClassification.Legendary) or (C_QuestLog.IsLegendaryQuest and C_QuestLog.IsLegendaryQuest(questInfo.questID));
    questInfo.isOnQuest = C_QuestLog.IsOnQuest(questInfo.questID);
    questInfo.hasQuestLineInfo = (classificationID and classificationID == Enum.QuestClassification.Questline) or LocalQuestInfo:HasQuestLineInfo(questInfo.questID);
    questInfo.isReadyForTurnIn = LocalQuestInfo:ReadyForTurnIn(questInfo.questID);
    questInfo.isStory = questInfo.isStory or LocalQuestFilter:IsStory(questInfo.questID, questInfo);
    questInfo.isThreat = classificationID and classificationID == Enum.QuestClassification.Threat or (tagInfo and tagInfo.tagID == Enum.QuestTagType.Threat);
    questInfo.isTrivial = questInfo.isHidden or C_QuestLog.IsQuestTrivial(questInfo.questID);
    questInfo.isWorldQuest = questInfo.isTask or (classificationID and classificationID == Enum.QuestClassification.WorldQuest) or (tagInfo and tagInfo.worldQuestType ~= nil) or QuestUtils_IsQuestWorldQuest(questInfo.questID);
    questInfo.questFactionGroup = LocalQuestInfo:GetQuestFactionGroup(questInfo.questID);
    questInfo.questName = questInfo.title or QuestUtils_GetQuestName(questInfo.questID);
    questInfo.questTagInfo = questInfo.tagInfo or tagInfo;
    -- Internal legacy
    questInfo.questType = C_QuestLog.GetQuestType(questInfo.questID);
    -- Test
    questInfo.wasEarnedByMe = questInfo.isCompleted and not questInfo.isAccountCompleted;
    -- questInfo.isRepeatable = C_QuestLog.IsRepeatableQuest(questInfo.questID) or C_QuestLog.IsQuestRepeatableType(questInfo.questID);
    questInfo.isRepeatable = (C_QuestLog.IsRepeatableQuest and C_QuestLog.IsRepeatableQuest(questInfo.questID)) or (C_QuestLog.IsQuestRepeatableType and C_QuestLog.IsQuestRepeatableType(questInfo.questID));
    questInfo.isBreadcrumbQuest = IsBreadcrumbQuest(questInfo.questID);
    questInfo.isSequenced = IsQuestSequenced(questInfo.questID);
    -- isInvasion = C_QuestLog.IsQuestInvasion(questID),
    -- isMeta
end

-- Retrieve game native quest info for given quest.
---@param questID number
---@return QuestInfo|table questInfo
-- 
-- `QuestInfo` structure (name/type): <br>
-- * `campaignID` --> `number?`  <br>
-- * `difficultyLevel` --> `number` <br>
-- * `frequency` --> `QuestFrequency?`  <br>
-- * `hasLocalPOI` --> `boolean` <br>
-- * `headerSortKey` --> `number?`  <br>
-- * `isAbandonOnDisable` --> `boolean` <br>
-- * `isAutoComplete` --> `boolean` <br>
-- * `isBounty` --> `boolean` <br>
-- * `isCollapsed` --> `boolean` <br>
-- * `isHeader` --> `boolean` <br>
-- * `isHidden` --> `boolean` <br>
-- * `isInternalOnly` --> `boolean` <br>
-- * `isOnMap` --> `boolean` <br>
-- * `isScaling` --> `boolean` <br>
-- * `isStory` --> `boolean` <br>
-- * `isTask` --> `boolean` <br>
-- * `level` --> `number` <br>
-- * `overridesSortOrder` --> `boolean` <br>
-- * `questClassification` --> `QuestClassification` <br>
-- * `questID` --> `number` <br>
-- * `questLogIndex` --> `luaIndex` <br>
-- * `readyForTranslation` --> `boolean` <br>
-- * `sortAsNormalQuest` --> `boolean` <br>
-- * `startEvent` --> `boolean` <br>
-- * `suggestedGroup` --> `number` <br>
-- * `title` --> `string` <br>
-- * `useMinimalHeader` --> `boolean` <br>
--
-- REF.: [QuestLogDocumentation.lua](https://www.townlong-yak.com/framexml/live/Blizzard_APIDocumentationGenerated/QuestLogDocumentation.lua) <br>
-- REF.: [QuestMixin](https://www.townlong-yak.com/framexml/live/Blizzard_ObjectAPI/Quest.lua)
-- 
function LocalQuestInfo:GetGameQuestInfo(questID)
    local questInfo = LocalQuestCache:Get(questID);
    if not questInfo then
        questInfo = C_QuestLog.GetInfo(questID);
    end
    if not questInfo then
        questInfo = { ["questID"] = questID };
    end

    return questInfo;
end

-- Retrieve custom quest info on top of the game's native data for given quest.
---@param questID number
---@return QuestInfo|table questInfo
-- 
function LocalQuestInfo:GetCustomQuestInfo(questID)
    local questInfo = self:GetGameQuestInfo(questID);
    AddMoreQuestInfo(questInfo);

    return questInfo;
end

-- Retrieve a limited amount of quest details needed to process quest related events.
---@param questID number
---@return table questInfo
--
function LocalQuestInfo:GetQuestInfoForQuestEvents(questID)
    local questInfo = self:GetGameQuestInfo(questID);
    -- Enrich details
    questInfo.questID = questID;
    questInfo.questName = questInfo.title or QuestUtils_GetQuestName(questInfo.questID);

    local classificationID = questInfo.questClassification or LocalQuestInfo:GetQuestClassificationID(questInfo.questID);
    questInfo.hasQuestLineInfo = (classificationID and classificationID == Enum.QuestClassification.Questline) or LocalQuestInfo:HasQuestLineInfo(questInfo.questID);
    questInfo.isCampaign = (questInfo.campaignID and questInfo.campaignID > 0) or (classificationID and classificationID == Enum.QuestClassification.Campaign) or C_CampaignInfo.IsCampaignQuest(questInfo.questID);
    questInfo.isDaily = LocalQuestFilter:IsDaily(questInfo.questID, questInfo);
    -- questInfo.isRepeatable = C_QuestLog.IsRepeatableQuest(questInfo.questID) or C_QuestLog.IsQuestRepeatableType(questInfo.questID);
    questInfo.isRepeatable = (C_QuestLog.IsRepeatableQuest and C_QuestLog.IsRepeatableQuest(questInfo.questID)) or (C_QuestLog.IsQuestRepeatableType and C_QuestLog.IsQuestRepeatableType(questInfo.questID));
    questInfo.isStory = questInfo.isStory or LocalQuestFilter:IsStory(questInfo.questID, questInfo);
    questInfo.isWeekly = LocalQuestFilter:IsWeekly(questInfo.questID, questInfo);

    return questInfo;
end

--@do-not-package@
--------------------------------------------------------------------------------
--> TODO
--[[

QuestUtils_IsQuestDungeonQuest(questID)
QuestUtils_GetQuestName(questID)  --> (needed ??)
QuestUtils_GetCurrentQuestLineQuest(questLineID)
QuestUtils_IsQuestWatched(questID)

C_QuestLog.GetActiveThreatMaps()  --> uiMapID list
C_QuestLog.HasActiveThreats()  --> boolean
C_QuestLog.IsQuestCriteriaForBounty(questID, bountyQuestID)  --> boolean
C_QuestLog.GetBountiesForMapID(uiMapID)  --> BountyInfo list
C_QuestLog.GetMapForQuestPOIs()  --> uiMapID list
C_QuestLog.GetQuestsOnMap(questID)  --> QuestOnMapInfo list (Structure --> <QuestLogDocumentation.lua>)
C_QuestLog.GetAllCompletedQuestIDs()  --> questID list              (needed ??)
C_QuestLog.GetQuestDifficultyLevel(questID)  --> level number

C_QuestLog.GetQuestType(questID)  --> questType number
C_QuestLog.GetZoneStoryInfo(uiMapID)  --> achievementID, storyMapID
C_QuestLog.IsComplete(questID)  --> boolean
C_QuestLog.IsMetaQuest(questID)  --> boolean
C_QuestLog.IsOnMap(questID)  --> boolean                            (needed ??)
C_QuestLog.IsOnQuest(questID)  --> boolean
C_QuestLog.IsPushableQuest(questID)  --> boolean - Returns true if the quest can be shared with other players.
C_QuestLog.IsQuestFromContentPush(questID)  --> boolean
C_QuestLog.IsQuestBounty(questID)  --> boolean
C_QuestLog.IsQuestDisabledForSession(questID)  --> boolean - Meaning??
C_QuestLog.QuestIgnoresAccountCompletedFiltering(questID)  --> boolean
C_QuestLog.IsQuestInvasion(questID)  --> boolean
C_QuestLog.IsQuestReplayable(questID)  --> boolean - Identifies if a quest is eligible for replay with party members who have not yet completed it.
C_QuestLog.IsQuestReplayedRecently(questID)  --> boolean
C_QuestLog.IsQuestTask(questID)  --> boolean
C_QuestLog.IsThreatQuest(questID)  --> boolean
C_QuestLog.IsUnitOnQuest(unit, questID)  --> boolean

C_TaskQuest.DoesMapShowTaskQuestObjectives(uiMapID)  --> boolean
C_TaskQuest.GetQuestInfoByQuestID(questID)  -->  {questTitle, factionID?, capped?, displayAsObjective?}
C_TaskQuest.GetQuestLocation(questID, uiMapID)  --> {locationX, locationY}
C_TaskQuest.GetQuestZoneID(questID)  --> uiMapID number
C_TaskQuest.GetQuestsForPlayerByMapID(uiMapID)  --> TaskPOIData list (Structure --> <QuestTaskInfoDocumentation.lua> or below)
C_TaskQuest.GetThreatQuests()  --> questID list

--> <https://www.townlong-yak.com/framexml/live/Blizzard_APIDocumentationGenerated/QuestLineInfoDocumentation.lua>
C_QuestLine.GetAvailableQuestLines(uiMapID)  --> QuestLineInfo list
C_QuestLine.GetQuestLineInfo(questID, uiMapID, displayableOnly)  --> QuestLineInfo (Structure --> <QuestLineInfoDocumentation.lua> or below)
C_QuestLine.GetQuestLineQuests(questLineID)  --> questID list
C_QuestLine.IsComplete(questLineID)  --> boolean
C_QuestLine.QuestLineIgnoresAccountCompletedFiltering(uiMapID, questLineID)  --> boolean
C_QuestLine.RequestQuestLinesForMap(uiMapID)  --> nil

------------------------
----- Future ideas -----
------------------------

C_QuestLog.DoesQuestAwardReputationWithFaction(questID, targetFactionID)  --> boolean
C_QuestLog.GetQuestDetailsTheme(questID)  --> QuestTheme (Structure --> <QuestLogDocumentation.lua>)
C_TaskQuest.GetQuestIconUIWidgetSet(questID)  --> widgetSet number
C_TaskQuest.GetQuestTooltipUIWidgetSet(questID)  --> widgetSet number

QuestUtil.GetQuestIconOfferForQuestID(questID, isLegendary, frequency, isRepeatable, isImportant, isMeta)
QuestUtil.GetQuestIconActiveForQuestID(questID, isComplete, isLegendary, frequency, isRepeatable, isImportant, isMeta)
QuestUtil.ShouldQuestIconsUseCampaignAppearance(questID)
QuestUtil.IsQuestActiveButNotComplete(questID)
QuestUtil.GetThreatPOIIcon(questID)  --> used in <data\questtypetags.lua>
--> <https://www.townlong-yak.com/framexml/live/Blizzard_FrameXMLUtil/QuestUtils.lua>

---------------------------
----- Quick Reference -----
---------------------------

Name = "QuestFrequency",
Type = "Enumeration",
NumValues = 4,
MinValue = 0,
MaxValue = 3,
Fields =
{
    { Name = "Default", Type = "QuestFrequency", EnumValue = 0 },
    { Name = "Daily", Type = "QuestFrequency", EnumValue = 1 },
    { Name = "Weekly", Type = "QuestFrequency", EnumValue = 2 },
    { Name = "ResetByScheduler", Type = "QuestFrequency", EnumValue = 3 },
},

Name = "QuestTag",
Type = "Enumeration",
NumValues = 12,
MinValue = 1,
MaxValue = 288,
Fields =
{
    { Name = "Group", Type = "QuestTag", EnumValue = 1 },
    { Name = "PvP", Type = "QuestTag", EnumValue = 41 },
    { Name = "Raid", Type = "QuestTag", EnumValue = 62 },
    { Name = "Dungeon", Type = "QuestTag", EnumValue = 81 },
    { Name = "Legendary", Type = "QuestTag", EnumValue = 83 },
    { Name = "Heroic", Type = "QuestTag", EnumValue = 85 },
    { Name = "Raid10", Type = "QuestTag", EnumValue = 88 },
    { Name = "Raid25", Type = "QuestTag", EnumValue = 89 },
    { Name = "Scenario", Type = "QuestTag", EnumValue = 98 },
    { Name = "Account", Type = "QuestTag", EnumValue = 102 },
    { Name = "CombatAlly", Type = "QuestTag", EnumValue = 266 },
    { Name = "Delve", Type = "QuestTag", EnumValue = 288 },
},

Name = "WorldQuestQuality",
Type = "Enumeration",
NumValues = 3,
MinValue = 0,
MaxValue = 2,
Fields =
{
    { Name = "Common", Type = "WorldQuestQuality", EnumValue = 0 },
    { Name = "Rare", Type = "WorldQuestQuality", EnumValue = 1 },
    { Name = "Epic", Type = "WorldQuestQuality", EnumValue = 2 },
},

Name = "QuestTagInfo",
Type = "Structure",
Fields =
{
    { Name = "tagName", Type = "cstring", Nilable = false },
    { Name = "tagID", Type = "number", Nilable = false },
    { Name = "worldQuestType", Type = "number", Nilable = true },
    { Name = "quality", Type = "WorldQuestQuality", Nilable = true },
    { Name = "tradeskillLineID", Type = "number", Nilable = true },
    { Name = "isElite", Type = "bool", Nilable = true },
    { Name = "displayExpiration", Type = "bool", Nilable = true },
},

Name = "TaskPOIData",
Type = "Structure",
Fields =
{
    { Name = "questId", Type = "number", Nilable = false },
    { Name = "x", Type = "number", Nilable = false },
    { Name = "y", Type = "number", Nilable = false },
    { Name = "inProgress", Type = "bool", Nilable = false },
    { Name = "numObjectives", Type = "number", Nilable = false },
    { Name = "mapID", Type = "number", Nilable = false },
    { Name = "isQuestStart", Type = "bool", Nilable = false },
    { Name = "isDaily", Type = "bool", Nilable = false },
    { Name = "isCombatAllyQuest", Type = "bool", Nilable = false },
    { Name = "isMeta", Type = "bool", Nilable = false },
    { Name = "childDepth", Type = "number", Nilable = true },
},

Name = "QuestLineInfo",
Type = "Structure",
Fields =
{
    { Name = "questLineName", Type = "cstring", Nilable = false },
    { Name = "questName", Type = "cstring", Nilable = false },
    { Name = "questLineID", Type = "number", Nilable = false },
    { Name = "questID", Type = "number", Nilable = false },
    { Name = "x", Type = "number", Nilable = false },
    { Name = "y", Type = "number", Nilable = false },
    { Name = "isHidden", Type = "bool", Nilable = false },
    { Name = "isLegendary", Type = "bool", Nilable = false },
    { Name = "isLocalStory", Type = "bool", Nilable = false },
    { Name = "isDaily", Type = "bool", Nilable = false },
    { Name = "isCampaign", Type = "bool", Nilable = false },
    { Name = "isImportant", Type = "bool", Nilable = false },
    { Name = "isAccountCompleted", Type = "bool", Nilable = false },
    { Name = "isCombatAllyQuest", Type = "bool", Nilable = false },
    { Name = "isMeta", Type = "bool", Nilable = false },
    { Name = "inProgress", Type = "bool", Nilable = false },
    { Name = "isQuestStart", Type = "bool", Nilable = false },
    { Name = "floorLocation", Type = "QuestLineFloorLocation", Nilable = false },
},

Name = "QuestRepeatability",
Type = "Enumeration",
NumValues = 5,
MinValue = 0,
MaxValue = 4,
Fields =
{
    { Name = "None", Type = "QuestRepeatability", EnumValue = 0 },
    { Name = "Daily", Type = "QuestRepeatability", EnumValue = 1 },
    { Name = "Weekly", Type = "QuestRepeatability", EnumValue = 2 },
    { Name = "Turnin", Type = "QuestRepeatability", EnumValue = 3 },
    { Name = "World", Type = "QuestRepeatability", EnumValue = 4 },
},

Name = "QuestTagType",
Type = "Enumeration",
NumValues = 19,
MinValue = 0,
MaxValue = 18,
Fields =
{
    { Name = "Tag", Type = "QuestTagType", EnumValue = 0 },
    { Name = "Profession", Type = "QuestTagType", EnumValue = 1 },
    { Name = "Normal", Type = "QuestTagType", EnumValue = 2 },
    { Name = "PvP", Type = "QuestTagType", EnumValue = 3 },
    { Name = "PetBattle", Type = "QuestTagType", EnumValue = 4 },
    { Name = "Bounty", Type = "QuestTagType", EnumValue = 5 },
    { Name = "Dungeon", Type = "QuestTagType", EnumValue = 6 },
    { Name = "Invasion", Type = "QuestTagType", EnumValue = 7 },
    { Name = "Raid", Type = "QuestTagType", EnumValue = 8 },
    { Name = "Contribution", Type = "QuestTagType", EnumValue = 9 },
    { Name = "RatedReward", Type = "QuestTagType", EnumValue = 10 },
    { Name = "InvasionWrapper", Type = "QuestTagType", EnumValue = 11 },
    { Name = "FactionAssault", Type = "QuestTagType", EnumValue = 12 },
    { Name = "Islands", Type = "QuestTagType", EnumValue = 13 },
    { Name = "Threat", Type = "QuestTagType", EnumValue = 14 },
    { Name = "CovenantCalling", Type = "QuestTagType", EnumValue = 15 },
    { Name = "DragonRiderRacing", Type = "QuestTagType", EnumValue = 16 },
    { Name = "Capstone", Type = "QuestTagType", EnumValue = 17 },
    { Name = "WorldBoss", Type = "QuestTagType", EnumValue = 18 },
},
]]
--------------------------------------------------------------------------------
--@end-do-not-package@
