waitUntil {!isNull player};

_precio = 0;
_unit = [_this,1,Objnull,[Objnull]] call BIS_fnc_param;


if(isNull _unit) exitWith {}; //if not the thief get bent
	
//puede pagar?¿
 if(life_cash - _precio < 0) exitWith { hint "No tienes suficiente dinero";[] spawn { sleep 5;hint "";} };

//equipar clase

life_cash = life_cash-_precio;


removeAllWeapons _unit;
removeallassigneditems _unit;
removeallcontainers _unit;
removeuniform _unit;
removevest _unit;
removebackpack _unit;



_unit addHeadgear "H_Beret_02";
 _unit addGoggles "G_Balaclava_Lowprofile"; 

_unit  addVest "V_TacVest_blk";
_unit  forceAddUniform "U_B_CombatUniform_mcam_worn";
 
_unit addWeapon 'Binocular';

_unit additem 'ItemWatch';
_unit assignItem "ItemWatch"; 
_unit addItem "ItemRadio"; 
_unit assignItem "ItemRadio"; 
_unit addItem "ItemGPS";
_unit assignItem "ItemGPS";
_unit addItem "ItemMap";
_unit assignItem "ItemMap";
_unit addItem "ItemCompass"; 
_unit assignItem "ItemCompass"; 

_unit  addItem "NVGoggles_OPFOR"; 
_unit  assignItem "NVGoggles_OPFOR";


_unit  addBackPack "B_Carryall_mcamo"; 
mybackpack = unitBackpack _unit ;
[[mybackpack,0,"#(argb, 8,8,3)color(0.05,0.05,0.05,1)"],"life_fnc_setTexture",true,false] spawn life_fnc_MP;


//cargar skin globalmente
[[_unit,0,"textures\TRAJES\otan.jpg"],"life_fnc_setTexture",true,false] spawn life_fnc_MP;

reload _unit;
if(true) exitWith{hint "Clase OTAN equipada";[] spawn { sleep 5;hint "";} };