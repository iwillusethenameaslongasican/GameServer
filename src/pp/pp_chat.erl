%%%------------------------------------
%%% @Module  : pp_chat
%%% @Author  : hanyan
%%% @Email   : ithinkily@vip.qq.com
%%% @Created : 2018.1.18
%%% @Description: 用户聊天相关处理类
%%%------------------------------------

-module(pp_chat).

-export([handle/3]).

-include("../common/common.hrl").
-include("../common/role.hrl").
-include("../include/chat_pb.hrl").

handle(40001, Status, Data) ->
	[FriendId, Content] = Data,
	#ets_role{id = RoleId, socket = Socket1} = Status,
	Now = erlang:timestamp(),
	Time = calendar:now_to_local_time(Now),
	[Year, Month, Day, Hour, Min, Sec] = _RegularTime = lib_chat:regular_time(Time),
	RegularTime = #time_section{
		year = Year,
		month = Month,
		day = Day,
		hour = Hour,
		minu = Min,
		sec = Sec
	},
	IsOnline = lib_role:is_online(FriendId),
	case IsOnline of
		false ->
			{ok, Pkt} = pt_40:write(proto_util:name_to_id(s2c_chat_reply), {0, Content, RegularTime}),
			lib_send:send(Socket1, Pkt);
		true ->
			{ok, Pkt} = pt_40:write(proto_util:name_to_id(s2c_chat_reply), {RoleId, Content, RegularTime}),
			lib_send:send(Socket1, Pkt),
			Socket2 = lib_role:get_socket(FriendId),
			lib_send:send(Socket2, Pkt)
	end;
	
handle(40003, Status, Data) ->
	[Content] = Data,
	#ets_role{id = RoleId, socket = Socket, room_id = RoomId} = Status,
	Now = erlang:timestamp(),
	Time = calendar:now_to_local_time(Now),
	[Year, Month, Day, Hour, Min, Sec] = _RegularTime = lib_chat:regular_time(Time),
	RegularTime = #time_section{
		year = Year,
		month = Month,
		day = Day,
		hour = Hour,
		minu = Min,
		sec = Sec
	},
	if RoomId =:= 0 ->
			{ok, Pkt} = pt_40:write(proto_util:name_to_id(s2c_group_chat_reply), {0, Content, RegularTime}),
			lib_send:send(Socket, Pkt);
		true ->
			{ok, Pkt} = pt_40:write(proto_util:name_to_id(s2c_group_chat_reply), {RoleId, Content, RegularTime}),
			{_Num, RoleInfos} = lib_scene:get_room_info(RoomId),
			Sockets = lib_scene:get_sockets(RoleInfos),
			lib_send:broadcast(Sockets, Pkt)
	end;

handle(40005, Status, Data) ->
	[Content] = Data,
	#ets_role{id = RoleId} = Status,
	Now = erlang:timestamp(),
	Time = calendar:now_to_local_time(Now),
	[Year, Month, Day, Hour, Min, Sec] = _RegularTime = lib_chat:regular_time(Time),
	RegularTime = #time_section{
		year = Year,
		month = Month,
		day = Day,
		hour = Hour,
		minu = Min,
		sec = Sec
	},
	{ok, Pkt} = pt_40:write(proto_util:name_to_id(s2c_world_chat_reply), {RoleId, Content, RegularTime}),
	lib_send:broadcast(Pkt);


handle(_, [], _Date) ->
	false.