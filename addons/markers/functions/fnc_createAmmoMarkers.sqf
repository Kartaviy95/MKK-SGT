#include "..\script_component.hpp"

private _markers = (EGVAR(core,markerGroups) get "ammo") select 0;
{deleteMarker _x} forEach _markers;
_markers = [];

{
    private _marker = createMarker [format [QEGVAR(core,ammo_%1), count _markers], getPos _x];
    _marker setMarkerShape "ICON";
    _marker setMarkerType "mil_box";
    _marker setMarkerColor "ColorYellow";
    private _name = format [localize "STR_MKK_SGT_MARKER_AMMO", (count _markers) + 1];
    _x setVariable [QEGVAR(core,description), _name];
    _marker setMarkerText _name;
    _markers pushBack _marker;
} forEach allMissionObjects "ReammoBox_F";

EGVAR(core,markerGroups) set ["ammo", [_markers, true]];
