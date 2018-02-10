%%%-----------------------------------
%%% @Module  : gb_tcp_acceptor_sup
%%% @Author  : hanyan
%%% @Email   : ithinkily@vip.qq.com
%%% @Created : 2017.11.09
%%% @Description: tcp acceptor 监控树
%%%-----------------------------------

-module(gb_tcp_acceptor_sup).
-behaviour(supervisor).
-export([start_link/0, init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
	{ok, {{simple_one_for_one, 10, 10},
		  [{gb_tcp_acceptor, {gb_tcp_acceptor, start_link, []},
		  transient, brutal_kill, worker, [gb_tcp_acceptor]
		  }]
		 }
	}.