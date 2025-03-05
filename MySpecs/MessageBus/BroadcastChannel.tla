-------------------- MODULE BroadcastChannel ----------------------
EXTENDS Sequences, Naturals, FiniteSets
CONSTANTS Clients, Msgs, QLen, NULL
VARIABLE bc_channel, in_msg_counter, rcv_counter

TypeInvariant ==
  /\ bc_channel = [ c \in Clients |-> <<>> (* Seq(Msgs) *) ]
  /\ in_msg_counter = 0
  /\ rcv_counter = 0

(* Interfaces *)
GetCurrentMsg(client) ==
  IF Len(bc_channel[client]) > 0
    THEN Head(bc_channel[client])
    ELSE NULL

(* Constraints *)
QConstraint == \A c \in Clients: Len(bc_channel[c]) \leq QLen
IN_COUNTER_CONSTRAINT == in_msg_counter < 10

(* Properties *)
RECURSIVE MsgInChannel(_)
MsgInChannel(clients) ==
  IF clients = {}
    THEN 0
    ELSE LET c == CHOOSE c \in clients: TRUE
         IN  Len(bc_channel[c]) + MsgInChannel(clients \ {c})
Losslessly == [](in_msg_counter = (rcv_counter + MsgInChannel(Clients)))

(* Actions *)
Init == TypeInvariant

PostMessage(client, msg) ==
  /\ bc_channel' = [ c \in Clients |->
                     IF c # client
                     THEN Append(bc_channel[c],msg)
                     ELSE bc_channel[c]]
  /\ in_msg_counter' = in_msg_counter + Cardinality(Clients) - 1
  /\ UNCHANGED <<rcv_counter>>
RcvMsg(client) ==
  /\ rcv_counter' = rcv_counter + 1
  /\ bc_channel[client] # <<>>
  /\ bc_channel' = [bc_channel EXCEPT ![client] = Tail(bc_channel[client])]
  /\ UNCHANGED <<in_msg_counter>>

Next == \/ \E c \in Clients: \E m \in Msgs: PostMessage(c,m)
        \/ \E c \in Clients: RcvMsg(c)
Spec == Init /\ [][Next]_<<bc_channel,in_msg_counter,rcv_counter>>
===================================================================
