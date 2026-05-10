#include "..\script_component.hpp"

{
    [_x, true] call FUNC(setMarkerGroupVisible);
} forEach ["build", "ammo", "vehicle", "bot", "respawn"];
