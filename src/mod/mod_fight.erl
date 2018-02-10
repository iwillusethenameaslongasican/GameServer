%%%-----------------------------------
%%% @Module  : mod_fight
%%% @Author  : hanyan
%%% @Email   : ithinkily@vip.qq.com
%%% @Created : 2018.1.12
%%% @Description: 用户登陆
%%%-----------------------------------

-module(mod_fight).


-include("../common/common.hrl").
-include("../common/role.hrl").
-include("../include/fight_pb.hrl").
-include("../include/room_pb.hrl").

-export([get_objects/1, start_fight/1, get_fight_info/1, update_win/1, print/1, get_pids/1]).

-compile(export_all).

get_objects(RoomId) ->
	case ets:lookup(?ETS_SCENE, RoomId) of
		[] ->
			{0, []};
		[Scene] ->
			#ets_scene{num = Num, roles = Roles} = Scene,
			Fun = fun(Role, {Index, Objects}) ->
					#role_info{id = RoleId, team = Team} = Role,
					if Index > 3 ->
						 Index1 = 1;
					   true ->
					   	 Index1 = Index
					end,
					Object = #object_info{
						id = RoleId,
						team = Team,
						swop_id = Index1
					},
					{Index1 + 1, [Object|Objects]}
			end,
			{_Index, Objects0} = lists:foldl(Fun, {1, []}, Roles),
			{Num, Objects0}
	end.

get_fight_info(RoleInfos) ->
	% lager:info("RoleInfos:~p", [RoleInfos]),
	Fun = fun(Role, Infos) ->
			#role_info{id = Id, team = Team} = Role,
			[EtsRole] = ets:lookup(?ETS_ROLE, Id),
			#ets_role{pid = Pid, socket = Socket} = EtsRole,
			FightInfo = #fight_info{
				id = Id,
				last_update_time = 0,
				pos_x = 0,
				pos_y = 0,
				pos_z = 0,
				last_shoot_time = 0,
				team = Team,
				hp = 100000,
				rpid = Pid,
				socket = Socket
			},
			[FightInfo|Infos]
	end,
	FightInfos = lists:foldl(Fun, [], RoleInfos).

update_win(State) ->
	IsWin = is_win(State),
	if IsWin =:= 0 ->
			ok;
	   true ->
	   		Fun = fun(X, Y, Lists) ->
				if X =:= 0 ->
						Lists;
				   true ->
				   		{fight_info, _, _, _, _, _, _, Team, _Socket, Pid, _} = Y,
				   		lager:info("Pid:~p", [{Pid}]),
				   		gen_server:cast(Pid, {finish_game, IsWin, Team})
				end
			end,
			_L = maps:fold(Fun, [], State)
	end.


is_win(State) ->
	% maps:map(fun(X, Y) -> lager:info("~p => ~p", [X, Y]) end, State).
	Fun = fun(X, Y, {Count1, Count2}) ->
				if X =:= 0 ->
						{Count1, Count2};
				   true ->
				   		{fight_info, _, _, _, _, _, _, Team, Hp, _, _} = Y,
				   		lager:info("Team, Hp:~p", [{Team, Hp}]),
				   		if (Team =:= 1) andalso (Hp > 0) ->
				   				{Count1 + 1, Count2};
				   		   (Team =:= 2) andalso (Hp > 0) ->
				   		   		{Count1, Count2 + 1};
				   		   true ->
				   		   		{Count1, Count2}
				   		end
				end
	end,
	{Count1, Count2} = maps:fold(Fun, {0, 0}, State),
	if Count1 =:= 0 andalso Count2 =/= 0->
			2;
	   true ->
	   		if Count2 == 0 andalso Count1 =/= 0->
	   			 1;
	   		   true ->
	   		   	 0
	   		end
	end.

get_pids(State) ->
	Fun = fun(X, Y, Lists) ->
				if X =:= 0 ->
						Lists;
				   true ->
				   		{fight_info, _, _, _, _, _, _, _, _, Pid, _} = Y,
				   		[Pid|Lists]
				end
	end,
	Pids = maps:fold(Fun, [], State).

print(State) ->
	maps:map(fun (X, Y) -> lager:info("~p => ~p", [X, Y]) end, State). 

%% 开启战斗进程
start_fight(Roles) ->
	{ok, Pid} = fight_serv:start(Roles),
	Pid.