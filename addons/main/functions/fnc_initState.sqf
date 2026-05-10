#include "..\script_component.hpp"

GVAR(allMarkersCounter) = 0;
GVAR(highlightMarkersCounter) = 0;
GVAR(mouseX) = 0.5;
GVAR(mouseY) = 0.5;
GVAR(debug) = false;
GVAR(insertNickname) = false;
GVAR(lastMarkerText) = "";
GVAR(lastEditedMarker) = "";
GVAR(markerNameHistory) = if (hasInterface) then {[name player]} else {[]};
GVAR(historyPosition) = 0;
GVAR(timing) = false;
GVAR(timingColor) = "ColorBlack";
GVAR(timingLastPosition) = if (hasInterface) then {getPos player} else {[0,0,0]};

GVAR(markerColors) = [
    "Default",
    "ColorBlack",
    "ColorRed",
    "ColorGreen",
    "ColorBlue",
    "ColorYellow",
    "ColorOrange",
    "ColorWhite",
    "ColorPink",
    "ColorBrown",
    "ColorKhaki",
    "ColorGrey"
];

GVAR(markerTypes) = [
    "mil_dot",
    "o_inf",
    "o_armor",
    "o_empty",
    "hd_objective",
    "hd_flag",
    "hd_arrow",
    "hd_ambush",
    "hd_destroy",
    "hd_start",
    "hd_end",
    "hd_pickup",
    "hd_join",
    "hd_warning",
    "hd_unknown",
    "hd_dot"
];

GVAR(markerGroups) = createHashMapFromArray [
    ["respawn", [[], false]],
    ["vehicle", [[], false]],
    ["ammo", [[], false]],
    ["build", [[], false]],
    ["bot", [[], false]],
    ["highlight", [[], true]]
];
