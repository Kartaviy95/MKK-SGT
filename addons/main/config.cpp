#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = QUOTE(MOD_NAME);
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "cba_main",
            "cba_xeh",
            "A3_Functions_F",
            "A3_UIFonts_F",
            "A3_Data_F"
        };
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"

class RscDisplayInsertMarker {
    onKeyUp = QUOTE(_this call FUNC(markerDialogKeyUp));
};
