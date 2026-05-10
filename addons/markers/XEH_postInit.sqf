#include "script_component.hpp"

if (isServer) then {
    [] spawn {
        sleep 1;
        call FUNC(createAllMarkers);
    };
};
