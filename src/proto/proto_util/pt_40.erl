%%%-----------------------------------
%%% @Module  : pt_40
%%% @Author  : hanyan
%%% @Email   : ithinkily@vip.qq.com
%%% @Created : 2018.1.14
%%% @Description: 40聊天
%%%-----------------------------------
-module(pt_40).
-export([read/2, write/2, encode/2]).
-include("../include/chat_pb.hrl").
-include("../common/common.hrl").
-include("../common/role.hrl").

%%私聊请求
read(40001, <<Bin/binary>>) ->
  lager:info("chat"),
  Msg = chat_pb:decode_c2s_chat_request(Bin),
  #c2s_chat_request{id = Id, content = Content} = Msg,
  {ok, [Id, Content]};

 %%队伍聊天请求
read(40003, <<Bin/binary>>) ->
  lager:info("group chat"),
  Msg = chat_pb:decode_c2s_group_chat_request(Bin),
  #c2s_group_chat_request{content = Content} = Msg,
  {ok, [Content]};

 %%群聊请求
read(40005, <<Bin/binary>>) ->
  lager:info("world chat"),
  Msg = chat_pb:decode_c2s_world_chat_request(Bin),
  #c2s_world_chat_request{content = Content} = Msg,
  {ok, [Content]};

 read(_Cmd, _R) ->
    {error, no_match}.

write(40002, {RoleId, Content, Time}) -> 
    Msg = #s2c_chat_reply{id = RoleId, content = Content, time = Time},
    lager:info("Msg: ~p", [Msg]),  
    Pkt = chat_pb:encode_s2c_chat_reply(Msg),
    NewPkt = encode(s2c_chat_reply, Pkt),
    {ok, NewPkt};

 write(40004, {RoleId, Content, Time}) -> 
    Msg = #s2c_group_chat_reply{id = RoleId, content = Content, time = Time},
    lager:info("Msg: ~p", [Msg]),  
    Pkt = chat_pb:encode_s2c_group_chat_reply(Msg),
    NewPkt = encode(s2c_group_chat_reply, Pkt),
    {ok, NewPkt};

 write(40006, {RoleId, Content, Time}) -> 
    Msg = #s2c_world_chat_reply{id = RoleId, content = Content, time = Time},
    lager:info("Msg: ~p", [Msg]),  
    Pkt = chat_pb:encode_s2c_world_chat_reply(Msg),
    NewPkt = encode(s2c_world_chat_reply, Pkt),
    {ok, NewPkt};

 write(_Cmd, _R) ->
    {ok, <<>>}.

encode(c2s_chat_request, Msg)->
   Id = proto_util:name_to_id(c2s_chat_request),
   encode_1(Id, Msg);
encode(s2c_chat_reply, Msg) ->
    Id = proto_util:name_to_id(s2c_chat_reply),
    encode_1(Id, Msg);
encode(c2s_group_chat_request, Msg)->
   Id = proto_util:name_to_id(c2s_group_chat_request),
   encode_1(Id, Msg);
encode(s2c_group_chat_reply, Msg) ->
    Id = proto_util:name_to_id(s2c_group_chat_reply),
    encode_1(Id, Msg);
encode(c2s_world_chat_request, Msg)->
   Id = proto_util:name_to_id(c2s_world_chat_request),
   encode_1(Id, Msg);
encode(s2c_world_chat_reply, Msg) ->
    Id = proto_util:name_to_id(s2c_world_chat_reply),
    encode_1(Id, Msg);
encode(Undefied, _Msg) ->
    undefied.

encode_1(Id, Msg) ->
    Pkt = erlang:iolist_to_binary(Msg),
    Len = erlang:iolist_size(Pkt) + 4,
    <<Len:2/unit:8-little, Id:4/unit:8-little, Pkt/binary>>.