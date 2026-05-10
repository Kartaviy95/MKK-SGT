#include "..\script_component.hpp"

private _slot = if (_this isEqualType []) then {_this param [0, 0, [0]]} else {_this};

private _markersToSave = [];
private _counter = 0;

for "_i" from 0 to EGVAR(core,allMarkersCounter) do {
    private _marker = format [QEGVAR(core,saved_%1), _i];
    if (markerType _marker isNotEqualTo "") then {
        _markersToSave pushBack [
            format ["marker_%1", _counter],
            markerAlpha _marker,
            markerBrush _marker,
            markerColor _marker,
            markerDir _marker,
            markerPos _marker,
            markerShape _marker,
            markerSize _marker,
            markerText _marker,
            markerType _marker
        ];
        _counter = _counter + 1;
    };
};

for "_i" from 0 to 1000 do {
    private _marker = format ["_USER_DEFINED #2/%1", _i];
    if (markerType _marker isNotEqualTo "") then {
        _markersToSave pushBack [
            format ["marker_%1", _counter],
            markerAlpha _marker,
            markerBrush _marker,
            markerColor _marker,
            markerDir _marker,
            markerPos _marker,
            markerShape _marker,
            markerSize _marker,
            markerText _marker,
            markerType _marker
        ];
        _counter = _counter + 1;
    };
};

profileNamespace setVariable [format [QEGVAR(core,savedMarkers_%1), _slot], _markersToSave];
saveProfileNamespace;
_markersToSave;
