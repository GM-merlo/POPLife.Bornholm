waitUntil {!isNull player};

_precio = 325000;
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



_unit addGoggles "G_Balaclava_Lowprofile"; 
_unit addHeadgear "H_MilCap_mcamo";
_unit  addVest "V_TacVestCamo_khk";
_unit  forceAddUniform "U_B_GhillieSuit";

 
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

_unit  addWeapon "srifle_GM6_LRPS_F";

_unit addMagazines ["5Rnd_127x108_Mag", 8];
   
_unit  addItem "NVGoggles_OPFOR"; 
_unit  assignItem "NVGoggles_OPFOR";


_unit  addBackPack "B_Carryall_oucamo"; 
mybackpack = unitBackpack _unit ;
mybackpack addItemCargoGlobal ["Toolkit", 1]; 
mybackpack addItemCargoGlobal ["FirstAidKit", 2];


//solo para altis
[true,"water",2] call life_fnc_handleInv;
[true,"tbacon",2] call life_fnc_handleInv;
[true,"redgull",2] call life_fnc_handleInv;

reload _unit;
if(true) exitWith{hint "Clase Sniper equipada";[] spawn { sleep 5;hint "";} };