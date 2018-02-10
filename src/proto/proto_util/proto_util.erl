%%%-----------------------------------
%%% @Module  : proto_util
%%% @Author  : hanyan
%%% @Email   : ithinkily@vip.qq.com
%%% @Created : 2017.12.26
%%% @Description: 协议相关类
%%%-----------------------------------

-module(proto_util).

-export([id_to_name/1, name_to_id/1]).

id_to_name(10001) ->
	c2s_login_request;
id_to_name(10002) ->
	s2c_login_reply;
id_to_name(10003) ->
	c2s_register_request;
id_to_name(10004) ->
	s2c_register_reply;
id_to_name(10005) ->
	c2s_logout_request;
id_to_name(10006) ->
	s2c_logout_reply;
id_to_name(10007) ->
	c2s_heartbeat_request;
id_to_name(10008) ->
	s2c_heartbeat_reply;
id_to_name(20003) ->
	c2s_get_achieve_request;
id_to_name(20004) ->
	s2c_get_achieve_reply;
id_to_name(20005) ->
	c2s_get_room_list_request;
id_to_name(20006) ->
	s2c_get_room_list_reply;
id_to_name(20007) ->
	c2s_create_room_request;
id_to_name(20008) ->
	s2c_create_room_reply;
id_to_name(20009) ->
	c2s_enter_room_request;
id_to_name(20010) ->
	s2c_enter_room_reply;
id_to_name(20011) ->
	c2s_get_room_info_request;
id_to_name(20012) ->
	s2c_get_room_info_reply;
id_to_name(20013) ->
	c2s_leave_room_request;
id_to_name(20014) ->
	s2c_leave_room_reply;
id_to_name(30001) ->
	c2s_start_fight_request;
id_to_name(30002) ->
	s2c_start_fight_reply;
id_to_name(30003) ->
	c2s_fight_request;
id_to_name(30004) ->
	s2c_fight_reply;
id_to_name(30005) ->
	c2s_update_unit_request;
id_to_name(30006) ->
	s2c_update_unit_reply;
id_to_name(30007) ->
	c2s_shooting_request;
id_to_name(30008) ->
	s2c_shooting_reply;
id_to_name(30009) ->
	c2s_hit_request;
id_to_name(30010) ->
	s2c_hit_reply;
id_to_name(30011) ->
	c2s_result_request;
id_to_name(30012) ->
	s2c_result_reply;
id_to_name(40001) ->
	c2s_chat_request;
id_to_name(40002) ->
	s2c_chat_reply;
id_to_name(40003) ->
	c2s_group_chat_request;
id_to_name(40004) ->
	s2c_group_chat_reply;
id_to_name(50001) ->
	c2s_friend_list_request;
id_to_name(50002) ->
	s2c_friend_list_reply;
id_to_name(50003) ->
	c2s_add_friend_request;
id_to_name(50004) ->
	s2c_add_friend_reply;
id_to_name(50005) ->
	c2s_del_friend_request;
id_to_name(50006) ->
	s2c_del_friend_reply;
id_to_name(50007) ->
	c2s_friend_info_request;
id_to_name(50006) ->
	s2c_friend_info_reply;
id_to_name(_) ->
	undefined.

name_to_id(c2s_login_request) ->
	10001;
name_to_id(s2c_login_reply) ->
	10002;
name_to_id(c2s_register_request) ->
	10003;
name_to_id(s2c_register_reply) ->
	10004;
name_to_id(c2s_logout_request) ->
	10005;
name_to_id(s2c_logout_reply) ->
	10006;
name_to_id(c2s_heartbeat_request) ->
	10007;
name_to_id(s2c_heartbeat_reply) ->
	10008;
name_to_id(c2s_get_achieve_request) ->
	20003;
name_to_id(s2c_get_achieve_reply) ->
	20004;
name_to_id(c2s_get_room_list_request) ->
	20005;
name_to_id(s2c_get_room_list_reply) ->
	20006;
name_to_id(s2c_create_room_reply) ->
	20008;
name_to_id(c2s_enter_room_request) ->
	20009;
name_to_id(s2c_enter_room_reply) ->
	20010;
name_to_id(c2s_get_room_info_request) ->
	20011;
name_to_id(s2c_get_room_info_reply) ->
	20012;
name_to_id(c2s_leave_room_request) ->
	20013;
name_to_id(s2c_leave_room_reply) ->
	20014;
name_to_id(c2s_start_fight_request) ->
	30001;
name_to_id(s2c_start_fight_reply) ->
	30002;
name_to_id(c2s_fight_request) ->
	30003;
name_to_id(s2c_fight_reply) ->
	30004;
name_to_id(c2s_update_unit_request) ->
	30005;
name_to_id(s2c_update_unit_reply) ->
	30006;
name_to_id(c2s_shooting_request) ->
	30007;
name_to_id(s2c_shooting_reply) ->
	30008;
name_to_id(c2s_hit_request) ->
	30009;
name_to_id(s2c_hit_reply) ->
	30010;
name_to_id(c2s_result_request) ->
	30011;
name_to_id(s2c_result_reply) ->
	30012;
name_to_id(c2s_chat_request) ->
	40001;
name_to_id(s2c_chat_reply) ->
	40002;
name_to_id(c2s_group_chat_request) ->
	40003;
name_to_id(s2c_group_chat_reply) ->
	40004;
name_to_id(c2s_friend_list_request) ->
	50001;
name_to_id(s2c_friend_list_reply) ->
	50002;
name_to_id(c2s_add_friend_request) ->
	50003;
name_to_id(s2c_add_friend_reply) ->
	50004;
name_to_id(c2s_del_friend_request) ->
	50005;
name_to_id(s2c_del_friend_reply) ->
	50006;
name_to_id(c2s_friend_info_request) ->
	50007;
name_to_id(s2c_friend_info_reply) ->
	50008;
name_to_id(_) ->
	undefined.


