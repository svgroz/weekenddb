%%%-------------------------------------------------------------------
%% @doc weekenddb public API
%% @end
%%%-------------------------------------------------------------------

-module(weekenddb_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    weekenddb_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
