%%%------------------------------------
%%% @Module  : lib_friend
%%% @Author  : hanyan
%%% @Email   : ithinkily@vip.qq.com
%%% @Created : 2018.1.19
%%% @Description: 好友
%%%------------------------------------

-module(lib_friend).

-export([get_friends/1, add_friend/2, del_friend/2, get_db_friends/1, init_friend/1]).
-compile(export_all).
-include("../include/friend_pb.hrl").
-include("../common/common.hrl").
-include("../common/role.hrl").

get_friends(RoleId) ->
	case ets:lookup(?ETS_FRIEND, RoleId) of
		[] ->
			{0, []};	
		[EtsFriend] ->
			#ets_friend{friends = Friends} = EtsFriend,
			Len = length(Friends),
			FriendInfos = get_friend_info(Friends),
			{Len, FriendInfos}
	end.					

init_friend(RoleId) ->
	case db_util:get_friends(RoleId) of
		[] ->
			ok;
		[Friends] ->
			FriendList = Friends#friends.friend_list,
			Len = length(FriendList),
			EtsFriend = #ets_friend{id = RoleId, num = Len, friends = FriendList},
			ets:insert(?ETS_FRIEND, EtsFriend)
	end.	

add_friend(RoleId, FriendId) ->
	case db_util:get_role_info(FriendId) of
			[] ->
				{-1};
			[Role] ->
				Friend = #friend{
					id = Role#account.id,
					username = Role#account.username,
					image = 1,
					win = Role#account.win,
					fail = Role#account.fail
				},
				case ets:lookup(?ETS_FRIEND, RoleId) of
					[EtsFriend] ->
						#ets_friend{friends = Friends} = EtsFriend,
						Ret = lists:keymember(FriendId, 2, Friends),
						case Ret of
							true ->
								{-1};
							false ->
								EtsFriend1 = EtsFriend#ets_friend{num = EtsFriend#ets_friend.num + 1, friends = [Friend|Friends]},
								ets:insert(?ETS_FRIEND, EtsFriend1),
								{1}
						end;
					[] ->
						EtsFriend = #ets_friend{
										id = RoleId,
										num = 1,
										friends = [Friend]
									},
						ets:insert(?ETS_FRIEND, EtsFriend),
						{1}
				end
	end.

del_friend(RoleId, FriendId) ->
	case ets:lookup(?ETS_FRIEND, RoleId) of
			[EtsFriend] ->
				#ets_friend{num = Num, friends = Friends} = EtsFriend,
				Ret = lists:keymember(FriendId, 2, Friends),
				case Ret of
					true ->
						Friends1 = lists:keydelete(FriendId, 2, Friends),
						if Num =:= 1 ->
								ets:delete(?ETS_FRIEND, RoleId);
						   true ->
						   		EtsFriend1 = EtsFriend#ets_friend{num = Num - 1, friends = Friends1},
						   		ets:insert(?ETS_FRIEND, EtsFriend1)
						end,
						{1};
					false ->
						{-1}
				end;
			[] ->
				{-1}
	end.

get_db_friends(EtsFriend) ->
	Friends = #friends{
		id = EtsFriend#ets_friend.id,
		friend_list = EtsFriend#ets_friend.friends
	},
	Friends.

get_friend_info(FriendList) ->
	Fun = fun(Friend, Lists) ->
					#friend{id = FriendId, username = Username, image = Image, win = Win, fail = Fail} = Friend,
					case ets:lookup(?ETS_ROLE, FriendId) of
						[] ->
							FriendInfo = #friend_info{
								id = FriendId,
								username = Username,
								image = Image,
								status = 1,
								win = Win,
								fail = Fail
							},
							[FriendInfo|Lists];
						[_Role] ->
							FriendInfo = #friend_info{
								id = FriendId,
								username = Username,
								image = Image,
								status = 2,
								win = Win,
								fail = Fail
							},
							[FriendInfo|Lists]
					end
			end,
			FriendInfos = lists:foldl(Fun, [], FriendList).
