%%%-----------------------------------
%%% @Module  : pt_30
%%% @Author  : hanyan
%%% @Email   : ithinkily@vip.qq.com
%%% @Created : 2018.1.12
%%% @Description: 30战斗
%%%-----------------------------------
-module(pt_30).
-export([read/2, write/2, encode/2]).
-include("../include/fight_pb.hrl").
-include("../common/common.hrl").
-include("../common/role.hrl").

%%战斗请求
read(30001, <<Bin/binary>>) ->
  lager:info("start_fight"),
  _Msg = fight_pb:decode_c2s_start_fight_request(Bin),
  {ok, []};

%% 位置同步
read(30005, <<Bin/binary>>) ->
  % lager:info("update_unit"),
  Msg = fight_pb:decode_c2s_update_unit_request(Bin),
  #c2s_update_unit_request{pos_x = PosX, pos_y = PosY, pos_z = PosZ, 
                          rot_x =RotX, rot_y = RotY, rot_z = RotZ,
                          gun_rot = GunRot, gun_roll = GunRoll} = Msg,
  {ok, [PosX, PosY, PosZ, RotX, RotY, RotZ, GunRot, GunRoll]};

%% 发射炮弹
read(30007, <<Bin/binary>>) ->
  lager:info("shooting"),
  Msg = fight_pb:decode_c2s_shooting_request(Bin),
  #c2s_shooting_request{pos_x = PosX, pos_y = PosY, pos_z = PosZ, 
                        rot_x =RotX, rot_y = RotY, rot_z = RotZ} = Msg,
  {ok, [PosX, PosY, PosZ, RotX, RotY, RotZ]};

%% 击中目标
read(30009, <<Bin/binary>>) ->
  lager:info("hit"),
  Msg = fight_pb:decode_c2s_hit_request(Bin),
  #c2s_hit_request{enemy_id = EnemyId, damage = Damage} = Msg,
  {ok, [EnemyId, Damage]};

read(_Cmd, _R) ->
    {error, no_match}.

write(30002, {Ret}) -> 
    Msg = #s2c_start_fight_reply{ret = Ret},
    % lager:info("Msg: ~p", [Msg]),  
    Pkt = fight_pb:encode_s2c_start_fight_reply(Msg),
    NewPkt = encode(s2c_start_fight_reply, Pkt),
    {ok, NewPkt};

write(30004, {Count, Objects}) ->
    Msg = #s2c_fight_reply{count = Count, objects = Objects},
    lager:info("Msg: ~p", [Msg]),  
    Pkt = fight_pb:encode_s2c_fight_reply(Msg),
    NewPkt = encode(s2c_fight_reply, Pkt),
    {ok, NewPkt};

write(30006, {RoleId, PosX, PosY, PosZ, RotX, RotY, RotZ, GunRot, GunRoll}) ->
    Msg = #s2c_update_unit_reply{id = RoleId, pos_x = PosX, pos_y = PosY, pos_z = PosZ, 
                                 rot_x =RotX, rot_y = RotY, rot_z = RotZ,
                                 gun_rot = GunRot, gun_roll = GunRoll},
    % lager:info("Msg: ~p", [Msg]),  
    Pkt = fight_pb:encode_s2c_update_unit_reply(Msg),
    NewPkt = encode(s2c_update_unit_reply, Pkt),
    {ok, NewPkt};

write(30008, {RoleId, PosX, PosY, PosZ, RotX, RotY, RotZ}) ->
    Msg = #s2c_shooting_reply{id = RoleId, pos_x = PosX, pos_y = PosY, pos_z = PosZ, 
                                 rot_x =RotX, rot_y = RotY, rot_z = RotZ},
    lager:info("Msg: ~p", [Msg]),  
    Pkt = fight_pb:encode_s2c_shooting_reply(Msg),
    NewPkt = encode(s2c_shooting_reply, Pkt),
    {ok, NewPkt};

write(30010, {RoleId, EnemyId, Damage}) ->
    Msg = #s2c_hit_reply{id = RoleId, enemy_id = EnemyId, damage = Damage},
    lager:info("Msg: ~p", [Msg]),  
    Pkt = fight_pb:encode_s2c_hit_reply(Msg),
    NewPkt = encode(s2c_hit_reply, Pkt),
    {ok, NewPkt};

write(30012, {Camp}) ->
    Msg = #s2c_result_reply{camp = Camp},
    lager:info("Msg: ~p", [Msg]),  
    Pkt = fight_pb:encode_s2c_result_reply(Msg),
    NewPkt = encode(s2c_result_reply, Pkt),
    {ok, NewPkt};

write(_Cmd, _R) ->
    {ok, <<>>}.

encode(c2s_start_fight_request, Msg)->
   Id = proto_util:name_to_id(c2s_start_fight_request),
   encode_1(Id, Msg);
encode(s2c_start_fight_reply, Msg) ->
    Id = proto_util:name_to_id(s2c_start_fight_reply),
    encode_1(Id, Msg);
encode(c2s_fight_request, Msg)->
   Id = proto_util:name_to_id(c2s_fight_request),
   encode_1(Id, Msg);
encode(s2c_fight_reply, Msg) ->
    Id = proto_util:name_to_id(s2c_fight_reply),
    encode_1(Id, Msg);
encode(c2s_update_unit_request, Msg)->
   Id = proto_util:name_to_id(c2s_update_unit_request),
   encode_1(Id, Msg);
encode(s2c_update_unit_reply, Msg) ->
    Id = proto_util:name_to_id(s2c_update_unit_reply),
    encode_1(Id, Msg);
encode(c2s_shooting_request, Msg)->
   Id = proto_util:name_to_id(c2s_shooting_request),
   encode_1(Id, Msg);
encode(s2c_shooting_reply, Msg) ->
    Id = proto_util:name_to_id(s2c_shooting_reply),
    encode_1(Id, Msg);
encode(c2s_hit_request, Msg)->
   Id = proto_util:name_to_id(c2s_hit_request),
   encode_1(Id, Msg);
encode(s2c_hit_reply, Msg) ->
    Id = proto_util:name_to_id(s2c_hit_reply),
    encode_1(Id, Msg);
encode(c2s_result_request, Msg)->
   Id = proto_util:name_to_id(c2s_result_request),
   encode_1(Id, Msg);
encode(s2c_result_reply, Msg) ->
    Id = proto_util:name_to_id(s2c_result_reply),
    encode_1(Id, Msg);
encode(Undefied, _Msg) ->
    undefied.

encode_1(Id, Msg) ->
    Pkt = erlang:iolist_to_binary(Msg),
    Len = erlang:iolist_size(Pkt) + 4,
    <<Len:2/unit:8-little, Id:4/unit:8-little, Pkt/binary>>.