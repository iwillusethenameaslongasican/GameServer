%%%------------------------------------
%%% @Module  : mod_kernel
%%% @Author  : hanyan
%%% @Email   : ithinkily@vip.qq.com
%%% @Created : 2017.11.10
%%% @Description: 核心服务
%%%------------------------------------

-module(mod_kernel).
-behaviour(gen_server).
-export([
			start_link/0,
			online_state/0
		]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include_lib("/usr/local/lib/erlang/lib/stdlib-3.3/include/qlc.hrl").
-include("../common/common.hrl").
-include("../common/role.hrl").

start_link() ->	
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 在线状况
online_state() ->
	case ets:info(?ETS_ONLINE, size) of
		undefined ->
			[0, 0];
		Num when Num < 200 -> %% 顺畅
			[1, Num];
		Num when Num >= 200, Num < 500 -> %% 正常
			[2, Num];
		Num when Num >= 200, Num < 800 -> %% 繁忙
			[3, Num];
		Num when Num >= 800 -> %% 爆满
			[4, Num]
	end.

init([]) ->
	%% 初始化ets表
	ok = init_ets(),
	%% 初始化mysql
	ok = init_mysql(),
	{ok, 1}.

handle_cast(_R, Status) ->
	{noreply, Status}.

handle_call(_R, _From, Status) ->
	{reply, ok, Status}.

handle_info(_Reason, Status) ->
	{noreply, Status}.

terminate(normal, Status) ->
	{ok, Status}.

code_change(_OldVsn, Status, _Extra) ->
	{ok, Status}.

%% ===================== 私有函数 =====================

%% mysql数据库连接初始化
init_mysql() ->
	mnesia:start(),
	% crypto:start(),  
 %    application:start(emysql),  
	% emysql:add_pool(hello_pool, 1, "root", "20157411.adj", "39.106.41.102", 3306, "db", utf8),
	% mysql:start_link(?DB, ?DB_HOST, ?DB_PORT, ?DB_USER, ?DB_PASS, ?DB_NAME, fun(_, _, _, _) -> ok end, ?DB_ENCODE),
	% mysql:connect(?DB, ?DB_HOST, ?DB_PORT, ?DB_USER, ?DB_PASS, ?DB_NAME, ?DB_ENCODE, true),
	ok.

%% 初始化ets表
init_ets() ->
	ets:new(?ETS_ONLINE, [{keypos, #ets_online.id}, named_table, public, set]), %% 用户在线列表
	ets:new(?ETS_ROLE, [{keypos, #ets_role.id}, named_table, public, set]),
	ets:new(?ETS_SCENE, [{keypos, #ets_scene.id}, named_table, public, set]),
	ok.

