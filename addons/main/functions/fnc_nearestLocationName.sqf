#include "..\script_component.hpp"

params ["_position"];

private _locations = nearestLocations [_position, ["NameVillage", "NameCity", "NameCityCapital"], 1000, _position];
if (_locations isEqualTo []) then {
    _locations = nearestLocations [_position, ["NameLocal", "Hill", "ViewPoint", "RockArea", "Strategic", "StrongpointArea", "FlatArea", "FlatAreaCity", "FlatAreaCitySmall", "Airport"], 1000, _position];
};

if (_locations isNotEqualTo []) exitWith {text (_locations select 0)};
text nearestLocation [_position, "NameCity"];
