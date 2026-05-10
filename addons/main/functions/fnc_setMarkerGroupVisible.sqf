#include "..\script_component.hpp"

params ["_groupKey", "_visible"];

private _entry = GVAR(markerGroups) getOrDefault [_groupKey, [[], false]];
{
    if (markerShape _x isNotEqualTo "") then {
        _x setMarkerAlpha ([0, 1] select _visible);
    };
} forEach (_entry select 0);

_entry set [1, _visible];
GVAR(markerGroups) set [_groupKey, _entry];
