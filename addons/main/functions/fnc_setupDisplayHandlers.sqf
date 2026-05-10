#include "..\script_component.hpp"

[] spawn {
    waitUntil {sleep 0.1; !isNull findDisplay 52};
    private _display = findDisplay 52;
    private _map = _display displayCtrl 51;
    if (!isNull _map) then {
        _map ctrlAddEventHandler ["MouseMoving", {
            params ["", "_xPos", "_yPos"];
            GVAR(mouseX) = _xPos;
            GVAR(mouseY) = _yPos;
        }];
        _map ctrlAddEventHandler ["KeyDown", {_this call FUNC(mapKeyDown)}];
    };
    _display displayAddEventHandler ["KeyDown", {_this call FUNC(mapKeyDown)}];
};

[] spawn {
    waitUntil {sleep 0.1; !isNull findDisplay 12};
    private _display = findDisplay 12;
    private _map = _display displayCtrl 51;
    if (!isNull _map) then {
        _map ctrlAddEventHandler ["MouseMoving", {
            params ["", "_xPos", "_yPos"];
            GVAR(mouseX) = _xPos;
            GVAR(mouseY) = _yPos;
        }];
        _map ctrlAddEventHandler ["KeyDown", {_this call FUNC(mapKeyDown)}];
    };
    _display displayAddEventHandler ["KeyDown", {_this call FUNC(mapKeyDown)}];
};

[] spawn {
    while {true} do {
        uiSleep 0.3;
        private _entry = GVAR(markerGroups) get "highlight";
        private _markers = _entry select 0;
        private _toDelete = [];
        {
            private _alpha = (markerAlpha _x) - 0.05;
            if (_alpha <= 0.65) then {
                deleteMarker _x;
                _toDelete pushBack _x;
            } else {
                _x setMarkerAlpha _alpha;
            };
        } forEach _markers;
        _entry set [0, _markers - _toDelete];
        GVAR(markerGroups) set ["highlight", _entry];
    };
};
