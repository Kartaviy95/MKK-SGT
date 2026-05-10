#include "..\script_component.hpp"

params ["_title"];

if (_title isEqualTo "") exitWith {};

private _playerName = if (hasInterface) then {name player} else {""};
GVAR(markerNameHistory) = (GVAR(markerNameHistory) - [_title]) + [_title];
if (_playerName isNotEqualTo "") then {
    GVAR(markerNameHistory) = (GVAR(markerNameHistory) - [_playerName]) + [_playerName];
};
GVAR(historyPosition) = (count GVAR(markerNameHistory)) - 1;
