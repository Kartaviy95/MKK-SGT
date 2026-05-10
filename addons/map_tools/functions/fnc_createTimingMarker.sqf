#include "..\script_component.hpp"

private _marker = format [QEGVAR(core,saved_%1), EGVAR(core,allMarkersCounter)];
EGVAR(core,allMarkersCounter) = EGVAR(core,allMarkersCounter) + 1;
_marker = createMarker [_marker, getPos player];
_marker setMarkerShape "ICON";
_marker setMarkerType "mil_triangle";
_marker setMarkerColor EGVAR(core,timingColor);
_marker setMarkerSize [0.5, 0.5];

private _timing = floor (diag_tickTime - EGVAR(core,timingStartTime));
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
