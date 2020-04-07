%%%-------------------------------------------------------------------
%%% @author SVGroz
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(tcp_processor_srv).

-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2]).

-define(SERVER, ?MODULE).

-record(tcp_processor_srv_state, {}).

%%%===================================================================
%%% Spawning and gen_server implementation
%%%===================================================================

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init([]) ->
  {ok, #tcp_processor_srv_state{}}.

handle_call(_Request, _From, State = #tcp_processor_srv_state{}) ->
  {reply, ok, State}.

handle_cast(_Request, State = #tcp_processor_srv_state{}) ->
  {noreply, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
