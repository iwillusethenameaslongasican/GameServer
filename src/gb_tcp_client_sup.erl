%%%-----------------------------------
%%% @Module  : gb_tcp_client_sup
%%% @Author  : hanyan
%%% @Email   : ithinkily@vip.qq.com
%%% @Created : 2017.11.09
%%% @Description: 客户端服务监控树
%%%-----------------------------------

-module(gb_tcp_client_sup).
-behaviour(supervisor).
-export([start_link/0]).
-export([init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
	{ok, 
		{
			{simple_one_for_one, 10, 10},
			[
				{
					gb_reader,
					{gb_reader, start_link, []},
					temporary, brutal_kill, worker, [gb_reader]
				}
			]
		}
	}.