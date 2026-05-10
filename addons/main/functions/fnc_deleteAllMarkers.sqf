#include "..\script_component.hpp"

{
    {
        deleteMarker _x;
    } forEach (_y select 0);
    GVAR(markerGroups) set [_x, [[], false]];
} forEach GVAR(markerGroups);
