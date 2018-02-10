%%%------------------------------------
%%% @Module  : pp_accouny
%%% @Author  : hanyan
%%% @Email   : ithinkily@vip.qq.com
%%% @Created : 2018.1.5
%%% @Description: 用户账号相关处理类
%%%------------------------------------

-module(pp_account).

-export([handle/3]).

-include("../common/common.hrl").
-include("../common/role.hrl").

handle(10001, [], Data) ->
	[Account, Password] = Data,
	case db_util:has_account(Account, Password) of
		[] ->
			lager:info("not register!!!"),
			false;
		Role ->
			{true, Role}
	end;

handle(10003, [], Data) ->
	[Account, Password] = Data,
	case db_util:has_account(Account, Password) of
		[] ->
			lager:info("insert!!!"),
			db_util:insert_account_one(Account, Password),
			true;
		Role ->
			lager:info("registered!!!"),
			false
	end;

handle(10005, Status, Data) ->
	#ets_role{id = RoleId, socket = Socket, pid = Pid, room_id = RoomId} = Status,
	{ok, Pkt} = pt_10:write(proto_util:name_to_id(s2c_logout_reply), {1}),
	lib_send:send(Socket, Pkt),
	pp_scene:handle(20013, Status, [RoomId]),
	ets:delete(?ETS_ROLE, RoleId),
	mod_login:logout(Pid, Status, "");

handle(10007, Status, Data) ->
	#ets_role{socket = Socket} = Status,
	% lager:info("10007"),
	gen_server:cast(self(), {update_heartbeat}),
	{ok, Pkt} = pt_10:write(proto_util:name_to_id(s2c_heartbeat_reply), {}),
	lib_send:send(Socket, Pkt);
	

handle(_, [], _Date) ->
	false.
