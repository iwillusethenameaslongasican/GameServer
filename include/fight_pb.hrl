-ifndef(C2S_START_FIGHT_REQUEST_PB_H).
-define(C2S_START_FIGHT_REQUEST_PB_H, true).
-record(c2s_start_fight_request, {
    
}).
-endif.

-ifndef(S2C_START_FIGHT_REPLY_PB_H).
-define(S2C_START_FIGHT_REPLY_PB_H, true).
-record(s2c_start_fight_reply, {
    ret = erlang:error({required, ret})
}).
-endif.

-ifndef(C2S_FIGHT_REQUEST_PB_H).
-define(C2S_FIGHT_REQUEST_PB_H, true).
-record(c2s_fight_request, {
    
}).
-endif.

-ifndef(S2C_FIGHT_REPLY_PB_H).
-define(S2C_FIGHT_REPLY_PB_H, true).
-record(s2c_fight_reply, {
    count = erlang:error({required, count}),
    objects = []
}).
-endif.

-ifndef(C2S_UPDATE_UNIT_REQUEST_PB_H).
-define(C2S_UPDATE_UNIT_REQUEST_PB_H, true).
-record(c2s_update_unit_request, {
    pos_x = erlang:error({required, pos_x}),
    pos_y = erlang:error({required, pos_y}),
    pos_z = erlang:error({required, pos_z}),
    rot_x = erlang:error({required, rot_x}),
    rot_y = erlang:error({required, rot_y}),
    rot_z = erlang:error({required, rot_z})
}).
-endif.

-ifndef(S2C_UPDATE_UNIT_REPLY_PB_H).
-define(S2C_UPDATE_UNIT_REPLY_PB_H, true).
-record(s2c_update_unit_reply, {
    id = erlang:error({required, id}),
    pos_x = erlang:error({required, pos_x}),
    pos_y = erlang:error({required, pos_y}),
    pos_z = erlang:error({required, pos_z}),
    rot_x = erlang:error({required, rot_x}),
    rot_y = erlang:error({required, rot_y}),
    rot_z = erlang:error({required, rot_z})
}).
-endif.

-ifndef(C2S_SHOOTING_REQUEST_PB_H).
-define(C2S_SHOOTING_REQUEST_PB_H, true).
-record(c2s_shooting_request, {
    pos_x = erlang:error({required, pos_x}),
    pos_y = erlang:error({required, pos_y}),
    pos_z = erlang:error({required, pos_z}),
    rot_x = erlang:error({required, rot_x}),
    rot_y = erlang:error({required, rot_y}),
    rot_z = erlang:error({required, rot_z})
}).
-endif.

-ifndef(S2C_SHOOTING_REPLY_PB_H).
-define(S2C_SHOOTING_REPLY_PB_H, true).
-record(s2c_shooting_reply, {
    id = erlang:error({required, id}),
    pos_x = erlang:error({required, pos_x}),
    pos_y = erlang:error({required, pos_y}),
    pos_z = erlang:error({required, pos_z}),
    rot_x = erlang:error({required, rot_x}),
    rot_y = erlang:error({required, rot_y}),
    rot_z = erlang:error({required, rot_z})
}).
-endif.

-ifndef(C2S_HIT_REQUEST_PB_H).
-define(C2S_HIT_REQUEST_PB_H, true).
-record(c2s_hit_request, {
    enemy_id = erlang:error({required, enemy_id}),
    damage = erlang:error({required, damage})
}).
-endif.

-ifndef(S2C_HIT_REPLY_PB_H).
-define(S2C_HIT_REPLY_PB_H, true).
-record(s2c_hit_reply, {
    id = erlang:error({required, id}),
    enemy_id = erlang:error({required, enemy_id}),
    damage = erlang:error({required, damage})
}).
-endif.

-ifndef(C2S_RESULT_REQUEST_PB_H).
-define(C2S_RESULT_REQUEST_PB_H, true).
-record(c2s_result_request, {
    
}).
-endif.

-ifndef(S2C_RESULT_REPLY_PB_H).
-define(S2C_RESULT_REPLY_PB_H, true).
-record(s2c_result_reply, {
    camp = erlang:error({required, camp})
}).
-endif.

-ifndef(C2S_GET_SUPPLY_REQUEST_PB_H).
-define(C2S_GET_SUPPLY_REQUEST_PB_H, true).
-record(c2s_get_supply_request, {
    
}).
-endif.

-ifndef(S2C_GET_SUPPLY_REPLY_PB_H).
-define(S2C_GET_SUPPLY_REPLY_PB_H, true).
-record(s2c_get_supply_reply, {
    ret = erlang:error({required, ret})
}).
-endif.

-ifndef(OBJECT_INFO_PB_H).
-define(OBJECT_INFO_PB_H, true).
-record(object_info, {
    id = erlang:error({required, id}),
    team = erlang:error({required, team}),
    swop_id = erlang:error({required, swop_id})
}).
-endif.

