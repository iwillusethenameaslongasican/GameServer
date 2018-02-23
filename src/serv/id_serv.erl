%%%------------------------------------
%%% @Module  : id_serv
%%% @Author  : hanyan
%%% @Email   : ithinkily@vip.qq.com
%%% @Created : 2018.1.8
%%% @Description: 唯一id服务
%%%------------------------------------

-module(id_serv).

-behaviour(gen_server). 

%% API
-export([start_link/0, generate/1]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).


start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

generate(Tag) ->
	gen_server:call(?MODULE, {generate, Tag}).


init([]) ->
	RoleId =  
		case db_util:get_max_role_id() of
			[] ->
				1;
			Ids ->
				lists:max(Ids)
		end,

	State = #{
		role => RoleId,
		room => 1
	},
	{ok, State}.

handle_call({generate, Tag}, _From, State) ->
	Id = maps:get(Tag, State),
	NextId = Id + 1,
	{reply, NextId, maps:put(Tag, NextId, State)};

handle_call(_Request, _From, State) ->
	{noreply, State}.

handle_cast(_Msg, State) ->
	{noreply, State}.

handle_info(_Info, State) ->
	{noreply, State}.

terminate(_Reason, _State) ->
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.
