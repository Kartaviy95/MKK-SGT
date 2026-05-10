#include "..\script_component.hpp"

if (!hasInterface || {isNull player}) exitWith {};

if (player getVariable [QGVAR(actionsAdded), false]) exitWith {};
player setVariable [QGVAR(actionsAdded), true];

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
