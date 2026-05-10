#include "..\script_component.hpp"

private _vehicles = (allMissionObjects "AllVehicles") select {!(_x isKindOf "Man")};
private _lines = [];
{
    private _name = getText (configFile >> "CfgVehicles" >> typeOf _x >> "displayName");
    if (_name isEqualTo "") then {_name = typeOf _x};
    private _location = [getPos _x] call EFUNC(core,nearestLocationName);
    _lines pushBack format ["%1 - %2", _name, _location];
} forEach _vehicles;

copyToClipboard (_lines joinString endl);
hint localize "STR_MKK_SGT_HINT_COPIED";
