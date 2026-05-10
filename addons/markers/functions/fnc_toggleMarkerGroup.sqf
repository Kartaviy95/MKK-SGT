#include "..\script_component.hpp"

params ["_groupKey", "_createFunction"];

private _entry = EGVAR(core,markerGroups) getOrDefault [_groupKey, [[], false]];
if ((_entry select 0) isEqualTo []) then {
    call _createFunction;
    _entry = EGVAR(core,markerGroups) getOrDefault [_groupKey, [[], false]];
};

[_groupKey, !(_entry select 1)] call FUNC(setMarkerGroupVisible);
