----------------- MODULE MessageBus --------------------
EXTENDS FiniteSets,Naturals,Sequences
CONSTANTS Clients, QLen, Topics, MsgID, NULL
VARIABLE channel, ctl, msg, i_msg_counter, r_counter

(* TLC Declarations *)
QConstraint == /\ \A c \in Clients: Len(channel[c]) \leq QLen
               /\ i_msg_counter \leq 10
(* Properties *)

(* Definitions *)

\* Message Definitions
WhoHas_M == [topic: Topics]
IHave_M == [topic: Topics, msgId: MsgID]
INeed_M == [topic: Topics, from: Clients, msgId: MsgID]
IGive_M == [topic: Topics, to: Clients, msgId: MsgID]

Msgs == WhoHas_M \union IHave_M \union INeed_M \union IGive_M

bc_channel == INSTANCE BroadcastChannel WITH
                Msgs <- Msgs, bc_channel <- channel, in_msg_counter <- i_msg_counter, rcv_counter <- r_counter

WhoHas(t) == [topic |-> t]
IHave(t, id) == [topic |-> t, msgId |-> id]
IGive(t, to_, id) == [topic |-> t, to |-> to_, msgId |-> id]
INeed(t, from_, id) == [topic |-> t, from |-> from_, msgId |-> id]


(* Actions *)
St_Push == "Push"
St_Pull == "Pull"
St_Rdy == "Rdy"
St_Give == "Give"
PushStates == {St_Rdy, St_Push, St_Give}
PullStates == {St_Rdy, St_Pull}

Init ==
  /\ ctl = [c \in Clients |-> [push |-> [st |-> St_Rdy, who |-> NULL],
                               pull |-> [st |-> St_Rdy, who |-> NULL]] ]
  /\ msg = [c \in Clients |-> [push |-> [topic |-> NULL, id |-> NULL],
                               pull |-> [topic |-> NULL, id |-> NULL]] ]
  /\ bc_channel!TypeInvariant

Push(client, topic, msg_id) ==
  \* Push one msg at a time but
  \* to pull from the same client
  \* is allowed.
  /\ (/\ ctl[client].push.st # St_Push
      /\ ctl[client].push.st # St_Give)
  /\ ctl' = [ctl EXCEPT ![client].push.st = St_Push]
  /\ msg' = [msg EXCEPT ![client].push.id = msg_id,
                        ![client].push.topic = topic]
  /\ UNCHANGED <<channel,i_msg_counter,r_counter>>
Push_Send_IHave(client, have_msg) == bc_channel!PostMessage(client, have_msg)
Push_Wait(client) ==
  /\ ctl[client].push.st = St_Push
     \* Notify all other clients that I have
     \* msg under a topic.
  /\ Push_Send_IHave(client, IHave(msg[client].push.topic, msg[client].push.id))
  /\ UNCHANGED <<msg,ctl>>
  \/ (bc_channel!RcvMsg(client)
      /\ LET msg_ == bc_channel!GetCurrentMsg(client)
         IN  IF msg_ \in INeed_M
               THEN ctl' = [ctl EXCEPT
                            ![client].push.st = St_Give,
                            ![client].push.who = msg_.from]
               ELSE ctl' = ctl /\ msg' = msg)
Push_Give(client) ==
  /\ ctl[client].push.st = St_Give
  /\ bc_channel!PostMessage(client,
                            IGive(msg[client].push.topic,
                                  ctl[client].push.who,
                                  msg[client].push.id))
  /\ ctl' = [ctl EXCEPT ![client].push.st = St_Rdy]
  /\ UNCHANGED <<msg>>

Pull(client, topic) ==
  /\ (ctl[client].pull.st # St_Pull)
  /\ ctl' = [ctl EXCEPT ![client].pull.st = St_Pull]
  /\ msg' = [msg EXCEPT ![client].pull.topic = topic]
  /\ UNCHANGED <<channel,i_msg_counter,r_counter>>
Pull_Send_WhoHas(client,whohas_msg) ==
  bc_channel!PostMessage(client, whohas_msg)

Pull_Give_Proc(client, msg_) ==
  IF /\ msg_.topic = msg[client].pull.topic
     /\ msg_.from = client
  THEN /\ msg' = [msg EXCEPT ![client].pull.topic = msg_.topic,
                             ![client].pull.id = msg_.msgId]
       /\ ctl' = [ctl EXCEPT ![client].pull.st = St_Rdy]
  ELSE msg' = msg /\ ctl' = ctl
Pull_From_Self(client) ==
  /\ msg' = [msg EXCEPT ![client].pull.topic = msg[client].push.topic,
                        ![client].pull.id    = msg[client].push.id]
  /\ ctl' = [ctl EXCEPT ![client].push.st = St_Rdy,
                        ![client].pull.st = St_Rdy]
  /\ UNCHANGED <<channel,i_msg_counter,r_counter>>
Pull_From_Remote(client) ==
  /\ Pull_Send_WhoHas(client,WhoHas(msg[client].pull.topic))
  /\ UNCHANGED <<msg,ctl>>
  \/ (/\ bc_channel!RcvMsg(client)
      /\ LET msg_ == bc_channel!GetCurrentMsg(client)
         IN  CASE msg_ \in IHave_M -> /\ bc_channel!PostMessage(client, INeed(msg[client].pull.topic,client,msg[client].pull.id))
                                      /\ UNCHANGED <<msg,ctl>>
               [] msg_ \in IGive_M -> Pull_Give_Proc(client, msg_)
               [] OTHER -> UNCHANGED <<msg,ctl>>)
Pull_Wait(client) ==
  /\ ctl[client].pull.st = St_Pull
  /\ IF ctl[client].push.st = St_Push
      THEN Pull_From_Self(client)
      ELSE Pull_From_Remote(client)

Next == \/ \E t \in Topics: \E client \in Clients: \E id \in MsgID:
                \/ Push(client, t, id)
                \/ Push_Wait(client)
                \/ Push_Give(client)
        \/ \E client \in Clients: \E t \in Topics:
                \/ Pull(client, t)
                \/ Pull_Wait(client)
Spec == Init /\ [][Next]_<<channel,ctl,msg>>
========================================================
