%%%------------------------------------
%%% @Module  : lib_send
%%% @Author  : hanyan
%%% @Email   : ithinkily@vip.qq.com
%%% @Created : 2017.1.5
%%% @Description: 网络发送类
%%%------------------------------------

-module(lib_send).

-export([send/2, broadcast/2]).
-compile(export_all).


-include("../common/common.hrl").
-include("../common/role.hrl").

send(Socket, Msg) ->
	gen_tcp:send(Socket, Msg).

broadcast(Sockets, Msg) ->
	Fun = fun(Socket) ->
			send(Socket, Msg)
		end,
	lists:foreach(Fun, Sockets).
