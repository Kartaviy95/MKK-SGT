#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = QUOTE(COMPONENT);
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            QUOTE(MAIN_ADDON)};
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
