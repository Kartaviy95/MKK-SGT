#include "..\script_component.hpp"

private _mapControl = controlNull;
if (!isNull findDisplay 12) then {
    _mapControl = (findDisplay 12) displayCtrl 51;
} else {
    if (!isNull findDisplay 52) then {
        _mapControl = (findDisplay 52) displayCtrl 51;
    };
};

if (isNull _mapControl) exitWith {""};

private _target = ctrlMapMouseOver _mapControl;
if ((_target isNotEqualTo []) && {(_target select 0) isEqualTo "marker"}) exitWith {_target select 1};
"";
