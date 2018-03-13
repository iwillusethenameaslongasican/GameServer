%%%------------------------------------------------
%%% File    : role.hrl
%%% Author  : hanyan
%%% Created : 2017-11-10
%%% Description: record
%%%------------------------------------------------

%%###########ETS##################
%%  在线玩家
-record(ets_online, {
        id,
        x,
        y, 
        z,
        score,
        socket
    }).

%% 场景
-record(ets_scene, {
		id,
		status,
		fpid,
		num,
		roles
	}).


%% 角色信息
-record(ets_role, {
		id,
		username,
		password,
		win,
		fail,
		pid,
		room_id,
		socket,
		score,
		last_heartbeat_time
	}).

%%好友
-record(ets_friend, {
		id,
		num,
		friends
	}).

-record(friend, {
		id,
		username,
		image,
		win,
		fail
	}).

-record(account, {id, username, password, win, fail}).
-record(friends, {id, friend_list}).

-record(fight_info, {id, last_update_time, pos_x, pos_y, pos_z, last_shoot_time, team, hp, bullet, rpid, socket}).