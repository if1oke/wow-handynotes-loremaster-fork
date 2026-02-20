--------------------------------------------------------------------------------
--[[ Player Info - Utility and wrapper functions for handling player character
                   related data. ]]--
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
-- REF.: <https://www.townlong-yak.com/framexml/live/Blizzard_SharedXMLBase/EnumUtil.lua>
-- REF.: <https://warcraft.wiki.gg/wiki/API_UnitFactionGroup>
-- (see also the function comments section for more reference)
--
--------------------------------------------------------------------------------

local AddonID, ns = ...;

local L = ns.L;  --> <locales\L10nUtils.lua>

--------------------------------------------------------------------------------

local LocalFactionInfo = {};
ns.FactionInfo = LocalFactionInfo;

----- Player -----

LocalFactionInfo.PlayerFactionGroup = UnitFactionGroup("player");

----- Quests -----

-- {Alliance=1, Horde=2, Neutral=3, Player=1|2}
LocalFactionInfo.QuestFactionGroupID = EnumUtil.MakeEnum(
    PLAYER_FACTION_GROUP[1],
    PLAYER_FACTION_GROUP[0],
    "Neutral"
);
LocalFactionInfo.QuestFactionGroupID["Player"] = LocalFactionInfo.QuestFactionGroupID[LocalFactionInfo.PlayerFactionGroup];

-- Quest name templates
LocalFactionInfo.QuestNameFactionGroupTemplate = {
    [LocalFactionInfo.QuestFactionGroupID.Alliance] = L.QUEST_NAME_FORMAT_ALLIANCE,
    [LocalFactionInfo.QuestFactionGroupID.Horde] = L.QUEST_NAME_FORMAT_HORDE,
    [LocalFactionInfo.QuestFactionGroupID.Neutral] = L.QUEST_NAME_FORMAT_NEUTRAL,
};
