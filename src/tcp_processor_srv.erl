%%%-------------------------------------------------------------------
%%% @author SVGroz
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(tcp_processor_srv).

-behaviour(gen_server).

-include("tcp_processos.hrl").

-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% Spawning and gen_server implementation
%%%===================================================================

start_link(Socket) ->
  gen_server:start_link(?MODULE, Socket, []).

init(Socket) ->
  Destination = self(),
  gen_server:cast(Destination, #tcp_processor_srv_read{length = 32}),
  {ok, #tcp_processor_srv_state{destination = Destination, socket = Socket}}.

handle_call(_Request, _From, State) ->
  {reply, ok, State}.

handle_cast(Request, #tcp_processor_srv_state{destination = Destination, socket = Socket}) ->
  State = #tcp_processor_srv_state{destination = Destination, socket = Socket},
  case Request of
    #tcp_processor_srv_read{length = Length} ->
      case gen_tcp:recv(Socket, Length) of
        {ok, Packet} ->
          gen_server:cast(Destination, #tcp_processor_srv_write{data = Packet}),
          {noreply, State};
        {error, _} ->
          {stop, normal, State}
      end;

    #tcp_processor_srv_write{data = Data} ->
      case gen_tcp:send(Socket, Data) of
        ok ->
          gen_server:cast(Destination, #tcp_processor_srv_read{length = 32}),
          {noreply, State};
        {error, _} ->
          {stop, normal, State}
      end
  end.

%%%===================================================================
%%% Internal functions
%%%===================================================================
