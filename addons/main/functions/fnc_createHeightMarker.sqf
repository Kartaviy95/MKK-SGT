#include "..\script_component.hpp"

params ["_position"];

private _marker = format [QGVAR(saved_%1), GVAR(allMarkersCounter)];
GVAR(allMarkersCounter) = GVAR(allMarkersCounter) + 1;
_marker = createMarker [_marker, _position];
_marker setMarkerShape "ICON";
_marker setMarkerType "mil_triangle";
_marker setMarkerColor "ColorBlack";
_marker setMarkerDir 180;
_marker setMarkerSize [0.5, 0.5];

private _elevationOffset = getNumber (configFile >> "CfgWorlds" >> worldName >> "elevationOffset");
_marker setMarkerText str (round (getTerrainHeightASL _position) + _elevationOffset);
