#include "script_component.hpp"

call FUNC(initState);

if (isServer) then {
    mkk_platform_doNotRemoveBots = true;
    {
        _x setVariable ["SerP_isPlayer", true, true];
    } forEach playableUnits;
};
