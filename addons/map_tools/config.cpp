#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = "MKK SGT Map Tools";
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "sgt_core"
        };
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"

class RscDisplayInsertMarker {
    onKeyUp = QUOTE(_this call FUNC(markerDialogKeyUp));
};
