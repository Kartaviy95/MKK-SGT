#include "script_component.hpp"

call FUNC(initState);

if (isServer) then {
    mkk_platform_doNotRemoveBots = true;
    {
        _x setVariable ["SerP_isPlayer", true, true];
    } forEach playableUnits;
};

if (!hasInterface) exitWith {};

[] spawn {
    waitUntil {sleep 0.1; !isNull player};
    uiSleep 1;

    call FUNC(showGroupsInfo);
    call FUNC(createMenu);
    call FUNC(setupDisplayHandlers);

    player addAction [
        localize "STR_MKK_SGT_ACTION_SELECT_UNIT",
        {call FUNC(selectCursorTarget)},
        nil,
        100,
        true,
        true,
        "",
        "cursorTarget isKindOf 'Man'"
    ];

    if (isServer) then {
        call FUNC(createAllMarkers);
    };
};
