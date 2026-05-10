#include "script_component.hpp"

if (!hasInterface) exitWith {};

[] spawn {
    waitUntil {sleep 0.1; !isNull player};
    uiSleep 1;

    call FUNC(addPlayerActions);
};
