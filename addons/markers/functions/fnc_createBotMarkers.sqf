#include "..\script_component.hpp"

private _markers = (EGVAR(core,markerGroups) get "bot") select 0;
{deleteMarker _x} forEach _markers;
_markers = [];

{
    if (!(_x in playableUnits) && {!(_x isKindOf "Animal")}) then {
        private _marker = createMarker [format [QEGVAR(core,bot_%1), count _markers], getPos _x];
        _marker setMarkerShape "ICON";
        _marker setMarkerType "mil_dot";
        _marker setMarkerColor (if (alive _x) then {"ColorWhite"} else {"ColorBlack"});
        _marker setMarkerText localize "STR_MKK_SGT_MARKER_BOT";
        _markers pushBack _marker;
    };
} forEach allMissionObjects "Man";

EGVAR(core,markerGroups) set ["bot", [_markers, true]];
