%%%------------------------------------
%%% @Module  : pp_scene
%%% @Author  : hanyan
%%% @Email   : ithinkily@vip.qq.com
%%% @Created : 2018.1.5
%%% @Description: 场景相关处理类
%%%------------------------------------

-module(pp_scene).

-export([handle/3]).

-include("../common/common.hrl").
-include("../common/role.hrl").

handle(20003, Status, Data) ->
	[RoleId, Win, Fail] = Data,
	#ets_role{socket = Socket} = Status,
	{ok, Pkt} = pt_20:write(proto_util:name_to_id(s2c_get_achieve_reply), {RoleId, Win, Fail}),
	lib_send:send(Socket, Pkt);

handle(20005, Status, Data) ->
	[Rooms, Num] = Data,
	#ets_role{socket = Socket} = Status,
	{ok, Pkt} = pt_20:write(proto_util:name_to_id(s2c_get_room_list_reply), {Rooms, Num}),
	lib_send:send(Socket, Pkt);

handle(20007, Status, Data) ->
	#ets_role{id = RoleId, socket = Socket, win = Win, fail = Fail} = Status,
	{Ret, RoomId} = lib_scene:create_room(RoleId, Win, Fail),
	{ok, Pkt} = pt_20:write(proto_util:name_to_id(s2c_create_room_reply), {Ret, RoomId}),
	lib_send:send(Socket, Pkt),
	case Ret of
		1 ->
			Status1 = Status#ets_role{room_id = RoomId},
			{changed, Status1};
		0 ->
			ok
	end;

handle(20009, Status, Data) ->
	[RoomId] = Data,
	#ets_role{id = RoleId, socket = Socket, win = Win, fail = Fail} = Status,
	{Ret, Sockets} = lib_scene:enter_room(RoomId, RoleId, Win, Fail),
	{ok, Pkt1} = pt_20:write(proto_util:name_to_id(s2c_enter_room_reply), {Ret, RoomId}),
	lib_send:send(Socket, Pkt1),
	{Num, RoleInfos} = lib_scene:get_room_info(RoomId),
	{ok, Pkt2} = pt_20:write(proto_util:name_to_id(s2c_get_room_info_reply), {Num, RoleInfos}),
	lib_send:broadcast(Sockets, Pkt2),
	case Ret of
		1 ->
			Status1 = Status#ets_role{room_id = RoomId},
			{changed, Status1};
		0 ->
			{nochanged, Status}
	end;

handle(20011, Status, Data) ->
	[RoomId] = Data,
	#ets_role{socket = Socket} = Status,
	{Num, RoleInfos} = lib_scene:get_room_info(RoomId),
	{ok, Pkt} = pt_20:write(proto_util:name_to_id(s2c_get_room_info_reply), {Num, RoleInfos}),
	lib_send:send(Socket, Pkt);

handle(20013, Status, Data) ->
	[RoomId] = Data,
	#ets_role{id = RoleId, socket = Socket} = Status,
	{Ret} = lib_scene:leave_room(RoomId, RoleId),
	{ok, Pkt1} = pt_20:write(proto_util:name_to_id(s2c_leave_room_reply), {Ret}),
	lib_send:send(Socket, Pkt1),
	{Num, RoleInfos} = lib_scene:get_room_info(RoomId),
	{ok, Pkt2} = pt_20:write(proto_util:name_to_id(s2c_get_room_info_reply), {Num, RoleInfos}),
	Sockets = lib_scene:get_sockets(RoleInfos),
	lib_send:broadcast(Sockets, Pkt2),
	case Ret of
		1 ->
			Status1 = Status#ets_role{room_id = 0},
			{changed, Status1};
		0 ->
			{nochanged, Status}
	end;

handle(_, [], _Date) ->
	false.