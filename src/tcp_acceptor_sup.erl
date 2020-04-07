%%%-------------------------------------------------------------------
%%% @author SVGroz
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(tcp_acceptor_sup).

-behaviour(supervisor).

-export([start_link/1, init/1]).

-spec start_link(Port) -> any() when Port :: number().

start_link(Port) when is_number(Port) ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, Port).

init(Port) when is_number(Port) ->
  SupFlags = #{
    strategy => one_for_all,
    intensity => 0,
    period => 1
  },
  TcpAcceptorSpec = #{
    id => tcp_acceptor_srv,
    start => {
      tcp_acceptor_srv,
      start_link,
      [
        Port
      ]
    }
  },
  ChildSpecs = [TcpAcceptorSpec],
  {ok, {SupFlags, ChildSpecs}}.
