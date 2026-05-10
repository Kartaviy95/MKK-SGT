#include "..\script_component.hpp"

private _mapControl = controlNull;
if (!isNull findDisplay 12) then {
    _mapControl = (findDisplay 12) displayCtrl 51;
} else {
    if (!isNull findDisplay 52) then {
        _mapControl = (findDisplay 52) displayCtrl 51;
    };
};
if (isNull _mapControl) exitWith {};

private _position = _mapControl ctrlMapScreenToWorld [GVAR(mouseX), GVAR(mouseY)];
private _marker = createMarker [format [QGVAR(highlight_%1), GVAR(highlightMarkersCounter)], _position];
GVAR(highlightMarkersCounter) = GVAR(highlightMarkersCounter) + 1;
_marker setMarkerShape "ICON";
_marker setMarkerType "mil_dot";
_marker setMarkerColor "ColorYellow";
_marker setMarkerText name player;
_marker setMarkerSize [1.5, 1.5];

private _entry = GVAR(markerGroups) get "highlight";
(_entry select 0) pushBack _marker;
GVAR(markerGroups) set ["highlight", _entry];

createVehicle ["SmokeShellYellow", _position, [], 0, "FLY"];
