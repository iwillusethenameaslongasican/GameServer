%%%------------------------------------
%%% @Module  : pp_fight
%%% @Author  : hanyan
%%% @Email   : ithinkily@vip.qq.com
%%% @Created : 2018.1.12
%%% @Description: 战斗相关处理类
%%%------------------------------------

-module(pp_fight).

-export([handle/3]).

-include("../common/common.hrl").
-include("../common/role.hrl").

handle(30001, Status, Data) ->
	#ets_role{id = RoleId, socket = Socket, room_id = RoomId} = Status,
	{Ret} = lib_scene:can_start(RoomId, RoleId),
	{ok, Pkt1} = pt_30:write(proto_util:name_to_id(s2c_start_fight_reply), {Ret}),
	lib_send:send(Socket, Pkt1),
	if Ret =:= 1 ->
		{Count, Objects} = lib_fight:get_objects(RoomId),
		{ok, Pkt2} = pt_30:write(proto_util:name_to_id(s2c_fight_reply), {Count, Objects}),
		{_Num, RoleInfos} = lib_scene:get_room_info(RoomId), 
		Sockets = lib_scene:get_sockets(RoleInfos),
		lib_send:broadcast(Sockets, Pkt2),
		FightInfo = lib_fight:get_fight_info(RoleInfos),
		Pid  = lib_fight:start_fight(FightInfo),
		ets:update_element(?ETS_SCENE, RoomId, {#ets_scene.fpid, Pid});
	  true ->
	  	ok
	end;

handle(30005, Status, Data) ->
	[PosX, PosY, PosZ, RotX, RotY, RotZ] = Data,
	#ets_role{id = RoleId, room_id = RoomId} = Status,
	Fpid = lib_scene:get_fpid(RoomId),
	gen_server:cast(Fpid, {update_unit, [RoleId, PosX, PosY, PosZ, RotX, RotY, RotZ]});

handle(30007, Status, Data) ->
	[PosX, PosY, PosZ, RotX, RotY, RotZ] = Data,
	#ets_role{id = RoleId, room_id = RoomId} = Status,
	Fpid = lib_scene:get_fpid(RoomId),
	gen_server:cast(Fpid, {shooting, [RoleId, PosX, PosY, PosZ, RotX, RotY, RotZ]});

handle(30009, Status, Data) ->
	[EnemyId, Damage] = Data,
	#ets_role{id = RoleId, room_id = RoomId} = Status,
	Fpid = lib_scene:get_fpid(RoomId),
	gen_server:cast(Fpid, {hit, [RoleId, EnemyId, Damage]});

handle(30011, Status, Data) ->
	[Ret] = Data,
	#ets_role{socket = Socket, room_id = RoomId} = Status,
	{ok, Pkt} = pt_30:write(proto_util:name_to_id(s2c_result_reply), {Ret}),
	lib_send:send(Socket, Pkt),
	FPid = lib_scene:get_fpid(RoomId),
	fight_serv:stop(FPid);

handle(30013, Status, _Data) ->
	#ets_role{id = RoleId, socket = Socket, room_id = RoomId} = Status,
	FPid = lib_scene:get_fpid(RoomId),
	gen_server:cast(FPid, {get_supply, [RoleId]}),
	{ok, Pkt} = pt_30:write(proto_util:name_to_id(s2c_get_supply_reply), {1}),
	lib_send:send(Socket, Pkt);

handle(_, [], _Date) ->
	false.