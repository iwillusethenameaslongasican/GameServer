%%%-----------------------------------
%%% @Module  : gb_server_app
%%% @Author  : hanyan
%%% @Email   : ithinkily@vip.qq.com
%%% @Created : 2017.11.07
%%% @Description: 打包程序
%%%-----------------------------------
-module(gb_server_app).
-behaviour(application).
-export([start/2, stop/1]).

start(normal, []) ->
	%% 从启动参数-extra获取参数(节点， 端口)
	[Ip, Port] = init:get_plain_arguments(),
	{ok, SupPid} = gb_sup:start_link(),
	gb_network:start([Ip, list_to_integer(Port)]),
	{ok, SupPid}.

stop(_State) ->
	void.
