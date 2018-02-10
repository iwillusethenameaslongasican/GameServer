%%%------------------------------------
%%% @Module  : pp_friend
%%% @Author  : hanyan
%%% @Email   : ithinkily@vip.qq.com
%%% @Created : 2018.1.19
%%% @Description: 好友相关处理类
%%%------------------------------------

-module(pp_friend).

-export([handle/3]).

-include("../common/common.hrl").
-include("../common/role.hrl").
-include("../include/friend_pb.hrl").

handle(50001, Status, Data) ->
	#ets_role{id = RoleId, socket = Socket} = Status,
	{Num, Infos} = lib_friend:get_friends(RoleId),
	{ok, Pkt} = pt_50:write(proto_util:name_to_id(s2c_friend_list_reply), {Num, Infos}),
	lib_send:send(Socket, Pkt);


handle(50003, Status, Data) ->
	[FriendId] = Data,
	#ets_role{id = RoleId, socket = Socket} = Status,
	{Ret} = lib_friend:add_friend(RoleId, FriendId),
	{ok, Pkt} = pt_50:write(proto_util:name_to_id(s2c_add_friend_reply), {Ret}),
	lib_send:send(Socket, Pkt);

handle(_, [], _Date) ->
	false