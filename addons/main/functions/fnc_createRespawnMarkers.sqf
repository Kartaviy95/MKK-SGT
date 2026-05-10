#include "..\script_component.hpp"

private _markers = (GVAR(markerGroups) get "respawn") select 0;
{deleteMarker _x} forEach _markers;
_markers = [];

{
    private _group = _x;
    private _count = { _x in playableUnits } count units _group;
    if (_count > 0 && {!isNull leader _group}) then {
        private _marker = createMarker [format [QGVAR(respawn_%1), count _markers], getPos leader _group];
        _marker setMarkerShape "ICON";
        _marker setMarkerType "mil_dot";
        _marker setMarkerColor (switch (side _group) do {
            case east: {"ColorRed"};
            case west: {"ColorBlue"};
            case resistance: {"ColorGreen"};
            case civilian: {"ColorWhite"};
            default {"ColorBlack"};
        });
        _marker setMarkerText format ["%1 (%2)", [_group] call FUNC(groupName), _count];
        _markers pushBack _marker;
    };
} forEach allGroups;

GVAR(markerGroups) set ["respawn", [_markers, true]];
