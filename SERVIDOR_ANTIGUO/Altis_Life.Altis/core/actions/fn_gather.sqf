/*
	File: fn_gather.sqf
	Author: Bryan "Tonic" Boardwine
	
	Description:
	Main functionality for gathering.
*/

private["_gather","_itemWeight","_diff","_itemName","_val","_resourceZones","_zone"];
_resourceZones = ["apple_1","apple_2","pear_1","pear_2","peaches_1","peaches_2","heroin_1","cocaine_1","weed_1","heroin_1_1","cocaine_1_1","weed_1_1"];
_zone = "";

if(life_action_inUse) exitWith {}; //Action is in use, exit to prevent spamming.

//Find out what zone we're near
{
	if(player distance (getMarkerPos _x) < 60) exitWith {_zone = _x;};
} foreach _resourceZones;

if(_zone == "") exitWith {
	life_action_inUse = false;
};
//Get the resource that will be gathered from the zone name...
switch(true) do {
	case (_zone in ["apple_1","apple_2"]): {_gather = "apple"; _val = 6;};
	case (_zone in ["pear_1","pear_2"]): {_gather = "pear"; _val = 6;};
	case (_zone in ["peaches_1","peaches_2"]): {_gather = "peach"; _val = 6;};
	case (_zone in ["heroin_1","heroin_1_1"]): {_gather = "heroinu"; _val = 2;};
	case (_zone in ["cocaine_1","cocaine_1_1"]): {_gather = "cocaine"; _val = 2;};
	case (_zone in ["weed_1","weed_1_1"]): {_gather = "cannabis"; _val = 2;};
	default {""};
};
//gather check??
if(vehicle player != player) exitWith {};

_diff = [_gather,_val,life_carryWeight,life_maxWeight] call life_fnc_calWeightDiff;
if(_diff == 0) exitWith {hint localize "STR_NOTF_InvFull"};
life_action_inUse = true;
for "_i" from 0 to 2 do
{
	player playMove "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon";
	waitUntil{animationState player != "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon";};
	sleep 2.5;
};

if(([true,_gather,_diff] call life_fnc_handleInv)) then
{
	_itemName = [([_gather,0] call life_fnc_varHandle)] call life_fnc_varToStr;
	titleText[format[localize "STR_NOTF_Gather_Success",_itemName,_diff],"PLAIN"];
};

life_action_inUse = false;