# MKK Proving Ground — архитектура и локализация

Использовать при добавлении модулей, переносе кода между аддонами, добавлении строк или изменении поведения локализации.

23. Локализация

Основной файл локализации:

addons/main/stringtable.xml

Минимальные языки:

English;
Russian.

Правила:

в конфиге UI использовать text = "$STR_MKK_PTG_...";
в SQF использовать localize "STR_MKK_PTG_...";
не хранить пользовательский текст напрямую в action-строках;
для динамического текста использовать format [localize "...", ...];
для displayName из чужих модов использовать общий helper локализации;
если строка из чужого мода не локализуется, показывать безопасный резервный вариант.

Текущее состояние stringtable:

ключи имеют префикс `STR_MKK_PTG_`;
в `addons/main/stringtable.xml` сейчас 275 key;
у всех текущих key есть English и Russian.

24. Внутренняя архитектура

Технические константы проекта:

техническое имя проекта: `mkk_ptg`;
префикс сборки: `ptg`;
`PREFIX` в коде: `ptg`;
версия из `script_version.hpp`: 1.0.0.0;
`REQUIRED_VERSION`: 2.20;
автор: Tarantino.

Фактические модули проекта:

ptg_main;
ptg_common;
ptg_catalog;
ptg_ui;
ptg_spawn;
ptg_tracking;
ptg_penetration;
ptg_player;
ptg_player_ace;
ptg_ace.

Назначение модулей:

main — внутренняя конфигурация, keybind, открытие UI, виртуальный/ACE арсенал, копирование classname, удаление и разблокировка объекта под прицелом;
common — общие helpers, безопасное чтение конфигов, локализация строк, масштабирование UI/HUD;
catalog — сбор, фильтрация и описание техники, поиск совместимых ящиков БК для статики;
ui — диалог, стартовое меню, экран техники, свободная камера, телепорт, перевооружение техники, тестовые цели, обработчики кнопок, локальный статус-дисплей объектов при наведении;
spawn — глобальный спавн, создание/удаление тестовых целей и реестр созданных объектов без обязательной загрузки аддона на dedicated server;
tracking — слежение за projectile;
penetration — тест пробития техники, тестовый projectile, отчет damage/hitpoints/crew, preview техники, параметры CfgAmmo;
player — бесконечные патроны, режим бога, обработчики респавна и выстрелов;
player_ace — блокировка ACE medical damage для режима бога;
ace — ACE self actions и terminal actions.

Фактические зависимости:

`ptg_main` требует `cba_main`;
`ptg_common`, `ptg_catalog`, `ptg_spawn`, `ptg_player` требуют `ptg_main`;
`ptg_tracking` требует `ptg_main` и `ptg_common`;
`ptg_ui` требует `ptg_main`, `ptg_common` и `ptg_player`;
`ptg_penetration` требует `ptg_main`, `ptg_ui`, `ptg_catalog`, `ptg_spawn`, `ptg_tracking`;
`ptg_ace` требует `ptg_main` и `ace_interact_menu`;
`ptg_player_ace` требует `ptg_player` и `ace_medical_damage`, использует `skipWhenMissingDependencies = 1`.

Основные UI-поверхности:

`MKK_PTG_MainDisplay` idd 88000;
оверлей перевооружения в `MKK_PTG_MainDisplay` использует idc 88201, 88220-88233, 88290-88292;
оверлей целей в `MKK_PTG_MainDisplay` использует idc 88201, 88400-88443;
`MKK_PTG_ObjectStatusDisplayHUD` слой RscTitles, idc 88200-88203;
`MKK_PTG_TrackingHUD` слой RscTitles, idc 88300-88302;
`MKK_PTG_PenetrationDisplay` idd 88900;
`MKK_PTG_PenetrationReportHUD` слой RscTitles, idc 88980-88981.

Игровые потоки создания/удаления объектов:

спавн техники: клиентский `ptg_spawn_fnc_requestSpawnVehicle` проверяет доступ и вызывает `ptg_spawn_fnc_serverSpawnVehicle` локально; `createVehicle` синхронизируется Arma 3 глобально;
очистка полигона: UI вызывает `ptg_spawn_fnc_cleanupRange`;
удаление объекта под прицелом: клиент `ptg_main_fnc_deleteCursorObject` вызывает `ptg_main_fnc_serverDeleteObject` локально; функция сохраняет старое имя, но не требует выполнения на сервере;
тестовая цель в тесте пробития: `ptg_penetration_fnc_serverCreateTarget` создает/заменяет цель в текущем runtime;
тестовый projectile: клиент `ptg_penetration_fnc_createTestShot` или клик в orbit-камере вызывает `ptg_penetration_fnc_serverFireTestShot`;
тестовые цели из оверлея: `ptg_spawn_fnc_requestSpawnTarget` / `ptg_spawn_fnc_requestDeleteTargets` проверяют вход и вызывают `ptg_spawn_fnc_serverSpawnTarget` / `ptg_spawn_fnc_serverDeleteTargets`;
перевооружение: turret magazines меняются на владельце техники через remoteExec к объекту, pylon loadout применяется через `setPylonLoadout` на машине, где техника local.
