#include "..\script_component.hpp"

params ["_title"];

if (_title isEqualTo "") exitWith {};

private _playerName = if (hasInterface) then {name player} else {""};
EGVAR(core,markerNameHistory) = (EGVAR(core,markerNameHistory) - [_title]) + [_title];
if (_playerName isNotEqualTo "") then {
    EGVAR(core,markerNameHistory) = (EGVAR(core,markerNameHistory) - [_playerName]) + [_playerName];
};
EGVAR(core,historyPosition) = (count EGVAR(core,markerNameHistory)) - 1;
