#include "..\script_component.hpp"

if (!isNil QGVAR(timingThread)) then {
    terminate GVAR(timingThread);
};

GVAR(timing) = false;
if ((GVAR(timingLastPosition) distance getPos player) > 10) then {
    call FUNC(createTimingMarker);
};
GVAR(timingLastPosition) = getPos player;
