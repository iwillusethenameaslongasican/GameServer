%%%-----------------------------------
%%% @Module  : mod_login
%%% @Author  : hanyan
%%% @Email   : ithinkily@vip.qq.com
%%% @Created : 2018.1.8
%%% @Description: 用户登陆
%%%-----------------------------------

-module(mod_login).


-include("../common/common.hrl").
-include("../common/role.hrl").

-compile(export_all).


-export([login/3, logout/3]).

%%用户登陆
login(start, [Id, UserName, Password, Win, Fail], Socket) ->
	{ok, Pid} = mod_role:start(),
	Role = #ets_role{
		id = Id,
		username = UserName,
		password = Password,
		win = Win,
		fail = Fail,
		pid = Pid,
		room_id = 0,
		socket = Socket,
		score = 0,
		last_heartbeat_time = 0
	},
	ets:insert(?ETS_ROLE, Role),
	gen_server:cast(Pid, {'SET_ROLE', Role}),
	{ok, Pid}.

%退出
logout(Pid, Role, Why) when is_pid(Pid) ->
	lager:info("exit reason: ~p", [Why]),
	#ets_role{id = RoleId, pid = Pid, room_id = RoomId} = Role,
	case ets:lookup(?ETS_SCENE, RoomId) of
		[] ->
			Role1 = Role,
			ok;
		[Scene] ->
			#ets_scene{status = State, fpid = FPid} = Scene,
				if State =:= 0 ->
						pp_scene:handle(20013, Role, [RoomId]),
						ets:delete(?ETS_ROLE, RoleId),
						Role1 = Role;
					true ->
						gen_server:cast(FPid, {exit_fight, [Role]}),
						Role1 = Role#ets_role{fail = Role#ets_role.fail + 1},
						mod_scene:leave_room(RoomId, RoleId),
						ets:delete(?ETS_ROLE, RoleId)
				end
	end,
	db_util:update_role(Role1),
	mod_role:stop(Pid),
	ok;

%正常退出
logout(_State, _Role, _Why) ->
	%% 保存用户信息
	ok.