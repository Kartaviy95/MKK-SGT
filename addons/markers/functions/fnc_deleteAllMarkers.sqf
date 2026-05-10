#include "..\script_component.hpp"

{
    {
        deleteMarker _x;
    } forEach (_y select 0);
    EGVAR(core,markerGroups) set [_x, [[], false]];
} forEach EGVAR(core,markerGroups);
