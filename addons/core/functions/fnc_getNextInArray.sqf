#include "..\script_component.hpp"

params ["_array", "_value", "_direction"];

private _index = _array find _value;
if (_index < 0) exitWith {_value};

_index = _index + _direction;
if (_index < 0) then {_index = (count _array) - 1};
if (_index >= count _array) then {_index = 0};

_array select _index;
