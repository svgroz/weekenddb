%%%-------------------------------------------------------------------
%%% @author SVGroz
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. апр. 2020 20:00
%%%-------------------------------------------------------------------
-author("SVGroz").

-record(tcp_processor_srv_state, {
  destination,
  socket
}).

-record(tcp_processor_srv_read, {
  length :: non_neg_integer()
}).

-record(tcp_processor_srv_write, {
  data :: binary()
}).