systemChat "Kaban SG Ready mod started!";

mkk_platform_doNotRemoveBots = true;
kbn_serp_mission = isClass(missionConfigFile >> "Serp_const");

if(!isDedicated)then{waitUntil{!isNil {player}};};

kbn_playerUID = (if(!isDedicated)then{str (getPlayerUID player)}else{"0"});

kbn_all_markers = [];
kbn_all_markers_counter = 0;
kbn_highlight_markers_counter = 0;
kbn_mouse_x = 0.5;
kbn_mouse_y = 0.5;
kbn_mouse_down_x = 0;
kbn_mouse_down_y = 0;

kbn_selected = [];
kbn_dragging = false;
kbn_renaming = false;
kbn_renaming_marker = "";
kbn_last_marker_text = "";
kbn_last_edited_marker = "";
kbn_debug = false;
kbn_insert_nickname = false;
kbn_saved_markers = [];
kbn_timing = false;
kbn_measure_height = false;
kbn_timing_color = "ColorBlack";
kbn_timing_last_position = position player;
kbn_mouse_holding = false;

kbn_marker_name_history = [name player];
kbn_history_position = 0;


kbn_respawn_markers_shown 	= false;
kbn_vehicles_markers_shown 	= false;
kbn_ammo_markers_shown 		= false;
kbn_build_markers_shown 	= false;
kbn_bot_markers_shown 		= false;

kbn_resp_markers 	= [];
kbn_veh_markers 	= [];
kbn_ammo_markers 	= [];
kbn_build_markers 	= [];
kbn_bot_markers 	= [];

kbn_highlights_markers = [];

kbn_markerColors =
[
	"Default",
	"ColorBlack",
	"ColorRed",
	"ColorGreen",
	"ColorBlue",
	"ColorYellow",
	"ColorOrange",
	"ColorWhite",
	"ColorPink",
	"ColorBrown",
	"ColorKhaki"
];

kbn_markerTypes =
[
	"mil_dot",
	"o_inf",
	"o_armor",
	"o_empty",
	"hd_objective",
	"hd_flag",
	"hd_arrow",
	"hd_ambush",
	"hd_destroy",
	"hd_start",
	"hd_end",
	"hd_pickup",
	"hd_join",
	"hd_warning",
	"hd_unknown",
	"hd_dot"
];


//маркеры на все группы
fnc_kbn_create_respawn_markers =
{
	{deleteMarker _x} forEach kbn_resp_markers;
	kbn_resp_markers = [];
	_fnc_groupName =
	{
		_name = toArray(str _this);
		_shorten = [];
		for "_i" from 2 to ((count _name) - 1) do
		{
			_shorten set [_i - 2, _name select _i];
		};
		toString(_shorten)
	};
	{
		_group = _x;
		_count = {_x in playableUnits} count units _group;
		if(_count > 0)then
		{
			marker = format ["grp_mark_%1", count kbn_resp_markers];
			marker = createMarker [marker, position leader _group];
			marker setMarkerShape "ICON";
			marker setMarkerType "mil_dot";
			if(side _group == east)then
			{
				marker setMarkerColor "ColorRed";
			};
			if(side _group == west)then
			{
				marker setMarkerColor "ColorBlue";
			};
			if(side _group == resistance)then
			{
				marker setMarkerColor "ColorGreen";
			};
			if(side _group == civilian)then
			{
				marker setMarkerColor "ColorWhite";
			};

			marker setMarkerText format["%1 (%2)", _group call _fnc_groupName, _count];

			kbn_resp_markers set [count kbn_resp_markers, marker];
		};
	} forEach allGroups;
	kbn_respawn_markers_shown = true;
};

fnc_kbn_hide_respawn_markers =
{
	{_x setMarkerAlpha 0;} forEach kbn_resp_markers;
	kbn_respawn_markers_shown = false;
};

fnc_kbn_show_respawn_markers =
{
	if(isNil "kbn_resp_markers")then{call fnc_kbn_create_respawn_markers};
	{_x setMarkerAlpha 1;} forEach kbn_resp_markers;
	kbn_respawn_markers_shown = true;
};

fnc_kbn_showHide_respawn_markers =
{
	if(kbn_respawn_markers_shown)then
	{
		call fnc_kbn_hide_respawn_markers;
	}
	else
	{
		call fnc_kbn_show_respawn_markers;
	};
};

//маркеры на технику
fnc_kbn_create_vehicles_markers =
{
	{deleteMarker _x} forEach kbn_veh_markers;
	kbn_veh_markers = [];

	{
		if(!(_x isKindOf "Man") && !(_x isKindOf "rhs_cargo_base"))then
		{
			marker = format ["veh_mark_%1", count kbn_veh_markers];
			marker = createMarker [marker, position _x];
			//kbn_all_markers set [count kbn_all_markers, marker];
			marker setMarkerShape "ICON";
			marker setMarkerType "mil_box";
			if(!canMove _x || damage _x > 0.5)then
			{
				marker setMarkerColor "ColorBlack";
			}
			else
			{
				marker setMarkerColor "ColorWhite";
			};
			_name = getText (configFile >> "cfgVehicles" >> typeOf _x >> "displayname");
			if(_name == "")then{_name = typeOf _x};
			marker setMarkerText _name;

			kbn_veh_markers set [count kbn_veh_markers, marker];
		};
	} forEach allMissionObjects "AllVehicles";
	kbn_vehicles_markers_shown = true;
};

fnc_kbn_hide_vehicles_markers =
{
	{_x setMarkerAlpha 0;} forEach kbn_veh_markers;
	kbn_vehicles_markers_shown = false;
};

fnc_kbn_show_vehicles_markers =
{
	if(isNil "kbn_veh_markers")then{call fnc_kbn_create_vehicles_markers};
	{_x setMarkerAlpha 1;} forEach kbn_veh_markers;
	kbn_vehicles_markers_shown = true;
};

fnc_kbn_showHide_vehicles_markers =
{
	if(kbn_vehicles_markers_shown)then
	{
		call fnc_kbn_hide_vehicles_markers;
	}
	else
	{
		call fnc_kbn_show_vehicles_markers;
	};
};

//маркеры на ящики
fnc_kbn_create_ammo_markers =
{
	{deleteMarker _x} forEach kbn_ammo_markers;
	kbn_ammo_markers = [];

	{
		if!(_x isKindOf "ACE_Tyre_Object")then
		{
			marker = format ["ammo_mark_%1", count kbn_ammo_markers];
			marker = createMarker [marker, position _x];
			//kbn_all_markers set [count kbn_all_markers, marker];
			marker setMarkerShape "ICON";
			marker setMarkerType "mil_box";
			marker setMarkerColor "ColorYellow";
			//_name = getText (configFile >> "cfgVehicles" >> typeOf _x >> "displayname");
			//if(_name == "")then{_name = typeOf _x};
			_name = "Ящик №" + str(count kbn_ammo_markers + 1);
			_x setVariable ["kbn_description", _name];
			marker setMarkerText _name;

			kbn_ammo_markers set [count kbn_ammo_markers, marker];
		};
	} forEach allMissionObjects "ReammoBox_F";
	kbn_ammo_markers_shown = true;
};

fnc_kbn_hide_ammo_markers =
{
	{_x setMarkerAlpha 0;} forEach kbn_ammo_markers;
	kbn_ammo_markers_shown = false;
};

fnc_kbn_show_ammo_markers =
{
	if(isNil "kbn_ammo_markers")then{call fnc_kbn_create_ammo_markers};
	{_x setMarkerAlpha 1;} forEach kbn_ammo_markers;
	kbn_ammo_markers_shown = true;
};

fnc_kbn_showHide_ammo_markers =
{
	if(kbn_ammo_markers_shown)then
	{
		call fnc_kbn_hide_ammo_markers;
	}
	else
	{
		call fnc_kbn_show_ammo_markers;
	};
};

//маркеры на статические объекты (ящики, здания и т. п.)
//_name = getText (configFile >> "cfgVehicles" >> typeOf _x >> "displayname");
//if(_name == "")then{_name = typeOf _x};
//_marker setMarkerText _name;
fnc_kbn_create_build_markers =
{
	{deleteMarker _x} forEach kbn_build_markers;
	kbn_build_markers = [];

	{
		if!((_x isKindOf "ReammoBox_F") || (_x isKindOf "AllVehicles") || (_x isKindOf "Man") || (_x isKindOf "Animal") || (_x isKindOf "EmptyDetector") || (_x isKindOf "Logic"))then
		{
			_marker = format ["bld_mark_%1", count kbn_build_markers];
			_marker = createMarker [_marker, position _x];
			_marker setMarkerShape "ICON";
			_marker setMarkerType "mil_triangle";
			_marker setMarkerColor "ColorOrange";
			_marker setMarkerSize [0.5, 0.5];

			kbn_build_markers set [count kbn_build_markers, _marker];

			_obj = _x;
			_bbox = boundingbox _obj;
			_b1 = _bbox select 0;
			_b2 = _bbox select 1;
			_bbx = (abs(_b1 select 0) + abs(_b2 select 0));
			_bby = (abs(_b1 select 1) + abs(_b2 select 1));
			_marker = createmarkerlocal [format ["bundingBoxMarker_%1",count kbn_build_markers],position _obj];
			_marker setmarkerdir direction _obj;
			_marker setmarkershapelocal "rectangle";
			_marker setmarkersizelocal [_bbx/2,_bby/2];
			_marker setmarkercolor "ColorOrange";

			_name = getText (configFile >> "cfgVehicles" >> typeOf _obj >> "displayname");
			if(_name == "")then{_name = typeOf _obj};
			_marker setMarkerText _name;

			kbn_build_markers set [count kbn_build_markers, _marker];

		};
	} forEach allMissionObjects "All";
	kbn_build_markers_shown = true;
};

fnc_kbn_hide_build_markers =
{
	{_x setMarkerAlpha 0;} forEach kbn_build_markers;
	kbn_build_markers_shown = false;
};

fnc_kbn_show_build_markers =
{
	if(isNil "kbn_build_markers")then{call fnc_kbn_create_build_markers};
	{_x setMarkerAlpha 1;} forEach kbn_build_markers;
	kbn_build_markers_shown = true;
};

fnc_kbn_showHide_build_markers =
{
	if(kbn_build_markers_shown)then
	{
		call fnc_kbn_hide_build_markers;
	}
	else
	{
		call fnc_kbn_show_build_markers;
	};
};

//маркеры на ботов
fnc_kbn_create_bot_markers =
{
	{deleteMarker _x} forEach kbn_bot_markers;
	kbn_bot_markers = [];

	{
		if(!(_x in playableUnits) && !(_x isKindOf "Animal"))then
		{
			marker = format ["bot_mark_%1", count kbn_bot_markers];
			marker = createMarker [marker, position _x];
			//kbn_all_markers set [count kbn_all_markers, marker];
			marker setMarkerShape "ICON";
			marker setMarkerType "mil_dot";
			if(alive _x)then
			{
				marker setMarkerColor "ColorWhite";
			}
			else
			{
				marker setMarkerColor "ColorBlack";
			};
			marker setMarkerText "Бот";

			kbn_bot_markers set [count kbn_bot_markers, marker];
		};
	} forEach allMissionObjects "Man";
	kbn_bot_markers_shown = true;
};

fnc_kbn_hide_bot_markers =
{
	{_x setMarkerAlpha 0;} forEach kbn_bot_markers;
	kbn_bot_markers_shown = false;
};

fnc_kbn_show_bot_markers =
{
	if(isNil "kbn_bot_markers")then{call fnc_kbn_create_bot_markers};
	{_x setMarkerAlpha 1;} forEach kbn_bot_markers;
	kbn_bot_markers_shown = true;
};

fnc_kbn_showHide_bot_markers =
{
	if(kbn_bot_markers_shown)then
	{
		call fnc_kbn_hide_bot_markers;
	}
	else
	{
		call fnc_kbn_show_bot_markers;
	};
};

//текстовые описания
fnc_kbn_nearest_location =
{
	private ["_position", "_location", "_locations"];
	_position = _this;

	_location = "";
	_locations = nearestLocations [_position, ["NameVillage", "NameCity", "NameCityCapital"], 1000, _position];
	if(count _locations > 0)then
	{
		_location = text (_locations select 0);
	}
	else
	{
		_locations = nearestLocations [_position, ["NameLocal", "Hill", "ViewPoint", "RockArea", "Strategic", "StrongpointArea", "FlatArea", "FlatAreaCity", "FlatAreaCitySmall", "Airport"], 1000, _position];
		if(count _locations > 0)then
		{
			_location = text (_locations select 0);
		}
		else
		{
			_location = text nearestLocation [_position, "NameCity"];
		};
	};

	_location
};

fnc_kbn_create_description =
{
	_red 	= [];
	_blue 	= [];
	_green 	= [];
	_all = [_red, _blue, _green];
	_weapons_all 			= [[], [], []];
	_weapons_all_count 		= [[], [], []];
	_items_all 				= [[], [], []];
	_items_all_count 		= [[], [], []];
	_magazines_all 			= [[], [], []];
	_magazines_all_count 	= [[], [], []];

	_fnc_groupName =
	{
		_name = toArray(str _this);
		_shorten = [];
		for "_i" from 2 to ((count _name) - 1) do
		{
			_shorten set [_i - 2, _name select _i];
		};
		toString(_shorten)
	};

	{
		_group = _x;
		_count = {_x in playableUnits} count units _group;
		if(_count > 0)then
		{
			_name = _group call _fnc_groupName;
			_side = side _group;
			_side_num = [east, west, resistance] find _side;

			_weapons 			= [];
			_weapons_count 		= [];

			private ["_items", "_items_count"];
			_items 				= _items_all 		select _side_num;
			_items_count 		= _items_all_count 	select _side_num;

			private ["_magazines", "_magazines_count"];
			_magazines 			= _magazines_all 		select _side_num;
			_magazines_count 	= _magazines_all_count 	select _side_num;

			_fnc_inheritsFrom =
			{
				_child 	= _this select 0;
				_parents = _this select 1;
				_ascendants = [(configFile >> "cfgWeapons" >> _child), true] call BIS_fnc_returnParents;
				_result = false;
				{if(_x in _ascendants)exitWith{_result = true}} forEach _parents;
				_result
			};

			_fnc_addWeapon =
			{
				private ["_arr", "_arr_count"];
				_weapon 		= _this select 0;
				_weapon_count 	= _this select 1;

				if(_weapon == "")exitWith{};

				_arr 		= _weapons;
				_arr_count 	= _weapons_count;
				if(isClass(configFile >> "CfgMagazines" >> _weapon))then
				{
					if!([_weapon, ["TimeBomb"]] call _fnc_inheritsFrom)then
					{
						_arr 		= _magazines;
						_arr_count 	= _magazines_count;
					};
				}
				else
				{
					_cfg = configFile >> "cfgWeapons" >> _weapon;
					_simulation = getText (_cfg >> "simulation");
					_isRucksack = getNumber (_cfg >> "ACE_PackSize") != 0;

					if(_isRucksack || {!(_simulation in ["Weapon", "Binocular", "ProxyWeapon"] || [_weapon, ["Launcher"]] call _fnc_inheritsFrom)} || {[_weapon, ["ItemCore"]] call _fnc_inheritsFrom})then
					{
						_arr 		= _items;
						_arr_count 	= _items_count;
					};
				};

				_found = _arr find _weapon;
				if(_found == -1)then
				{
					_found = count _arr;
					_arr 		set [_found, _weapon];
					_arr_count 	set [_found, _weapon_count];
				}
				else
				{
					_arr_count 	set [_found, (_arr_count select _found) + _weapon_count];
				};
			};

			{
				_unit = _x;

				{
					_weapon = _x;
					[_weapon, 1] call _fnc_addWeapon;
				} forEach weapons _unit;

				_weapon = backpack _unit;
				[_weapon, 1] call _fnc_addWeapon;

				{
					_weapon = _x;
					[_weapon, 1] call _fnc_addWeapon;
				} forEach magazines _unit;

				if(backpack  _unit != "")then
				{
					{
						_weapon = _x;
						_weapon_count = 1;
						[_weapon, _weapon_count] call _fnc_addWeapon;
					}forEach ([backpack  _unit]);
					{
						_weapon = _x;
						_weapon_count = 1;
						[_weapon, _weapon_count] call _fnc_addWeapon;
					}forEach (backpackItems _unit);
				};

			} forEach units _group;

			_location = (getPos leader _group) call fnc_kbn_nearest_location;
			_grp_data = [_name, _count, _weapons, _weapons_count, _location];

			private["_arr"];
			_arr = _all select _side_num;
			_arr 	set [count _arr, 	_grp_data];
		};
	} forEach allGroups;

	_newLine = toString [13, 10];
	_text = "";
	{
		_side_num = _foreachIndex;
		_groups = _x;
		if(count _groups > 0)then
		{
			_text = _text + (["Красные", "Синие", "Зеленые"] select _side_num) + _newLine;

			private ["_items", "_items_count"];
			_items 				= _items_all 			select _side_num;
			_items_count 		= _items_all_count 		select _side_num;

			private ["_magazines", "_magazines_count"];
			_magazines 			= _magazines_all 		select _side_num;
			_magazines_count 	= _magazines_all_count 	select _side_num;

			_units_total = 0;
			{
				_grp_data = _x;
				_name 			= _grp_data select 0;
				_count 			= _grp_data select 1;
				_location 		= _grp_data select 4;
				_weapons 		= _grp_data select 2;
				_weapons_count 	= _grp_data select 3;

				_units_total 	= _units_total + _count;

				_text = _text + format["%1 %2 (%3)", _name, _location, _count] + " ";

				{
					_weapon = getText (configFile >> "cfgWeapons" >> _x >> "displayname");
					_weapon_count = _weapons_count select _foreachIndex;
					if(_foreachIndex > 0)then{_text = _text + ", "};
					_text = _text + format["%1x %2", _weapon_count, _weapon];
				} foreach _weapons;
				_text = _text + _newLine;
			} forEach _groups;

			_text = _text + _newLine + format["Всего: %1 чел.", _units_total] + _newLine;

			_text = _text + _newLine + "Снаряжение:" + _newLine;
			{
				_weapon = getText (configFile >> "cfgWeapons" >> _x >> "displayname");
				_weapon_count = _items_count select _foreachIndex;
				if(_foreachIndex > 0)then{_text = _text + ", "};
				_text = _text + format["%1x %2", _weapon_count, _weapon];
			} foreach _items;
			_text = _text + _newLine;

			_text = _text + _newLine + "Боеприпасы:" + _newLine;
			{
				_weapon = getText (configFile >> "cfgMagazines" >> _x >> "displayname");
				_weapon_count = _magazines_count select _foreachIndex;
				if(_foreachIndex > 0)then{_text = _text + ", "};
				_text = _text + format["%1x %2", _weapon_count, _weapon];
			} foreach _magazines;
			_text = _text + _newLine;

			_text = _text + _newLine;
		};
	} forEach _all;

	hintsilent "Скопируйте текст из окна в буфер обмена и вставьте в блокнот!";

	if(!isNull (findDisplay 46))then
	{
		(findDisplay 46) createDisplay "Rsc_Kaban_DisplayText";
	}
	else
	{
		(findDisplay 52) createDisplay "Rsc_Kaban_DisplayText";
	};

	findDisplay 5187 displayCtrl 101 ctrlSetText _text;
	findDisplay 5187 displayCtrl 102 ctrlSetText "Описание";

	_text
};

fnc_kbn_create_description_short =
{
	_red 	= [];
	_blue 	= [];
	_green 	= [];
	_all = [_red, _blue, _green];

	_fnc_groupName =
	{
		_name = toArray(str _this);
		_shorten = [];
		for "_i" from 2 to ((count _name) - 1) do
		{
			_shorten set [_i - 2, _name select _i];
		};
		toString(_shorten)
	};

	{
		_group = _x;
		_count = {_x in playableUnits} count units _group;
		if(_count > 0)then
		{
			_name = _group call _fnc_groupName;
			_side = side _group;
			_side_num = [east, west, resistance] find _side;

			_location = (getPos leader _group) call fnc_kbn_nearest_location;
			_grp_data = [_name, _count, _location];

			private["_arr"];
			_arr = _all select _side_num;
			_arr 	set [count _arr, 	_grp_data];
		};
	} forEach allGroups;

	_newLine = toString [13, 10];
	_text = "";
	{
		_side_num = _foreachIndex;
		_groups = _x;
		if(count _groups > 0)then
		{
			_text = _text + (["Красные", "Синие", "Зеленые"] select _side_num) + _newLine;

			_units_total = 0;
			{
				_grp_data = _x;
				_name 			= _grp_data select 0;
				_count 			= _grp_data select 1;
				_location 		= _grp_data select 2;

				_units_total 	= _units_total + _count;

				_text = _text + format["%1 %2 (%3)", _name, _location, _count] + _newLine;

			} forEach _groups;

			_text = _text + _newLine + format["Всего: %1 чел.", _units_total] + _newLine;
			_text = _text + _newLine;
		};
	} forEach _all;

	hintsilent "Скопируйте текст из окна в буфер обмена и вставьте в блокнот!";

	if(!isNull (findDisplay 46))then
	{
		(findDisplay 46) createDisplay "Rsc_Kaban_DisplayText";
	}
	else
	{
		(findDisplay 52) createDisplay "Rsc_Kaban_DisplayText";
	};

	findDisplay 5187 displayCtrl 101 ctrlSetText _text;
	findDisplay 5187 displayCtrl 102 ctrlSetText "Описание";

	_text
};

fnc_kbn_find_vehicles_groups_and_cargo =
{
	_sides = [east, west, resistance, civilian];
	kbn_vehicles_groups = [[], [], [], [], [["Не приписано", []]]];
	{
		_group = _x;
		_countPlayable = {_x in playableUnits} count units _group;
		if(_countPlayable > 0)then
		{
			_sideIdx = _sides find (side _group);
			_sideGroups = kbn_vehicles_groups select _sideIdx;
			_sideGroups set [count _sideGroups, [_group, []]];
		};
	} forEach allGroups;

	kbn_cargo_crates = [];

	{
		_cargo = _x getVariable ["ace_sys_cargo_content", []];
		if(count _cargo > 0)then{kbn_cargo_crates = kbn_cargo_crates + _cargo};
	} forEach allMissionObjects "All";

	{
		_unit = _x;
		_name = getText (configFile >> "cfgVehicles" >> (typeOf _unit) >> "displayname");
		if((_unit isKindOf "AllVehicles" || _unit isKindOf "ReammoBox_F") && !(_unit isKindOf "Man") && !(_unit isKindOf "rhs_cargo_base") && (_name != "") && !(_unit in kbn_cargo_crates))then
		{
			_group = group nearestObject [_unit, "Man"];
			if!(isNull _group)then
			{
				_sideIdx = _sides find (side _group);
				_sideGroups = kbn_vehicles_groups select _sideIdx;
				{
					if(_x select 0 == _group)then
					{
						_vehs = _x select 1;
						_vehs set [count _vehs, _unit];
					};
				} forEach _sideGroups;
			}
			else
			{
				_sideGroups = kbn_vehicles_groups select 4;
				_vehs = (_sideGroups select 0) select 1;
				_vehs set [count _vehs, _unit];
			};
		};
	} forEach allMissionObjects "All";
};

fnc_kbn_get_vehicle_weapons =
{
	private ["_unit", "_newLine", "_text", "_vehCfg", "_weapons", "_magazines", "_turrets", "_turret", "_subturrets", "_weapon", "_weaponCfg", "_weaponName", "_hasAmmo", "_weaponMags", "_magazine", "_count", "_magazineCfg", "_magazineName", "_magazineCount"];
	_unit = _this;
	_newLine = toString [13, 10] + "	";
	_text = "";

	_vehCfg = configFile >> "cfgVehicles" >> (typeOf _unit);
	_weapons 	=  getArray(_vehCfg >> "weapons");
	_magazines 	= getArray(_vehCfg >> "magazines");
	_turrets = (_vehCfg >> "Turrets");
	for "_i" from 0 to (count _turrets) - 1 do {
		_turret = _turrets select _i;
		_weapons = _weapons + getArray(_turret >> "weapons");
		_removedWeapons = getArray(_turret >> "weapons") - (_unit weaponsTurret [_i]);
		_weapons = _weapons - _removedWeapons;
		_magazines = _magazines + getArray(_turret >> "magazines");
		_subturrets = _turret >> "Turrets";
		for "_j" from 0 to (count _subturrets) - 1 do {
			_turret = _subturrets select _j;
			_weapons = _weapons + getArray(_turret >> "weapons");
			_removedWeapons = getArray(_turret >> "weapons") - (_unit weaponsTurret [_i, _j]);
			_weapons = _weapons - _removedWeapons;
			_magazines = _magazines + getArray(_turret >> "magazines");
		};
	};

	_weapons = _weapons - ["FakeWeapon", "CarHorn", "TruckHorn", "BikeHorn", "TruckHorn2", "SportCarHorn", "MiniCarHorn"];

	{
		_weapon = _x;
		_weaponCfg = configFile >> "cfgWeapons" >> _weapon;
		_weaponName = getText(_weaponCfg >> "displayName");
		if(_weaponName == "")then{_weaponName = _weapon};
		_text = _text + _weaponName;

		_hasAmmo = false;

		_weaponMags = getArray(_weaponCfg >> "Magazines");
		{
			_magazine = _x;
			_count = {_x == _magazine} count _magazines;
			_magazines = _magazines - [_magazine];
			if(_count > 0)then
			{
				if!(_hasAmmo)then
				{
					_hasAmmo = true;
					_text = _text + " (";
				}
				else
				{
					_text = _text + ", ";
				};

				_magazineCfg = configFile >> "cfgMagazines" >> _magazine;
				_magazineName = getText(_magazineCfg >> "displayName");
				_magazineCount = getNumber(_magazineCfg >> "count");

				_text = _text + str(_magazineCount * _count) + "х " + _magazineName;
			};
		} forEach _weaponMags;

		if(_hasAmmo)then
		{
			_text = _text + ")";
		};

		_text = _text + _newLine;

	} forEach _weapons;

	_text
};

fnc_kbn_create_veh_description =
{
	if(isNil "kbn_vehicles_groups")then
	{
		call fnc_kbn_find_vehicles_groups_and_cargo;
	};

	_newLine = toString [13, 10];
	_text = "Техника:" + _newLine;

	_fnc_groupName =
	{
		private ["_name", "_shorten"];
		if(typeName _this == "STRING")exitWith{_this};
		if(isNull _this)exitWith{""};

		_name = toArray(str _this);
		_shorten = [];
		for "_i" from 2 to ((count _name) - 1) do
		{
			_shorten set [_i - 2, _name select _i];
		};
		toString(_shorten)
	};

	{
		_sideGroups = _x;
		if(count _sideGroups > 0) then
		{
			_sideName = ["КРАСНЫЕ", "СИНИЕ", "ЗЕЛЕНЫЕ", "ГРАЖДАНСКИЕ", "БЕСХОЗНЫЕ"] select _foreachIndex;
			_text = _text + _sideName + _newLine;

			{
				_groupVehs = _x;
				_group = _groupVehs select 0;
				_vehs = _groupVehs select 1;

				_group_name = _group call _fnc_groupName;

				{
					_unit = _x;
					_name = _unit getVariable ["kbn_description", ""];
					if(_name == "")then
					{
						_name = getText (configFile >> "cfgVehicles" >> (typeOf _unit) >> "displayname");
					};

					if((_unit isKindOf "AllVehicles" || _unit isKindOf "ReammoBox_F") && !(_unit isKindOf "Man") && !(_unit isKindOf "rhs_cargo_base") && (_name != "") && !(_unit in kbn_cargo_crates))then
					{
						_location = (getPos _unit) call fnc_kbn_nearest_location;
						_text = _text + format["%2 (%3, %1)", _group_name, _name, _location] + _newLine;

						_weapons_text = _unit call fnc_kbn_get_vehicle_weapons;
						if(_weapons_text != "")then
						{
							_text = _text + "	" + _weapons_text
						};

						_totalWeapons 	= count (getWeaponCargo 	_unit select 0);
						_totalMagazines = count (getMagazineCargo 	_unit select 0);
						_totalBackpacks = count (getBackpackCargo 	_unit select 0);

						if(_totalWeapons + _totalMagazines + _totalBackpacks > 0)then
						{
							_text = _text + "	";
						};

						_cargo = getWeaponCargo _unit;
						_weapons 	= _cargo select 0;
						_counts 	= _cargo select 1;
						{
							if(_foreachIndex > 0)then{_text = _text + ", "};
							_name 	= getText (configFile >> "cfgWeapons" >> _x >> "displayname");
							_count 	= _counts select _foreachIndex;
							_text = _text + format["%1x %2", _count, _name];
						} forEach _weapons;

						_cargo = getMagazineCargo _unit;
						_weapons 	= _cargo select 0;
						_counts 	= _cargo select 1;
						{
							if(_foreachIndex > 0 || _totalWeapons > 0)then{_text = _text + ", "};
							_name 	= getText (configFile >> "cfgMagazines" >> _x >> "displayname");
							_count 	= _counts select _foreachIndex;
							_text = _text + format["%1x %2", _count, _name];
						} forEach _weapons;

						_cargo = getBackpackCargo _unit;
						_weapons 	= _cargo select 0;
						_counts 	= _cargo select 1;
						{
							if(_foreachIndex > 0 || (_totalWeapons + _totalMagazines) > 1)then{_text = _text + ", "};
							_name 	= getText (configFile >> "cfgWeapons" >> _x >> "displayname");
							_count 	= _counts select _foreachIndex;
							_text = _text + format["%1x %2", _count, _name];
						} forEach _weapons;

						if(_totalWeapons + _totalMagazines + _totalBackpacks > 0)then
						{
							_text = _text + _newLine;
						};

						_cargos = _x getVariable ["ace_sys_cargo_content", []];
						if(count _cargos > 0)then
						{
							_text = _text + "Багаж:" + _newLine + "	";


							{
								_unit = _x;
								_name = _unit getVariable ["kbn_description", ""];
								if(_name == "")then
								{
									_name = getText (configFile >> "cfgVehicles" >> (typeOf _unit) >> "displayname");
								};

								_text = _text + _name + _newLine + "	";

								_totalWeapons 	= count (getWeaponCargo 	_unit select 0);
								_totalMagazines = count (getMagazineCargo 	_unit select 0);
								_totalBackpacks = count (getBackpackCargo 	_unit select 0);

								_cargo = getWeaponCargo _unit;
								_weapons 	= _cargo select 0;
								_counts 	= _cargo select 1;
								{
									if(_foreachIndex > 0)then{_text = _text + ", "};
									_name 	= getText (configFile >> "cfgWeapons" >> _x >> "displayname");
									_count 	= _counts select _foreachIndex;
									_text = _text + format["%1x %2", _count, _name];
								} forEach _weapons;

								_cargo = getMagazineCargo _unit;
								_weapons 	= _cargo select 0;
								_counts 	= _cargo select 1;
								{
									if(_foreachIndex > 0 || _totalWeapons > 0)then{_text = _text + ", "};
									_name 	= getText (configFile >> "cfgMagazines" >> _x >> "displayname");
									_count 	= _counts select _foreachIndex;
									_text = _text + format["%1x %2", _count, _name];
								} forEach _weapons;

								_cargo = getBackpackCargo _unit;
								_weapons 	= _cargo select 0;
								_counts 	= _cargo select 1;
								{
									if(_foreachIndex > 0 || (_totalWeapons + _totalMagazines) > 1)then{_text = _text + ", "};
									_name 	= getText (configFile >> "cfgWeapons" >> _x >> "displayname");
									_count 	= _counts select _foreachIndex;
									_text = _text + format["%1x %2", _count, _name];
								} forEach _weapons;

								if(_totalWeapons + _totalMagazines + _totalBackpacks > 0)then
								{
									_text = _text + _newLine + "	";
								};

							} forEach _cargos;


						};

						_text = _text + _newLine;
					};
				} forEach _vehs;
			} forEach _sideGroups;
		};
	} forEach kbn_vehicles_groups;

	hintsilent "Скопируйте текст из окна в буфер обмена и вставьте в блокнот!";

	if(!isNull (findDisplay 46))then
	{
		(findDisplay 46) createDisplay "Rsc_Kaban_DisplayText";
	}
	else
	{
		(findDisplay 52) createDisplay "Rsc_Kaban_DisplayText";
	};
	findDisplay 5187 displayCtrl 101 ctrlSetText _text;
	findDisplay 5187 displayCtrl 102 ctrlSetText "Описание";
	_text
};

fnc_kbn_create_veh_description_short =
{
	if(isNil "kbn_vehicles_groups")then
	{
		call fnc_kbn_find_vehicles_groups_and_cargo;
	};

	_newLine = toString [13, 10];
	_text = "Техника:" + _newLine;

	_fnc_groupName =
	{
		private ["_name", "_shorten"];
		if(typeName _this == "STRING")exitWith{_this};
		if(isNull _this)exitWith{""};

		_name = toArray(str _this);
		_shorten = [];
		for "_i" from 2 to ((count _name) - 1) do
		{
			_shorten set [_i - 2, _name select _i];
		};
		toString(_shorten)
	};

	{
		_sideGroups = _x;
		if(count _sideGroups > 0) then
		{
			_sideName = ["КРАСНЫЕ", "СИНИЕ", "ЗЕЛЕНЫЕ", "ГРАЖДАНСКИЕ", "БЕСХОЗНЫЕ"] select _foreachIndex;
			_text = _text + _sideName + _newLine;
			_arr = [];
			{
				_groupVehs = _x;
				_group = _groupVehs select 0;
				_vehs = _groupVehs select 1;

				_group_name = _group call _fnc_groupName;

				{
					_unit = _x;
					_name = _unit getVariable ["kbn_description", ""];
					if(_name == "")then
					{
						_name = getText (configFile >> "cfgVehicles" >> (typeOf _unit) >> "displayname");
					};

					if((_unit isKindOf "AllVehicles") && !(_unit isKindOf "ReammoBox_F") && !(_unit isKindOf "Man") && !(_unit isKindOf "rhs_cargo_base") && (_name != "") && !(_unit in kbn_cargo_crates))then
					{
						_arr set [count _arr, _name];
					};
				} forEach _vehs;
			} forEach _sideGroups;

			while{count _arr > 0}do
			{
				_count = count _arr;
				_veh = _arr select 0;
				_arr = _arr - [_veh];
				_count = _count - count _arr;
				_text = _text + format["%1x %2", _count, _veh] + _newLine;
			};
		};
	} forEach kbn_vehicles_groups;

	hintsilent "Скопируйте текст из окна в буфер обмена и вставьте в блокнот!";

	if(!isNull (findDisplay 46))then
	{
		(findDisplay 46) createDisplay "Rsc_Kaban_DisplayText";
	}
	else
	{
		(findDisplay 52) createDisplay "Rsc_Kaban_DisplayText";
	};
	findDisplay 5187 displayCtrl 101 ctrlSetText _text;
	findDisplay 5187 displayCtrl 102 ctrlSetText "Описание";
	_text
};

fnc_kbn_create_convent_description =
{
	_newLine = toString [13, 10];
	_text = localize "convent";
	_text = [_text, "<br/>", _newLine] call CBA_fnc_replace;
	//createDialog "RscDisplayEditDiaryRecord"; //idd 125
	if(!isNull (findDisplay 46))then
	{
		(findDisplay 46) createDisplay "Rsc_Kaban_DisplayText"; //idd 5187
	}
	else
	{
		(findDisplay 52) createDisplay "Rsc_Kaban_DisplayText";  //idd 5187
	};
	findDisplay 5187 displayCtrl 101 ctrlSetText _text;
	findDisplay 5187 displayCtrl 102 ctrlSetText "Условности";
	_text
};

fnc_kbn_create_briefing_description =
{
	_side = _this;
	_suff = "_gue";
	if(_side == east)then{_suff = "_rf";};
	if(_side == west)then{_suff = "_bf";};

	_who = "зеленых";
	if(_side == east)then{_who = "красных";};
	if(_side == west)then{_who = "синих";};

	_newLine = toString [13, 10];
	_text = ""
	+ localize "situation_title" + " для " + _who + "<br/><br/>"
	+ localize ("situation" + _suff) + "<br/><br/>"
	+ localize "task_title" + " для " + _who + "<br/><br/>"
	+ localize ("task" + _suff) + "<br/><br/>"
	+ localize "execution_title" + " для " + _who + "<br/><br/>"
	+ localize ("execution" + _suff) + "<br/><br/>"
	;
	_text = [_text, "<br/>", _newLine] call CBA_fnc_replace;
	//createDialog "RscDisplayEditDiaryRecord"; //idd 125
	if(!isNull (findDisplay 46))then
	{
		(findDisplay 46) createDisplay "Rsc_Kaban_DisplayText"; //idd 5187
	}
	else
	{
		(findDisplay 52) createDisplay "Rsc_Kaban_DisplayText";  //idd 5187
	};
	findDisplay 5187 displayCtrl 101 ctrlSetText _text;
	findDisplay 5187 displayCtrl 102 ctrlSetText "Брифинг для " + _who;
	_text
};

//управление маркерами
fnc_kbn_create_all_markers =
{
	call fnc_kbn_create_build_markers;
	call fnc_kbn_create_ammo_markers;
	call fnc_kbn_create_vehicles_markers;
	call fnc_kbn_create_bot_markers;
	call fnc_kbn_create_respawn_markers;
};

fnc_kbn_delete_all_markers =
{
	{deleteMarker _x} forEach kbn_resp_markers;
	{deleteMarker _x} forEach kbn_veh_markers;
	{deleteMarker _x} forEach kbn_ammo_markers;
	{deleteMarker _x} forEach kbn_build_markers;
	{deleteMarker _x} forEach kbn_bot_markers;
};

fnc_kbn_show_all_markers =
{
	call fnc_kbn_show_build_markers;
	call fnc_kbn_show_ammo_markers;
	call fnc_kbn_show_vehicles_markers;
	call fnc_kbn_show_bot_markers;
	call fnc_kbn_show_respawn_markers;
};

fnc_kbn_hide_all_markers =
{
	call fnc_kbn_hide_build_markers;
	call fnc_kbn_hide_ammo_markers;
	call fnc_kbn_hide_vehicles_markers;
	call fnc_kbn_hide_bot_markers;
	call fnc_kbn_hide_respawn_markers;
};

fnc_kbn_showAllSerpMarkers =
{
	{
		call compile format["SerP_markers_%1 call SerP_updateMarkers;",_x];
	} forEach [east,west,resistance,civilian];
};

fnc_kbn_hideAllSerpMarkers =
{
	{
		[["All"],[]] call SerP_updateMarkers;
	} forEach [east,west,resistance,civilian];
};

fnc_kbn_findMarkerUnderCursor =
{
	//hint str ctrlMapMouseOver ((findDisplay 12) displayCtrl 51)
	//["marker","_USER_DEFINED #2/1"]

	_cursorTarget = [];
	if(!isNull (findDisplay 12))then
	{
		_cursorTarget = ctrlMapMouseOver ((findDisplay 12) displayCtrl 51);
	}
	else
	{
		_cursorTarget = ctrlMapMouseOver ((findDisplay 52) displayCtrl 51);
	};

	if(count _cursorTarget > 0)then{if(_cursorTarget select 0 == "marker")then{_cursorTarget select 1}else{""}}else{""};
};

fnc_kbn_saveAllMyMarkers =
{
	_markers_to_save = [];
	_counter = 0;

	for "_i" from 0 to kbn_all_markers_counter do
	{
		_marker = format["_kbn_saved_%1", _i];
		if(markerType _marker != "")then
		{
			_markers_to_save set [count _markers_to_save,
			[format["marker_%1", _counter],
			markerAlpha _marker,
			markerBrush _marker,
			markerColor _marker,
			markerDir 	_marker,
			markerPos 	_marker,
			markerShape _marker,
			markerSize 	_marker,
			markerText 	_marker,
			markerType 	_marker]];

			_counter = _counter + 1;
		};
	};

	for "_i" from 0 to 1000 do
	{
		_marker = format["_USER_DEFINED #2/%1", _i];
		if(markerType _marker != "")then
		{
			_markers_to_save set [count _markers_to_save,
			[format["marker_%1", _counter],
			markerAlpha _marker,
			markerBrush _marker,
			markerColor _marker,
			markerDir 	_marker,
			markerPos 	_marker,
			markerShape _marker,
			markerSize 	_marker,
			markerText 	_marker,
			markerType 	_marker]];

			_counter = _counter + 1;
		};
	};

	kbn_saved_markers = _markers_to_save;
	profileNamespace setVariable [format["kbn_saved_markers_%1", _this], kbn_saved_markers];
	saveProfileNamespace;
	_markers_to_save
};

fnc_kbn_loadAllMyMarkers =
{
	_markers_to_load = profileNamespace getVariable [format["kbn_saved_markers_%1", _this], nil];
	if(!isNil "_markers_to_load")then
	{
		{
			//_marker = _x select 0;
			_marker = "_kbn_saved_" + str(kbn_all_markers_counter);
			kbn_all_markers_counter = kbn_all_markers_counter + 1;
			_marker = createMarker [_marker, _x select 5];
			_marker setMarkerAlpha 	(_x select 1);
			_marker setMarkerBrush 	(_x select 2);
			_marker setMarkerColor 	(_x select 3);
			_marker setMarkerDir 	(_x select 4);
			_marker setMarkerShape 	(_x select 6);
			_marker setMarkerSize 	(_x select 7);
			_marker setMarkerText 	(_x select 8);
			_marker setMarkerType 	(_x select 9);
		} forEach _markers_to_load;
	};
};

fnc_kbn_clearAllMyMarkers =
{
	for "_i" from 0 to 1000 do
	{
		_marker = format["_USER_DEFINED #2/%1", _i];
		deleteMarker _marker;
	};

	for "_i" from 0 to 1000 do
	{
		_marker = format["_kbn_saved_%1", _i];
		deleteMarker _marker;
	};
};

//kbn_all_markers set [count kbn_all_markers, marker];

//клавиатура и мышь
fnc_kbn_clear_selection =
{
	{
		_x setMarkerAlpha 1;
	} forEach kbn_selected;
	kbn_selected = [];
};

fnc_kbn_onKeyDown =
{
	_result = false;
	if(kbn_debug)then{systemChat str ["KeyDown", _this];};
	_key = _this select 1;
	_shift = _this select 2;
	if(_key == 211)then //DELETE
	{
		_result = true;
	};

	if(_key == 35)then // H
	{
		_marker = call fnc_kbn_findMarkerUnderCursor;
		if(_marker != "")then
		{
			_shift = _this select 2;
			_ctrl = _this select 3;
			if(_shift)then //Shift+H - hide
			{
				_marker setMarkerAlpha 0;
			};
			if(_ctrl)then //Ctrl+H - hide
			{
				_marker setMarkerAlpha 1;
			};
		};
	};

	if(_key == 20)then // T
	{
		_pos = [0,0];
		if(!isNull (findDisplay 12))then
		{
			_pos = ((findDisplay 12) displayCtrl 51) ctrlMapScreenToWorld [kbn_mouse_x, kbn_mouse_y];
		}
		else
		{
			_pos = ((findDisplay 52) displayCtrl 51) ctrlMapScreenToWorld [kbn_mouse_x, kbn_mouse_y];
		};
		_marker = _pos call fnc_kbn_createHeightMarker;
	};

	_result
};

//окна
fnc_kbn_markers_handler_old =
{
	if(kbn_debug)then{systemChat str ["fnc_kbn_markers_handler", _this]};
	_key 	= _this select 1;
	_shift 	= _this select 2;
	_ctrl 	= _this select 3;
	_alt 	= _this select 4;

	if (_key in [201,209]) exitWith
	{
		_dir = if(_key == 201)then{1}else{-1};
		kbn_history_position = kbn_history_position + _dir;
		if(kbn_history_position < 0)then{kbn_history_position = 0;};
		if(kbn_history_position >= count kbn_marker_name_history)then{kbn_history_position = (count kbn_marker_name_history) - 1;};
		_text = kbn_marker_name_history select kbn_history_position;
		((findDisplay 54) displayCtrl 101) ctrlSetText _text;
		true
	};

	if (kbn_renaming && _key in [28,156]) exitWith
	{
		kbn_last_marker_text = ctrlText ((findDisplay 54) displayCtrl 101);
		kbn_last_marker_text call fnc_kbn_add_title_to_history;
		kbn_renaming_marker setMarkerText kbn_last_marker_text;
		kbn_renaming_marker setMarkerAlpha 1;
		kbn_renaming = false;
		(findDisplay 54) closeDisplay 0;
		true
	};

	if (kbn_renaming && _key in [200,208]) exitWith
	{
		_dir = if(_key == 208)then{1}else{-1};
		if(_shift)then
		{
			_color = MarkerColor kbn_renaming_marker;
			_newColor = [kbn_markerColors, _color, _dir] call fnc_kbn_getNextInArray;
			kbn_renaming_marker setMarkerColor _newColor;
			kbn_renaming_marker setMarkerAlpha 1;
		}
		else
		{
			_type = MarkerType kbn_renaming_marker;
			_newType = [kbn_markerTypes, _type, _dir] call fnc_kbn_getNextInArray;
			kbn_renaming_marker setMarkerType _newType;
			kbn_renaming_marker setMarkerAlpha 1;
		};
		true
	};

	if (!kbn_renaming && _key in [28,156]) exitWith
	{
		kbn_last_marker_text = ctrlText ((findDisplay 54) displayCtrl 101);
		kbn_last_marker_text call fnc_kbn_add_title_to_history;
		if (_ctrl) then
		{
			[_this select 0] call c_persistent_markers_markerHandle;
			(findDisplay 54) closeDisplay 0;
			true
		}
		else
		{
			if(kbn_insert_nickname)then
			{
				((findDisplay 54) displayCtrl 101) ctrlSetText ((name player) + ' ' + (ctrlText ((findDisplay 54) displayCtrl 101)));
			};
			false
		};
	};

	false
};

fnc_kbn_markers_handler_new =
{
	if ((_this select 1) in [28,156]) then
	{
		_text = ctrlText ((findDisplay 54) displayCtrl 101);
		_pic_pos = ctrlPosition ((findDisplay 54) displayCtrl 102);
		_mark_pos = [(_pic_pos select 0) + (_pic_pos select 2) / 2, (_pic_pos select 1) + (_pic_pos select 3) / 2];
		_pos = [0,0];
		if(!isNull (findDisplay 12))then
		{
			_pos = ((findDisplay 12) displayCtrl 51) ctrlMapScreenToWorld _mark_pos;
		}
		else
		{
			_pos = ((findDisplay 52) displayCtrl 51) ctrlMapScreenToWorld _mark_pos;
		};
		if(kbn_debug)then{systemChat str [_pic_pos, _mark_pos, _pos];};

		_marker = "_kbn_marker_" + str(kbn_all_markers_counter);
		kbn_all_markers_counter = kbn_all_markers_counter + 1;
		_marker = createMarker [_marker, _pos];
		_marker setMarkerText _text;
		_marker setMarkerColor "ColorYellow";
		_marker setMarkerShape "ICON";
		_marker setMarkerType "mil_dot";
		_marker setMarkerSize [1, 1];

		kbn_all_markers set [count kbn_all_markers, _marker];
		kbn_last_marker_text = _text;
		kbn_last_marker_text call fnc_kbn_add_title_to_history;
		//(findDisplay 54) closeDisplay 0;
		closeDialog 0;
	};
	true
};

fnc_kbn_markers_handler = fnc_kbn_markers_handler_old;

//тайминг
fnc_kbn_createTimingMarker =
{
	_marker = "_kbn_saved_" + str(kbn_all_markers_counter);
	kbn_all_markers_counter = kbn_all_markers_counter + 1;
	_marker = createMarker [_marker, position player];
	_marker setMarkerShape "ICON";
	_marker setMarkerType "mil_triangle";
	_marker setMarkerColor kbn_timing_color;
	_marker setMarkerSize [0.5, 0.5];

	_timing = floor(diag_tickTime - kbn_timing_start_time);
	_hours = floor(_timing / 3600);
	_minuts = floor((_timing - (_hours * 3600)) / 60);
	_seconds = floor(_timing - (_hours * 3600) - (_minuts * 60));
	_text = format ["%1%2:%3%4:%5%6",
		if(_hours > 9)then{""}else{0}, _hours,
		if(_minuts > 9)then{""}else{0}, _minuts,
		if(_seconds > 9)then{""}else{0}, _seconds];
	_marker setMarkerText _text;
};

fnc_kbn_timing_start =
{
	terminate kbn_timing_thread;
	kbn_timing_color = _this;
	kbn_timing = true;
	kbn_timing_thread = [] spawn
	{
		kbn_timing_start_time = diag_tickTime;
		kbn_timing_next_time = kbn_timing_start_time;
		while{kbn_timing}do
		{
			_distance = kbn_timing_last_position distance (position player);
			if(_distance > 10 && ((diag_tickTime >= kbn_timing_next_time) || (_distance >= 300) || visibleMap))then
			{
				call fnc_kbn_createTimingMarker;
				kbn_timing_last_position = position player;
				waitUntil{!visibleMap};
				kbn_timing_next_time = diag_tickTime + 30;
			};
			sleep 0.1;
		};
	};
};

fnc_kbn_timing_stop =
{
	terminate kbn_timing_thread;
	kbn_timing = false;
	_distance = kbn_timing_last_position distance (position player);
	if(_distance > 10)then
	{
		call fnc_kbn_createTimingMarker;
	};
	kbn_timing_last_position = position player;
};

//высотомер
fnc_kbn_createHeightMarker =
{
	_pos = _this;
	_elevationOffset = getNumber(configFile >> "cfgWorlds" >> worldName >> "elevationOffset");
	_marker = "_kbn_saved_" + str(kbn_all_markers_counter);
	kbn_all_markers_counter = kbn_all_markers_counter + 1;
	_marker = createMarker [_marker, _pos];
	_marker setMarkerShape "ICON";
	_marker setMarkerType "mil_triangle";
	_marker setMarkerColor "ColorBlack";
	_text = str (round (getTerrainHeightASL _pos) + _elevationOffset);
	_marker setMarkerText _text;
	_marker setMarkerDir 180;
	_marker setMarkerSize [0.5, 0.5];
};

//подсветка
fnc_kbn_createHighlightMarker =
{
	_pos = [0,0];
	if(!isNull (findDisplay 12))then
	{
		_pos = ((findDisplay 12) displayCtrl 51) ctrlMapScreenToWorld [kbn_mouse_x, kbn_mouse_y];
	}
	else
	{
		_pos = ((findDisplay 52) displayCtrl 51) ctrlMapScreenToWorld [kbn_mouse_x, kbn_mouse_y];
	};

	_marker = "kbn_highlight_" + str(kbn_highlight_markers_counter);
	kbn_highlight_markers_counter = kbn_highlight_markers_counter + 1;
	_marker = createMarker [_marker, _pos];
	_marker setMarkerShape "ICON";
	_marker setMarkerType "mil_dot";
	_marker setMarkerColor "ColorYellow";
	_marker setMarkerText (name player);
	_marker setMarkerSize [1.5, 1.5];
	kbn_highlights_markers set [count kbn_highlights_markers, _marker];

	createVehicle ["SmokeShellYellow", _pos, [], 0, "FLY"]
};

//утилиты
fnc_kbn_createMarkerCopy =
{
	_marker = _this;
	if(markerShape _marker == "")exitWith{_marker};

	_markerCopy = "_kbn_saved_" + str(kbn_all_markers_counter);
	kbn_all_markers_counter = kbn_all_markers_counter + 1;
	_markerCopy = createMarker [_markerCopy, markerPos _marker];
	_markerCopy setMarkerShape (markerShape _marker);
	_markerCopy setMarkerType (markerType _marker);
	_markerCopy setMarkerColor (markerColor _marker);
	_markerCopy setMarkerDir (markerDir _marker);
	_markerCopy setMarkerSize (markerSize _marker);
	_markerCopy setMarkerBrush (markerBrush _marker);
	_markerCopy setMarkerText (markerText _marker);
	_markerCopy
};

fnc_kbn_createLastMarkerCopy =
{
	if(kbn_last_edited_marker == "")exitWith{};

	_pos = [0,0];
	if(!isNull (findDisplay 12))then
	{
		_pos = ((findDisplay 12) displayCtrl 51) ctrlMapScreenToWorld [kbn_mouse_x, kbn_mouse_y];
	}
	else
	{
		_pos = ((findDisplay 52) displayCtrl 51) ctrlMapScreenToWorld [kbn_mouse_x, kbn_mouse_y];
	};

	_markerCopy = kbn_last_edited_marker call fnc_kbn_createMarkerCopy;
	_markerCopy setMarkerPos _pos;
	_newText = (markerText kbn_last_edited_marker) call fnc_kbn_incrementText;
	_markerCopy setMarkerText _newText;

	kbn_last_edited_marker = _markerCopy;
};

fnc_kbn_newMarkerText =
{
	if(kbn_renaming)exitWith{kbn_last_marker_text};
	""
};

fnc_kbn_incrementText =
{
	_source = toArray _this;
	_digits = toArray "0123456789";
	_zero = _digits select 0;
	_found = false;
	_multi = 1;
	_number = 0;
	_i = (count _source) - 1;
	while{!_found && _i >= 0}do
	{
		_char = _source select _i;
		if!(_char in _digits)exitWith{_found = true;};
		_number = _number + (_char - _zero) * _multi;
		_i = _i - 1;
		_multi = _multi * 10;
	};

	if(_i == ((count _source) - 1))then
	{
		_this
	}
	else
	{
		_source resize (_i + 1);
		(toString _source) + (str(_number + 1))
	};
};

fnc_kbn_getNextInArray =
{
	_array 	= _this select 0;
	_value 	= _this select 1;
	_dir 	= _this select 2;

	_ind = _array find _value;
	if(_ind < 0)exitWith{_value};

	_ind = _ind + _dir;
	if(_ind < 0)then{_ind = (count _array) - 1;};
	if(_ind >= count _array)then{_ind = 0;};

	_array select _ind
};

fnc_kbn_add_title_to_history =
{
	_title 	= _this;
	_player = name player;
	kbn_marker_name_history = kbn_marker_name_history - [_title] + [_title] - [_player] + [_player] - [""];
	kbn_history_position = (count kbn_marker_name_history) - 1;
};

fnc_kbn_selectPlayer =
{
	private ["_unit"];
	_unit = _this;
	selectPlayer _unit;
	[] spawn
	{
		sleep 0.1;
		waitUntil{player == player};
		call compile preprocessFileLineNumbers "SerP\briefing.sqf";
		call fnc_kbn_create_menu;
		call fnc_kbn_show_groups_info;
	};
};

fnc_kbn_selectPlayerCursorTarget =
{
	(cursorTarget) call fnc_kbn_selectPlayer;
};
if(isServer)then //сделаем, чтобы боты не исчезали после war begins
{
	[] spawn
	{
		sleep 0.1;
		{
			_x setVariable ["SerP_isPlayer", true, true];
		} forEach playableUnits;
	};
};

if (isDedicated) exitWith {};

if(isServer)then //создание маркеров на старте
{
	[] spawn
	{
		uiSleep 1;
		call fnc_kbn_create_all_markers; //на выделенном сервере маркеры не создаются
	};
};

//меню
fnc_kbn_show_groups_info =
{
	player createDiarySubject ["kbn_units", "Отряды"];

	_addExtPAA =
	{
		private["_path", "_array", "_len", "_last4"];
		_path = toLower _this;
		_array = toArray(_path);
		_len = count _array;
		_last4 = toString[_array select _len-4, _array select _len-3, _array select _len-2, _array select _len-1];
		if(_last4 == ".paa")then {_this} else {_this + ".paa"};
	};

	_addToArray =
	{
		private["_value", "_array", "_count", "_found", "_x", "_forEachIndex"];
		_value = _this select 0;
		_array = _this select 1;
		_count = _this select 2;
		_found = false;
		{
			if(_x select 0 == _value)exitWith
			{
				_found = true;
				_array set [_forEachIndex, [_value, (_x select 1) + _count]];
			};
		}forEach _array;

		if(!_found)then
		{
			_array set [count _array, [_value, _count]];
		};
	};

	_all_units_counter = 0;
	_addGroupUnitToDiary =
	{
		_unit = _this select 0;
		_number = _this select 1;
		_desc = _unit getVariable ["kbn_description", ""];

		_unit_var = "kbn_unit_" + (str _all_units_counter);
		missionNamespace setVariable [_unit_var, _unit];
		_text = _text + "<font color='#FFFFBB'><execute expression='" + _unit_var + " call fnc_kbn_selectPlayer'>" + (str _number) + ". " + _desc + "</execute></font> ";

		_all_units_counter = _all_units_counter + 1;

		if(primaryWeapon _unit != "")then
		{
			_name = getText(configFile >> "CfgWeapons" >> (primaryWeapon _unit) >> "displayName");
			_text = _text + " - " + _name;
		};
		_text = _text + "<br/>";

		_weaponsPrimary = [primaryWeapon _unit, secondaryWeapon _unit] - [""];
		_weapons = weapons _unit - _weaponsPrimary - ["Binocular","lerca_1200_black","Rangefinder","Laserdesignator","lerca_1200_tan","BWA3_Vector","AGM_Vector"];
		_items = assignedItems _unit - [""];
		{
			_cfg = configFile >> "CfgWeapons" >> _x;
			_pic = getText(_cfg >> "picture") call _addExtPAA;
			_text = _text + "<img image=""" + _pic + """ height=40 /> ";
		} forEach (_weaponsPrimary)+(primaryWeaponItems _unit - [""]);
		_text = _text + "<br/>";

		_weaponsList = [];
		_magasinesList = [];

		{
			_cfg = configFile >> "CfgWeapons" >> _x;
			_pic = getText(_cfg >> "picture") call _addExtPAA;
			if(!(_x in items _unit))then
			{
				[_pic, _weaponsList, 1] call _addToArray;
			};
		} forEach (_weapons)+(handgunItems _unit - [""]);

			{
			_cfg = configFile >> "CfgWeapons" >> _x;
			_pic = getText(_cfg >> "picture") call _addExtPAA;
			[_pic, _weaponsList, 1] call _addToArray;
		} forEach (_items);

			{
			_cfg = configFile >> "CfgMagazines" >> _x;
			_pic = getText(_cfg >> "picture") call _addExtPAA;
			[_pic, _magasinesList, 1] call _addToArray;
		} forEach (magazines _unit);

		{
			_pic = _x select 0;
			_count = _x select 1;
			for "_i" from 1 to _count do
			{
				_text = _text + "<img image=""" + _pic + """ height=24 /> ";
			};
		}forEach _weaponsList;
		_text = _text + "<br/>";

		{
			_pic = _x select 0;
					_count = _x select 1;
					_count = str _count;
					_text = _text + "<img image=""" + _pic + """ height=24 /> " + "x" + _count + "    ";
			}forEach _magasinesList;
		_text = _text + "<br/>";
	};

	_addGroupToDiary =
	{
		private["_group", "_text", "_name", "_shorten"];
		_group = _this;
		if(count units _group > 0)then
		{
			_text = "";
			{[_x, _forEachIndex + 1] call _addGroupUnitToDiary;} forEach units _group;
			_name = toArray(str _group);
			_shorten = [];
			for "_i" from 2 to ((count _name) - 1) do
			{
				_shorten set [_i - 2, _name select _i];
			};
			_name = toString(_shorten);
			if(side _group == side player)then
			{
				player createDiaryRecord ["kbn_units", ["Наш отряд " + _name + " (" + str(count units _group) + ")", _text]];
			}
			else
			{
				player createDiaryRecord ["kbn_units", ["Противник " + _name + " (" + str(count units _group) + ")", _text]];
			};
		};
	};

	for "_i" from (count allGroups) - 1 to 0 step -1 do
	{
		_group = allGroups select _i;
		_group call _addGroupToDiary;
	};
};

fnc_kbn_create_menu =
{
	player createDiarySubject ["TU_actions", "Действия"];
	player createDiaryRecord ["TU_actions", ["Горячие клавиши",
	"<font color='#FFFF55'>[ЛКМ]</font> Редактировать маркер
	<br /><font color='#FFFF55'>[ЛКМ + Тащить]</font> Переместить маркер
	<br /><font color='#FFFF55'>[Delete]</font> Удалить маркер
	<br /><font color='#FFFF55'>[Shift+ЛКМ]</font> Редактировать любой маркер
	<br /><font color='#FFFF55'>[Shift+ЛКМ + Тащить]</font> Переместить любой маркер
	<br /><font color='#FFFF55'>[Shift+Delete]</font> Удалить любой маркер
	<br /><font color='#FFFF55'>[Ctrl+ЛКМ + Тащить]</font> Копировать маркер
	<br /><font color='#FFFF55'>[Ctrl + Клик]</font> Создать копию последнего маркера
	<br /><font color='#FFFF55'>[Shift+H]</font> Скрыть маркер
	<br /><font color='#FFFF55'>[Ctrl+H]</font> Показать маркер
	<br /><font color='#FFFF55'>[Alt+ЛКМ]</font> Подсветить позицию
	<br /><font color='#FFFF55'>[T]</font> Установить отметку высоты
	<br /><font color='#FFFF55'>[PgUp/PgDn]</font> История заголовков маркеров
	"]];

	player createDiaryRecord ["TU_actions", ["Подготовка к СГ - Тайминг",
	"Начать замер:
	 <br /><font color='#00FF00'>[<executeClose expression='""ColorGreen"" call fnc_kbn_timing_start'>Зеленый</executeClose>]</font>
	 <br /><font color='#0000FF'>[<executeClose expression='""ColorBlue"" call fnc_kbn_timing_start'>Синий</executeClose>]</font>
	 <br /><font color='#FFFF00'>[<executeClose expression='""ColorYellow"" call fnc_kbn_timing_start'>Желтый</executeClose>]</font>
	 <br /><font color='#FF8800'>[<executeClose expression='""ColorOrange"" call fnc_kbn_timing_start'>Оранжевый</executeClose>]</font>
	 <br /><font color='#FF8888'>[<executeClose expression='""ColorPink"" call fnc_kbn_timing_start'>Розовый</executeClose>]</font>
	 <br /><font color='#FF0000'>[<executeClose expression='""ColorRed"" call fnc_kbn_timing_start'>Красный</executeClose>]</font>
	 <br /><font color='#884400'>[<executeClose expression='""ColorBrown"" call fnc_kbn_timing_start'>Коричневый</executeClose>]</font>
	 <br /><font color='#88BB88'>[<executeClose expression='""ColorKhaki"" call fnc_kbn_timing_start'>Хаки</executeClose>]</font>
	 <br /><font color='#000000'>[<executeClose expression='""ColorBlack"" call fnc_kbn_timing_start'>Черный</executeClose>]</font>
	 <br /><font color='#888888'>[<executeClose expression='""ColorGrey"" call fnc_kbn_timing_start'>Серый</executeClose>]</font>
	 <br /><font color='#FFFFFF'>[<executeClose expression='""ColorWhite"" call fnc_kbn_timing_start'>Белый</executeClose>]</font>
	 <br />[<execute expression='call fnc_kbn_timing_stop'>Остановить замер</execute>]
	 <br />"]];

	player createDiaryRecord ["TU_actions", ["Подготовка к СГ - Описания",
	"Пехота и вооружение: [<execute expression='call fnc_kbn_create_description'>Показать</execute>]
	<br />Отделения (кратко): [<execute expression='call fnc_kbn_create_description_short'>Показать</execute>]
	<br />Техника и ящики: [<execute expression='call fnc_kbn_create_veh_description'>Показать</execute>]
	<br />Техника (кратко): [<execute expression='call fnc_kbn_create_veh_description_short'>Показать</execute>]
	<br />Условности: [<execute expression='call fnc_kbn_create_convent_description'>Показать</execute>]
	"
	+ (if((east countSide playableUnits) > 0)then
	{
		"<br />Брифинг для красных: [<execute expression='east call fnc_kbn_create_briefing_description'>Показать</execute>]"
	} else{""})

	+ (if((west countSide playableUnits) > 0)then
	{
		"<br />Брифинг для синих: [<execute expression='west call fnc_kbn_create_briefing_description'>Показать</execute>]"
	} else{""})

	+ (if((resistance countSide playableUnits) > 0)then
	{
		"<br />Брифинг для зеленых: [<execute expression='resistance call fnc_kbn_create_briefing_description'>Показать</execute>]"
	} else{""})

	]];

	player createDiaryRecord ["TU_actions", ["Подготовка к СГ - Маркеры",
	"Все маркеры: [<execute expression='call fnc_kbn_show_all_markers'>Показать</execute>] [<execute expression='call fnc_kbn_hide_all_markers'>Скрыть</execute>] [<execute expression='call fnc_kbn_create_all_markers'>Пересоздать</execute>] [<execute expression='call fnc_kbn_delete_all_markers'>Удалить</execute>]

	<br />Показать/скрыть: [<execute expression='call fnc_kbn_showHide_respawn_markers'>Спаун</execute>]
	[<execute expression='call fnc_kbn_showHide_vehicles_markers'>Техника</execute>]
	[<execute expression='call fnc_kbn_showHide_ammo_markers'>Ящики</execute>]
	[<execute expression='call fnc_kbn_showHide_build_markers'>Строения</execute>]
	[<execute expression='call fnc_kbn_showHide_bot_markers'>Боты</execute>]

	<br />Маркеры Serp: [<execute expression='call fnc_kbn_showAllSerpMarkers'>Показать</execute>] [<execute expression='call fnc_kbn_hideAllSerpMarkers'>Скрыть</execute>]

	<br />----------------------------------

	<br />Позывной в начале маркера: [<execute expression='kbn_insert_nickname = true;'>Включить</execute>] [<execute expression='kbn_insert_nickname = false;'>Выключить</execute>]

	<br />----------------------------------

	<br />Сохранить маркеры: <execute expression='0 call fnc_kbn_saveAllMyMarkers'>[0]</execute> <execute expression='1 call fnc_kbn_saveAllMyMarkers'>[1]</execute> <execute expression='2 call fnc_kbn_saveAllMyMarkers'>[2]</execute> <execute expression='3 call fnc_kbn_saveAllMyMarkers'>[3]</execute> <execute expression='4 call fnc_kbn_saveAllMyMarkers'>[4]</execute> <execute expression='5 call fnc_kbn_saveAllMyMarkers'>[5]</execute> <execute expression='6 call fnc_kbn_saveAllMyMarkers'>[6]</execute> <execute expression='7 call fnc_kbn_saveAllMyMarkers'>[7]</execute> <execute expression='8 call fnc_kbn_saveAllMyMarkers'>[8]</execute> <execute expression='9 call fnc_kbn_saveAllMyMarkers'>[9]</execute>

	<br />Загрузить маркеры: <execute expression='0 call fnc_kbn_loadAllMyMarkers'>[0]</execute> <execute expression='1 call fnc_kbn_loadAllMyMarkers'>[1]</execute> <execute expression='2 call fnc_kbn_loadAllMyMarkers'>[2]</execute> <execute expression='3 call fnc_kbn_loadAllMyMarkers'>[3]</execute> <execute expression='4 call fnc_kbn_loadAllMyMarkers'>[4]</execute> <execute expression='5 call fnc_kbn_loadAllMyMarkers'>[5]</execute> <execute expression='6 call fnc_kbn_loadAllMyMarkers'>[6]</execute> <execute expression='7 call fnc_kbn_loadAllMyMarkers'>[7]</execute> <execute expression='8 call fnc_kbn_loadAllMyMarkers'>[8]</execute> <execute expression='9 call fnc_kbn_loadAllMyMarkers'>[9]</execute>

	<br />[<execute expression='call fnc_kbn_clearAllMyMarkers'>Очистить маркеры</execute>]

	"]];
};

[] spawn //ототбражение меню маркеров и описаний отрядов
{
	uiSleep 1;
	call fnc_kbn_show_groups_info;
	call fnc_kbn_create_menu;
};

[] spawn //обработчики клавиш на брифинге
{
	waitUntil{!isNull (findDisplay 52)};
	if(kbn_debug)then{systemChat "Briefing display found!";};
	if(kbn_debug)then{systemChat str ["((findDisplay 52) displayCtrl 51)", ((findDisplay 52) displayCtrl 51)];};
	kbn_onKeyDown_handler2 = ((findDisplay 52) displayCtrl 51) ctrlAddEventHandler ["keyDown", "_this call fnc_kbn_onKeyDown"];

	kbn_onKeyDown_handler = (findDisplay 52) displayAddEventHandler ["KeyDown", "_this call fnc_kbn_onKeyDown;"];

};

[] spawn  //обработчики клавиш на карте
{
	waitUntil{!isNull (findDisplay 12)};
	if(kbn_debug)then{systemChat "Map display found!";};
	if(kbn_debug)then{systemChat str ["((findDisplay 12) displayCtrl 51)", ((findDisplay 12) displayCtrl 51)];};
	kbn_onKeyDown_handler = ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["keyDown", "_this call fnc_kbn_onKeyDown"];

	kbn_onKeyDown_handler = (findDisplay 12) displayAddEventHandler ["KeyDown", "_this call fnc_kbn_onKeyDown;"];

};

[] spawn //обработчик маркеров подсветки
{
	waitUntil{!isNull (findDisplay 52)};
	while{missionStart select 0 != 0}do
	{
		_markersToDelete = [];
		uiSleep 0.3;
		{
			_marker = _x;
			_alpha = markerAlpha _marker;
			_alpha = _alpha - 0.05;
			if(_alpha <= (1 - (0.05 * 7)))then
			{
				deleteMarker _marker;
				_markersToDelete set [count _markersToDelete, _marker];
			}
			else
			{
				_marker setMarkerAlpha _alpha;
			};
		} forEach kbn_highlights_markers;

		kbn_highlights_markers = kbn_highlights_markers - _markersToDelete;
	};

	{deleteMarker _x} forEach kbn_highlights_markers;
	kbn_highlights_markers = [];
};

[] spawn //отключим обработчики окончания миссии Serp
{
	waitUntil{sleep 1; !isNil "serp_endMission"};
	serp_endMission = {};

	waitUntil{sleep 1; !isNil "SerP_processorEND"};
	SerP_processorEND = {};
};
//sleep 1; //не работает

//запуск Proving ground
if(isClass(configFile>>"RscDisplayMPInterrupt">>"controls">>"Btn1"))then
{
	systemChat "Mobile Proving Ground mod started!";
	_ = [] execVM "proving_ground\init.sqf";
};

//меню для вселения в других ботов
[["Вселиться", "x\kaban_sg_ready\fnc_selectPlayerCursorTarget.sqf", [], 100, true, true, "", "cursorTarget isKindOf 'Man'"]] call CBA_fnc_addPlayerAction;
