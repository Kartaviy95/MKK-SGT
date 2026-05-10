#include "..\script_component.hpp"

private _slot = if (_this isEqualType []) then {_this param [0, 0, [0]]} else {_this};

private _markersToLoad = profileNamespace getVariable [format [QEGVAR(core,savedMarkers_%1), _slot], []];
{
    private _marker = format [QEGVAR(core,saved_%1), EGVAR(core,allMarkersCounter)];
    EGVAR(core,allMarkersCounter) = EGVAR(core,allMarkersCounter) + 1;
    _marker = createMarker [_marker, _x select 5];
    _marker setMarkerAlpha (_x select 1);
    _marker setMarkerBrush (_x select 2);
    _marker setMarkerColor (_x select 3);
    _marker setMarkerDir (_x select 4);
    _marker setMarkerShape (_x select 6);
    _marker setMarkerSize (_x select 7);
    _marker setMarkerText (_x select 8);
    _marker setMarkerType (_x select 9);
} forEach _markersToLoad;
