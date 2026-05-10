#include "..\script_component.hpp"

private _markers = (EGVAR(core,markerGroups) get "vehicle") select 0;
{deleteMarker _x} forEach _markers;
_markers = [];

{
    if (!(_x isKindOf "Man")) then {
        private _marker = createMarker [format [QEGVAR(core,vehicle_%1), count _markers], getPos _x];
        _marker setMarkerShape "ICON";
        _marker setMarkerType "mil_box";
        _marker setMarkerColor (if (!canMove _x || {damage _x > 0.5}) then {"ColorBlack"} else {"ColorWhite"});
        private _name = getText (configFile >> "CfgVehicles" >> typeOf _x >> "displayName");
        if (_name isEqualTo "") then {_name = typeOf _x};
        _marker setMarkerText _name;
        _markers pushBack _marker;
    };
} forEach allMissionObjects "AllVehicles";

EGVAR(core,markerGroups) set ["vehicle", [_markers, true]];
