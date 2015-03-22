#include <macro.h>
/*
	File: fn_weaponShopBuySell.sqf
	Author: Bryan "Tonic" Boardwine
	
	Description:
	Master handling of the weapon shop for buying / selling an item.
*/
disableSerialization;
private["_price","_item","_itemInfo","_bad"];
if((lbCurSel 38403) == -1) exitWith {hint localize "STR_Shop_Weapon_NoSelect"};
_price = lbValue[38403,(lbCurSel 38403)]; if(isNil "_price") then {_price = 0;};
_item = lbData[38403,(lbCurSel 38403)];
_itemInfo = [_item] call life_fnc_fetchCfgDetails;

_bad = "";

if((_itemInfo select 6) != "CfgVehicles") then
{
	if((_itemInfo select 4) in [4096,131072]) then
	{
		if(!(player canAdd _item) && (uiNamespace getVariable["Weapon_Shop_Filter",0]) != 1) exitWith {_bad = (localize "STR_NOTF_NoRoom")};
	};
};

if(_bad != "") exitWith {hint _bad};

if((uiNamespace getVariable["Weapon_Shop_Filter",0]) == 1) then
{
	ALUK_wonga = ALUK_wonga + _price;
	[_item,false] call life_fnc_handleItem;
	hint parseText format[localize "STR_Shop_Weapon_Sold",_itemInfo select 1,[_price] call life_fnc_numberText];
	[nil,(uiNamespace getVariable["Weapon_Shop_Filter",0])] call life_fnc_weaponShopFilter; //Update the menu.
}
	else
{
	if(!isNil {grpPlayer getVariable "gang_bank"} && {(grpPlayer getVariable "gang_bank") >= _price}) then {
		_action = [
			format[(localize "STR_Shop_Virt_Gang_FundsMSG")+ "<br/><br/>" +(localize "STR_Shop_Virt_Gang_Funds")+ " <t color='#8cff9b'>£%1</t><br/>" +(localize "STR_Shop_Virt_YourFunds")+ " <t color='#8cff9b'>£%2</t>",
				[(grpPlayer getVariable "gang_bank")] call life_fnc_numberText,
				[ALUK_wonga] call life_fnc_numberText
			],
			localize "STR_Shop_Virt_YourorGang",
			localize "STR_Shop_Virt_UI_GangFunds",
			localize "STR_Shop_Virt_UI_YourCash"
		] call BIS_fnc_guiMessage;
		if(_action) then {
			hint parseText format[localize "STR_Shop_Weapon_BoughtGang",_itemInfo select 1,[_price] call life_fnc_numberText];
			_funds = grpPlayer getVariable "gang_bank";
			_funds = _funds - _price;
			grpPlayer setVariable["gang_bank",_funds,true];
			[_item,true] spawn life_fnc_handleItem;
			playSound "buy";
			[[1,grpPlayer],"TON_fnc_updateGang",false,false] spawn life_fnc_MP;

			_flag = nearestObject[position player,"Flag_White_F"];
			if(!(isNil '_flag')) then {
				_gangDBId = _flag getVariable["gangOwnerId",-1];
				if(_gangDBId != -1) then {
					_addPrice = (_price/100) * 20;
					[_flag,round (_addPrice)] call life_fnc_gangFundAdd;
				};
			};

		} else {
			if(_price > ALUK_wonga) exitWith {hint localize "STR_NOTF_NotEnoughMoney"};
			hint parseText format[localize "STR_Shop_Weapon_BoughtItem",_itemInfo select 1,[_price] call life_fnc_numberText];
			__SUB__(ALUK_wonga,_price);
			[_item,true] spawn life_fnc_handleItem;
			playSound "buy";

			_flag = nearestObject[position player,"Flag_White_F"];
			if(!(isNil '_flag')) then {
				_gangDBId = _flag getVariable["gangOwnerId",-1];
				if(_gangDBId != -1) then {
					_addPrice = (_price/100) * 20;
					[_flag,round (_addPrice)] call life_fnc_gangFundAdd;
				};
			};

		};
	} else {
		if(_price > ALUK_wonga) exitWith {hint localize "STR_NOTF_NotEnoughMoney"};
		hint parseText format[localize "STR_Shop_Weapon_BoughtItem",_itemInfo select 1,[_price] call life_fnc_numberText];
		ALUK_wonga = ALUK_wonga - _price;
		playSound "buy";
		[_item,true] spawn life_fnc_handleItem;

		_flag = nearestObject[position player,"Flag_White_F"];
		if(!(isNil '_flag')) then {
			_gangDBId = _flag getVariable["gangOwnerId",-1];
			if(_gangDBId != -1) then {
				_addPrice = (_price/100) * 20;
				[_flag,round (_addPrice)] call life_fnc_gangFundAdd;
			};
		};

	};
};


[] call life_fnc_saveGear;