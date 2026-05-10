#include "..\script_component.hpp"

params ["_groupKey", "_visible"];

private _entry = EGVAR(core,markerGroups) getOrDefault [_groupKey, [[], false]];
{
    if (markerShape _x isNotEqualTo "") then {
        _x setMarkerAlpha ([0, 1] select _visible);
    };
} forEach (_entry select 0);

_entry set [1, _visible];
EGVAR(core,markerGroups) set [_groupKey, _entry];
