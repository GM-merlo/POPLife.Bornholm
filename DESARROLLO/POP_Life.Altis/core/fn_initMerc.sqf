#include <macro.h>
/*
	File: fn_initMerc.sqf
	Author: Bryan "Tonic" Boardwine
	
	Description:
	Cop Initialization file.
*/
private["_end"];
player addRating 9999999;
waitUntil {!(isNull (findDisplay 46))};
_end = false;
if(life_blacklisted) exitWith
{
	["Blacklisted",false,true] call BIS_fnc_endMission;
	sleep 30;
};


if(__GETC__(life_merclevel) == 0) then {
	["NotWhitelisted",false,true] call BIS_fnc_endMission;
	sleep 35;
};

if(life_is_arrested) then
{
	life_is_arrested = false;
	[player,true] spawn life_fnc_jail;
};

[] call life_fnc_spawnMenu;
waitUntil{!isNull (findDisplay 38500)}; //Wait for the spawn selection to be open.
waitUntil{isNull (findDisplay 38500)}; //Wait for the spawn selection to be done.

if(__GETC__(life_adminlevel) > 0) then {
	adminChannel radioChannelAdd [player];
};