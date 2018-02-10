%%%-----------------------------------
%%% @Module  : mod_scene
%%% @Author  : hanyan
%%% @Email   : ithinkily@vip.qq.com
%%% @Created : 2018.1.2
%%% @Description: 场景进程
%%%-----------------------------------

-module(mod_scene).


-include("../common/common.hrl").
-include("../common/role.hrl").
-include("../include/room_pb.hrl").

-compile(export_all).

-export([get_room_list/0, create_room/3, get_room_info/1, enter_room/4, leave_room/2, can_start/2, get_fpid/1]).

get_room_list() ->
	L = ets:match_object(?ETS_SCENE, #ets_scene{_='_'}),
    Fun = fun(Room, Lists) ->
        #ets_scene{id = Id, num = Num, status = Status} = Room,
        RoomInfo = #room_info{room_id = Id, num = Num, status = Status},
        [RoomInfo|Lists]
    end,
    Rooms = lists:foldl(Fun, [], L),
    Rooms.

create_room(RoleId, Win, Fail) ->
	RoleInfo = #role_info{
		id = RoleId,
		team = 1,
		win = Win,
		fail = Fail,
		is_owner = 1
	},
	RoomId = mod_id:generate(room),
	Scene = #ets_scene{
		id = RoomId,
		status = 0,
		num = 1,
		roles = [RoleInfo]
	},
	ets:insert(?ETS_SCENE, Scene),
	{1, RoomId}.

enter_room(RoomId, RoleId, Win, Fail) ->
	case ets:lookup(?ETS_SCENE, RoomId) of
		[] ->
			{0, []};
		[Scene] ->
			#ets_scene{num = Num, roles = Roles, status = Status} = Scene,
			Len = length(Roles),
			if Len >= 6 ->
					{0, []};
			   true ->
			   		if Status =:= 1 ->
			   				{0, []};
			   		   true ->
							Team = switch_team(Roles),
							RoleInfo = #role_info{
									id = RoleId,
									team = Team,
									win = Win,
									fail = Fail,
									is_owner = 0
							},
							Num1 = Num + 1,
							if Num1 =:= 6 ->
									Status1 = 1;
							   true ->
									Status1 = 0
							end,
							Scene1 = Scene#ets_scene{num = Num + 1, roles = [RoleInfo|Roles], status = Status1},
							ets:insert(?ETS_SCENE, Scene1),
							Sockets = get_sockets([RoleInfo|Roles]),
							{1, Sockets}

					end
			end
	end.					

leave_room(RoomId, RoleId) ->
	case ets:lookup(?ETS_SCENE, RoomId) of
		[] ->
			{0};
		[Scene] ->
			#ets_scene{roles = Roles} = Scene,
			Role = lists:keyfind(RoleId, 2, Roles),
			#role_info{is_owner = IsOwner} = Role,
			lager:info("Roles:~p", [Roles]),
			Roles1 = lists:keydelete(RoleId, 2, Roles),
			lager:info("Roles1:~p", [Roles1]),
			Num1 = length(Roles1),
			if Num1 =:= 0 ->
					ets:delete(?ETS_SCENE, RoomId);
			   true ->
			   		if IsOwner =:= 1 ->
			   				Roles2 = update_owner(Roles1);
			   		   true ->
			   		   		Roles2 = Roles1
			   		end,
			   		% lager:info("Roles2: ~p", [Roles2]),
					Scene1 = Scene#ets_scene{num = length(Roles1), roles = Roles2},
					ets:insert(?ETS_SCENE, Scene1)
			end,
			{1}
	end.

can_start(RoomId, RoleId) ->
	case ets:lookup(?ETS_SCENE, RoomId) of
		[] ->
			{0};
		[Scene] ->
			#ets_scene{roles = Roles, status = Status} = Scene,
			Role = lists:keyfind(RoleId, 2, Roles),
			#role_info{is_owner = IsOwner} = Role,
			if IsOwner =:= 0 ->
					{0};
			   true ->
			   		if Status =:= 1 ->
			   				{0};
			   		   true ->
			   		   		{Count1, Count2} = count(Roles),
			   		   		if Count1 < 1 orelse Count2 < 1 ->
			   		   				{0};
			   		   		   true ->
			   		   		   		Scene1 = Scene#ets_scene{status = 1},
			   		   		   		ets:insert(?ETS_SCENE, Scene1),
			   		   		   		{1}
			   		   		end
			   		end
			end
	end.


get_room_info(RoomId) ->
	case ets:lookup(?ETS_SCENE, RoomId) of
		[] ->
			{0, []};
		[Scene] ->
			#ets_scene{num = Num, roles = Roles} = Scene,
			{Num, lists:reverse(Roles)}
	end.

switch_team(Roles) ->
	{Count1, Count2} = count(Roles),
	if Count1 =< Count2 ->
			Ret = 1;
	   true ->
	   		Ret = 2
	end,
	Ret.

count(Roles) ->
	Fun = fun(Role, {Count1, Count2}) ->
		#role_info{team = Team} = Role,
		if Team =:= 1 ->
				{Count1 + 1, Count2};
		   true ->
		   		{Count1, Count2 + 1}
		end
	end,
	{Count1, Count2} = lists:foldl(Fun, {0, 0}, Roles).

update_owner(Roles) ->
	[Role|_] = Roles,
	#role_info{id = RoleId} = Role,
	Role1 = Role#role_info{is_owner = 1},
	Roles1 = lists:keyreplace(RoleId, 2, Roles, Role1).

get_sockets(Roles) ->
	Fun = fun(Role, List) ->
			#role_info{id = Id} = Role,
			case ets:lookup(?ETS_ROLE, Id) of
				[] ->
					List;
				[Role1] ->
					#ets_role{socket = Socket} = Role1,
					[Socket|List]
			end
		end,
	Sockets = lists:foldl(Fun, [], Roles).

get_fpid(RoomId) ->
	case ets:lookup(?ETS_SCENE, RoomId) of
		[] ->
			0;
		[Scene] ->
			#ets_scene{fpid = FPid} = Scene,
			FPid
	end.



