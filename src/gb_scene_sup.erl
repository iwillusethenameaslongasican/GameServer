%%%-----------------------------------
%%% @Module  : gb_scene_sup
%%% @Author  : hanyan
%%% @Email   : ithinkily@vip.qq.com
%%% @Created : 2018.1.2
%%% @Description: 场景监控树
%%%-----------------------------------

-module(gb_scene_sup).
-behaviour(supervisor).
-export([start_link/0, init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
	{ok, {{simple_one_for_one, 10, 10},
		  [{mod_scene, {mod_scene, start_link, []},
		  transient, brutal_kill, worker, [mod_scene]
		  }]
		 }
	}.