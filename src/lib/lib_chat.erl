%%%------------------------------------
%%% @Module  : lib_chat
%%% @Author  : hanyan
%%% @Email   : ithinkily@vip.qq.com
%%% @Created : 2018.1.25
%%% @Description: 聊天
%%%------------------------------------

-module(lib_chat).

-export([regular_time/1]).
-compile(export_all).

regular_time(Time) ->
	{{Year, Month, Day}, {Hour, Min, Sec}} = Time,
	[Year, Month, Day, Hour, Min, Sec].