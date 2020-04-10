%%%-------------------------------------------------------------------
%%% @author SVGroz
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(tcp_processor_sup).

-behaviour(supervisor).

-include("tcp_processos.hrl").

-export([start_link/0, init/1]).
-export([start_child/1]).

-define(MAX_NUMBER, 342323).

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
  SupFlags = #{
    strategy => simple_one_for_one,
    intensity => 0,
    period => 1
  },
  ChildSpecs = [
    #{
      id => tcp_processor_srv,
      start => {
        tcp_processor_srv,
        start_link,
        []
      },
      restart => transient,
      shutdown => brutal_kill
    }
  ],
  {ok, {SupFlags, ChildSpecs}}.

start_child(LSocket) ->
  supervisor:start_child(?MODULE, [LSocket]).
