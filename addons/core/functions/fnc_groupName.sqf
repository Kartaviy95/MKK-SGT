#include "..\script_component.hpp"

params ["_group"];

private _name = str _group;
if ((count _name) > 2) then {
    _name select [2, (count _name) - 3]
} else {
    _name
};
