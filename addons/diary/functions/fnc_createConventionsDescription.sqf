#include "..\script_component.hpp"

private _text = getMissionConfigValue ["onLoadMission", ""];
if (_text isEqualTo "") then {
    _text = localize "STR_MKK_SGT_DESC_NO_CONVENTIONS";
};

copyToClipboard _text;
hint localize "STR_MKK_SGT_HINT_COPIED";
