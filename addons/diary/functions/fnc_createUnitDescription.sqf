#include "..\script_component.hpp"

private _lines = [];
{
    private _group = _x;
    private _units = units _group;
    if (_units isNotEqualTo []) then {
        _lines pushBack format ["%1 (%2)", [_group] call EFUNC(core,groupName), count _units];
        {
            private _weapon = primaryWeapon _x;
            private _weaponName = if (_weapon isEqualTo "") then {
                localize "STR_MKK_SGT_DESC_NO_PRIMARY"
            } else {
                private _name = getText (configFile >> "CfgWeapons" >> _weapon >> "displayName");
                if (_name isEqualTo "") then {_weapon} else {_name}
            };
            _lines pushBack format ["  %1. %2 - %3", _forEachIndex + 1, name _x, _weaponName];
        } forEach _units;
        _lines pushBack "";
    };
} forEach allGroups;

copyToClipboard (_lines joinString endl);
hint localize "STR_MKK_SGT_HINT_COPIED";
