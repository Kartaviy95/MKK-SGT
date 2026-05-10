#include "..\script_component.hpp"

if (!hasInterface) exitWith {};

player createDiarySubject [QGVAR(actions), localize "STR_MKK_SGT_DIARY_ACTIONS"];

private _timingText = "";
{
    _timingText = _timingText + format [
        "<br/><font color='%1'>[<executeClose expression='""%2"" call %3'>%4</executeClose>]</font>",
        _x select 0,
        _x select 1,
        QFUNC(startTiming),
        _x select 2
    ];
} forEach [
    ["#00FF00", "ColorGreen", localize "STR_MKK_SGT_COLOR_GREEN"],
    ["#0000FF", "ColorBlue", localize "STR_MKK_SGT_COLOR_BLUE"],
    ["#FFFF00", "ColorYellow", localize "STR_MKK_SGT_COLOR_YELLOW"],
    ["#FF8800", "ColorOrange", localize "STR_MKK_SGT_COLOR_ORANGE"],
    ["#FF0000", "ColorRed", localize "STR_MKK_SGT_COLOR_RED"],
    ["#000000", "ColorBlack", localize "STR_MKK_SGT_COLOR_BLACK"],
    ["#FFFFFF", "ColorWhite", localize "STR_MKK_SGT_COLOR_WHITE"]
];

player createDiaryRecord [QGVAR(actions), [
    localize "STR_MKK_SGT_DIARY_TIMING",
    format [
        "%1%2<br/>[<execute expression='call %3'>%4</execute>]",
        localize "STR_MKK_SGT_MENU_TIMING_START",
        _timingText,
        QFUNC(stopTiming),
        localize "STR_MKK_SGT_MENU_TIMING_STOP"
    ]
]];

player createDiaryRecord [QGVAR(actions), [
    localize "STR_MKK_SGT_DIARY_DESCRIPTIONS",
    format [
        "%1 [<execute expression='call %2'>%3</execute>]<br/>%4 [<execute expression='call %5'>%3</execute>]<br/>%6 [<execute expression='call %7'>%3</execute>]<br/>%8 [<execute expression='side player call %9'>%3</execute>]",
        localize "STR_MKK_SGT_MENU_INFANTRY",
        QFUNC(createUnitDescription),
        localize "STR_MKK_SGT_MENU_SHOW",
        localize "STR_MKK_SGT_MENU_VEHICLES",
        QFUNC(createVehicleDescription),
        localize "STR_MKK_SGT_MENU_CONVENTIONS",
        QFUNC(createConventionsDescription),
        localize "STR_MKK_SGT_MENU_BRIEFING",
        QFUNC(createBriefingDescription)
    ]
]];

private _saveLinks = "";
private _loadLinks = "";
for "_i" from 0 to 9 do {
    _saveLinks = _saveLinks + format [" <execute expression='%1 call %2'>[%1]</execute>", _i, QFUNC(saveMarkers)];
    _loadLinks = _loadLinks + format [" <execute expression='%1 call %2'>[%1]</execute>", _i, QFUNC(loadSavedMarkers)];
};

player createDiaryRecord [QGVAR(actions), [
    localize "STR_MKK_SGT_DIARY_MARKERS",
    format [
        "%1 [<execute expression='call %2'>%3</execute>] [<execute expression='call %4'>%5</execute>] [<execute expression='call %6'>%7</execute>] [<execute expression='call %8'>%9</execute>]<br/>%10 [<execute expression='[""respawn"", %11] call %12'>%13</execute>] [<execute expression='[""vehicle"", %14] call %12'>%15</execute>] [<execute expression='[""ammo"", %16] call %12'>%17</execute>] [<execute expression='[""build"", %18] call %12'>%19</execute>] [<execute expression='[""bot"", %20] call %12'>%21</execute>]<br/>%22%23<br/>%24%25<br/>[<execute expression='call %26'>%27</execute>]",
        localize "STR_MKK_SGT_MENU_ALL_MARKERS",
        QFUNC(showAllMarkers),
        localize "STR_MKK_SGT_MENU_SHOW",
        QFUNC(hideAllMarkers),
        localize "STR_MKK_SGT_MENU_HIDE",
        QFUNC(createAllMarkers),
        localize "STR_MKK_SGT_MENU_RECREATE",
        QFUNC(deleteAllMarkers),
        localize "STR_MKK_SGT_MENU_DELETE",
        localize "STR_MKK_SGT_MENU_TOGGLE",
        QFUNC(createRespawnMarkers),
        QFUNC(toggleMarkerGroup),
        localize "STR_MKK_SGT_MARKER_GROUP_RESPAWN",
        QFUNC(createVehicleMarkers),
        localize "STR_MKK_SGT_MARKER_GROUP_VEHICLE",
        QFUNC(createAmmoMarkers),
        localize "STR_MKK_SGT_MARKER_GROUP_AMMO",
        QFUNC(createBuildMarkers),
        localize "STR_MKK_SGT_MARKER_GROUP_BUILD",
        QFUNC(createBotMarkers),
        localize "STR_MKK_SGT_MARKER_GROUP_BOT",
        localize "STR_MKK_SGT_MENU_SAVE_MARKERS",
        _saveLinks,
        localize "STR_MKK_SGT_MENU_LOAD_MARKERS",
        _loadLinks,
        QFUNC(clearSavedMarkers),
        localize "STR_MKK_SGT_MENU_CLEAR_MARKERS"
    ]
]];

player createDiaryRecord [QGVAR(actions), [
    localize "STR_MKK_SGT_DIARY_KEYS",
    localize "STR_MKK_SGT_MENU_KEYS_TEXT"
]];
