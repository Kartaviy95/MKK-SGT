#include "..\script_component.hpp"

for "_i" from 0 to 1000 do {
    deleteMarker format ["_USER_DEFINED #2/%1", _i];
    deleteMarker format [QGVAR(saved_%1), _i];
};
