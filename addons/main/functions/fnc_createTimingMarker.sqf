#include "..\script_component.hpp"

private _marker = format [QGVAR(saved_%1), GVAR(allMarkersCounter)];
GVAR(allMarkersCounter) = GVAR(allMarkersCounter) + 1;
_marker = createMarker [_marker, getPos player];
_marker setMarkerShape "ICON";
_marker setMarkerType "mil_triangle";
_marker setMarkerColor GVAR(timingColor);
_marker setMarkerSize [0.5, 0.5];

private _timing = floor (diag_tickTime - GVAR(timingStartTime));
private _hours = floor (_timing / 3600);
private _minutes = floor ((_timing - (_hours * 3600)) / 60);
private _seconds = floor (_timing - (_hours * 3600) - (_minutes * 60));
_marker setMarkerText format [
    "%1%2:%3%4:%5%6",
    if (_hours > 9) then {""} else {"0"},
    _hours,
    if (_minutes > 9) then {""} else {"0"},
    _minutes,
    if (_seconds > 9) then {""} else {"0"},
    _seconds
];
