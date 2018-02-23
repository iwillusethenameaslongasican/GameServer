%%%-----------------------------------
%%% @Module  : pt_50
%%% @Author  : hanyan
%%% @Email   : ithinkily@vip.qq.com
%%% @Created : 2018.1.18
%%% @Description: 50好友
%%%-----------------------------------
-module(pt_50).
-export([read/2, write/2, encode/2]).
-include("../include/friend_pb.hrl").
-include("../common/common.hrl").
-include("../common/role.hrl").

%%好友列表
read(50001, <<Bin/binary>>) ->
  lager:info("friend_list"),
  _Msg = friend_pb:decode_c2s_friend_list_request(Bin),
  {ok, []};

%%添加好友
read(50003, <<Bin/binary>>) ->
  lager:info("add_friend"),
  Msg = friend_pb:decode_c2s_add_friend_request(Bin),
  #c2s_add_friend_request{id = Id} = Msg,
  {ok, [Id]};

%%删除好友
read(50005, <<Bin/binary>>) ->
  lager:info("del_friend"),
  Msg = friend_pb:decode_c2s_del_friend_request(Bin),
  #c2s_del_friend_request{id = Id} = Msg,
  {ok, [Id]};

%%好友资料
read(50007, <<Bin/binary>>) ->
  lager:info("friend_info"),
  _Msg = friend_pb:decode_c2s_friend_info_request(Bin),
  {ok, []};

 read(_Cmd, _R) ->
    {error, no_match}.

write(50002, {Num, Infos}) -> 
    Msg = #s2c_friend_list_reply{num = Num, infos = Infos},
    lager:info("Msg: ~p", [Msg]),  
    Pkt = friend_pb:encode_s2c_friend_list_reply(Msg),
    NewPkt = encode(s2c_friend_list_reply, Pkt),
    {ok, NewPkt};

write(50004, {Ret}) -> 
    Msg = #s2c_add_friend_reply{result = Ret},
    lager:info("Msg: ~p", [Msg]),  
    Pkt = friend_pb:encode_s2c_add_friend_reply(Msg),
    NewPkt = encode(s2c_add_friend_reply, Pkt),
    {ok, NewPkt};

write(50006, {Ret}) -> 
    Msg = #s2c_del_friend_reply{result = Ret},
    lager:info("Msg: ~p", [Msg]),  
    Pkt = friend_pb:encode_s2c_del_friend_reply(Msg),
    NewPkt = encode(s2c_del_friend_reply, Pkt),
    {ok, NewPkt};

 write(50008, {Info}) -> 
    Msg = #s2c_friend_info_reply{info = Info},
    lager:info("Msg: ~p", [Msg]),  
    Pkt = friend_pb:encode_s2c_friend_info_reply(Msg),
    NewPkt = encode(s2c_friend_info_reply, Pkt),
    {ok, NewPkt};

write(_Cmd, _R) ->
    {ok, <<>>}.

encode(c2s_friend_list_request, Msg)->
   Id = proto_util:name_to_id(c2s_friend_list_request),
   encode_1(Id, Msg);
encode(s2c_friend_list_reply, Msg) ->
    Id = proto_util:name_to_id(s2c_friend_list_reply),
    encode_1(Id, Msg);
encode(c2s_add_friend_request, Msg)->
   Id = proto_util:name_to_id(c2s_add_friend_request),
   encode_1(Id, Msg);
encode(s2c_add_friend_reply, Msg) ->
    Id = proto_util:name_to_id(s2c_add_friend_reply),
    encode_1(Id, Msg);
encode(c2s_del_friend_request, Msg)->
   Id = proto_util:name_to_id(c2s_del_friend_request),
   encode_1(Id, Msg);
encode(s2c_del_friend_reply, Msg) ->
    Id = proto_util:name_to_id(s2c_del_friend_reply),
    encode_1(Id, Msg);
encode(c2s_friend_info_request, Msg)->
   Id = proto_util:name_to_id(c2s_friend_info_request),
   encode_1(Id, Msg);
encode(s2c_friend_info_reply, Msg) ->
    Id = proto_util:name_to_id(s2c_friend_info_reply),
    encode_1(Id, Msg);
encode(Undefied, _Msg) ->
    undefied.

encode_1(Id, Msg) ->
    Pkt = erlang:iolist_to_binary(Msg),
    Len = erlang:iolist_size(Pkt) + 4,
    <<Len:2/unit:8-little, Id:4/unit:8-little, Pkt/binary>>.

