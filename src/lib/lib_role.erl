%%%------------------------------------
%%% @Module  : lib_role
%%% @Author  : hanyan
%%% @Email   : ithinkily@vip.qq.com
%%% @Created : 2018.1.20
%%% @Description: 角色
%%%------------------------------------

-module(lib_role).

-export([get_socket/1, is_online/1]).
-compile(export_all).
-include("../common/common.hrl").
-include("../common/role.hrl").

get_socket(RoleId) ->
	case ets:lookup(?ETS_ROLE, RoleId) of
		[] ->
			ok;
		[Role] ->
			#ets_role{socket = Socket} = Role,
			Socket
	end.

is_online(RoleId) ->
	case ets:lookup(?ETS_ROLE, RoleId) of
		[] ->
			false;
		[Role] ->
			true
	end.