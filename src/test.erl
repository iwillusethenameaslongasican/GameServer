
% -module(test).
% -export([test/0]). 
% test() ->
%     lager:info("test info"),
%     lager:error("test error").

 
 		% 	Msg = #c2s_login_request{username="hello world", password="world"},  
			% Pkt = player_pb:encode_c2s_login_request(Msg),
			% NewPkt = pt_10:encode(c2s_login_request, Pkt),
			% ok = gen_tcp:send(Socket, NewPkt)

-module(test).
-export([
			start/0,
			reset_tables/0,
			demo/0,
			do/1,
			is_process_alive/1
		]).

-include_lib("/usr/local/lib/erlang/lib/stdlib-3.3/include/qlc.hrl").

-record(shop, {item, quantity, cost}).
-record(cost, {name, price}).

is_process_alive(Pid) when is_pid(Pid)->
rpc:call(node(Pid),erlang,is_process_alive,[Pid]);
is_process_alive(_Pid)->
false.

start() ->
	mnesia:create_schema([node()]),
	mnesia:start(),
	mnesia:create_table(shop, [{attributes, record_info(fields, shop)}]),
	mnesia:create_table(cost, [{attributes, record_info(fields, cost)}]).

example_tables() ->
	[
		%% shop表
		{shop, apple, 20, 2.3},
		{shop, orange, 100, 3.8},
		{shop, pear, 200, 3.6},
		{shop, banana, 420, 4.5},
		%% cost表
		{cost, apple, 1.5},
		{cost, orange, 2.4},
		{cost, pear, 2.2},
		{cost, banana, 1.5}
	].

reset_tables() ->
	mnesia:clear_table(shop),
	mnesia:clear_table(cost),
	F = fun() ->
			lists:foreach(fun mnesia:write/1, example_tables())
		end,
	mnesia:transaction(F).

demo() ->
	do(qlc:q([X || X <- mnesia:table(shop)])).


do(Q) ->
	F = fun() -> qlc:e(Q) end,
	{atomic, Val} = mnesia:transaction(F),
	Val.