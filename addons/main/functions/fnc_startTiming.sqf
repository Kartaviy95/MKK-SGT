#include "..\script_component.hpp"

private _color = if (_this isEqualType []) then {_this param [0, "ColorBlack", [""]]} else {_this};

if (!isNil QGVAR(timingThread)) then {
    terminate GVAR(timingThread);
};

GVAR(timingColor) = _color;
GVAR(timing) = true;
GVAR(timingLastPosition) = getPos player;

GVAR(timingThread) = [] spawn {
    GVAR(timingStartTime) = diag_tickTime;
    GVAR(timingNextTime) = GVAR(timingStartTime);
    while {GVAR(timing)} do {
        private _distance = GVAR(timingLastPosition) distance getPos player;
        if (_distance > 10 && {(diag_tickTime >= GVAR(timingNextTime)) || {_distance >= 300} || {visibleMap}}) then {
            call FUNC(createTimingMarker);
            GVAR(timingLastPosition) = getPos player;
            waitUntil {sleep 0.1; !visibleMap};
            GVAR(timingNextTime) = diag_tickTime + 30;
        };
        sleep 0.1;
    };
};
