/*
	Author: Karel Moricky

	Description:
	Execute received remote execution

	Parameter(s):
	_this select 0: STRING - Packet variable name (always "AKR_fnc_rem_packet")
	_this select 1: ARRAY - Packet value (sent by BIS_fnc_MP function; see it's description for more details)
	
	Returns:
	BOOL - true if function was executed successfuly
*/
private ["_params","_functionName","_target","_isPersistent","_isCall","_varName","_varValue","_function"];

_varName = _this select 0;
_varValue = _this select 1;

_mode = 	[_varValue,0,[0]] call bis_fnc_param;
_params = 	[_varValue,1,[]] call bis_fnc_param;
_functionName =	[_varValue,2,"",[""]] call bis_fnc_param;
_target =	[_varValue,3,true,[objnull,true,0,[],sideUnknown,grpnull,""]] call bis_fnc_param;
_isPersistent =	[_varValue,4,false,[false]] call bis_fnc_param;
_isCall =	[_varValue,5,false,[false]] call bis_fnc_param;

if (typename _target == typename []) then {
	//--- Multi execution
	{
		[_varName,[_mode,_params,_functionName,_x,_isPersistent,_isCall]] call bis_fnc_MPexec;
	} foreach _target;
} else{
	//--- Single execution
	if (ismultiplayer && _mode == 0) then {
		private ["_ownerID","_serverID"];
		_serverID = owner (missionnamespace getvariable ["bis_functions_mainscope",objnull]); //--- Server ID is not always 0

		//--- Server process
		switch (typename _target) do {
			case (typename ""): {
				_ownerID = owner (missionnamespace getvariable [_target,objnull]);
			};
			case (typename objnull): {
				private ["_targetCuratorUnit"];
				_targetCuratorUnit = getassignedcuratorunit _target;
				if !(isnull _targetCuratorUnit) then {_target = _targetCuratorUnit;};
				_ownerID = owner _target;
			};
			case (typename true): {
				_ownerID = [_serverID,-1] select _target;
			};
			case (typename 0): {
				_ownerID = _target;
			};
			case (typename grpnull);
			case (typename sideUnknown): {
				_ownerID = -1;
			};
		};
		AKR_fnc_rem_packet = [1,_params,_functionName,_target,_isPersistent,_isCall];

		//--- Send to clients
		if (_ownerID < 0) then {
			//--- Everyone
			publicvariable "AKR_fnc_rem_packet";
		} else {
			if (_ownerID != _serverID) then {
				//--- Client
				_ownerID publicvariableclient "AKR_fnc_rem_packet";
			};
		};

		//--- Server execution (for all or server only)
		if (_ownerID == -1 || _ownerID == _serverID) then {
			["AKR_fnc_rem_packet",AKR_fnc_rem_packet] spawn BIS_fnc_MPexec;
		};

		//--- Persistent call (for all or clients)
		if (_isPersistent) then {
			if (typename _target != typename 0) then {
				private ["_logic","_queue"];
				_logic = missionnamespace getvariable ["bis_functions_mainscope",objnull];
				_queue = _logic getvariable ["BIS_fnc_MP_queue",[]];
				_queue set [
					count _queue,
					+AKR_fnc_rem_packet
				];
				_logic setvariable ["BIS_fnc_MP_queue",_queue,true];
			} else {
				["Persistent execution is not allowed when target is %1. Use %2 or %3 instead.",typename 0,typename objnull,typename false] call bis_fnc_error;
			};
		};
	} else {

		//--- Local execution
		private ["_canExecute"];
		_canExecute = switch (typename _target) do {
			case (typename grpnull): {player in units _target};
			case (typename sideUnknown): {(player call bis_fnc_objectside) == _target};
			default {true};
		};

		if (_canExecute) then {
			_function = missionnamespace getvariable _functionName;
			if (!isnil "_function") then {

				//--- Function
				if (_isCall) then {
					_params call _function;
				} else {
					_params spawn _function;
				};
				true
			} else {
				_supportInfo = supportInfo format ["*:%1*",_functionName];
				if (count _supportInfo > 0) then {

					//--- Scripting command
					_cfgRemoteExecCommands = [["CfgRemoteExecCommands"],configfile] call bis_fnc_loadClass;
					if (isclass (_cfgRemoteExecCommands >> _functionName)) then {
						_paramCount = if (typename _params == typename []) then {count _params} else {1};
						switch (_paramCount) do {
							case 0: {_params call compile format ["%1",_functionName]; true};
							case 1: {_params call compile format ["%1 (_this)",_functionName]; true};
							case 2: {_params call compile format ["(_this select 0) %1 (_this select 1)",_functionName]; true};
							default {
								//--- Error
								["Error when remotely executing '%1' - wrong number of arguments (%2) passed, must be 0, 1 or 2",_functionName,count _params] call bis_fnc_error;
								false
							};
						};
					} else {
						//--- Banned commands
						["Scripting command '%1' is not allowed to be remotely executed",_functionName] call bis_fnc_error;
						false
					};
				} else {
					//--- Error
					["Function or scripting command '%1' does not exist",_functionName] call bis_fnc_error;
					false
				};
			};
		};
	};
};