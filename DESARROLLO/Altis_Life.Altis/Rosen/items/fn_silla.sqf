/*
	Archivo: fn_silla.sqf
	Autor Rosen
	
	Descripción: Saca una silla para sentarse
	
*/

private ["_silla"];
[] spawn {
	if (life_sentarse) exitWith {};
	life_sentarse = true;
	player switchMove "Crew";
	closeDialog 0;
	titleText["A sentarse","PLAIN"];
	_silla = "Land_CampingChair_V2_F" createVehicle [0,0,0];
	_silla allowDamage false;
	_silla enableSimulationGlobal false;
	_silla attachTo [player, [0,0,0.2], "culo"];
	_silla setVectorUp [0,180,-1];
	//espera 20 segundos;
	sleep 20;
	deleteVehicle _silla;
	player switchMove "";
	life_sentarse = false;
};