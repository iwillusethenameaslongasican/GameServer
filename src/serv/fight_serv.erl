%%% @Author  : hanyan
%%% @Email   : ithinkily@vip.qq.com
%%% @Created : 2018.1.15
%%% @Description: 战斗进程
%%%------------------------------------

-module(fight_serv).

-behaviour(gen_server). 

%% API
-export([start/1, stop/1]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("../common/common.hrl").
-include("../common/role.hrl").
-include("../include/fight_pb.hrl").


start(FightInfos) ->
	gen_server:start(?MODULE, [FightInfos], []).

%停止本游戏进程
stop(Pid) 
	when is_pid(Pid) ->
		gen_server:cast(Pid, stop).

init([FightInfos]) ->
	process_flag(trap_exit, true),
	State = #{
	},
	Fun = fun(Info, {Status, Sockets}) ->
			#fight_info{id = Id, socket = Socket} = Info,
			% lager:info("Info:~p", [Info]),
			Status1 = maps:put(Id, Info, Status),
			{Status1, [Socket|Sockets]}
	end,
	{State1, Sockets1} = lists:foldl(Fun, {State, []}, FightInfos),
	State2 = maps:put(0, Sockets1, State1),
	% lager:info("State2:~p", [State2]),
	{ok, State2}.


handle_call(stop, _From, State) ->
	{stop, normal, State};

handle_call(_Request, _From, State) ->
	{noreply, State}.

handle_cast({update_unit, [RoleId, PosX, PosY, PosZ, RotX, RotY, RotZ, GunRot, GunRoll]}, State) ->
	Sockets = maps:get(0, State),
	FightInfo = maps:get(RoleId, State),
	NewFightInfo = FightInfo#fight_info{
						last_update_time = erlang:now(),
						pos_x = PosX,
						pos_y = PosY,
						pos_z = PosZ
						},
	State1 = maps:put(RoleId, NewFightInfo, State),
	{ok, Pkt} = pt_30:write(proto_util:name_to_id(s2c_update_unit_reply), {RoleId, PosX, PosY, PosZ, RotX, RotY, RotZ, GunRot, GunRoll}),
	lib_send:broadcast(Sockets, Pkt),
	{noreply, State1};


handle_cast({shooting, [RoleId, PosX, PosY, PosZ, RotX, RotY, RotZ]}, State) ->
	Sockets = maps:get(0, State),
	{ok, Pkt} = pt_30:write(proto_util:name_to_id(s2c_shooting_reply), {RoleId, PosX, PosY, PosZ, RotX, RotY, RotZ}),
	lib_send:broadcast(Sockets, Pkt),
	{noreply, State};

handle_cast({hit, [RoleId, EnemyId, Damage]}, State) ->
	Sockets = maps:get(0, State),
	RoleInfo = maps:get(RoleId, State),
	FightInfo = maps:get(EnemyId, State),
	#fight_info{last_shoot_time = LastShootTime} = RoleInfo,
	Now = erlang:now(),
	if (Now - LastShootTime) =< 1 ->
			State2 = State,
			lager:info("开炮作弊: ~p", [RoleId]);
	   true ->
	   		NewRoleInfo = RoleInfo#fight_info{
									last_shoot_time = erlang:timestamp()
								},
			State1 = maps:put(RoleId, NewRoleInfo, State),
			NewFightInfo = FightInfo#fight_info{
									hp = FightInfo#fight_info.hp - Damage
								},
			State2 = maps:put(EnemyId, NewFightInfo, State1),
			{ok, Pkt} = pt_30:write(proto_util:name_to_id(s2c_hit_reply), {RoleId, EnemyId, Damage}),
			lib_send:broadcast(Sockets, Pkt),
			%% 胜负判断
			lib_fight:update_win(State2)
	end,
	{noreply, State2};

handle_cast({exit_fight, [Role]}, State) ->
	#ets_role{id = RoleId} = Role,
	gen_server:cast(self(), {hit, [RoleId, RoleId, 999999]}),
	{noreply, State};

handle_cast(stop, State) ->
	{stop, normal, State};

handle_cast(_Msg, State) ->
	{noreply, State}.

handle_info(_Info, State) ->
	{noreply, State}.

terminate(_Reason, _State) ->
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.