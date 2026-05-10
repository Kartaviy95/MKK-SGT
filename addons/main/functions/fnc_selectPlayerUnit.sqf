#include "..\script_component.hpp"

private _unit = if (_this isEqualType []) then {_this param [0, objNull]} else {_this};

if (isNull _unit || {!(_unit isKindOf "Man")}) exitWith {};

selectPlayer _unit;
[] spawn {
    sleep 0.1;
    waitUntil {sleep 0.1; !isNull player};
    call FUNC(showGroupsInfo);
    call FUNC(createMenu);
};
