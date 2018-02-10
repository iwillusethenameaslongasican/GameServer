%%%------------------------------------
%%% @Module  : lib_friend
%%% @Author  : hanyan
%%% @Email   : ithinkily@vip.qq.com
%%% @Created : 2018.1.19
%%% @Description: 好友
%%%------------------------------------

-module(lib_friend).

-export([get_friends/1, add_friend/2]).
-compile(export_all).
-include("../include/friend_pb.hrl").
-include("../common/common.hrl").
-include("../common/role.hrl").

get_friends(RoleId) ->
	case ets:lookup(?ETS_FRIEND, RoleId) of
		[] ->
			{0, []};
		[Friends] ->
			Len = length(Friends),
			Fun = fun(Friend, Lists) ->
					#friend{id = FriendId, username = Username, image = Image, win = Win, fail = Fail} = Friend,
					case ets:lookup(?ETS_ROLE, FriendId) of
						[] ->
							FriendInfo = #friend_info{
								id = Friend,
								username = Username,
								image = Image,
								status = 1,
								win = Win,
								fail = Fail
							},
							[FriendInfo|Lists];
						[_Role] ->
							FriendInfo = #friend_info{
								id = Friend,
								username = Username,
								image = Image,
								status = 2,
								win = Win,
								fail = Fail
							},
							[FriendInfo|Lists]
					end
			end,
			FriendInfos = lists:foldl(Fun, [], Friends),
			{Len, FriendInfos}
	end.					


add_friend(RoleId, FriendId) ->
	FriendInfo = db_util:is_exist(FriendId),
	case FriendInfo of
		[] ->
			{-1};
		[Username, Image, Win, Fail] ->
			EtsFriend = ets:lookup(?ETS_FRIEND, RoleId),
			#ets_friends{friends = Friends} = EtsFriend,
			Friend = #friend{
				id = FriendId,
				username = Username,
				image = Image,
				win = Win,
				fail = Fail
			},
			Ret = lists:keymember(FriendId, 2, Friends),
			case Ret of
				true ->
					{-1};
				false ->
					EtsFriend1 = EtsFriend#ets_friends{num = EtsFriend#ets_friends.num + 1, friends = [Friend|Friends]},
					ets:insert(RoleId, EtsFriend1),
					{1}
			end
	end.





