%%%-----------------------------------
%%% @Module  : gb_network
%%% @Author  : hanyan
%%% @Email   : ithinkily@vip.qq.com
%%% @Created : 2017.11.07
%%% @Description: 网络
%%%-----------------------------------

-module(gb_network).
-export([start/1]).

start([Ip, Port]) ->
	ok = start_kernel(),
	ok = start_client(),
	ok = start_id(),
	ok = start_tcp(Port).
	% ok = start_rank().

%% 开启核心服务
start_kernel() ->
	{ok, _} = supervisor:start_child(
				gb_sup,
				{mod_kernel,
				{mod_kernel, start_link, []},
				permanent, 10000, supervisor, [mod_kernel]}
		),
	ok.


% %% 随机种子
% start_rand() ->
% 	{ok, _} = supervisor:start_child(
% 				gb_sup,
% 				{mod_rand,
% 				{mod_rand, start_link, []},
% 				permanent, 10000, supervisor, [mod_rand]}
% 		),
% 	ok.

%% 开启客户端监控树
start_client() ->
	{ok, _} = supervisor:start_child(
				gb_sup,
				{gb_tcp_client_sup,
				{gb_tcp_client_sup, start_link, []},
				transient, infinity, supervisor, [tcp_client_sup]}
		),
	ok.


%% 开启tcp listener监控树
start_tcp(Port) ->
	{ok, _} = supervisor:start_child(
				gb_sup,
				{gb_tcp_listener_sup,
				{gb_tcp_listener_sup, start_link, [Port]},
				transient, infinity, supervisor, [tcp_listener_sup]}
		),
	ok.

%% 开启唯一id服务
start_id() ->
	{ok, _} = supervisor:start_child(
				gb_sup,
				{id_serv,
				{id_serv, start_link, []},
				permanent, 10000, supervisor, [id_serv]}
		),
	ok.

% %% 开启场景监控树
% start_scene() ->
% 	{ok, _} = supervisor:start_child(
% 				gb_sup,
% 				{gb_scene_sup,
% 				{gb_scene_sup, start_link, []},
% 				permanent, 10000, supervisor, [gb_scene_sup]}
% 		),
% 	ok.

% %% 开启排行榜监控树
% start_rank() ->
% 	{ok, _} = supervisor:start_child(
% 				gb_sup,
% 				{mod_rank,
% 				{mod_rank, start_link, []},
% 				permanent, 10000, supervisor, [mod_rand]}
% 		),
% 	ok.