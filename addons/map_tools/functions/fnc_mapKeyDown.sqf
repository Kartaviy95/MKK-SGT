#include "..\script_component.hpp"

params ["_controlOrDisplay", "_key", "_shift", "_ctrl", "_alt"];

if (_key isEqualTo 211) exitWith {true};

if (_key isEqualTo 35) exitWith {
    private _marker = call FUNC(findMarkerUnderCursor);
    if (_marker isNotEqualTo "") then {
        if (_shift) then {_marker setMarkerAlpha 0};
        if (_ctrl) then {_marker setMarkerAlpha 1};
    };
    false
};

if (_key isEqualTo 20) exitWith {
    private _mapControl = controlNull;
    if (!isNull findDisplay 12) then {
        _mapControl = (findDisplay 12) displayCtrl 51;
    } else {
        if (!isNull findDisplay 52) then {
            _mapControl = (findDisplay 52) displayCtrl 51;
        };
    };
    if (!isNull _mapControl) then {
        [_mapControl ctrlMapScreenToWorld [EGVAR(core,mouseX), EGVAR(core,mouseY)]] call FUNC(createHeightMarker);
    };
    false
};

if (_alt) exitWith {
    call FUNC(createHighlightMarker);
    false
};

false;
