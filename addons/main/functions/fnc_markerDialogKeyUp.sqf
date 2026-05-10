#include "..\script_component.hpp"

params ["_display", "_key", "_shift", "_ctrl", "_alt"];

private _edit = _display displayCtrl 101;
if (isNull _edit) exitWith {false};

if (_key in [201, 209]) exitWith {
    private _direction = if (_key isEqualTo 209) then {-1} else {1};
    GVAR(historyPosition) = GVAR(historyPosition) + _direction;
    if (GVAR(historyPosition) < 0) then {GVAR(historyPosition) = 0};
    if (GVAR(historyPosition) >= count GVAR(markerNameHistory)) then {GVAR(historyPosition) = (count GVAR(markerNameHistory)) - 1};
    if (GVAR(historyPosition) >= 0) then {
        _edit ctrlSetText (GVAR(markerNameHistory) select GVAR(historyPosition));
    };
    true
};

if (_key in [28, 156]) exitWith {
    private _text = ctrlText _edit;
    if (GVAR(insertNickname)) then {
        _text = format ["%1 %2", name player, _text];
        _edit ctrlSetText _text;
    };
    [_text] call FUNC(addTitleToHistory);
    false
};

false;
