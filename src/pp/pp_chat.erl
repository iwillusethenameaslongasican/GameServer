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

handle(40003, Status, Data) ->
	[Content] = Data,
	#ets_role{id = RoleId, room_id = RoomId} = Status,
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
	lager:info("RegularTime:~p", [RegularTime]),
	{ok, Pkt} = pt_40:write(proto_util:name_to_id(s2c_group_chat_reply), {RoleId, Content, RegularTime}),
	{_Num, RoleInfos} = mod_scene:get_room_info(RoomId), 
	Sockets = mod_scene:get_sockets(RoleInfos),
	lib_send:broadcast(Sockets, Pkt);

handle(_, [], _Date) ->
	false.