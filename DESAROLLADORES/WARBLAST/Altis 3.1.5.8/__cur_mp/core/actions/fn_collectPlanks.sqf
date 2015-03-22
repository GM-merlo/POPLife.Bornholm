/* 
	File: fn_collectPlanks.sqf
	
	Author: Ciaran Langton
	Date: 2014-12-12 21:44:46
	Last Modified by: Ciaran Langton
	Last Modified time: 2015-03-08 13:17:32
*/
_count = life_inv_woodp;
if(([false,"woodp",life_inv_woodp] call life_fnc_handleInv)) then
{
	titleText["Thanks for this work, I have put you down for lower bail price!","PLAIN"];
	if(life_bail_amount < 5000) exitWith {hint "I am unable to lower your bail price anymore. There is a limit. (£5000)"};
	for "_i" from 0 to _count do {
		if(life_bail_amount > 5000) then {
			life_bail_amount = life_bail_amount - 2000;
		};
	};
	if(life_bail_amount < 5000) then {life_bail_amount = 5000;};
};