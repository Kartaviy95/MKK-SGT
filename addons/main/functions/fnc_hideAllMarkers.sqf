#include "..\script_component.hpp"

{
    [_x, false] call FUNC(setMarkerGroupVisible);
} forEach ["build", "ammo", "vehicle", "bot", "respawn"];
