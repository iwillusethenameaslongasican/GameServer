%%%------------------------------------
%%% @Module  : db_util
%%% @Author  : hanyan
%%% @Email   : ithinkily@vip.qq.com
%%% @Created : 2017.1.5
%%% @Description: mnesia数据库处理类
%%%------------------------------------

-module(db_util).

-export([has_account/2, 
		insert_account_one/2, 
		get_max_role_id/0, 
		get_role_info/1, 
		update_role/1,
		get_friends/1,
		update_friend/1]).
-compile(export_all).
-include_lib("/usr/local/lib/erlang/lib/stdlib-3.3/include/qlc.hrl").

-include("../../common/role.hrl").
-include("../../common/common.hrl").

%% 是否已注册
has_account(UserName, _Password) ->
	do(qlc:q([X || X <- mnesia:table(account),
					   X#account.username =:= UserName])).

%% 	注册，插入account表
insert_account_one(UserName, Password) ->
  	Id = id_serv:generate(role),
	Row = #account{id = Id, username = UserName, password = Password, win = 0, fail = 0},
	F = fun() ->
			mnesia:write(Row)
	end,
	mnesia:transaction(F).

%% 取得最大角色id
get_max_role_id() ->
	do(qlc:q([X#account.id || X <- mnesia:table(account)])).

get_role_info(RoleId) ->
	do(qlc:q([X || X <- mnesia:table(account),
				   X#account.id =:= RoleId])).

update_role(State) ->
	Role = role_serv:get_role(State),
	F = fun() ->
			mnesia:write(Role)
	end,
	mnesia:transaction(F).

get_friends(RoleId) ->
	do(qlc:q([X || X <- mnesia:table(friends),
				   X#account.id =:= RoleId])).

update_friend(RoleId) ->
	case ets:lookup(?ETS_FRIEND, RoleId) of
		[] ->
			Oid = {friends, RoleId},
			F = fun() ->
				mnesia:delete(Oid)
			end,
			mnesia:transaction(F);
		[EtsFriend] ->
			Friends = lib_friend:get_db_friends(EtsFriend),
			F = fun() ->
				mnesia:write(Friends)
			end,
			mnesia:transaction(F)
	end.

test() ->
 	% mnesia:delete_table(account),
 	% mnesia:create_table(account, [{attributes, record_info(fields, account)}, {disc_copies, [node()]}]),
 	mnesia:create_table(friends, [{attributes, record_info(fields, friends)}, {disc_copies, [node()]}]).
 % 	F = fun() ->
	% 		lists:foreach(fun mnesia:write/1, example_tables())
	% 	end,
	% mnesia:transaction(F).

% example_tables() ->
% 	[
% 		%% account
% 		{account, 1, "hanyan", "184514", 0, 0},
% 		{account, 2, "hehe", "184514", 0, 0},
% 		{account, 3, "23331", "184514", 0, 0}

% 	].

do(Q) ->
	F = fun() -> qlc:e(Q) end,
	{atomic, X} = mnesia:transaction(F),
	X.