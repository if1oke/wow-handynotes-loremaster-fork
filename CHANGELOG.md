# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.10.1-beta+120001] - 2026-02-20

### Changed

* TOC: updated interface version to `120001` to support WoW 12.0 (and HandyNotes 12.0).

### Fixed

* Quest Info: fixed Lua errors caused by `C_QuestLog.IsLegendaryQuest` being removed in WoW 12.0 — added nil-check guard before calling the function (`Core.lua`, `data/questinfo.lua`).
* Quest Info: fixed Lua errors caused by `C_QuestLog.IsRepeatableQuest` being removed in WoW 12.0 — added nil-check guard before calling the function (`Core.lua`, `data/questinfo.lua`).
* Quest Info: fixed Lua errors caused by `C_QuestLog.IsQuestRepeatableType` being removed in WoW 12.0 — added nil-check guard before calling the function (`data/questinfo.lua`).

## [0.10.0-beta+110002] - 2024-09-20

### Added

* Settings: added option to toggle the repeatable tag line for world quest.
* Settings: added option to toggle quest titles in the Loremaster tooltip.

### Changed

* Quest Type Tags: loosened filter to allow the repeatable tag line for world quests.
* Tooltip: refined zone story, questline and campaign identification and indication.
* Tooltip: updated storyline quest counter to support Warband vs. individual progress.
* Tooltip: updated counter and visual indication of in-progress and ready-for-turn-in storyline quests.
* Tooltip: updated color theme for storyline quests (`green` - Warband completed quest, `dark green` - quest completed by current char + Warband, `yellow` - current available quest, `lighter yellow` - ongoing/in-progress quest, `white` - available not yet completed quest, `orange` - story/lore quest.
* Tooltip: adjusted quest tooltip width - tooltips with shorter content will now be stretched to fit the game's default tooltip.

### Fixed

* Tooltip: due to the many changes recently, when deactivating one or more content categories in settings superfluous spacing appeared in the main tooltip.
* Quest Type Tags: important quests showed both old- and new-style tags in the tooltip.
* Notifications: when earning an achievement criteria the counter was off by 1 since the achievement cache wasn't reset.
* Notifications: due to faulty campaign identification, when accepting a quest the notification message did not appear.
* Notifications: quest counter for campaign and questlines didn't show correct numbers due to Warband completed quests.
* Notifications: when completing a quest from a campaign the notification message showed chapter and campaign name in the wrong order.

## [0.9.0-beta+110002] - 2024-08-28

### Added

* The War Within: added `Loremaster of Khaz Algar` data.
* Quest Type Tags: added optional transparency for trivial quest types.
* Quest Type Tags: added support for Covenant Calling quests.
* Quest Type Tags: added `custom optional tags` for storyline and account-wide completed quests.

### Changed

* Data: updated World Map pin hovering update behavior.
* Quest Type Tags: combined trivial quest tag with primary quest type tag, unless there is no primary type.
* Quest Type Tags: combined timed recurring quest types with daily and weekly tags, since the duration is already shown.
* Quest Type Tags: updated the internal `quest type tagging system`.
* Tooltip: updated colors for active quest title and tag line text to match the default tooltip.
* Tooltip: added `timer to quest offer tooltips` for auto-updating the tooltip content.
* Tooltip: the tooltip no longer changes the game's tooltip by hooking into it, instead it appears below the quest icon tooltip.
* Tooltip: completely rebuild the `tooltip hooking and anchoring system`.
* Updated TOC file version to `WoW 11.0.2`.

### Removed

* Settings: this options has been removed. The storyline tooltip can no longer be selected as shown separately since it is now already separated from the game's default tooltip.

### Fixed

* Notifications: sometimes campaign chapter IDs and storyline IDs are not identical which led to not counting saved active lore quests correctly or not being recognized at all.
* Tooltip: sometimes campaign chapter IDs and storyline IDs are not identical which led to not indicating to the current campaign chapter correctly.
* Tooltip: fixed UI scaling of the questline tooltip.

## [0.8.0-beta+110000] - 2024-08-03

### Added

* Tooltip: added support for tracking `World Quests`, `Threat and Bonus Objective Quests`.
* Tooltip: added an optional text which tells you `who earned` the achievement.
* Tooltip: added an icon to indicate account-wide achievements.
* Tooltip: added a line to achievements to show the `parent achievement`.
* Quest Type Tags: added quest classification to quest type tags.
* Quest Type Tags: added tag icon support for World Quests.
* Quest Type Tags: added tag icon for War Mode PvP quests.
* Zone Story: added manually `more optional zone achievements` (not part of any Loremaster achievement but still lore related).

### Changed

* Adjusted code to the many changes Blizzard made in the extension pre-patch, to support eg. Warband achievements.
* World Map: char specific achievement are displayed in `darker green icons`.
* World Map: optional zone stories are now displayed in `yellow icons`.
* World Map: updated mouse-over-quest-icon hooks.
* Updated TOC file version to `WoW 11.0.0`.
* Zone Story: Updated map and achievement IDs.
* Dragonflight: Updated weekly quest IDs.

### Fixed

* Tooltip: quests completed by other chars were not indicated as active.
* Tooltip: zone story chapter quests were only shown when eg. a chapter wasn't indicated as active.
* Settings: some achievement entries in the zone view tooltip for optional achievements could not be hidden when there were more than one.
* Settings: some zone icons in continent view for optional achievements could not be hidden.

## [0.7.1-beta+100206] - 2024-03-22

### Changed

* Updated TOC file version to `WoW 10.2.6`.
* Refined map info retrieval for the player's current position.

### Fixed

* Tooltip: in continent view the achievement progress only updated once, eg. when logging-in or reloading the UI.
* Zone Story: completed but not turned-in quests haven't been recognized as active quests.

## [0.7.0-beta+100205] - 2024-02-08

### Added

* Zone Story: added manually all "Loremaster of ..." achievements to the `continent view` of the World Map.
* Zone Story: added manually the following optional zone achievements (not part of any Loremaster achievement):
  + Shadowlands: `The Maw` and `Zereth Mortis`,
  + Battle for Azeroth: `Nazjatar` and `Mechagon`,
  + Legion: `Suramar`,
  + Draenor: `The Garrison Campaign` chapters,
  + Pandaria: `Isle of Thunder` and `Krasarang Wilds`,
  + Northrend: `Zul'Drak`.
* Settings: added option to hide the zone story details/tooltip in zones where the achievement already has been completed.
* Quest Type Tags: added tag icon for profession quests.

### Changed

* Quest Filter: updated quest IDs for races, obsolete quests and mixed-up faction groups.
* Settings: moved "Single Line Achievements" option for zone stories to the "Select Display Type..." dropdown menu.
* Settings: updated the display type options for each category.

## [0.6.0-beta+100205] - 2024-01-29

### Added

* Zone Story: added manually optional zone stories for `Zaralek Cavern`, `Forbidden Reach` and `Emerald Dream`. (These are additional storylines and not part of any Loremaster achievement.)
* Settings: added slider for adjusting `continent icon size + transparency`.
* Settings: added slider for adjusting the `questline tooltip's scroll speed`.

### Changed

* World Map: continent icons will now auto-scale with the size of the map.
* World Map: increased continent icon size 1.5x and reduced transparency to 75 %.
* Settings: modified layout for continent icon options.
* Settings: modified layout for quest tooltip options.
* Tooltip: increased scrolling speed for the questline tooltip.
* Quest Filter: updated obsolete quest IDs.
* Updated README files.

### Fixed

* Active Quests: fixed unnecessary blank line which appeared under the "Ready for turn-in" message.
* Quest Type Tags: fixed multiple tag icons for turn-in quests appearing in questline quest lists.

## [0.5.0-beta+100205] - 2024-01-20

### Added

* Quest Type Tags: added faction group tags.
* Campaign: added optional `campaign description`. Some campaigns provide further information about themselves.
* Questlines: added highlight and counter for displaying the number of active (ongoing) quests.
* New `tooltip handler` [LibQTip](https://www.curseforge.com/wow/addons/libqtip-1-0) for better organizing and displaying the tooltip content.

### Changed

* Updated TOC file version to `WoW 10.2.5`.
* Quest Type Tags: combined account-wide quest types with the player's faction group, when they are limited to that, as can be seen in the game's quest log tooltip.
* Quest Type Tags: quest types shown by Blizzard in the active quest tooltip will be ignored since they're already shown, eg. raids or dungeons.
* Quest Type Tags: active (ongoing) quests now show a completion icon suitable for their own type.
* Tooltip: content categories can now be separated into `multiple tooltips`.
* Tooltip: `tooltips are now scrollable` and clamped to the screen.
* Tooltip: the plugin name in active quests is now only showing when at least the "Ready for turn-in" message is activated. Without any tooltip content there's no need for the plugin name to be shown. In short: w/o content from this plugin, the tooltip mimics Blizzard's default look and feel.

### Fixed

* Questlines: story quests now are now recognized properly, as long as zone story chapters provide additional information about them.

## [0.4.2-alpha+100200] - 2024-01-05

### Fixed

* Not all external library files have been included correctly in the previous release.

## [0.4.0-alpha+100200] - 2024-01-04

### Added

* Zone Story: added optional `chapter quests`. Some story chapters are directly linked to a quest which can be displayed.
* A `waypoint` can now be created to the currently hovered quest icon.
* Campaign: added optional `chapter description`. Only some campaign chapters have those, eg. when they are linked to other campaigns.
* Settings: added option to get notified in `chat` whenever a `lore-relevant quest` has been accepted or turned-in.
* Settings: added option to get notified in `chat` whenever a `lore-relevant achievement` or criteria has been earned.
* Settings: added option to hide the icons over zones with a completed story.
* Zone Story: added manually `zone stories for Shadowlands and Dragonflight`; their main zones have each two stories which are required for the Loremaster achievements (Dragonflight is not yet part of the achievement).
* Zone Story: added completion check to the Worldmap's `continent view` with two icons (a green checkmark for complete and a red X for incomplete achievements).
* Questlines: `active quests` can now display chapter details; by default Blizzard does not provide any questline information for active quests.
* Questlines: story quests can now optionally be highlighted in a distinctive text color.
* Questlines: completing `recurring quests` can now optionally be remembered once they have been turned in, despite the eg. daily or weekly reset.

### Changed

* Settings: moved chat notifications to the about section.
* Zone Story: a story achievement can now be displayed in a single line or in multiple more detailed lines.
* Zone Story: a zone's Loremaster achievement name is now shown in the Zone tooltip details.

## [0.3.0-alpha+100107] - 2023-10-14

### Added

* Settings: Quest type tags can optionally be displayed as text instead of icons.
* Quest type tag icons for currently hovered quest and for questline quests.

### Changed

* Refined quest type classification. Now showing more than one quest type when hovering a quest icon.
* Refined automated packaging and releasing.

## [0.2.0-alpha+100107] - 2023-09-27

### Added

* Counter for displaying the number of daily and weekly quests in questlines.
* Automated packaging and releasing for `CurseForge`, `Wago`, `WoWInterface` and `GitHub`.

### Fixed

* Meta files for packaging and releasing didn't include the embedded libraries correctly.

## [0.1.1-alpha+100107] - 2023-09-07

### Changed

* Updated TOC file version to `WoW 10.1.7`.

### Fixed

* Dragonflight: The questline "Bonus Event Holiday Quests" now appears properly again.

## [0.1.0-alpha+100105] - 2023-09-04

### Added

* Files for packaging + releasing.
* Settings menu with basic options.
* Manual quest filter for following quest types: daily, weekly, faction group, class, race and obsolete.
* Basic caching system for questlines, map infos, zone stories and their quests.
* Availability and completion check for campaign quests.
* Availability and completion check for story line quests.
* Availability and completion check for zone story quests.
* Quest type details, eg. "Raid", "Dungeon", etc.
* World Map hook for active quest pins.
* World Map hook for storyline quest pins.
* New slash commands: `/lm`, `/loremaster`
* Basic file structure for a HandyNotes plugin using Ace3.

<!-- [Unreleased]: https://github.com/erglo/wow-handynotes-loremaster/compare/v0.6.0-beta...development -->
[0.10.0-beta+110002]: https://github.com/erglo/wow-handynotes-loremaster/compare/v0.9.0-beta...v0.10.0-beta
[0.9.0-beta+110002]: https://github.com/erglo/wow-handynotes-loremaster/compare/v0.8.0-beta...v0.9.0-beta
[0.8.0-beta+110000]: https://github.com/erglo/wow-handynotes-loremaster/compare/v0.7.1-beta...v0.8.0-beta
[0.7.1-beta+100206]: https://github.com/erglo/wow-handynotes-loremaster/compare/v0.7.0-beta...v0.7.1-beta
[0.7.0-beta+100205]: https://github.com/erglo/wow-handynotes-loremaster/compare/v0.6.0-beta...v0.7.0-beta
[0.6.0-beta+100205]: https://github.com/erglo/wow-handynotes-loremaster/compare/v0.5.0-beta...v0.6.0-beta
[0.5.0-beta+100205]: https://github.com/erglo/wow-handynotes-loremaster/compare/v0.4.2-alpha...v0.5.0-beta
[0.4.2-alpha+100200]: https://github.com/erglo/wow-handynotes-loremaster/compare/v0.4.0-alpha...v0.4.2-alpha
[0.4.0-alpha+100200]: https://github.com/erglo/wow-handynotes-loremaster/compare/v0.3.0-alpha...v0.4.0-alpha
[0.3.0-alpha+100107]: https://github.com/erglo/wow-handynotes-loremaster/compare/v0.2.0-alpha...v0.3.0-alpha
[0.2.0-alpha+100107]: https://github.com/erglo/wow-handynotes-loremaster/compare/v0.1.1-alpha...v0.2.0-alpha
[0.1.1-alpha+100107]: https://github.com/erglo/wow-handynotes-loremaster/compare/v0.1.0-alpha...v0.1.1-alpha
[0.1.0-alpha+100105]: https://github.com/erglo/wow-handynotes-loremaster/releases/tag/v0.1.0-alpha
