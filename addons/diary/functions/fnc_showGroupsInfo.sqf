#include "..\script_component.hpp"

if (!hasInterface) exitWith {};

player createDiarySubject [QGVAR(units), localize "STR_MKK_SGT_DIARY_UNITS"];

private _unitCounter = 0;
{
    private _group = _x;
    if ((count units _group) > 0) then {
        private _text = "";
        {
            private _unitVar = format [QGVAR(unit_%1), _unitCounter];
            missionNamespace setVariable [_unitVar, _x];
            private _description = _x getVariable [QEGVAR(core,description), name _x];
            private _weapon = primaryWeapon _x;
            private _weaponName = if (_weapon isEqualTo "") then {
                ""
            } else {
                getText (configFile >> "CfgWeapons" >> _weapon >> "displayName")
            };
            _text = _text + format [
                "<font color='#FFFFBB'><execute expression='%1 call %2'>%3. %4</execute></font>%5<br/>",
                _unitVar,
                QEFUNC(admin_tools,selectPlayerUnit),
                _forEachIndex + 1,
                _description,
                if (_weaponName isNotEqualTo "") then {" - " + _weaponName} else {""}
            ];
            _unitCounter = _unitCounter + 1;
        } forEach units _group;

        private _title = format [
            "%1 %2 (%3)",
            if (side _group isEqualTo side player) then {localize "STR_MKK_SGT_DIARY_OWN_GROUP"} else {localize "STR_MKK_SGT_DIARY_ENEMY_GROUP"},
            [_group] call EFUNC(core,groupName),
            count units _group
        ];
        player createDiaryRecord [QGVAR(units), [_title, _text]];
    };
} forEach allGroups;
