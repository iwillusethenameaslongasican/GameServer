%%%-----------------------------------
%%% @Module  : role_serv
%%% @Author  : hanyan
%%% @Email   : ithinkily@vip.qq.com
%%% @Created : 2018.1.8
%%% @Description: 用户进程
%%%-----------------------------------

-module(role_serv).

-behaviour(gen_server). 

-include("../common/common.hrl").
-include("../common/role.hrl").
-include("../include/room_pb.hrl").

-compile(export_all).

%% API
-export([start/0, stop/1]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3, get_role/1]).

-define(TIME, 2000).
-define(TIMEOUT, 10).

start() ->
	gen_server:start(?MODULE, [], []).

%停止本游戏进程
stop(Pid) 
	when is_pid(Pid) ->
		gen_server:cast(Pid, stop).


init([]) ->
	process_flag(priority, max),
	erlang:send_after(?TIME, self(), check_heartbeat),
	{ok, none}.

handle_call({'SOCKET_EVENT', Cmd, Bin}, _From, Status) ->
	case routing(Cmd, Status, Bin) of
		{changed, Status1} ->
			{reply, ok, Status1};
		{_, Status2} ->
			{reply, ok, Status2};
		_R ->
			{reply, ok, Status}
	end;


handle_call({'Logout'}, _From, State) ->
	#ets_role{room_id = RoomId} = State,
	{_, State1} = pp_scene:handle(20013, State, [RoomId]),
	{reply, ok, State1};

handle_call(_Request, _From, State) ->
	{noreply, State}.


handle_cast({'SET_ROLE', Role}, _State) ->
	{noreply, Role};

handle_cast({update_heartbeat}, State) ->
	{noreply, State#ets_role{last_heartbeat_time = erlang:timestamp()}};

handle_cast({finish_game, Camp, Team}, State) ->
	#ets_role{id = RoleId, socket = Socket, room_id = RoomId} = State,
	%%发送结果
	pp_fight:handle(30011, State, [Camp]),
	if Camp =:= Team ->
			State1 = State#ets_role{win = State#ets_role.win + 1};
	   true ->
	   		State1 = State#ets_role{fail = State#ets_role.fail + 1}
    end,
	case ets:lookup(?ETS_SCENE, RoomId) of
		[] ->
			skip;
		[Scene] ->
			#ets_scene{roles = Roles} = Scene,
			Role1 = lists:keyfind(RoleId, 2, Roles),
			Role2 = Role1#role_info{win = State1#ets_role.win, fail = State1#ets_role.fail},
			Roles1 = lists:keyreplace(RoleId, 2, Roles, Role2),
			Scene1 = Scene#ets_scene{status = 0, roles = Roles1},
			ets:insert(?ETS_SCENE, Scene1)
	end,
    ets:insert(?ETS_ROLE, State1),
    db_util:update_role(State1),
	{noreply, State1};

handle_cast(stop, State) ->
	{stop, normal, State};

handle_cast(_Msg, State) ->
	{noreply, State}.

handle_info(check_heartbeat, State) ->
	#ets_role{last_heartbeat_time = LastHeartbeatTime} = State,
	Now = erlang:timestamp(),
	Now1 = get_microsecs(Now),
	LastHeartbeatTime1 = get_microsecs(LastHeartbeatTime),
	if Now1 - LastHeartbeatTime1 > ?TIMEOUT ->
			lib_login:logout(self(), State, "HeartBeat TIMEOUT!");
	   true ->
	   		erlang:send_after(?TIME, self(), check_heartbeat)
	end,
	{noreply, State};

handle_info(_Info, State) ->
	{noreply, State}.

terminate(_Reason, _State) ->
	ok.


code_change(_OldVsn, State, _Extra) ->
	{ok, State}.

routing(Cmd, Status, Bin) ->
	[H1, H2, _, _, _] = integer_to_list(Cmd),
	H = [H1, H2],
	case [H1, H2] of
		"10" -> pp_account:handle(Cmd, Status, Bin);
		"20" -> pp_scene:handle(Cmd, Status, Bin);
		"30" -> pp_fight:handle(Cmd, Status, Bin);
		"40" -> pp_chat:handle(Cmd, Status, Bin);
		"50" -> pp_friend:handle(Cmd, Status, Bin);
		_ ->
			lager:error("[~p]路由失败", [Cmd]),
			{error, "routing failure"}
	end.

get_microsecs({Mega, Secs, _Micro}) ->
	 Mega * 1000000 + Secs.

get_role(State) ->
	 Role = #account{
    		id = State#ets_role.id, 
    		username = State#ets_role.username, 
    		password = State#ets_role.password,
    		win = State#ets_role.win, 
    		fail = State#ets_role.fail
    }.

