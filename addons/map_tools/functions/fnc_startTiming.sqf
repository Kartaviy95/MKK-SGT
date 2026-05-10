#include "..\script_component.hpp"

private _color = if (_this isEqualType []) then {_this param [0, "ColorBlack", [""]]} else {_this};

if (!isNil QEGVAR(core,timingThread)) then {
    terminate EGVAR(core,timingThread);
};

EGVAR(core,timingColor) = _color;
EGVAR(core,timing) = true;
EGVAR(core,timingLastPosition) = getPos player;

EGVAR(core,timingThread) = [] spawn {
    EGVAR(core,timingStartTime) = diag_tickTime;
    EGVAR(core,timingNextTime) = EGVAR(core,timingStartTime);
    while {EGVAR(core,timing)} do {
        private _distance = EGVAR(core,timingLastPosition) distance getPos player;
        if (_distance > 10 && {(diag_tickTime >= EGVAR(core,timingNextTime)) || {_distance >= 300} || {visibleMap}}) then {
            call FUNC(createTimingMarker);
            EGVAR(core,timingLastPosition) = getPos player;
            waitUntil {sleep 0.1; !visibleMap};
            EGVAR(core,timingNextTime) = diag_tickTime + 30;
        };
        sleep 0.1;
    };
};
