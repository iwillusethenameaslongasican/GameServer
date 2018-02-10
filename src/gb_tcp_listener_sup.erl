%%%-----------------------------------
%%% @Module  : gb_tcp_listener_sup
%%% @Author  : hanyan
%%% @Email   : ithinkily@vip.qq.com
%%% @Created : 2017.11.09
%%% @Description: tcp listerner 监控树
%%%-----------------------------------

-module(gb_tcp_listener_sup).

-behaviour(supervisor).

-export([start_link/1]).

-export([init/1]).

start_link(Port) ->
    supervisor:start_link(?MODULE, {10, Port}).

init({AcceptorCount, Port}) ->
    {ok,
        {
            {one_for_all, 10, 10},
                [
                    {
                        gb_tcp_acceptor_sup,
                        {gb_tcp_acceptor_sup, start_link, []},
                        transient,
                        infinity,
                        supervisor,
                        [gb_tcp_acceptor_sup]
                    },
                    {
                        gb_tcp_listener,
                        {gb_tcp_listener, start_link, [AcceptorCount, Port]},
                        transient,
                        100,
                        worker,
                        [gb_tcp_listener]
                    }
                ]
        }
    }.