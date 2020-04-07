%%%-------------------------------------------------------------------
%%% @author SVGroz
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(tcp_acceptor_srv).

-behaviour(gen_server).

-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2]).

-define(SERVER, ?MODULE).

-record(tcp_acceptor_srv_state, {listenSocket}).

%%%===================================================================
%%% Spawning and gen_server implementation
%%%===================================================================

-spec start_link(Port) -> any() when Port :: number().

start_link(Port) when is_number(Port) ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, Port, []).

init(Port) when is_number(Port) ->
  case gen_tcp:listen(Port, [binary, {packet, 0}, {active, false}]) of
    {ok, LSock} ->
      gen_server:cast(?MODULE, accept),
      {ok, #tcp_acceptor_srv_state{listenSocket = LSock}};
    {error, Reason} -> {stop, Reason}
  end.

handle_call(_Request, _From, State) when is_record(State, tcp_acceptor_srv_state) ->
  {reply, ok, State}.

handle_cast(_Request, State) when is_record(State, tcp_acceptor_srv_state) ->
  case gen_tcp:accept(State#tcp_acceptor_srv_state.listenSocket) of
    {ok, _} ->
      gen_server:cast(?MODULE, accept),
      {noreply, State};

    {error, Reason} -> {stop, Reason}
  end.

%%%===================================================================
%%% Internal functions
%%%===================================================================
