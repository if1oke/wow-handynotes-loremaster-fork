Теперь у меня достаточно данных. Вот полный обзор проекта.

---

# HandyNotes: Loremaster — Обзор проекта

## Что это и зачем

Плагин для аддона **HandyNotes**, который добавляет на карту мира иконки и тултипы для отслеживания:
- **Zone Story** — ачивки "Loremaster" по зонам
- **Campaign** — сюжетные кампании (цепочки квестов с главами)
- **Questline** — именованные цепочки квестов внутри зоны

Без HandyNotes аддон не запустится (жёсткая зависимость в `.toc`).

---

## Архитектура и принцип работы

```
HandyNotes (хост)
    └── LoremasterPlugin (этот аддон)
            ├── Ace3 Framework (AceAddon, AceDB, AceConsole, AceEvent)
            ├── LibQTip-1.0 (кастомные тултипы)
            └── WoW API (C_QuestLog, C_QuestLine, C_CampaignInfo, C_Map...)
```

**Поток работы:**

1. HandyNotes вызывает методы плагина когда игрок наводит мышь на иконку на карте
2. Плагин через `OnMapPin_MouseEnter` перехватывает событие
3. `GetPinTooltip()` → `CreateQuestInfoTable()` — собирает данные о квесте
4. Определяет тип: обычный квест / сюжетная линия / кампания / zone story
5. Строит тултип через LibQTip (до 3 независимых тултипа одновременно)
6. При принятии/сдаче квеста — уведомления в чате + запись в `LoremasterDB`

**Namespace (`ns`)** — все модули общаются через общее пространство имён, которое передаётся через `local AddonID, ns = ...` (стандарт WoW аддонов).

---

## Файловая структура

```
/
├── Core.lua              ← Главный файл (2729 строк): вся логика тултипов, хуки, ивенты
├── Options.lua           ← UI настроек в WoW Settings (808 строк, через Ace3)
├── embeds.xml            ← Загрузка embedded библиотек из папки libs/
├── HandyNotes_erglo_Loremaster.toc  ← Манифест аддона
├── .pkgmeta              ← Конфиг для BigWigsMods packager (CI/CD)
│
├── data/
│   ├── achievements.lua  ← ID ачивок и карт по экспаншенам (Dragonflight, TWW, SL...)
│   ├── database.lua      ← Работа с SavedVariables (LoremasterDB)
│   ├── faction.lua       ← Определение фракции игрока
│   ├── questcache.lua    ← Кеширование данных квестов
│   ├── questfilter.lua   ← Классификация квестов (daily/weekly/story/campaign)
│   ├── questinfo.lua     ← Метаданные квестов (название, уровень, награды)
│   └── questtypetags.lua ← Иконки-теги типов квестов (dungeon, pvp, world quest...)
│
├── locales/              ← Локализация (en, de)
│
├── utils/                ← ПУСТО! (внешняя зависимость — см. ниже)
└── libs/                 ← ОТСУТСТВУЕТ! (внешняя зависимость — см. ниже)
```

---

## Критически важно: отсутствующие зависимости

**Папки `libs/` и `utils/` отсутствуют в репозитории** — это нормально для WoW аддонов, но требует понимания.

### Как это должно работать

Проект использует **BigWigsMods packager** — CI/CD инструмент, который при сборке:
1. Скачивает библиотеки по путям из `.pkgmeta` → `externals:`
2. Помещает их в `libs/` и `utils/`
3. Собирает ZIP для публикации на CurseForge / Wago / WoWInterface

### Что нужно скачать вручную для локальной разработки

**`libs/`** — нужно создать и заполнить:
| Папка | Источник |
|---|---|
| `libs/LibStub/` | https://repos.curseforge.com/wow/libstub/trunk |
| `libs/CallbackHandler-1.0/` | https://repos.wowace.com/wow/callbackhandler/trunk/CallbackHandler-1.0 |
| `libs/AceAddon-3.0/` | https://repos.curseforge.com/wow/ace3/trunk/AceAddon-3.0 |
| `libs/AceConsole-3.0/` | https://repos.curseforge.com/wow/ace3/trunk/AceConsole-3.0 |
| `libs/AceDB-3.0/` | https://repos.curseforge.com/wow/ace3/trunk/AceDB-3.0 |
| `libs/AceEvent-3.0/` | https://repos.wowace.com/wow/ace3/trunk/AceEvent-3.0 |
| `libs/LibQTip-1.0/` | https://repos.curseforge.com/wow/libqtip-1-0 |

**`utils/`** — клонировать отдельный репозиторий автора:
```bash
git clone https://github.com/erglo/wow-addon-utilities.git utils
```

Нужны файлы: `achievements.lua`, `libqtip.lua`, `worldmap.lua`

> Самый простой способ — скачать готовую сборку с CurseForge/Wago и взять `libs/` и `utils/` оттуда.

---

## Ключевые модули в Core.lua

| Блок | Назначение |
|---|---|
| `ZoneStoryUtils` | Кеш данных zone story ачивок |
| `LocalQuestLineUtils` | Работа с questline API |
| `LocalCampaignUtils` | Работа с campaign API |
| `GetPinTooltip()` | Точка входа — строит весь тултип |
| `CreateQuestInfoTable()` | Собирает данные квеста для отображения |
| `OnInitialize()` | Регистрация в HandyNotes, настройка AceDB |
| `OnEnable()` | Slash-команды `/lm`, `/loremaster` |

---

## Состояние проекта и TODO

**Текущая версия:** `v0.10.0-beta` (поддержка WoW 12.0 добавлена в последнем коммите)

**Ближайшие задачи из `TODO.txt`** (приоритеты A/B/C):

| Приоритет | Задача |
|---|---|
| **(A)** | Скрывать тултип если GameTooltip показывает только 1 строку |
| **(B)** | Кнопка на карте мира для обзора questline |
| **(B)** | Не показывать ZoneStory тултип за пределами `C_Map.GetMapWorldSize()` |
| **(C)** | Авто-скролл тултипа до нужного квеста |
| — | Иконки-теги для breadcrumb/sequenced/bounty/repeatable квестов |
| — | Показывать уровень сложности квеста |
| — | Правый клик по иконке континента |
| — | Трекинг иконок на миникарте |

---

## Комментированные (выключенные) библиотеки

В `embeds.xml` закомментированы — готовы к включению при необходимости:
- `AceHook-3.0` — нужен для более сложного хукинга функций
- `AceDBOptions-3.0` — стандартный UI для настроек AceDB
- `AceBucket-3.0` — группировка ивентов
- `AceTimer-3.0` — таймеры (упоминается в коде для авто-обновления тултипов)

---

## Инструменты разработчика (из `.pkgmeta`)

Автор использовал: `bug-grabber`, `bugsack`, `idtip`, `textureviewer`, `wowlua` — стандартный набор WoW разработчика.

**DEV_MODE** включается в `Core.lua:110`:
```lua
local DEV_MODE = false  -- поставь true для отладки
```

---

## Краткое резюме для старта

1. **Ядро** — весь основной код в `Core.lua`, настройки в `Options.lua`
2. **Данные** — папка `data/` содержит всю логику классификации квестов и ID ачивок
3. **Зависимости** — нужно добавить `libs/` и `utils/` вручную для локального тестирования
4. **HandyNotes API** — плагин регистрируется через `HandyNotes:RegisterPluginDB()` и реализует интерфейс с методами `GetNodes`, `OnEnter`, `OnLeave`
5. **WoW 12.0** — последний коммит исправил ошибки с `C_QUEST` API, которые изменились в новой версии