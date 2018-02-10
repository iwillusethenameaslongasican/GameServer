 %%%--------------------------------------
%%% @Module  : gb
%%% @Author  : hanyan
%%% @Email   : ithinkily@vip.qq.com
%%% @Created : 2017.11.12
%%% @Description:  游戏开启
%%%--------------------------------------
-module(gb).
-export([start/0, stop/0, info/0]).
-define(SERVER_APPS, [sasl, syntax_tools, compiler, goldrush, lager, gb_server]).

%% 启动游戏服务器
start() ->
	try
		ok = start_applications(?SERVER_APPS)
	after
		timer:sleep(100)
	end.

%% 停止游戏服务器
stop() ->
	% ok = mod_login:stop_all(),
	ok = stop_applications(?SERVER_APPS),
	erlang:halt().

info() ->
    SchedId      = erlang:system_info(scheduler_id),
    SchedNum     = erlang:system_info(schedulers),
    ProcCount    = erlang:system_info(process_count),
    ProcLimit    = erlang:system_info(process_limit),
    ProcMemUsed  = erlang:memory(processes_used),
    ProcMemAlloc = erlang:memory(processes),
    MemTot       = erlang:memory(total),
    io:format( "abormal termination:
                       ~n   Scheduler id:                         ~p
                       ~n   Num scheduler:                        ~p
                       ~n   Process count:                        ~p
                       ~n   Process limit:                        ~p
                       ~n   Memory used by erlang processes:      ~p
                       ~n   Memory allocated by erlang processes: ~p
                       ~n   The total amount of memory allocated: ~p
                       ~n",
                            [SchedId, SchedNum, ProcCount, ProcLimit,
                             ProcMemUsed, ProcMemAlloc, MemTot]),
      ok.

%%安装数据库
install() ->
    io:format( "CCCCCCCCCCCCCCCCCCCCC"),
    ok.

%%############辅助调用函数##############
manage_applications(Iterate, Do, Undo, SkipError, ErrorTag, Apps) ->
	Iterate(fun(App, Acc) ->
					case Do(App) of
							ok -> [App | Acc]; %% 合拢
							{error, {SkipError, _}} -> Acc;
							{error, Reason} ->
								lists:foreach(Undo, Acc),
								throw({error, {ErrorTag, App, Reason}})
					end
			end, [], Apps
			),
	ok.

start_applications(Apps) ->
	manage_applications(fun lists:foldl/3,
						fun application:start/1,
						fun application:stop/1,
						already_started,
						cannot_start_application,
						Apps).

stop_applications(Apps) ->
	manage_applications(fun lists:foldr/3,
						fun application:stop/1,
						fun application:start/1,
						not_started,
						cannot_stop_application,
						Apps).