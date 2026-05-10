#include "..\script_component.hpp"

params ["_display", "_key", "_shift", "_ctrl", "_alt"];

private _edit = _display displayCtrl 101;
if (isNull _edit) exitWith {false};

if (_key in [201, 209]) exitWith {
    private _direction = if (_key isEqualTo 209) then {-1} else {1};
    EGVAR(core,historyPosition) = EGVAR(core,historyPosition) + _direction;
    if (EGVAR(core,historyPosition) < 0) then {EGVAR(core,historyPosition) = 0};
    if (EGVAR(core,historyPosition) >= count EGVAR(core,markerNameHistory)) then {EGVAR(core,historyPosition) = (count EGVAR(core,markerNameHistory)) - 1};
    if (EGVAR(core,historyPosition) >= 0) then {
        _edit ctrlSetText (EGVAR(core,markerNameHistory) select EGVAR(core,historyPosition));
    };
    true
};

if (_key in [28, 156]) exitWith {
    private _text = ctrlText _edit;
    if (EGVAR(core,insertNickname)) then {
        _text = format ["%1 %2", name player, _text];
        _edit ctrlSetText _text;
    };
    [_text] call FUNC(addTitleToHistory);
    false
};

false;
