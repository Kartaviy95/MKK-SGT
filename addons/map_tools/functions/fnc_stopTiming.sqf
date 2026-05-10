#include "..\script_component.hpp"

if (!isNil QEGVAR(core,timingThread)) then {
    terminate EGVAR(core,timingThread);
};

EGVAR(core,timing) = false;
if ((EGVAR(core,timingLastPosition) distance getPos player) > 10) then {
    call FUNC(createTimingMarker);
};
EGVAR(core,timingLastPosition) = getPos player;
