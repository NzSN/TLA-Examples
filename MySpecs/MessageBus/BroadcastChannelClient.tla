------------------ MODULE BroadcastChannelClient --------------
EXTENDS Sequences, Naturals
CONSTANTS MSGS, Event(_)
VARIABLES bc_client, bc_channel

TypeInvariant == bc_client \in [val: MSGS, idx: Nat]

PostMessage(v) ==
  /\ out_chan!Send(v)
  /\ UNCHANGED <<in_chan>>

OnMessage(msg) ==
  /\ in_chan!Rcv
  /\ Event(in_chan.val)
  /\ UNCHANGED <<out_chan>>
===============================================================
