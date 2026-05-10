#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = "MKK SGT Diary";
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "sgt_core",
            "sgt_markers",
            "sgt_map_tools",
            "sgt_admin_tools"
        };
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
