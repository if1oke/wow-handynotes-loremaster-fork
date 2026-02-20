# HandyNotes: Loremaster

[![GitHub repo](https://img.shields.io/badge/repo-wow--handynotes--loremaster-gray?logo=github&color=%2324292E)](https://github.com/if1oke/wow-handynotes-loremaster "Repo on GitHub")
![GitHub Tag](https://img.shields.io/github/v/tag/if1oke/wow-handynotes-loremaster-fork)
![CurseForge Game Versions](https://img.shields.io/curseforge/game-versions/1467382?logo=battle.net&logoColor=%23148EFF&label=WoW-retail)

## THIS IS A FORK OF ORIGINAL LOREMASTER ADDON WITH 12.X SUPPORT, BELOW IS THE ORIGINAL README:

This World of Warcraft™ addon helps you keep track of the Loremaster story quest achievements as well as questlines and campaigns.  
Simply **hover a quest icon** on the world map, if it is part of a questline or a story campaign additional details about your progress will appear in the icon's tooltip.

⚠️**Required addon:** [HandyNotes](https://www.curseforge.com/wow/addons/handynotes "Visit CurseForge.com")

Download available at:
[CurseForge.com](https://www.curseforge.com/wow/addons/handynotes-loremaster-12-x-fork/files "CurseForge Files"),
[GitHub.com](https://github.com/if1oke/wow-handynotes-loremaster/releases "GitHub Releases").  

_(**Note:** This is a playable release. For some add-on hosting services or addon manager you might need to activate visibility for **beta** releases in order to find this addon.)_

## Features (_beta_)

* Extends quest icon tooltips on the worldmap with details about zone stories, questlines and campaigns.
* Choose whether you want to see the tooltips content categories in multiple tooltips (default) or in a single one.
* Displays an icon in continent view indicating whether you finished a zone's story achievement or not.
* Get notified in chat when accepting or turning-in a quest. When it belongs to a questline or a campaign you'll be informed about your progress.
* See more than just 1 quest type provided by Blizzard.
* _TODO (NYI)_: Adds an icon on the right top corner of the worldmap with details about available questlines on the active zone.
* **Many options:** simply hide the content you're not interested in.

----

### Contributing

If you have a feature request or if you would like to report a bug, please visit the repository's [issue page at GitHub](https://github.com/if1oke/wow-handynotes-loremaster/issues).

**Note:** Questlines will sometimes have multiple quests with the same name. _That is NOT a bug!!_ The game filters quests in background processes I don't have access to (or at least I haven't figured out how, yet), depending eg. on the player's class, race, faction group, etc. There are also quests which are obsolete but haven't been removed from the game, yet.  
Currently, those quests need to be filtered manually. You're welcome to report those, especially if you know how to distinguish them.  
_Also note, those name doublets are merely a visual nuisance. Don't let them irritate you. The game will still choose the correct quest for you as soon as you reach that point in a questline._

⚠️**Translators:** _Please do **not** provide any localizations, yet. All strings are still hard coded and many of them are subject to change in the current stage of development (beta)._  
_Note: Future changes and instruction details will be provided in this sections._

----

### Tools Used

* Microsoft's [Visual Studio Code](https://code.visualstudio.com) with ...
  + Sumneko's [Lua Language Server](https://github.com/LuaLS/lua-language-server) extension
  + Ketho's [World of Warcraft API](https://github.com/Ketho/vscode-wow-api) extension
  + Stanzilla's [World of Warcraft TOC Language Support](https://github.com/Stanzilla/vscode-wow-toc) extension
  + David Anson's [Markdown linting and style checking](https://github.com/DavidAnson/vscode-markdownlint) extension
* Version control management with [Git](https://git-scm.com) + [GitHub](https://github.com/)
  + Packaging and uploading: [BigWigsMods/packager](https://github.com/BigWigsMods/packager)
  + Changelog generating: [kemayo/actions-recent-changelog](https://github.com/kemayo/actions-recent-changelog)
* In-game development tools (addons):
  + [BugGrabber](https://www.curseforge.com/wow/addons/bug-grabber),
    [BugSack](https://www.curseforge.com/wow/addons/bugsack),
    [idTip](https://www.curseforge.com/wow/addons/idtip),
    [TextureViewer](https://www.curseforge.com/wow/addons/textureviewer),
    [WoWLua](https://www.curseforge.com/wow/addons/wowlua).  
* Game libraries:
  + [Ace3](https://www.curseforge.com/wow/addons/ace3),
    [CallbackHandler-1.0](https://www.curseforge.com/wow/addons/callbackhandler),
    [LibQTip-1.0](https://www.curseforge.com/wow/addons/libqtip-1-0),
    [LibStub](https://www.curseforge.com/wow/addons/libstub).

### References

* Townlong Yak's [FrameXML archive](https://www.townlong-yak.com/framexml/live)
* WoWpedia's [World of Warcraft API](https://wowpedia.fandom.com/wiki/World_of_Warcraft_API)
* [Wowhead.com](https://www.wowhead.com)
* Matt Cone's ["The Markdown Guide"](https://www.markdownguide.org)
  *(Buy his [book](https://www.markdownguide.org/book)!)*
* [The Git Book](https://git-scm.com/book)
* [Documentation](https://code.visualstudio.com/docs) for Visual Studio Code
