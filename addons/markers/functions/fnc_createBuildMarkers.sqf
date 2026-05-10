#include "..\script_component.hpp"

private _markers = (EGVAR(core,markerGroups) get "build") select 0;
{deleteMarker _x} forEach _markers;
_markers = [];

{
    if (
        !(_x isKindOf "ReammoBox_F") &&
        {!(_x isKindOf "AllVehicles")} &&
        {!(_x isKindOf "Man")} &&
        {!(_x isKindOf "Animal")} &&
        {!(_x isKindOf "EmptyDetector")} &&
        {!(_x isKindOf "Logic")}
    ) then {
        private _icon = createMarker [format [QEGVAR(core,build_%1), count _markers], getPos _x];
        _icon setMarkerShape "ICON";
        _icon setMarkerType "mil_triangle";
        _icon setMarkerColor "ColorOrange";
        _icon setMarkerSize [0.5, 0.5];
        _markers pushBack _icon;

        private _box = boundingBox _x;
        private _min = _box select 0;
        private _max = _box select 1;
        private _rect = createMarkerLocal [format [QEGVAR(core,buildBox_%1), count _markers], getPos _x];
        _rect setMarkerDirLocal direction _x;
        _rect setMarkerShapeLocal "RECTANGLE";
        _rect setMarkerSizeLocal [((abs (_min select 0)) + (abs (_max select 0))) / 2, ((abs (_min select 1)) + (abs (_max select 1))) / 2];
        _rect setMarkerColorLocal "ColorOrange";
        private _name = getText (configFile >> "CfgVehicles" >> typeOf _x >> "displayName");
        if (_name isEqualTo "") then {_name = typeOf _x};
        _rect setMarkerText _name;
        _markers pushBack _rect;
    };
} forEach allMissionObjects "All";

EGVAR(core,markerGroups) set ["build", [_markers, true]];
