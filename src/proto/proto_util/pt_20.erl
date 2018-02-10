%%%-----------------------------------
%%% @Module  : pt_20
%%% @Author  : hanyan
%%% @Email   : ithinkily@vip.qq.com
%%% @Created : 2017.11.12
%%% @Description: 20场景
%%%-----------------------------------
-module(pt_20).
-export([read/2, write/2, encode/2]).
-include("../include/room_pb.hrl").
-include("../common/common.hrl").
-include("../common/role.hrl").

%%获取玩家成绩
read(20003, <<Bin/binary>>) ->
	lager:info("get_achieve"),
  Msg = room_pb:decode_c2s_get_achieve_request(Bin),
  #c2s_get_achieve_request{
    id = Id
  } = Msg,
  [Role] = ets:lookup(?ETS_ROLE, Id),
  #ets_role{id = RoleId, win = Win, fail = Fail} = Role,
  % Reply = #s2c_get_achieve_reply{id = RoleId, win = Win, fail = Fail}
  % lager:info("Reply:~p", [Reply]),
  {ok, [RoleId, Win, Fail]};

%%获取房间列表
read(20005, <<Bin/binary>>) ->
	lager:info("get_room_list"),
    Rooms = mod_scene:get_room_list(),
    Num = length(Rooms),
    {ok,  [Rooms, Num]};

%%创建房间
read(20007, <<Bin/binary>>) ->
	 lager:info("create_room"),
    {ok,  []};

%%进入房间
read(20009, <<Bin/binary>>) ->
	lager:info("enter_room"),
   Msg = room_pb:decode_c2s_enter_room_request(Bin),
   #c2s_enter_room_request{room_id = RoomId} = Msg,
    {ok,  [RoomId]};

%%取得房间信息
read(20011, <<Bin/binary>>) ->
	lager:info("get_room_info"),
    Msg = room_pb:decode_c2s_get_room_info_request(Bin),
   #c2s_get_room_info_request{room_id = RoomId} = Msg,
    {ok,  [RoomId]};

%%离开房间
read(20013, <<Bin/binary>>) ->
	lager:info("leave_room"),
  Msg = room_pb:decode_c2s_leave_room_request(Bin),
   #c2s_leave_room_request{room_id = RoomId} = Msg,
    {ok,  [RoomId]};

read(_Cmd, _R) ->
    {error, no_match}.


write(20004, {RoleId, Win, Fail}) ->
    Msg = #s2c_get_achieve_reply{id = RoleId, win = Win, fail = Fail},
    lager:info("Msg: ~p", [Msg]),  
    Pkt = room_pb:encode_s2c_get_achieve_reply(Msg),
    NewPkt = encode(s2c_get_achieve_reply, Pkt),
    {ok, NewPkt};

write(20006, {Rooms, Num}) ->
    Msg = #s2c_get_room_list_reply{num = Num, rooms = Rooms},
    lager:info("Msg: ~p", [Msg]),  
    Pkt = room_pb:encode_s2c_get_room_list_reply(Msg),
    NewPkt = encode(s2c_get_room_list_reply, Pkt),
    {ok, NewPkt};

write(20008, {Ret, RoomId}) ->
    Msg = #s2c_create_room_reply{ret = Ret, room_id = RoomId},
    lager:info("Msg: ~p", [Msg]),  
    Pkt = room_pb:encode_s2c_create_room_reply(Msg),
    NewPkt = encode(s2c_create_room_reply, Pkt),
    {ok, NewPkt};

write(20010, {Ret, RoomId}) ->
    Msg = #s2c_enter_room_reply{ret = Ret, room_id = RoomId},
    lager:info("Msg: ~p", [Msg]),  
    Pkt = room_pb:encode_s2c_enter_room_reply(Msg),
    NewPkt = encode(s2c_enter_room_reply, Pkt),
    {ok, NewPkt};

write(20012, {Num, RoleInfos}) ->
    Msg = #s2c_get_room_info_reply{num = Num, roles = RoleInfos},
    lager:info("Msg: ~p", [Msg]),  
    Pkt = room_pb:encode_s2c_get_room_info_reply(Msg),
    NewPkt = encode(s2c_get_room_info_reply, Pkt),
    {ok, NewPkt};

write(20014, {Ret}) ->
    Msg = #s2c_leave_room_reply{ret = Ret},
    lager:info("Msg: ~p", [Msg]),  
    Pkt = room_pb:encode_s2c_leave_room_reply(Msg),
    NewPkt = encode(s2c_leave_room_reply, Pkt),
    {ok, NewPkt};

write(_Cmd, _R) ->
    {ok, <<>>}.


encode(c2s_get_achieve_request, Msg)->
   Id = proto_util:name_to_id(c2s_get_achieve_request),
   encode_1(Id, Msg);
encode(s2c_get_achieve_reply, Msg) ->
    Id = proto_util:name_to_id(s2c_get_achieve_reply),
    encode_1(Id, Msg);
encode(c2s_get_room_list_request, Msg)->
   Id = proto_util:name_to_id(c2s_get_room_list_request),
   encode_1(Id, Msg);
encode(s2c_get_room_list_reply, Msg) ->
    Id = proto_util:name_to_id(s2c_get_room_list_reply),
    encode_1(Id, Msg);
encode(c2s_create_room_request, Msg)->
   Id = proto_util:name_to_id(c2s_create_room_request),
   encode_1(Id, Msg);
encode(s2c_create_room_reply, Msg) ->
    Id = proto_util:name_to_id(s2c_create_room_reply),
    encode_1(Id, Msg);
encode(c2s_enter_room_request, Msg)->
   Id = proto_util:name_to_id(c2s_enter_room_request),
   encode_1(Id, Msg);
encode(s2c_enter_room_reply, Msg) ->
    Id = proto_util:name_to_id(s2c_enter_room_reply),
    encode_1(Id, Msg);
encode(c2s_get_room_info_request, Msg)->
   Id = proto_util:name_to_id(c2s_get_room_info_request),
   encode_1(Id, Msg);
encode(s2c_get_room_info_reply, Msg) ->
    Id = proto_util:name_to_id(s2c_get_room_info_reply),
    encode_1(Id, Msg);
encode(c2s_leave_room_request, Msg)->
   Id = proto_util:name_to_id(c2s_leave_room_request),
   encode_1(Id, Msg);
encode(s2c_leave_room_reply, Msg) ->
    Id = proto_util:name_to_id(s2c_leave_room_reply),
    encode_1(Id, Msg);
encode(Undefied, _Msg) ->
    undefied.

encode_1(Id, Msg) ->
    Pkt = erlang:iolist_to_binary(Msg),
    Len = erlang:iolist_size(Pkt) + 4,
    lager:info("Id:~p", [Id]),
    <<Len:2/unit:8-little, Id:4/unit:8-little, Pkt/binary>>.