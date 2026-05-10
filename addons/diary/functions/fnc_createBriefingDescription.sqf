#include "..\script_component.hpp"

private _side = if (_this isEqualType []) then {_this param [0, side player]} else {_this};

private _groups = allGroups select {side _x isEqualTo _side && {{_x in playableUnits} count units _x > 0}};
private _lines = [];
{
    _lines pushBack format [
        "%1: %2 %3",
        [_x] call EFUNC(core,groupName),
        count units _x,
        localize "STR_MKK_SGT_DESC_UNITS"
    ];
} forEach _groups;

copyToClipboard (_lines joinString endl);
hint localize "STR_MKK_SGT_HINT_COPIED";
