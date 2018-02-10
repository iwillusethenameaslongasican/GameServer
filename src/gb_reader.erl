%%%-----------------------------------
%%% @Module  : gb_reader
%%% @Author  : hanyan
%%% @Email   : ithinkily@vip.qq.com
%%% @Created : 2017.11.09
%%% @Description: 读取客户端
%%%-----------------------------------

-module(gb_reader).
-export([start_link/0, init/0]).
-include("../common/common.hrl").
-include("../common/role.hrl").
-include("../include/player_pb.hrl").
-define(TCP_TIMEOUT, 60000). % 解析协议超时时间
-define(HEART_TIMEOUT, 1800000). % 心跳包超时时间
-define(HEART_TIMEOUT_TIME, 10). % 心跳包超时次数
-define(HEADER_LENGTH, 2).	% 消息头长度

%% 记录客户端进程
-record(role, {
			accname = none,
			timeout = 0,
			pid = none
	}).

start_link() ->
	{ok, proc_lib:spawn_link(?MODULE, init, [])}.

%%gen_server init
%%Host:主机IP
%%Port:端口
init() ->
	process_flag(trap_exit, true),
	Role = #role{
				accname = none,
				timeout = 0,
				pid = none
			},
	receive
		{go, Socket} ->
			login_parse_packet(Socket, Role)
	end.

%%接收来自客户端的数据 - 先处理登陆
%%Socket：socket id
%%Client: client记录
login_parse_packet(Socket, Role) ->
	Ref = async_recv(Socket, ?HEADER_LENGTH, ?HEART_TIMEOUT),
	receive
		{inet_async, Socket, Ref, {ok, <<Len:16/little>>}} ->		
			case Len > 0 of
				true ->
					Ref1 = async_recv(Socket, Len, ?TCP_TIMEOUT),
					receive
						{inet_async, Socket, Ref1, {ok, <<Cmd:32/little, Binary/binary>>}} ->
							case routing(Cmd, Binary) of
								%% 先验证登陆
								{ok, login, Data} ->
									case pp_account:handle(Cmd, [], Data) of
										{true, [Row]} ->
											Id = Row#account.id,
											UserName = Row#account.username,
											Password = Row#account.password,
											Win = Row#account.win,
											Fail = Row#account.fail,
											% lager:info("Id, UserName, Win, Fail: ~p", [{Id, UserName, Password, Win, Fail}]),
											{ok, Pid} = mod_login:login(start, [Id, UserName, Password, Win, Fail], Socket),
											Role1 = Role#role{
												accname = UserName,
												pid = Pid
											},
											{ok, Pkt} = pt_10:write(proto_util:name_to_id(s2c_login_reply), {1, Id}),
											lib_send:send(Socket, Pkt),
											do_parse_packet(Socket, Role1);
										false ->
											{ok, Pkt} = pt_10:write(proto_util:name_to_id(s2c_login_reply), {0, 0}),
											lib_send:send(Socket, Pkt),
											login_lost(Socket, Role, 0, "login fail")
									end;
								{ok, register, Data} ->
									case pp_account:handle(Cmd, [], Data) of
										true ->
											{ok, Pkt} = pt_10:write(proto_util:name_to_id(s2c_register_reply), 1),
											lib_send:send(Socket, Pkt),
											login_parse_packet(Socket, Role);
										false ->
											{ok, Pkt} = pt_10:write(proto_util:name_to_id(s2c_register_reply), 0),
											lib_send:send(Socket, Pkt),
											login_lost(Socket, Role, 0, "register fail")
									end;
								_ ->
									lager:info("other!!!!")
							end
					end;
				_ ->
					lager:info("len < 0")
			end;
		{inet_async, Socket, Ref, {error, timeout}} ->
			case Role#role.timeout >= ?HEART_TIMEOUT_TIME of
				true ->
					login_lost(Socket, Role, 0, {error, timeout});
				false ->
					login_parse_packet(Socket, Role#role{timeout = Role#role.timeout + 1})
			end;
		%% 用户断开连接或出错
  		Other ->
 			login_lost(Socket, Role, 0, Other)	
	end.

 %% 接收来自客户端的数据 - 登陆后进入游戏逻辑
 %% socket: socket id
 %% Client: client记录
 do_parse_packet(Socket, Role) ->
 	Ref = async_recv(Socket, ?HEADER_LENGTH, ?HEART_TIMEOUT),
 	receive
 		{inet_async, Socket, Ref, {ok, <<Len:16/little>>}} ->
 			case Len > 0 of
 				true ->
 					Ref1 = async_recv(Socket, Len, ?TCP_TIMEOUT),
 					receive
 						{inet_async, Socket, Ref1, {ok, <<Cmd:32/little, Binary/binary>>}} ->
 							case routing(Cmd, Binary) of
 								%% 这里是处理游戏逻辑
 								{ok, Data} ->
 									case catch gen:call(Role#role.pid, '$gen_call', {'SOCKET_EVENT', Cmd, Data}) of
 										{ok, _Res} ->
 											do_parse_packet(Socket, Role);
 										{'EXIT', Reason} ->
 											do_lost(Socket, Role, Cmd, Reason)
 									end;
 								Other ->
 									do_lost(Socket, Role, Cmd, Other)
 							end;
 						Other ->
 							do_lost(Socket, Role, 9999, Other)
 					end;
 				false ->
 							do_lost(Socket, Role, 9999, "Other")
 			end;

 		%% 超时处理
 		{inet_async, Socket, Ref, {error, timeout}} ->
 			case Role#role.timeout >= ?HEART_TIMEOUT_TIME of
				true ->
					login_lost(Socket, Role, 0, {error, timeout});
				false ->
					login_parse_packet(Socket, Role#role{timeout = Role#role.timeout + 1})
			end;

 		%% 用户断开连接或失败
 		Other ->
 			do_lost(Socket, Role, 0, Other)
 	end.

%% 断开连接
login_lost(Socket, _Client, _Cmd, Reason) ->
	gen_tcp:close(Socket),
	exit({unexpected_message, Reason}).

do_lost(_Socket, Role, _Cmd, Reason) ->
	mod_login:logout(Role#role.pid, "unexpected_message"),
	exit({unexpected_message, Reason}).

%% 路由
%% 组成如: pt_10:read
routing(Cmd, Binary) ->
	%% 取前面两位区分功能类型
	[H1, H2, _, _, _] = integer_to_list(Cmd),
	Module = list_to_atom("pt_" ++ [H1, H2]),
	Module:read(Cmd, Binary).

%% 接收信息
async_recv(Sock, Length, Timeout) when is_port(Sock) ->
	case prim_inet:async_recv(Sock, Length, Timeout) of
		{error, Reason} -> throw({Reason});
		{ok, Res} 		-> Res;
		Res 			-> Res
	end.