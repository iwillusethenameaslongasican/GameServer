%%%-----------------------------------
%%% @Module  : pt_10
%%% @Author  : hanyan
%%% @Email   : ithinkily@vip.qq.com
%%% @Created : 2017.11.12
%%% @Description: 10帐户信息
%%%-----------------------------------
-module(pt_10).
-export([read/2, write/2, encode/2]).
-include("../include/player_pb.hrl").
%%
%%客户端 -> 服务端 ----------------------------
%%

%%登陆
read(10001, <<Bin/binary>>) ->
    Msg = player_pb:decode_c2s_login_request(Bin),
    #c2s_login_request{username = UserName, password = Password} = Msg,
    % lager:info("UserName, Password: ~p", [{UserName, Password}]),
    {ok, login, [UserName, Password]};

%%注册
read(10003, <<Bin/binary>>) ->
    Msg = player_pb:decode_c2s_register_request(Bin),
    #c2s_register_request{username = UserName, password = Password} = Msg,
    {ok, register, [UserName, Password]};

%%退出
read(10005, <<Bin/binary>>) ->
    {ok, []};

%%心跳
read(10007, <<Bin/binary>>) ->
    % lager:info("heartbeat"),  
    {ok, []};

read(_Cmd, _R) ->
    {error, no_match}.

%%
%%服务端 -> 客户端 ------------------------------------
%%

%%登陆返回
write(10002, {Result, Id}) ->
    Msg = #s2c_login_reply{result_code = Result, id = Id},
    lager:info("Msg: ~p", [Msg]),  
    Pkt = player_pb:encode_s2c_login_reply(Msg),
    NewPkt = encode(s2c_login_reply, Pkt),
    {ok, NewPkt};

%%注册返回
write(10004, Result) ->
    Msg = #s2c_register_reply{result_code = Result},  
    Pkt = player_pb:encode_s2c_register_reply(Msg),
    NewPkt = encode(s2c_register_reply, Pkt),
    {ok, NewPkt};

%%注册返回
write(10006, {Ret}) ->
    Msg = #s2c_logout_reply{ret = Ret},  
    Pkt = player_pb:encode_s2c_logout_reply(Msg),
    NewPkt = encode(s2c_logout_reply, Pkt),
    {ok, NewPkt};

%%心跳
write(10008, {}) ->
    Msg = #s2c_heartbeat_reply{},  
    % lager:info("Msg: ~p", [Msg]), 
    Pkt = player_pb:encode_s2c_heartbeat_reply(Msg),
    NewPkt = encode(s2c_heartbeat_reply, Pkt),
    {ok, NewPkt};

write(_Cmd, _R) ->
    {ok, <<>>}.

encode(c2s_login_request, Msg)->
   Id = proto_util:name_to_id(c2s_login_request),
   encode_1(Id, Msg);
encode(s2c_login_reply, Msg) ->
    Id = proto_util:name_to_id(s2c_login_reply),
    encode_1(Id, Msg);
encode(c2s_register_request, Msg)->
   Id = proto_util:name_to_id(c2s_register_request),
   encode_1(Id, Msg);
encode(s2c_register_reply, Msg) ->
    Id = proto_util:name_to_id(s2c_register_reply),
    encode_1(Id, Msg);
encode(c2s_logout_request, Msg)->
   Id = proto_util:name_to_id(c2s_logout_request),
   encode_1(Id, Msg);
encode(s2c_logout_reply, Msg) ->
    Id = proto_util:name_to_id(s2c_logout_reply),
    encode_1(Id, Msg);
encode(c2s_heartbeat_request, Msg)->
   Id = proto_util:name_to_id(c2s_heartbeat_request),
   encode_1(Id, Msg);
encode(s2c_heartbeat_reply, Msg) ->
    Id = proto_util:name_to_id(s2c_heartbeat_reply),
    encode_1(Id, Msg);
encode(Undefied, _Msg) ->
    undefied.

encode_1(Id, Msg) ->
    Pkt = erlang:iolist_to_binary(Msg),
    Len = erlang:iolist_size(Pkt) + 4,
    <<Len:2/unit:8-little, Id:4/unit:8-little, Pkt/binary>>.


% decode(MsgCode, <<>>) ->
%     proto_util:id_to_name(MsgCode);
% decode(MsgCode, MsgData) ->
%     player_pb:decode(c2s_login_request, MsgData).

